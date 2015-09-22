From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 02/32] IB/core: Add SEND_LAST_INV and SEND_ONLY_INV opcodes
Date: Tue, 22 Sep 2015 10:30:45 +0300
Message-ID: <1442907075-13228-3-git-send-email-kamalh@mellanox.com>
References: <1442907075-13228-1-git-send-email-kamalh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442907075-13228-1-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Intorduce Add SEND_LAST_INV and SEND_ONLY_INV opcodes in ib_pack.h to be
used by RXE for RC.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_pack.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index 0e494d5..6c4b11a 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -103,6 +103,8 @@ enum {
 	IB_OPCODE_ATOMIC_ACKNOWLEDGE                = 0x12,
 	IB_OPCODE_COMPARE_SWAP                      = 0x13,
 	IB_OPCODE_FETCH_ADD                         = 0x14,
+	IB_OPCODE_SEND_LAST_INV                     = 0x16,
+	IB_OPCODE_SEND_ONLY_INV                     = 0x17,
 
 	/* real constants follow -- see comment about above IB_OPCODE()
 	   macro for more details */
@@ -129,6 +131,8 @@ enum {
 	IB_OPCODE(RC, ATOMIC_ACKNOWLEDGE),
 	IB_OPCODE(RC, COMPARE_SWAP),
 	IB_OPCODE(RC, FETCH_ADD),
+	IB_OPCODE(RC, SEND_LAST_INV),
+	IB_OPCODE(RC, SEND_ONLY_INV),
 
 	/* UC */
 	IB_OPCODE(UC, SEND_FIRST),
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
