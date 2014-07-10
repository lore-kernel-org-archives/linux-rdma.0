From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] svcrdma: send_write() must not overflow the device's max sge
Date: Thu, 10 Jul 2014 14:51:16 -0500
Message-ID: <005d01cf9c78$4fa621d0$eef26570$@opengridcomputing.com>
References: <20140709184914.22217.59770.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140709184914.22217.59770.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I tested this with nfsv3 and v4, over cxgb4 and mlx4: cthon04, iozone, fio, and xfs.  No regressions seen...

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
