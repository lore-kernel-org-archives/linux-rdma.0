From: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Subject: [patch 01/44] ib_pack.h
Date: Fri, 01 Jul 2011 08:18:22 -0500
Message-ID: <20110701132200.742681850@systemfabricworks.com>
References: <20110701131821.928693424@systemfabricworks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=patch1
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bring up to date with the current version of the IBTA spec.
	- add new opcodes for RC and RD
	- add new groups of opcodes for CN and XRC

Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

---
 include/rdma/ib_pack.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: infiniband/include/rdma/ib_pack.h
===================================================================
--- infiniband.orig/include/rdma/ib_pack.h
+++ infiniband/include/rdma/ib_pack.h
@@ -75,6 +75,7 @@ enum {
 	IB_OPCODE_UC                                = 0x20,
 	IB_OPCODE_RD                                = 0x40,
 	IB_OPCODE_UD                                = 0x60,
+	IB_OPCODE_CN                                = 0x80,
 
 	/* operations -- just used to define real constants */
 	IB_OPCODE_SEND_FIRST                        = 0x00,
@@ -98,6 +99,10 @@ enum {
 	IB_OPCODE_ATOMIC_ACKNOWLEDGE                = 0x12,
 	IB_OPCODE_COMPARE_SWAP                      = 0x13,
 	IB_OPCODE_FETCH_ADD                         = 0x14,
+	IB_OPCODE_CNP                               = 0x00,
+	IB_OPCODE_RESYNC                            = 0x15,
+	IB_OPCODE_SEND_LAST_INV                     = 0x16,
+	IB_OPCODE_SEND_ONLY_INV                     = 0x17,
 
 	/* real constants follow -- see comment about above IB_OPCODE()
 	   macro for more details */
@@ -124,6 +129,8 @@ enum {
 	IB_OPCODE(RC, ATOMIC_ACKNOWLEDGE),
 	IB_OPCODE(RC, COMPARE_SWAP),
 	IB_OPCODE(RC, FETCH_ADD),
+	IB_OPCODE(RC, SEND_LAST_INV),
+	IB_OPCODE(RC, SEND_ONLY_INV),
 
 	/* UC */
 	IB_OPCODE(UC, SEND_FIRST),
@@ -161,10 +168,15 @@ enum {
 	IB_OPCODE(RD, ATOMIC_ACKNOWLEDGE),
 	IB_OPCODE(RD, COMPARE_SWAP),
 	IB_OPCODE(RD, FETCH_ADD),
+	IB_OPCODE(RD, RESYNC),
 
 	/* UD */
 	IB_OPCODE(UD, SEND_ONLY),
-	IB_OPCODE(UD, SEND_ONLY_WITH_IMMEDIATE)
+	IB_OPCODE(UD, SEND_ONLY_WITH_IMMEDIATE),
+
+	/* CN */
+	IB_OPCODE(CN, CNP),
+
 };
 
 enum {

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
