From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/2] IB/{mlx4,ipoib}: bug fixes for vendor mads and
 ipoib/gro
Date: Tue, 31 Jan 2012 19:12:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237333498CF8@ORSMSX101.amr.corp.intel.com>
References: <alpine.LRH.2.00.1201261624540.30384@ogerlitz.voltaire.com>
 <4F24F51F.20309@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F24F51F.20309-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > This short series fixes two kind of badly hurting bugs that we
> > stepped on lately. We would be happy to have them treated quickly
> > so they can be pushed further to -stable, distros, etc.
> 
> Roland, when (hopefully soon) accepting these, could you please add CC
> to stable in the commits so they go there automatically?

What sort of impact does this bug to ipoib have?

I ask because my bandwidth numbers on 3.2 for large, unidirectional transfers over ipoib are abysmal.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
