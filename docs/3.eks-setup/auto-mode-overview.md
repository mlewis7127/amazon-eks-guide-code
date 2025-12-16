


With Amazon EKS Auto Mode, AWS take on far more of the heavy undifferentiated lifting, including all cluster capabilities for compute, storage and networking. It also includes manging the operating system, patching and more as shown in the updated shared responsibility model for Auto Mode.

![Shared Responsibility Model](../static/shared-responsibility-model.jpg)





```yaml
[
    {
        "Attachment": {
            "AttachTime": "2025-12-15T13:09:49+00:00",
            "AttachmentId": "eni-attach-0a41330b4263aab9e",
            "DeleteOnTermination": true,
            "DeviceIndex": 1,
            "NetworkCardIndex": 0,
            "InstanceOwnerId": "339713109942",
            "Status": "attached"
        },
        "AvailabilityZone": "eu-west-2b",
        "Description": "Amazon EKS eks-test-cluster",
        "Groups": [
            {
                "GroupId": "sg-007aeb5a2163d352b",
                "GroupName": "eks-test-cluster-cluster-20251215130539819800000005"
            },
            {
                "GroupId": "sg-00bb3d15b3c20dff3",
                "GroupName": "eks-cluster-sg-eks-test-cluster-1909116673"
            }
        ],
        "InterfaceType": "interface",
        "Ipv6Addresses": [],
        "MacAddress": "0a:24:3c:18:75:cd",
        "NetworkInterfaceId": "eni-06ecbd3d5689071df",
        "OwnerId": "424727766526",
        "PrivateDnsName": "ip-10-0-4-100.eu-west-2.compute.internal",
        "PublicDnsName": "",
        "PrivateIpAddress": "10.0.4.100",
        "PrivateIpAddresses": [
            {
                "Primary": true,
                "PrivateDnsName": "ip-10-0-4-100.eu-west-2.compute.internal",
                "PrivateIpAddress": "10.0.4.100"
            }
        ],
        "RequesterId": "339713109942",
        "RequesterManaged": true,
        "SourceDestCheck": true,
        "Status": "in-use",
        "SubnetId": "subnet-01e7672de9be89bc1",
        "TagSet": [],
        "VpcId": "vpc-0d8e1352a7bab979e",
        "Operator": {
            "Managed": false
        },
        "AvailabilityZoneId": "euw2-az3"
    },
    {
        "Attachment": {
            "AttachTime": "2025-12-15T13:19:38+00:00",
            "AttachmentId": "eni-attach-0993eba273364f46a",
            "DeleteOnTermination": true,
            "DeviceIndex": 1,
            "NetworkCardIndex": 0,
            "InstanceOwnerId": "339713109942",
            "Status": "attached"
        },
        "AvailabilityZone": "eu-west-2a",
        "Description": "Amazon EKS eks-test-cluster",
        "Groups": [
            {
                "GroupId": "sg-007aeb5a2163d352b",
                "GroupName": "eks-test-cluster-cluster-20251215130539819800000005"
            },
            {
                "GroupId": "sg-00bb3d15b3c20dff3",
                "GroupName": "eks-cluster-sg-eks-test-cluster-1909116673"
            }
        ],
        "InterfaceType": "interface",
        "Ipv6Addresses": [],
        "MacAddress": "06:2a:a9:33:c9:f5",
        "NetworkInterfaceId": "eni-014688de9cde4c19f",
        "OwnerId": "424727766526",
        "PrivateDnsName": "ip-10-0-3-194.eu-west-2.compute.internal",
        "PublicDnsName": "",
        "PrivateIpAddress": "10.0.3.194",
        "PrivateIpAddresses": [
            {
                "Primary": true,
                "PrivateDnsName": "ip-10-0-3-194.eu-west-2.compute.internal",
                "PrivateIpAddress": "10.0.3.194"
            }
        ],
        "RequesterId": "339713109942",
        "RequesterManaged": true,
        "SourceDestCheck": true,
        "Status": "in-use",
        "SubnetId": "subnet-09b1de77219c803f1",
        "TagSet": [],
        "VpcId": "vpc-0d8e1352a7bab979e",
        "Operator": {
            "Managed": false
        },
        "AvailabilityZoneId": "euw2-az2"
    }
]
```




aws ec2 describe-network-interfaces --filters "Name=vpc-id,Values=<your-vpc-id>" --query "NetworkInterfaces[?contains(Description, 'EKS')]"









```shell
amazon-eks-guide % kubectl get services -A
NAMESPACE     NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
default       kubernetes                  ClusterIP   172.20.0.1      <none>        443/TCP   40m
kube-system   eks-extension-metrics-api   ClusterIP   172.20.126.86   <none>        443/TCP   40m
mattlewis@Matts-MacBook-Pro-2 amazon-eks-guide % kubectl get all -n kube-system
NAME                                TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/eks-extension-metrics-api   ClusterIP   172.20.126.86   <none>        443/TCP   40m
```



