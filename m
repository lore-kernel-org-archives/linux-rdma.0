From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Staging: rdma: hfi1: verbs_mcast: fixed a brace coding style issue
Date: Wed, 24 Feb 2016 12:08:47 -0500
Message-ID: <20160224170846.GA32144@phlsvsds.ph.intel.com>
References: <1456068639-4745-1-git-send-email-Becher.Jannik@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456068639-4745-1-git-send-email-Becher.Jannik-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jannik Becher <becher.jannik-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 21, 2016 at 04:30:39PM +0100, Jannik Becher wrote:
>Fixed a coding style issue.
>
>Signed-off-by: Jannik Becher <Becher.Jannik-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>---
> drivers/staging/rdma/hfi1/verbs_mcast.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/staging/rdma/hfi1/verbs_mcast.c b/drivers/staging/rdma/hfi1/verbs_mcast.c
>index afc6b4c..c45d4b1 100644
>--- a/drivers/staging/rdma/hfi1/verbs_mcast.c
>+++ b/drivers/staging/rdma/hfi1/verbs_mcast.c
>@@ -140,11 +140,11 @@ struct hfi1_mcast *hfi1_mcast_find(struct hfi1_ibport *ibp, union ib_gid *mgid)
> 
> 		ret = memcmp(mgid->raw, mcast->mgid.raw,
> 			     sizeof(union ib_gid));
>-		if (ret < 0)
>+		if (ret < 0) {
> 			n = n->rb_left;
>-		else if (ret > 0)
>+		} else if (ret > 0) {
> 			n = n->rb_right;
>-		else {
>+		} else {
> 			atomic_inc(&mcast->refcount);
> 			spin_unlock_irqrestore(&ibp->lock, flags);
> 			goto bail;
>-- 

Doug,

This has been taken care already when I moved the code to rdmavt. Patch is 
submitted in the midst of my other stuff for 4.6. See:
http://www.spinics.net/lists/linux-rdma/msg32802.html

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
