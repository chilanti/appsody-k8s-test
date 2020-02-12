# Testing Appsody on Kube
This repo includes the artifacts that are necessary to test Appsody on an Openshift 4.x cluster, in a way that is consistent with the pattern implemented by Che.
Che makes use of two separate Kube deployments:
1) The Che deployment itself, where the developers projects are created and maintained
2) The PFE deployment, where the actual development activities are performed

This test framework reproduces this pattern. Once you are all set up, you will be running two Pods (for as many deployments):
1) The Che Emulator (this is where you issue `appsody init`) 
2) The PFE Emulater (this is where you issue `appsody run` and `appsody stop`)

Let's get started.
## Cluster setup
These steps are needed if you move to a new cluster or if you delete and clean up the existing cluster (for example, by deleting the `appsody-k8s` project).
1) Clone this repo.
1) Login to your Openshift cluster (`oc login etc.`)
1) Run `./setup.sh`

The last step does the following:
1) Creates a project and namespace called `appsody-k8s`
1) Changes some mysterious security policies, allowing containes to run as privileged and as root in `appsody-k8s`
1) Creates a service account called `appsody-sa`, which will be used by the Che Emulator and the PFE emulator
1) Assigns cluster-admin powers to `appsody-sa`
1) Creates a PVC called `appsody-workspace`. Keep in mind that this PVC must be bound to an `RWX` PV. On Fyre, you get a single usable PV out of the box - you need to make sure that:
a) it is unbound
b) you've changed it's mode to be RWX (in addition to RWO, whihc is the default)
If you haven't done so, this is a good time to make the change.

## Setting up the Emulators
Once you have your cluster setup, you can concentrate on creating the deployments for the Che and PFE Emulators.
1) First step is building Appsody. You probably want to test your own version of Appsody: build it in the Appsody repo using `make package`. 
1) Copy the RPM installer for your Appsody version to the folder where you cloned this repo (it should be called `appsody-0.0.0-1.x86_64.rpm`).
1) Build the Appsody on Kube image. To do so, you can edit the `build.sh` script and replace the image name to match your docker account and namespace. Then run `./build <tag>`. Note down the full image name, you'll need it later.
1) Edit both the `che.yaml` and `pfe.yaml`, and replace the `image` element:
```
        image: <your image:tag>
```
1) Ensure that your `oc` points to the `appsody-k8s` project (run `oc project appsody-k8s`)
1) Run `oc apply -f che.yaml`. Make sure the pod comes up before you do anything else.
1) Run `oc apply -f pfe.yaml`. Check that the pod comes up ok.

If your pods are up and running, you are now ready to experiment Appsody on Kube.

