From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 22/28] nes: Avoid gcc 6.1 warning -Wmisleading-indentation
Date: Mon,  5 Sep 2016 15:08:12 -0600
Message-ID: <1473109698-31408-23-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

../providers/nes/nes_uverbs.c:489:5: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
     if (++nesuqp->rq_tail >= nesuqp->rq_size)
     ^~
../providers/nes/nes_uverbs.c:491:6: note: ...this statement, but the latter is misleadingly indented as if it is guarded by the 'if'
      if (entry->status == NES_CQ_BUF_OV_ERR)
      ^~

Presumably this has been tested as is, so I've opted to preserve the
behaviour, but I can't tell if that is right or not.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libnes/src/nes_uverbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libnes/src/nes_uverbs.c b/libnes/src/nes_uverbs.c
index 80891d6243c7..6458c51c3f55 100644
--- a/libnes/src/nes_uverbs.c
+++ b/libnes/src/nes_uverbs.c
@@ -518,8 +518,8 @@ int nes_ima_upoll_cq(struct ibv_cq *cq, int num_entries, struct ibv_wc *entry)
 				/* Working on a RQ Completion*/
 				if (++nesuqp->rq_tail >= nesuqp->rq_size)
 					nesuqp->rq_tail = 0;
-					if (entry->status == NES_CQ_BUF_OV_ERR)
-						entry->status = IBV_WC_LOC_LEN_ERR;
+				if (entry->status == NES_CQ_BUF_OV_ERR)
+					entry->status = IBV_WC_LOC_LEN_ERR;
 			}
 
 			if (++head >= cq_size)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
