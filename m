From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 21:52:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AAFE820B@ORSMSX109.amr.corp.intel.com>
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
 <20151209182212.GF31636@obsidianresearch.com> <56689E86.9080807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56689E86.9080807-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> Example: Compute nodes are assigned pkeys 0x8000 and 0x7fff.  A node
> >> running the job scheduler has pkeys 0xffff and 0x8000 (maybe it's
> >> also the backup SA).  Ibacm would need to select pkey 0x8000 for
> >> communication.
> >
> > I've also seen the reverse, eg 0xFFFF is used for default ipoib
> > communication and 0x8001 is assigned to only some nodes as a child
> > vlan.
> 
> That's what I use internally in our test lab.
> 
> > Choosing 0x8001 in that case won't work either.
> 
> Nope.  The suggestion here would break our setup.  Well, *would* being
> the operative word where what I mean is would if we used ibacm.  But
> that's a story for another email...

In this case, Kaike, please change the default to just be pkey[0].

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
