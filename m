From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: linux-next: Tree for Jun 21 (infiniband: qib)
Date: Fri, 21 Jun 2013 15:31:17 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211592E2@FMSMSX107.amr.corp.intel.com>
References: <20130621181721.11783d80583444868725b62c@canb.auug.org.au>
 <51C4717D.4090002@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C4717D.4090002-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: "linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I just submitted  a fix for this.

> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org]
> Sent: Friday, June 21, 2013 11:30 AM
> To: Stephen Rothwell
> Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; infinipath; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: linux-next: Tree for Jun 21 (infiniband: qib)
> 
> On 06/21/13 01:17, Stephen Rothwell wrote:
> > Hi all,
> >
> > Happy solstice!
> >
> > Changes since 20130620:
> >
> 
> 
> on x86_64:
> 
> when CONFIG_SMP is not enabled:
> 
> (from qib.h:)
> 
> #ifdef CONFIG_INFINIBAND_QIB_DCA
> struct qib_irq_notify {
> 	int rcv;
> 	void *arg;
> 	struct irq_affinity_notify notify;
> };
> #endif
> 
> struct irq_affinity_notify is only defined for CONFIG_SMP or
> GENERIC_HARDIRQS.
> Build error happens when one of those is not enabled.
> 
> 
> In file included from drivers/infiniband/hw/qib/qib_cq.c:41:0:
> drivers/infiniband/hw/qib/qib.h:447:29: error: field 'notify' has incomplete type
> make[4]: *** [drivers/infiniband/hw/qib/qib_cq.o] Error 1
> 
> 
> 
> 
> --
> ~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
