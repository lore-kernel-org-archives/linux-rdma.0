From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH v3 05/10] iw_cxgb4: Add connection management functions.
Date: Mon, 26 Apr 2010 09:56:12 -0500
Message-ID: <4BD5A98C.8030700@opengridcomputing.com>
References: <20100416182924.22495.59421.stgit@build.ogc.int>	<20100416182951.22495.60351.stgit@build.ogc.int> <adask6oo2d4.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adask6oo2d4.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> Thanks, all this looks pretty clean and small so I added it (as one big
> patch).  One tiny issue that we can fix with a follow-up patch:
>
>  > +int c4iw_ep_redirect(void *ctx, struct dst_entry *old, struct dst_entry *new,
>  > +		     struct l2t_entry *l2t)
>  > +{
>  > +	struct c4iw_ep *ep = ctx;
>  > +
>  > +	if (ep->dst != old)
>  > +		return 0;
>  > +
>  > +	PDBG("%s ep %p redirect to dst %p l2t %p\n", __func__, ep, new,
>  > +	     l2t);
>  > +	dst_hold(new);
>  > +	cxgb4_l2t_release(ep->l2t);
>  > +	ep->l2t = l2t;
>  > +	dst_release(old);
>  > +	ep->dst = new;
>  > +	return 1;
>  > +}
>
> As far as I can see this function is not called or otherwise referenced
> anywhere else (except for a declaration in a header).  Can we drop it?
>   

Yes.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
