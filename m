From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibstat does not recognize iWARP RNIC adapters
Date: Thu, 26 Apr 2012 22:11:07 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373469D87B6@ORSMSX101.amr.corp.intel.com>
References: <8A71B368A89016469F72CD08050AD3340B8AAE7F@maui.asicdesigners.com>
 <1828884A29C6694DAF28B7E6B8A82373469D85A8@ORSMSX101.amr.corp.intel.com>
 <4F995001.7050306@opengridcomputing.com>
 <1828884A29C6694DAF28B7E6B8A82373469D860B@ORSMSX101.amr.corp.intel.com>
 <4F99586F.5040106@opengridcomputing.com>
 <4F995E5C.1090705@dev.mellanox.co.il> <4F996A71.6090309@dev.mellanox.co.il>
 <4F996B62.2030707@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F996B62.2030707-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Troy Leedberg <troy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hal/Sean, I defer to you on whether you think we should add this change to
> ibstat.  If you all recommend against it,
> we'll advise customers to use ibv_devinfo, which is included with libibverbs
> and is required for iwarp user apps.  But
> it seems a minimal change to add, and previously it did include iwarp devices.

It's not my call, but the proposed change is to libibumad, not ibstat.  libibumad is really used to communicate with the kernel ib_user_mad module, which ignores iWarp devices.  My objection was to changing libibumad, which cannot support iWarp devices in any generic way.

Having ibstat report iWarp devices by going through libibumad can actually give a false sense that a iWarp device is usable and both libibumad and ib_user_mad are required to make iWarp devices work.  Considering that it hasn't worked in 4 years, I would think customers are more used to it not working with iwarp devices than with.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
