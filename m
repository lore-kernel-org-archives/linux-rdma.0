From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH for-next V1 5/9] IB/core: Add rdma_network_type to wc
Date: Mon, 30 Nov 2015 20:56:15 +0000
Message-ID: <HE1PR05MB1418F62E731D463F2A63A899B1000@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
 <1444925232-13598-6-git-send-email-matanb@mellanox.com>
 <20151123211916.GA6062@obsidianresearch.com>
 <CAAKD3BCWMrd8A+UgjQg+jtfLmyOCaOB4iGCr2ZAbaazRBZeGxw@mail.gmail.com>
 <20151124181415.GC10391@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124181415.GC10391-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-

> 
> The abstraction at the gid cache is making it too easy to make this mistake. It
> is enabling callers to do direct gid lookups without a route lookup, which is
> unconditionally wrong. Every call site into the gid cache I looked at appears to
> have this problem.
> 
> The simplest fix is to have a new gid cache api for rocve2 that somehow
> forces/includes the necessary route lookup. The existing API cannot simply
> be extended for rocev2.
> 

I think that the GID cache should remain just that: a cache.
We shouldn't bloat it.
The CMA is the proper place to handle IP resolution.

> > roce_gid_mgmt, is the part that populates this "dumb" database.
> > IMHO, adding such a "smart" layer to the GID cache is wrong, as this
> > should be part of RDMACM which does the translation. No need to get
> > the gid cache involved.
> 
> OK. Change the gid cache so only a RDMA CM private API can return
> rocev2 gids.
> 

The same cache is also used in IB and thus by other components, so it cannot
be a private CM API.
RoCE ULPs use the CMA for establishing connections, so route lookups should
be done from there.
 --Liran

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
