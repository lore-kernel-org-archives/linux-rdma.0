Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AA31FCFFC;
	Fri, 16 Oct 2026 22:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792190393; cv=none; b=FVOtGnrjZ+pQTr+keuh8rSIE9r+xkMQCDVUuP1KtYzg2AzMAM3k59xOr6tSWdAt4PbZams0XVEILwzIBtl8nNgzKbA1b62TYgqTcNtEHu+Ozxd+V2YwgtI7N+Px3l6gtbLxGUdqlX9QZEZhUcrjfXsGRy0nF6Zeamqs6dooe818=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792190393; c=relaxed/simple;
	bh=8F1gINHTwJDo7+qHWqoPb5n9sfe2ZbaI+T/P0vTNF3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eJaPip2KW28X1uBM/Uu222DnRckEz5jZTeoUQsOxqD7U101+O0XF3ktHUY/voixyx0IsjcgqauzdQSktd96m1schtfXfc4o/ETGL08hI+Ighn0WUax0jipNMPTagKz3c4GCLaCTgeBSo7nCEUbq6+OY97MsYopJ7dhIyHS+PzsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IiIoVqpu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IiIoVqpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2AF1F000C4;
	Fri, 16 Oct 2026 22:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792190392;
	bh=hIBiQdMoNaihUw74IwWPWoNygO6MOd6xOHTvwa92FH4=;
	h=From:To:Cc:Subject:Date;
	b=IiIoVqpuN6p9VrKV0zFxXR06NmGUdzmdbl2Trd8Utjsp0eUM1eoADmIwaZ9gKDsRi
	 /8r0XcvdE+wgBsfR1nVZIgzP6F8NhT3a9YfhDO35rGK7KiRjvaEGYzpjwpv4Iqlb60
	 hDUkJZPgvcI67rymBGXOSSGRzK92EcWonSShF7LxfhZqm/PSbfy5NAoDx/IF9WSNUx
	 9sVSeRvt22+jAtsGc6GAkiCigD4u8Y8kE4tyahiFgP5vpHqQSF09WYhClKvtMd0fdS
	 T+ZR0OPRtKeFmRoLNblC3icAren1MV1NESmYcnQaiYRKtU0FdnMO+PceCJXjkWgSQ3
	 It31bxpFx6/iA==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: infiniband: Convert hisilicon,hns-roce-v1 to DT schema
Date: Fri, 16 Oct 2026 17:39:34 -0500
Message-ID: <20261016223935.1496846-1-robh@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert hisilicon,hns-roce-v1 binding to DT schema format. It's a
straight forward conversion.

While generally '#address-cells' and '#size-cells' are not needed in
leaf nodes, there are some exceptions. Not sure if there's a dependency
in this case, so leaving them in place since this is an old binding.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../infiniband/hisilicon,hns-roce-v1.yaml     | 173 ++++++++++++++++++
 .../infiniband/hisilicon-hns-roce.txt         | 108 -----------
 MAINTAINERS                                   |   2 +-
 3 files changed, 174 insertions(+), 109 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/infiniband/hisilicon,hns-roce-v1.yaml
 delete mode 100644 Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt

