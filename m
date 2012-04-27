From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: ibstat does not recognize iWARP RNIC adapters
Date: Fri, 27 Apr 2012 10:29:16 -0700
Message-ID: <20120427102916.7794f39e.weiny2@llnl.gov>
References: <8A71B368A89016469F72CD08050AD3340B8AAE7F@maui.asicdesigners.com>
	<1828884A29C6694DAF28B7E6B8A82373469D85A8@ORSMSX101.amr.corp.intel.com>
	<4F995001.7050306@opengridcomputing.com>
	<1828884A29C6694DAF28B7E6B8A82373469D860B@ORSMSX101.amr.corp.intel.com>
	<4F99586F.5040106@opengridcomputing.com>
	<4F995E5C.1090705@dev.mellanox.co.il>
	<4F996A71.6090309@dev.mellanox.co.il>
	<4F996B62.2030707@opengridcomputing.com>
	<1828884A29C6694DAF28B7E6B8A82373469D87B6@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373469D87B6-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 26 Apr 2012 22:11:07 +0000
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > Hal/Sean, I defer to you on whether you think we should add this change to
> > ibstat.  If you all recommend against it,
> > we'll advise customers to use ibv_devinfo, which is included with libibverbs
> > and is required for iwarp user apps.  But
> > it seems a minimal change to add, and previously it did include iwarp devices.
> 
> It's not my call, but the proposed change is to libibumad, not ibstat.  libibumad is really used to communicate with the kernel ib_user_mad module, which ignores iWarp devices.  My objection was to changing libibumad, which cannot support iWarp devices in any generic way.
> 
> Having ibstat report iWarp devices by going through libibumad can actually give a false sense that a iWarp device is usable and both libibumad and ib_user_mad are required to make iWarp devices work.  Considering that it hasn't worked in 4 years, I would think customers are more used to it not working with iwarp devices than with.
> 

Sean states this very well.  Until iWARP supports some sort of MAD processing
that is the distinction on what devices libibumad should return.  Following
that distinction I think ibstat should be changed in some way to reflect that.
See the other thread by Hal concerning possible names like "umad_devinfo".  I
am open to suggestions for other names.

Ira

> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
