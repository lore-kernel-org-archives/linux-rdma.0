From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Tue, 31 May 2016 10:14:15 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605311012100.3682@east.gentwo.org>
References: <57238F8C.70505@sandisk.com> <B72A389F-FFF1-498C-A946-8AA72B7769F8@oracle.com> <57277B63.8030506@sandisk.com> <6BBFD126-877C-4638-BB91-ABF715E29326@oracle.com> <1AFD636B-09FC-4736-B1C5-D1D9FA0B97B0@oracle.com> <8a3276bf-f716-3dca-9d54-369fc3bdcc39@dev.mellanox.co.il>
 <aaa67d51-663a-0aba-fc54-a5ab5d947a55@sandisk.com> <C0AE237D-5E5A-4F94-B717-F3A3B4B4D4A8@oracle.com> <574728EC.9040802@grimberg.me> <57473025.5020801@grimberg.me> <20160526192351.GV25500@leon.nu> <alpine.DEB.2.20.1605261511230.8857@east.gentwo.org>
 <574A941D.9050404@grimberg.me>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <574A941D.9050404-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 29 May 2016, Sagi Grimberg wrote:

>
> > > Sagi,
> > > I'm wondering if allocation from ZONE_DMA is the right way to
> > > replace ZONE_NORMAL allocations.
> > >
> > > I don't remember if memory compaction works on ZONE_DMA and it makes
> > > me nervous to think about long and multiple alloc/dealloc MR scenario.
> >
> > ZONE_DMA is a 16M memory segment used for legacy devices of the PC/AT era
> > (such as floppy drivers). Please do not use it.
>
> Really? It's used all over the stack...

On x86 that is the case. Other arches may have different uses for ZONE_DMA
but the intend it to support legacy devices unable to write to the whole
of memory (that is usally ZONE_NORMAL).

from include/linux/mmzone.h

enum zone_type {
#ifdef CONFIG_ZONE_DMA
        /*
         * ZONE_DMA is used when there are devices that are not able
         * to do DMA to all of addressable memory (ZONE_NORMAL). Then we
         * carve out the portion of memory that is needed for these
devices.
         * The range is arch specific.
         *
         * Some examples
         *
         * Architecture         Limit
         * ---------------------------
         * parisc, ia64, sparc  <4G
         * s390                 <2G
         * arm                  Various
         * alpha                Unlimited or 0-16MB.
         *
         * i386, x86_64 and multiple other arches
         *                      <16M.
         */
        ZONE_DMA,
#endif

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
