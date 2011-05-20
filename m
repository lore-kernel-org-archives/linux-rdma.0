From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Return EPROTONOSUPPORT when an RDMA device lacks QP0
Date: Fri, 20 May 2011 19:23:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373010745@ORSMSX101.amr.corp.intel.com>
References: <E280C3CC-BD50-4383-BE33-FCC31C72D3F0@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E280C3CC-BD50-4383-BE33-FCC31C72D3F0-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> We had a script which was looping through the devices returned from ibstat
> and attempted to register a SMI agent on an ethernet device.  This caused
> a kernel panic.  We have fixed our script.  This patch prevents the panic.

Do you remember where the panic was?

I'm going to guess in ib_register_mad_agent() at this line:

	mad_agent_priv->agent.mr = ib_get_dma_mr(port_priv->qp_info[qpn].qp->pd,
						 IB_ACCESS_LOCAL_WRITE);

in which case it may be safer to check for the NULL pointer.  Can you confirm if this was the spot?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
