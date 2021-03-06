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
        imagePullPolicy: Always        
```
1) Ensure that your `oc` points to the `appsody-k8s` project (run `oc project appsody-k8s`)
1) Run `oc apply -f che.yaml`. Make sure the pod comes up before you do anything else.
1) Run `oc apply -f pfe.yaml`. Check that the pod comes up ok.

If your pods are up and running, you are now ready to experiment Appsody on Kube.

## Running Appsody on Kube
Running Appsody on Kube requires some extra steps that you wouldn't perform on a "local" Appsody installation. Those steps ensure that the system behaves just like Che with the Codewind plug-ins.
### Appsody init
1) Open the Openshift cluster console and log in as an admin.
1) In the `appsody-k8s` project, navigate to `Deployments`. 
1) Click the `che-emulator` deployment.
1) Open the YAML for the deployment, and note down somewhere the UUID that was generated by Openshift. This UUID is needed to make the Appsody application deployment a child of the Che emulator deployment.
1) Now, navigate to the pod, and open the `Terminal` of the Che emulator.
1) Pick a project name you are going to test (example: `my-nodejs-test`) and note it down.
1) In the root directory, run `. ./set-cw-env.sh <Appsody project name>  <UUID>`. Replace the Appsody project name and the UUID with the values you have set aside in the previous steps.
1) Create the project directory (example: `my-nodejs-test`) under `/workspaces/workspace123/projects`. This directory structure emulates how Che structures the folders in a multi-tenant environment (`workspace123` is the workspace assigned to the user `123` in this emulation).
1) Change directories to `/workspaces/workspace123/projects/<your project>`.
1) Run `appsody init <stack>`. Make sure everything completes successfully.
### Appsody run
1) Open another Openshift console tab - log in as admin.
1) This time, navigate to the `pfe-emulator` deployment under `appsody-k8s`
1) Navigate to the Pod and open the `Terminal`.
1) Run the same `. ./set-cw-env.sh <Appsody project name>  <UUID>` command you ran earlier, with the same values.
1) Change directories to `/codewind-workspace/<your project>`. You should find the contents generated by `appsody init` earlier on in that directory (if it's empty or not found, there's something wrong).
1) Run `appsody run -v`. The terminal should show the log (after a while) coming from the Appsody app. Make sure it comes up fine.
1) Open a third console tab. Now you should see a third deployment under `appsody-k8s`, which represents the Appsody app running on Kube in development mode.