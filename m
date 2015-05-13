From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH RFC] Documentation/infiniband: Add docs for rdma-helpers
Date: Wed, 13 May 2015 15:24:32 +0200
Message-ID: <1431523472-10888-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Or Gerlitz <ogerlitz@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: linux-rdma@vger.kernel.org

This is the following patch for:
  https://lkml.org/lkml/2015/5/5/417
which try to document the settled rdma_cap_XX().

Highlights:
  There could be many missing/mistakes/misunderstanding, please don't
  be hesitate to point out the issues, any suggestions to improve or
  complete the description are very welcomed ;-)

Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 Documentation/infiniband/rdma_helpers.txt | 76 +++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 Documentation/infiniband/rdma_helpers.txt

diff --git a/Documentation/infiniband/rdma_helpers.txt b/Documentation/infiniband/rdma_helpers.txt
new file mode 100644
index 0000000..abc75ec
--- /dev/null
+++ b/Documentation/infiniband/rdma_helpers.txt
@@ -0,0 +1,76 @@
+RDMA HELPERS
+
+  For core layer, below helpers are used to check if a paticular capability
+  is supported by the port.
+
+    rdma_cap_ib_mad		- Infiniband Management Datagrams.
+    rdma_cap_ib_smi		- Infiniband Subnet Management Interface.
+    rdma_cap_ib_cm		- Infiniband Communication Manager.
+    rdma_cap_iw_cm		- IWARP Communication Manager.
+    rdma_cap_ib_sa		- Infiniband Subnet Administration.
+    rdma_cap_ib_mcast		- Infiniband Multicast.
+    rdma_cap_read_multi_sge	- RDMA Read Multiple Scatter-Gather Entries.
+    rdma_cap_af_ib		- Native Infiniband Address.
+    rdma_cap_eth_ah		- Ethernet Address Handler.
+
+USAGE
+
+  if (rdma_cap_XX(device, i)) {
+	/* The port i of device support XX */
+	...
+  } else {
+	/* The port i of device don't support XX */
+	...
+  }
+
+  rdma_cap_ib_mad
+  ---------------
+    Management Datagrams (MAD) is the prototype of management packet
+    to be used by all the kinds of infiniband managers, use the helper
+    to verify the port before utilize related features.
+
+  rdma_cap_ib_smi
+  ---------------
+    Subnet Management Interface (SMI) will handle SMP packet from SM
+    in an infiniband fabric, use the helper to verify the port before
+    utilize related features.
+
+  rdma_cap_ib_cm
+  ---------------
+    Communication Manager (CM) will handle the connections between
+    adaptors, currently there are two different implementation,
+    IB or IWARP, use the helper to verify whether the port using
+    IB-CM or not
+
+  rdma_cap_iw_cm
+  ---------------
+    IWARP has it's own implemented CM which is different from infiniband,
+    use the helper to check whether the port using IWARP-CM or not.
+
+  rdma_cap_ib_sa
+  ---------------
+    Subnet Administration (SA) is the database built by SM in an
+    infiniband fabric, use the helper to verify the port before
+    utilize related features.
+
+  rdma_cap_ib_mcast
+  ---------------
+    Multicast is the feature for one QP to send messages to multiple
+    QP in an infiniband fabric, use the helper to verify the port before
+    utilize related features.
+
+  rdma_cap_read_multi_sge
+  ---------------
+    RDMA read operation could support multiple scatter-gather entries,
+    use the helper to verify wthether the port support this feature
+    or not.
+
+  rdma_cap_af_ib
+  ---------------
+    RDMA address format could be ethernet or infiniband, use the helper
+    to verify whether the port support infiniband format or not.
+
+  rdma_cap_eth_ah
+  ---------------
+    Infiniband address handler format is special in ethernet fabric, use
+    the helper to verify whether the port is using ethernet format or not.
-- 
2.1.0

