From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 11:22:12 -0700
Message-ID: <20151209182212.GF31636@obsidianresearch.com>
References: <56683080.1090801@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185810D9@CRSMSX101.amr.corp.intel.com>
 <5668354B.4090903@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB18581111@CRSMSX101.amr.corp.intel.com>
 <56683C6C.7070106@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB185811ED@CRSMSX101.amr.corp.intel.com>
 <5668458A.7020809@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AAFE7F21@ORSMSX109.amr.corp.intel.com>
 <56685B98.5080803@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AAFE7FB6@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AAFE7FB6-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2015 at 05:13:49PM +0000, Hefty, Sean wrote:
 
> Example: Compute nodes are assigned pkeys 0x8000 and 0x7fff.  A node
> running the job scheduler has pkeys 0xffff and 0x8000 (maybe it's
> also the backup SA).  Ibacm would need to select pkey 0x8000 for
> communication.

I've also seen the reverse, eg 0xFFFF is used for default ipoib
communication and 0x8001 is assigned to only some nodes as a child
vlan.

Choosing 0x8001 in that case won't work either.

pkey[0] at least has the logic that the admin will configure things so
that the default ipoib device reaches the broadest audiance makes the
most sense to me. That is what most sites I've seen want to do.

I'm not quite sure what the acm algorithm is, but can't it just figure
out the pkey from the IP routing? Ie if you have an IP address to
resolve a few netlink queries will tell you what pkey to use, and that
is where the acm multicast should go?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
