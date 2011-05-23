From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] Return EPROTONOSUPPORT when an RDMA device lacks QP0
Date: Sun, 22 May 2011 21:05:49 -0700
Message-ID: <BANLkTinoKxr5A6Qm7JXV=7qvgaLwoKJt+A@mail.gmail.com>
References: <E280C3CC-BD50-4383-BE33-FCC31C72D3F0@llnl.gov>
 <1828884A29C6694DAF28B7E6B8A82373010745@ORSMSX101.amr.corp.intel.com>
 <8D19CC19-B4FD-4338-9267-9C1BC32A6BAE@llnl.gov> <1828884A29C6694DAF28B7E6B8A8237301085B@ORSMSX101.amr.corp.intel.com>
 <B4F482DA-6C66-4AC9-A583-D2091E8F32C4@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B4F482DA-6C66-4AC9-A583-D2091E8F32C4-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > @@ -2738,6 +2745,7 @@ static void init_mad_qp(struct
ib_mad_port_private *port_priv,
 >  	spin_lock_init(&qp_info->snoop_lock);
 >  	qp_info->snoop_table = NULL;
 >  	qp_info->snoop_table_size = 0;
 > +	qp_info->qp = NULL;
 >  	atomic_set(&qp_info->snoop_count, 0);
 >  }

This bit isn't needed, is it?  qp_info is in memory allocated with kzalloc.
(We could get rid of the other = 0 / = NULL lines too)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
