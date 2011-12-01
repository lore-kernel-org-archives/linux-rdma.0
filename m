From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 4/5] rdma/cm: Update port reservation to support AF_IB
Date: Thu, 1 Dec 2011 18:31:56 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237323FC1EED@ORSMSX102.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E8D150@ORSMSX101.amr.corp.intel.com>
 <4ED73F81.6060605@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ED73F81.6060605-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +static struct idr *cma_select_ib_ps(struct rdma_id_private *id_priv)
> > [...]
> > +	if (ps) {
> > +		sib->sib_sid = cpu_to_be64(sid_ps | ntohs(cma_port((struct
> sockaddr *) sib)));
> > +		sib->sib_sid_mask = cpu_to_be64(RDMA_IB_IP_PS_MASK | sib-
> >sib_sid_mask);
> > +	}
> > +	return ps;
> 
> looks like ntohs(cma_port((struct sockaddr *) sib)) introduced this sparse
> warning
> 
> > drivers/infiniband/core/cma.c:2338:37: warning: restricted __be64
> > degrades to integer

I don't understand this warning, but I'll re-run sparse on the complete patch set and fixup any issues.  (I thought I had run sparse against the patches, but maybe it was an older change set.)  Thanks.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