```shell
amazon-eks-guide % kubectl get crd | grep -E "(eks|karpenter|auto)"
cninodes.eks.amazonaws.com                      2025-12-12T21:39:08Z
ingressclassparams.eks.amazonaws.com            2025-12-12T21:39:08Z
nodeclaims.karpenter.sh                         2025-12-12T21:39:09Z
nodeclasses.eks.amazonaws.com                   2025-12-12T21:39:09Z
nodediagnostics.eks.amazonaws.com               2025-12-12T21:39:09Z
nodepools.karpenter.sh                          2025-12-12T21:39:09Z
targetgroupbindings.eks.amazonaws.com           2025-12-12T21:39:08Z
```

```shell
amazon-eks-guide % aws eks describe-cluster --name eks-test-cluster --region eu-west-2 --profile san
dbox --query 'cluster.{AutoMode: computeConfig, Storage: storageConfig, Network: kubernetesNetworkConfig}'
{
    "AutoMode": {
        "enabled": true,
        "nodePools": [
            "general-purpose",
            "system"
        ],
        "nodeRoleArn": "arn:aws:iam::424727766526:role/eks-test-cluster-eks-auto-20251212212851103100000001"
    },
    "Storage": {
        "blockStorage": {
            "enabled": true
        }
    },
    "Network": {
        "serviceIpv4Cidr": "172.20.0.0/16",
        "ipFamily": "ipv4",
        "elasticLoadBalancing": {
            "enabled": true
        }
    }
}
```

aws eks describe-cluster \
  --name eks-test-cluster \
  --query "{networking:cluster.kubernetesNetworkConfig.elasticLoadBalancing, storage:cluster.storageConfig.blockStorage}"

{
    "networking": {
        "enabled": true
    },
    "storage": {
        "enabled": true
    }
}




