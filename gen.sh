#!/bin/bash

prefix="https://raw.githubusercontent.com/kubernetes/kubernetes"
branch="master"

unversioned="$prefix/$branch/pkg/api/unversioned/types.go"
v1="$prefix/$branch/pkg/api/v1/types.go"
res="$prefix/$branch/pkg/api/resource/quantity.go"
v1beta1="$prefix/$branch/pkg/apis/extensions/v1beta1/types.go"

echo "Fetching unversioned/types.go"
curl -o unversioned/types.go -SsL $unversioned
echo "Fetching v1/types.go"
curl -o v1/types.go -SsL $v1
#curl -o resource/quantity.go -SsL $res
echo "Fetching extensions/v1beta1/types.go"
curl -o extensions/v1beta1/types.go -SsL $v1beta1


for target in "v1/types.go" "extensions/v1beta1/types.go"; do
  echo "Rewriting imports on $target"
  perl -pi -e "s|k8s\.io/kubernetes/pkg/api/unversioned|github.com/technosophos/kubelite/unversioned|g" $target
  perl -pi -e "s|k8s\.io/kubernetes/pkg/api/resource|github.com/technosophos/kubelite/resource|g" $target
  perl -pi -e "s|k8s\.io/kubernetes/pkg/api/v1|github.com/technosophos/kubelite/v1|g" $target
  perl -pi -e "s|k8s\.io/kubernetes/pkg/types|github.com/technosophos/kubelite/types|g" $target
  perl -pi -e "s|\"k8s\.io/kubernetes/pkg/util\"||g" $target
  perl -pi -e "s|\"k8s\.io/kubernetes/pkg/runtime\"||g" $target
  perl -pi -e "s|util\.IntOrString|types.IntOrString|g" $target
  perl -pi -e "s|runtime\.RawExtension|types.RawExtension|g" $target
done
