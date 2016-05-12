From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/15] ib_pack.h: Add opcode definition for send with
 invalidate
Date: Thu, 12 May 2016 10:23:53 -0700
Message-ID: <20160512172352.9741.88565.stgit@scvm10.sc.intel.com>
References: <20160512172050.9741.84190.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172050.9741.84190.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The opcode for "SEND Last with Invalidate" and "SEND Only with
Invalidate" have been defined for RC in IBA Specification Vol 1
since Release 1.2. Add the definition to the header file in
preparation of supporting these opcodes in rdmavt based drivers.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/ib_pack.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index 0f3daae..b13419c 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -103,6 +103,9 @@ enum {
 	IB_OPCODE_ATOMIC_ACKNOWLEDGE                = 0x12,
 	IB_OPCODE_COMPARE_SWAP                      = 0x13,
 	IB_OPCODE_FETCH_ADD                         = 0x14,
+	/* opcode 0x15 is reserved */
+	IB_OPCODE_SEND_LAST_WITH_INVALIDATE         = 0x16,
+	IB_OPCODE_SEND_ONLY_WITH_INVALIDATE         = 0x17,
 
 	/* real constants follow -- see comment about above IB_OPCODE()
 	   macro for more details */
@@ -129,6 +132,8 @@ enum {
 	IB_OPCODE(RC, ATOMIC_ACKNOWLEDGE),
 	IB_OPCODE(RC, COMPARE_SWAP),
 	IB_OPCODE(RC, FETCH_ADD),
+	IB_OPCODE(RC, SEND_LAST_WITH_INVALIDATE),
+	IB_OPCODE(RC, SEND_ONLY_WITH_INVALIDATE),
 
 	/* UC */
 	IB_OPCODE(UC, SEND_FIRST),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
