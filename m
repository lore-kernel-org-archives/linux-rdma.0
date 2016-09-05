From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 23/28] rxe: Avoid gcc 5.4 warning -Wswitch
Date: Mon,  5 Sep 2016 15:08:13 -0600
Message-ID: <1473109698-31408-24-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

convert_send_wr switches incompletely on an enum. Assume the intent was to
not do any copies for other enum members and dummy them in.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librxe/src/rxe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/librxe/src/rxe.c b/librxe/src/rxe.c
index 94d0de51f7dd..7164f6627171 100644
--- a/librxe/src/rxe.c
+++ b/librxe/src/rxe.c
@@ -596,6 +596,12 @@ void convert_send_wr(struct rxe_send_wr *kwr, struct ibv_send_wr *uwr)
 		kwr->wr.atomic.swap		= uwr->wr.atomic.swap;
 		kwr->wr.atomic.rkey		= uwr->wr.atomic.rkey;
 		break;
+
+	case IBV_WR_LOCAL_INV:
+	case IBV_WR_BIND_MW:
+	case IBV_WR_SEND_WITH_INV:
+	case IBV_WR_TSO:
+		break;
 	}
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
