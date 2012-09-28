From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 3/7] libibverbs: Add support for XRC SRQs
Date: Fri, 28 Sep 2012 17:24:20 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A9809D@FMSMSX151.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A97DCA@FMSMSX151.amr.corp.intel.com>
 <20120928004205.GB21759@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120928004205.GB21759-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +static inline uint32_t ibv_get_srq_num(struct ibv_srq *srq)
> > +{
> > +	struct verbs_context *vctx = verbs_get_ctx_op(srq->context, get_srq_num);
> > +	if (!vctx) {
> > +		errno = ENOSYS;
> > +		return 0;
> > +	}
> > +	return vctx->get_srq_num(srq);
> > +}
> 
> Do you think the function pointer indirection for ibv_get_srq_num is
> needed? I had thought something like:

Needed?  No - but I was trying to keep the verbs definitions in driver.h away from the user.
 
> Where has_comp_mask is a bitmask from the provider with each bit
> indicating if a provider allocated structure is extended with
> comp_mask. The driver is required to allocate all structures of that
> type with a comp_mask if the bit is set.

I like the concept of has_comp_mask.  I'll add that.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
