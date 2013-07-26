From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] RDMA/cxgb3: stack info leak in iwch_craete_cq()
Date: Fri, 26 Jul 2013 11:47:08 +0300
Message-ID: <20130726084708.GA5636@mwanda>
References: <20130725170409.GB7026@elgon.mountain>
 <51F171D0.7050204@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51F171D0.7050204-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 25, 2013 at 01:43:28PM -0500, Steve Wise wrote:
> On 7/25/2013 12:04 PM, Dan Carpenter wrote:
> >The "uresp.reserved" field isn't initialized.  It's at the end, of the
> >struct here so we don't need to copy it to the user.
> >
> >Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >
> >diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> >index e87f220..b8e26f2 100644
> >--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
> >+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
> >@@ -226,7 +226,7 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev, int entries, int ve
> >  			mm->len = PAGE_ALIGN(((1UL << uresp.size_log2) + 1) *
> >  					     sizeof(struct t3_cqe));
> >  			uresp.memsize = mm->len;
> >-			resplen = sizeof uresp;
> >+			resplen = sizeof uresp - sizeof uresp.reserved;
> >  		}
> >  		if (ib_copy_to_udata(udata, &uresp, resplen)) {
> >  			kfree(mm);
> 
> How did you find this?

This is some incoming Smatch stuff.

> 
> What if, in the future, the iwch_create_cq_resp struct is changed
> and stuff added to the end?  I'm not sure this optimization is worth
> it?

Yeah.  I'm not sure either.  I wouldn't do it outside infiniband
code because I was copying other code from there.  I can redo this.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
