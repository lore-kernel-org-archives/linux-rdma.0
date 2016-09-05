From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 10/28] nes: Fix clang 3.6 warning -Wtautological-constant-out-of-range-compare
Date: Mon,  5 Sep 2016 15:08:00 -0600
Message-ID: <1473109698-31408-11-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

clang will miscompile this code because it make assumptions
about the signededness of enums.

Instead create a constant for an invalid ibv_wc_opcode and use that
everywhere. Unsigned enums will use -1, signed enums should use INT_MAX.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libnes/src/nes_uverbs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/libnes/src/nes_uverbs.c b/libnes/src/nes_uverbs.c
index 12e6222313ad..80891d6243c7 100644
--- a/libnes/src/nes_uverbs.c
+++ b/libnes/src/nes_uverbs.c
@@ -471,13 +471,15 @@ int nes_ima_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 	}
 
 	while (cqe_count < num_entries) {
-		entry->opcode = -1;
+		const enum ibv_wc_opcode INVAL_OP = -1;
+
+		entry->opcode = INVAL_OP;
 		cqe = &cqes[head];
 		cqe_misc =
 			le32_to_cpu(cqe->cqe_words[NES_NIC_CQE_MISC_IDX]);
 		if (cqe_misc & NES_NIC_CQE_VALID) {
 			memset(entry, 0, sizeof *entry);
-			entry->opcode = -1;
+			entry->opcode = INVAL_OP;
 			cqe->cqe_words[NES_NIC_CQE_MISC_IDX] = 0;
 			entry->status = (cqe_misc & NES_NIC_CQE_ERRV_MASK) >>
 						NES_NIC_CQE_ERRV_SHIFT;
@@ -523,7 +525,7 @@ int nes_ima_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 			if (++head >= cq_size)
 				head = 0;
 
-			if (entry->opcode != -1) {
+			if (entry->opcode != INVAL_OP) {
 				/* it is possible that no entry will be
 				  available */
 				cqe_count++;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
