From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 18:39:36 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB18581334@CRSMSX101.amr.corp.intel.com>
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
 <20151209182212.GF31636@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AAFE8111@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AAFE8111-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Hefty, Sean
> Sent: Wednesday, December 09, 2015 1:37 PM
> To: Jason Gunthorpe
> Cc: Hal Rosenstock; Wan, Kaike; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
> 
> > pkey[0] at least has the logic that the admin will configure things so
> > that the default ipoib device reaches the broadest audiance makes the
> > most sense to me. That is what most sites I've seen want to do.
> 
> Kaike, will pkey[0] work in the configurations that you're targeting with this
> change?

Yes. That will work for me.

> 
> This seems like a very simple solution that's better than what we have now.
> 
> > I'm not quite sure what the acm algorithm is, but can't it just figure
> > out the pkey from the IP routing? Ie if you have an IP address to
> > resolve a few netlink queries will tell you what pkey to use, and that
> > is where the acm multicast should go?
> 
> When an IP address is used, it uses the correct pkey (based on routing data).
> I mentioned this in a separate email, but this addresses the case when
> hostnames are used and ipoib may not be involved.
> 
> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
