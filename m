From: "Robert Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: [PATCH] rdma/ib_pack.h: add new bth opcodes
Date: Mon, 9 Aug 2010 00:00:24 -0500
Message-ID: <009e01cb377f$cc2bfc00$6483f400$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Several new opcodes have been added since the last time ib_pack.h was
updated.
These changes add them.

Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
---

diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index cbb50f4..42b43d4 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -73,8 +73,11 @@ enum {
        IB_OPCODE_UC                                = 0x20,
        IB_OPCODE_RD                                = 0x40,
        IB_OPCODE_UD                                = 0x60,
+       IB_OPCODE_CN                                = 0x80,
+       IB_OPCODE_XRC                               = 0xA0,

        /* operations -- just used to define real constants */
+       IB_OPCODE_CNP                               = 0x00,
        IB_OPCODE_SEND_FIRST                        = 0x00,
        IB_OPCODE_SEND_MIDDLE                       = 0x01,
        IB_OPCODE_SEND_LAST                         = 0x02,
@@ -96,6 +99,9 @@ enum {
        IB_OPCODE_ATOMIC_ACKNOWLEDGE                = 0x12,
        IB_OPCODE_COMPARE_SWAP                      = 0x13,
        IB_OPCODE_FETCH_ADD                         = 0x14,
+       IB_OPCODE_RESYNC                            = 0x15,
+       IB_OPCODE_SEND_LAST_WITH_INVALIDATE         = 0x16,
+       IB_OPCODE_SEND_ONLY_WITH_INVALIDATE         = 0x17,

        /* real constants follow -- see comment about above IB_OPCODE()
           macro for more details */
@@ -122,6 +128,8 @@ enum {
        IB_OPCODE(RC, ATOMIC_ACKNOWLEDGE),
        IB_OPCODE(RC, COMPARE_SWAP),
        IB_OPCODE(RC, FETCH_ADD),
+       IB_OPCODE(RC, SEND_LAST_WITH_INVALIDATE),
+       IB_OPCODE(RC, SEND_ONLY_WITH_INVALIDATE),

        /* UC */
        IB_OPCODE(UC, SEND_FIRST),
@@ -159,10 +167,39 @@ enum {
        IB_OPCODE(RD, ATOMIC_ACKNOWLEDGE),
        IB_OPCODE(RD, COMPARE_SWAP),
        IB_OPCODE(RD, FETCH_ADD),
+       IB_OPCODE(RD, RESYNC),

        /* UD */
        IB_OPCODE(UD, SEND_ONLY),
        IB_OPCODE(UD, SEND_ONLY_WITH_IMMEDIATE)
+
+       /* CN */
+       IB_OPCODE(CN, CNP),
+
+       /* XRC */
+       IB_OPCODE(XRC, SEND_FIRST),
+       IB_OPCODE(XRC, SEND_MIDDLE),
+       IB_OPCODE(XRC, SEND_LAST),
+       IB_OPCODE(XRC, SEND_LAST_WITH_IMMEDIATE),
+       IB_OPCODE(XRC, SEND_ONLY),
+       IB_OPCODE(XRC, SEND_ONLY_WITH_IMMEDIATE),
+       IB_OPCODE(XRC, RDMA_WRITE_FIRST),
+       IB_OPCODE(XRC, RDMA_WRITE_MIDDLE),
+       IB_OPCODE(XRC, RDMA_WRITE_LAST),
+       IB_OPCODE(XRC, RDMA_WRITE_LAST_WITH_IMMEDIATE),
+       IB_OPCODE(XRC, RDMA_WRITE_ONLY),
+       IB_OPCODE(XRC, RDMA_WRITE_ONLY_WITH_IMMEDIATE),
+       IB_OPCODE(XRC, RDMA_READ_REQUEST),
+       IB_OPCODE(XRC, RDMA_READ_RESPONSE_FIRST),
+       IB_OPCODE(XRC, RDMA_READ_RESPONSE_MIDDLE),
+       IB_OPCODE(XRC, RDMA_READ_RESPONSE_LAST),
+       IB_OPCODE(XRC, RDMA_READ_RESPONSE_ONLY),
+       IB_OPCODE(XRC, ACKNOWLEDGE),
+       IB_OPCODE(XRC, ATOMIC_ACKNOWLEDGE),
+       IB_OPCODE(XRC, COMPARE_SWAP),
+       IB_OPCODE(XRC, FETCH_ADD),
+       IB_OPCODE(XRC, SEND_LAST_WITH_INVALIDATE),
+       IB_OPCODE(XRC, SEND_ONLY_WITH_INVALIDATE),
 };

 enum {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