EKS Auto Mode Test Results: SUCCESS!
✅ What We Confirmed:
Auto Mode Enabled: computeConfig.enabled: true
NodePool Ready: general-purpose nodepool exists and is ready
Automatic Node Provisioning: Node i-0aac5ee7a39c88fc9 was created automatically
Correct Labels: Node has eks.amazonaws.com/compute-type=auto and karpenter.sh/nodepool=general-purpose
Pod Scheduling: Pods successfully scheduled and running
Instance Selection: Auto Mode chose c6a.large instance automatically
Bottlerocket OS: Using optimized Bottlerocket AMI for EKS Auto Mode
🔍 Key Auto Mode Features Verified:
Automatic scaling: Node appeared when workload was deployed
Intelligent instance selection: Chose appropriate c6a.large for nginx workload
Managed infrastructure: Using Bottlerocket OS with containerd 2.1
Karpenter integration: Node managed by Karpenter (karpenter.sh/* labels)
Cost optimization: Single node handles both pods efficiently

Deploy a simple workload to trigger node creation

```shell
kubectl create deployment nginx-test --image=nginx --replicas=2

deployment.apps/nginx-test created
```


kubectl get pods -o wide


amazon-eks-guide % kubectl get pods -o wide
NAME                          READY   STATUS              RESTARTS   AGE   IP       NODE                  NOMINATED NODE   READINESS GATES
nginx-test-586bbf5c4c-5qnld   0/1     ContainerCreating   0          23s   <none>   i-0aac5ee7a39c88fc9   <none>           <none>
nginx-test-586bbf5c4c-s2qxl   0/1     ContainerCreating   0          23s   <none>   i-0aac5ee7a39c88fc9   <none>           <none>
mattlewis@Matts-MacBook-Pro-2 amazon-eks-guide % 

amazon-eks-guide % kubectl get nodes -o wide
NAME                  STATUS   ROLES    AGE   VERSION               INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                                                              KERNEL-VERSION   CONTAINER-RUNTIME
i-0aac5ee7a39c88fc9   Ready    <none>   21s   v1.34.1-eks-113cf36   10.0.5.30     <none>        Bottlerocket (EKS Auto, Standard) 2025.12.5 (aws-k8s-1.34-standard)   6.12.55          containerd://2.1.5+bottlerocket
mattlewis@Matts-MacBook-Pro-2 amazon-eks-guide % 




amazon-eks-guide % kubectl get nodes --show-labels
NAME                  STATUS   ROLES    AGE   VERSION               LABELS
i-0aac5ee7a39c88fc9   Ready    <none>   37s   v1.34.1-eks-113cf36   app.kubernetes.io/managed-by=eks,beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=c6a.large,beta.kubernetes.io/os=linux,eks.amazonaws.com/compute-type=auto,eks.amazonaws.com/instance-capability-flex=false,eks.amazonaws.com/instance-category=c,eks.amazonaws.com/instance-cpu-manufacturer=amd,eks.amazonaws.com/instance-cpu-sustained-clock-speed-mhz=3600,eks.amazonaws.com/instance-cpu=2,eks.amazonaws.com/instance-ebs-bandwidth=10000,eks.amazonaws.com/instance-encryption-in-transit-supported=true,eks.amazonaws.com/instance-family=c6a,eks.amazonaws.com/instance-generation=6,eks.amazonaws.com/instance-hypervisor=nitro,eks.amazonaws.com/instance-memory=4096,eks.amazonaws.com/instance-network-bandwidth=781,eks.amazonaws.com/instance-size=large,eks.amazonaws.com/nodeclass=default,failure-domain.beta.kubernetes.io/region=eu-west-2,failure-domain.beta.kubernetes.io/zone=eu-west-2c,k8s.io/cloud-provider-aws=e1b03224209c15b2d84b2e89ca2758fd,karpenter.sh/capacity-type=on-demand,karpenter.sh/do-not-sync-taints=true,karpenter.sh/initialized=true,karpenter.sh/nodepool=general-purpose,karpenter.sh/registered=true,kubernetes.io/arch=amd64,kubernetes.io/hostname=i-0aac5ee7a39c88fc9,kubernetes.io/os=linux,node.kubernetes.io/instance-type=c6a.large,topology.ebs.csi.eks.amazonaws.com/zone=eu-west-2c,topology.k8s.aws/zone-id=euw2-az1,topology.kubernetes.io/region=eu-west-2,topology.kubernetes.io/zone=eu-west-2c
mattlewis@Matts-MacBook-Pro-2 amazon-eks-guide % 



amazon-eks-guide % kubectl get pods
NAME                          READY   STATUS    RESTARTS   AGE
nginx-test-586bbf5c4c-5qnld   1/1     Running   0          74s
nginx-test-586bbf5c4c-s2qxl   1/1     Running   0          74s
mattlewis@Matts-MacBook-Pro-2 amazon-eks-guide % 


amazon-eks-guide % kubectl delete deployment nginx-test
deployment.apps "nginx-test" deleted
mattlewis@Matts-MacBook-Pro-2 amazon-eks-guide % 




Amazon EKS Auto mode includes capabilities that deliver essential cluster functionality, including:

* Pod networking
* Service networking
* Cluster DNS
* Autoscaling
* Block storage
* Load balancer controller
* Pod Identity agent
* Node monitoring agent

With Auto mode compute, many commonly used EKS add-ons become redundant, such as:

* Amazon VPC CNI
* kube-proxy
* CoreDNS
* Amazon EBS CSI Driver
* EKS Pod Identity Agent



kubectl get nodepool general-purpose -o yaml

```yaml
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  annotations:
    karpenter.sh/nodepool-hash: "4012513481623584108"
    karpenter.sh/nodepool-hash-version: v3
  creationTimestamp: "2025-12-13T17:26:55Z"
  generation: 1
  labels:
    app.kubernetes.io/managed-by: eks
  name: general-purpose
  resourceVersion: "16335"
  uid: a5714d26-9f7d-4e14-81fd-d9b76f1796c5
spec:
  disruption:
    budgets:
    - nodes: 10%
    consolidateAfter: 30s
    consolidationPolicy: WhenEmptyOrUnderutilized
  template:
    metadata: {}
    spec:
      expireAfter: 336h
      nodeClassRef:
        group: eks.amazonaws.com
        kind: NodeClass
        name: default
      requirements:
      - key: karpenter.sh/capacity-type
        operator: In
        values:
        - on-demand
      - key: eks.amazonaws.com/instance-category
        operator: In
        values:
        - c
        - m
        - r
      - key: eks.amazonaws.com/instance-generation
        operator: Gt
        values:
        - "4"
      - key: kubernetes.io/arch
        operator: In
        values:
        - amd64
      - key: kubernetes.io/os
        operator: In
        values:
        - linux
      terminationGracePeriod: 24h0m0s
status:
  conditions:
  - lastTransitionTime: "2025-12-13T17:27:43Z"
    message: ""
    observedGeneration: 1
    reason: ValidationSucceeded
    status: "True"
    type: ValidationSucceeded
  - lastTransitionTime: "2025-12-13T17:28:05Z"
    message: ""
    observedGeneration: 1
    reason: NodeClassReady
    status: "True"
    type: NodeClassReady
  - lastTransitionTime: "2025-12-13T18:03:39Z"
    message: ""
    observedGeneration: 1
    reason: NodeRegistrationHealthy
    status: "True"
    type: NodeRegistrationHealthy
  - lastTransitionTime: "2025-12-13T17:28:05Z"
    message: ""
    observedGeneration: 1
    reason: Ready
    status: "True"
    type: Ready
  nodeClassObservedGeneration: 1
  nodes: 0
  resources:
    cpu: "0"
    ephemeral-storage: "0"
    memory: "0"
    nodes: "0"
    pods: "0"
```

