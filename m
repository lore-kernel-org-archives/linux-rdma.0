From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Return EPROTONOSUPPORT when an RDMA device lacks QP0
Date: Fri, 20 May 2011 23:23:33 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237301085B@ORSMSX101.amr.corp.intel.com>
References: <E280C3CC-BD50-4383-BE33-FCC31C72D3F0@llnl.gov>
 <1828884A29C6694DAF28B7E6B8A82373010745@ORSMSX101.amr.corp.intel.com>
 <8D19CC19-B4FD-4338-9267-9C1BC32A6BAE@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8D19CC19-B4FD-4338-9267-9C1BC32A6BAE-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > 	mad_agent_priv->agent.mr = ib_get_dma_mr(port_priv->qp_info[qpn].qp-
> >pd,
> > 						 IB_ACCESS_LOCAL_WRITE);
> >
> > in which case it may be safer to check for the NULL pointer.  Can you
> confirm if this was the spot?
> 
> Yes it was that spot.  I did think of that today after I sent the patch.
> 
> Do you think it would be safer just to check for both pointers QP0 and 1
> (depending on the registration)?

Yes, it seems safer and easier to maintain if we just validated the pointer.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
