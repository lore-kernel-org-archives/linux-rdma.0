From: Salil Mehta <salil.mehta@huawei.com>
Subject: [PATCH V2 for-next 9/9] IB/hns: Add node_guid definition to the bindings document
Date: Tue, 13 Sep 2016 20:49:30 +0100
Message-ID: <20160913194930.273964-10-salil.mehta@huawei.com>
References: <20160913194930.273964-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160913194930.273964-1-salil.mehta@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: salil.mehta@huawei.com, xavier.huwei@huawei.com, oulijun@huawei.com, yisen.zhuang@huawei.com, mehta.salil.lnk@gmail.com, xuwei5@hisilicon.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

This patch adds node_guid definition in bindings document.
The value of node_guid will be used during RDMA connection.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Reviewed-by: Wei Hu <xavier.huwei@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt b/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
index f97993b..d3b273e 100644
--- a/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
+++ b/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
@@ -14,6 +14,7 @@ length of memory mapped region.
 representing a ethernet device.
 - dsaf-handle: phandle, specifies a reference to a node
 representing a dsaf device.
+- node_guid: a number that uniquely identifies a device or component
 - #address-cells: must be 2
 - #size-cells: must be 2
 Optional properties:
@@ -32,6 +33,7 @@ Example:
 			dma-coherent;
 			eth-handle = <&eth2 &eth3 &eth4 &eth5 &eth6 &eth7>;
 			dsaf-handle = <&soc0_dsa>;
+			node-guid = [00 9A CD 00 00 01 02 03];
 			#address-cells = <2>;
 			#size-cells = <2>;
 			interrupt-parent = <&mbigen_dsa>;
-- 
1.9.1