diff --git a/Documentation/devicetree/bindings/infiniband/hisilicon,hns-roce-v1.yaml b/Documentation/devicetree/bindings/infiniband/hisilicon,hns-roce-v1.yaml
new file mode 100644
index 000000000000..d987840f417c
--- /dev/null
+++ b/Documentation/devicetree/bindings/infiniband/hisilicon,hns-roce-v1.yaml
@@ -0,0 +1,173 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/infiniband/hisilicon,hns-roce-v1.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Hisilicon HNS RoCE
+
+maintainers:
+  - Chengchang Tang <tangchengchang@huawei.com>
+  - Junxian Huang <huangjunxian6@hisilicon.com>
+
+description:
+  Hisilicon RoCE engine is a part of network subsystem. It works depending on
+  other part of network subsystem, such as gmac and dsa fabric.
+
+properties:
+  compatible:
+    const: hisilicon,hns-roce-v1
+
+  reg:
+    maxItems: 1
+
+  '#address-cells':
+    const: 2
+
+  '#size-cells':
+    const: 2
+
+  dma-coherent: true
+
+  interrupts:
+    items:
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Completion event IRQ
+      - description: Async event IRQ
+      - description: Event overflow IRQ
+
+  interrupt-names:
+    items:
+      - const: hns-roce-comp-0
+      - const: hns-roce-comp-1
+      - const: hns-roce-comp-2
+      - const: hns-roce-comp-3
+      - const: hns-roce-comp-4
+      - const: hns-roce-comp-5
+      - const: hns-roce-comp-6
+      - const: hns-roce-comp-7
+      - const: hns-roce-comp-8
+      - const: hns-roce-comp-9
+      - const: hns-roce-comp-10
+      - const: hns-roce-comp-11
+      - const: hns-roce-comp-12
+      - const: hns-roce-comp-13
+      - const: hns-roce-comp-14
+      - const: hns-roce-comp-15
+      - const: hns-roce-comp-16
+      - const: hns-roce-comp-17
+      - const: hns-roce-comp-18
+      - const: hns-roce-comp-19
+      - const: hns-roce-comp-20
+      - const: hns-roce-comp-21
+      - const: hns-roce-comp-22
+      - const: hns-roce-comp-23
+      - const: hns-roce-comp-24
+      - const: hns-roce-comp-25
+      - const: hns-roce-comp-26
+      - const: hns-roce-comp-27
+      - const: hns-roce-comp-28
+      - const: hns-roce-comp-29
+      - const: hns-roce-comp-30
+      - const: hns-roce-comp-31
+      - const: hns-roce-async
+      - const: hns-roce-common
+
+  eth-handle:
+    description: References to one or more Ethernet devices.
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    items:
+      maxItems: 1
+
+  dsaf-handle:
+    description: Reference to a dsaf device.
+    $ref: /schemas/types.yaml#/definitions/phandle
+
+  node-guid:
+    description: A number that uniquely identifies a device or component.
+    $ref: /schemas/types.yaml#/definitions/uint8-array
+
+required:
+  - compatible
+  - reg
+  - '#address-cells'
+  - '#size-cells'
+  - eth-handle
+  - dsaf-handle
+  - node-guid
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        infiniband@c4000000 {
+            compatible = "hisilicon,hns-roce-v1";
+            reg = <0x0 0xc4000000 0x0 0x100000>;
+            #address-cells = <2>;
+            #size-cells = <2>;
+            dma-coherent;
+            eth-handle = <&eth2 &eth3 &eth4 &eth5 &eth6 &eth7>;
+            dsaf-handle = <&soc0_dsa>;
+            node-guid = [00 9A CD 00 00 01 02 03];
+            interrupts = <722 1>, <723 1>, <724 1>, <725 1>,
+                         <726 1>, <727 1>, <728 1>, <729 1>,
+                         <730 1>, <731 1>, <732 1>, <733 1>,
+                         <734 1>, <735 1>, <736 1>, <737 1>,
+                         <738 1>, <739 1>, <740 1>, <741 1>,
+                         <742 1>, <743 1>, <744 1>, <745 1>,
+                         <746 1>, <747 1>, <748 1>, <749 1>,
+                         <750 1>, <751 1>, <752 1>, <753 1>,
+                         <785 1>, <754 4>;
+            interrupt-names = "hns-roce-comp-0", "hns-roce-comp-1",
+                              "hns-roce-comp-2", "hns-roce-comp-3",
+                              "hns-roce-comp-4", "hns-roce-comp-5",
+                              "hns-roce-comp-6", "hns-roce-comp-7",
+                              "hns-roce-comp-8", "hns-roce-comp-9",
+                              "hns-roce-comp-10", "hns-roce-comp-11",
+                              "hns-roce-comp-12", "hns-roce-comp-13",
+                              "hns-roce-comp-14", "hns-roce-comp-15",
+                              "hns-roce-comp-16", "hns-roce-comp-17",
+                              "hns-roce-comp-18", "hns-roce-comp-19",
+                              "hns-roce-comp-20", "hns-roce-comp-21",
+                              "hns-roce-comp-22", "hns-roce-comp-23",
+                              "hns-roce-comp-24", "hns-roce-comp-25",
+                              "hns-roce-comp-26", "hns-roce-comp-27",
+                              "hns-roce-comp-28", "hns-roce-comp-29",
+                              "hns-roce-comp-30", "hns-roce-comp-31",
+                              "hns-roce-async", "hns-roce-common";
+        };
+    };
diff --git a/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt b/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
deleted file mode 100644
index be31cf05cd2e..000000000000
--- a/Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
+++ /dev/null
@@ -1,108 +0,0 @@
-Hisilicon RoCE DT description
-
-Hisilicon RoCE engine is a part of network subsystem.
-It works depending on other part of network subsystem, such as gmac and
-dsa fabric.
-
-Additional properties are described here:
-
-Required properties:
-- compatible: Should contain "hisilicon,hns-roce-v1".
-- reg: Physical base address of the RoCE driver and
-length of memory mapped region.
-- eth-handle: phandle, specifies a reference to a node
-representing a ethernet device.
-- dsaf-handle: phandle, specifies a reference to a node
-representing a dsaf device.
-- node_guid: a number that uniquely identifies a device or component
-- #address-cells: must be 2
-- #size-cells: must be 2
-Optional properties:
-- dma-coherent: Present if DMA operations are coherent.
-- interrupts: should contain 32 completion event irq,1 async event irq
-and 1 event overflow irq.
-- interrupt-names:should be one of 34 irqs for roce device
-  - hns-roce-comp-0 ~ hns-roce-comp-31: 32 complete event irq
-  - hns-roce-async: 1 async event irq
-  - hns-roce-common: named common exception warning irq
-Example:
-	infiniband@c4000000 {
-			compatible = "hisilicon,hns-roce-v1";
-			reg = <0x0 0xc4000000 0x0 0x100000>;
-			dma-coherent;
-			eth-handle = <&eth2 &eth3 &eth4 &eth5 &eth6 &eth7>;
-			dsaf-handle = <&soc0_dsa>;
-			node-guid = [00 9A CD 00 00 01 02 03];
-			#address-cells = <2>;
-			#size-cells = <2>;
-			interrupt-parent = <&mbigen_dsa>;
-			interrupts = <722 1>,
-					<723 1>,
-					<724 1>,
-					<725 1>,
-					<726 1>,
-					<727 1>,
-					<728 1>,
-					<729 1>,
-					<730 1>,
-					<731 1>,
-					<732 1>,
-					<733 1>,
-					<734 1>,
-					<735 1>,
-					<736 1>,
-					<737 1>,
-					<738 1>,
-					<739 1>,
-					<740 1>,
-					<741 1>,
-					<742 1>,
-					<743 1>,
-					<744 1>,
-					<745 1>,
-					<746 1>,
-					<747 1>,
-					<748 1>,
-					<749 1>,
-					<750 1>,
-					<751 1>,
-					<752 1>,
-					<753 1>,
-					<785 1>,
-					<754 4>;
-
-			interrupt-names = "hns-roce-comp-0",
-					"hns-roce-comp-1",
-					"hns-roce-comp-2",
-					"hns-roce-comp-3",
-					"hns-roce-comp-4",
-					"hns-roce-comp-5",
-					"hns-roce-comp-6",
-					"hns-roce-comp-7",
-					"hns-roce-comp-8",
-					"hns-roce-comp-9",
-					"hns-roce-comp-10",
-					"hns-roce-comp-11",
-					"hns-roce-comp-12",
-					"hns-roce-comp-13",
-					"hns-roce-comp-14",
-					"hns-roce-comp-15",
-					"hns-roce-comp-16",
-					"hns-roce-comp-17",
-					"hns-roce-comp-18",
-					"hns-roce-comp-19",
-					"hns-roce-comp-20",
-					"hns-roce-comp-21",
-					"hns-roce-comp-22",
-					"hns-roce-comp-23",
-					"hns-roce-comp-24",
-					"hns-roce-comp-25",
-					"hns-roce-comp-26",
-					"hns-roce-comp-27",
-					"hns-roce-comp-28",
-					"hns-roce-comp-29",
-					"hns-roce-comp-30",
-					"hns-roce-comp-31",
-					"hns-roce-async",
-					"hns-roce-common";
-		};
diff --git a/MAINTAINERS b/MAINTAINERS
index 149bc44003bd..d5dbde48e0eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12119,7 +12119,7 @@ M:	Chengchang Tang <tangchengchang@huawei.com>
 M:	Junxian Huang <huangjunxian6@hisilicon.com>
 L:	linux-rdma@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
+F:	Documentation/devicetree/bindings/infiniband/hisilicon,hns-roce-v1.yaml
 F:	drivers/infiniband/hw/hns/
 
 HISILICON SAS Controller
-- 
2.53.0

