From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] libibverbs: add ARM64 memory barrier macros
Date: Fri, 20 May 2016 13:37:28 -0500
Message-ID: <011001d1b2c6$a95a6f40$fc0f4dc0$@opengridcomputing.com>
References: <20160520163207.B99DCE0B9D@smtp.ogc.us> <9C6B67F36DCAFC479B1CF6A967258A8C7DDBB201@ORSMSX115.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8C7DDBB201-8oqHQFITsIFqS6EAlXoojrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Woodruff, Robert J'" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >The default generic barriers are not correct for ARM64. This results in data
> corruption.  The correct macros are lifted from the linux kernel.
> 
> Does this mean that the code you want to add to libibverbs will be tainted
with GPL
> since they come from the Linux kernel.

I guess so.

> I know that there are a lot of people that will not use a GPL library, since
it could
> taint their applications with GPL if they
> link to that library. I thought that is why LGPL was invented to prevent such
tainting.

I could utilize the code from FreeBSD.  Does that allow me to submit this to
libibverbs under the dual GPL/BSD license?

/*
 * Options for DMB and DSB:
 *      oshld   Outer Shareable, load
 *      oshst   Outer Shareable, store
 *      osh     Outer Shareable, all
 *      nshld   Non-shareable, load
 *      nshst   Non-shareable, store
 *      nsh     Non-shareable, all
 *      ishld   Inner Shareable, load
 *      ishst   Inner Shareable, store
 *      ish     Inner Shareable, all
 *      ld      Full system, load
 *      st      Full system, store
 *      sy      Full system, all
 */
#define dsb(opt)        __asm __volatile("dsb " __STRING(opt) : : : "memory")
#define dmb(opt)        __asm __volatile("dmb " __STRING(opt) : : : "memory")

#define mb()    dmb(sy) /* Full system memory barrier all */
#define wmb()   dmb(st) /* Full system memory barrier store */
#define rmb()   dmb(ld) /* Full system memory barrier load */



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
