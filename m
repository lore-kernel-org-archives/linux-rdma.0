From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: Fixes memory leak in send_flowc
Date: Mon, 16 Jun 2014 16:44:04 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1406161638360.21018@chino.kir.corp.google.com>
References: <1402940957-6381-1-git-send-email-xerofoify@gmail.com> <539F34E8.3000501@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <539F34E8.3000501-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 16 Jun 2014, Steve Wise wrote:

> On 6/16/2014 12:49 PM, Nicholas Krause wrote:
> > Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >   drivers/infiniband/hw/cxgb4/cm.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/hw/cxgb4/cm.c
> > b/drivers/infiniband/hw/cxgb4/cm.c
> > index 5e153f6..867e664 100644
> > --- a/drivers/infiniband/hw/cxgb4/cm.c
> > +++ b/drivers/infiniband/hw/cxgb4/cm.c
> > @@ -455,8 +455,11 @@ static void send_flowc(struct c4iw_ep *ep, struct
> > sk_buff *skb)
> >   	unsigned int flowclen = 80;
> >   	struct fw_flowc_wr *flowc;
> >   	int i;
> > -
> 
> Please add back the above blank line.
> 
> >   	skb = get_skb(skb, flowclen, GFP_KERNEL);
> > +	if (!skb) {
> > +		kfree_skb(skb);
> 
> Let's do a pr_warn() here;
> 
>         pr_warn(MOD "%s failed to allocate skb.\n", __func__);
> 

No need, if the allocation from skbuff_head_cache fails in the slab 
allocator, the page allocator will loop forever for orders less than 
PAGE_ALLOC_COSTLY_ORDER or spew a page allocation failure warning with a 
stack trace that indicated the high order page allocation failed in this 
path.

> 
> > +		return;
> > +	}
> >   	flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
> >     	flowc->op_to_nparams = cpu_to_be32(FW_WR_OP(FW_FLOWC_WR) |
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
