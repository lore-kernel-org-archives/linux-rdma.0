From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Date: Tue, 9 Apr 2013 22:09:44 +0300
Message-ID: <20130409190943.GC8212@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
 <515F3948.40205@linux.vnet.ibm.com>
 <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 05, 2013 at 02:03:33PM -0700, Roland Dreier wrote:
> On Fri, Apr 5, 2013 at 1:51 PM, Michael R. Hines
> <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > Sorry, I was wrong. ignore the comments about cgroups. That's still broken.
> > (i.e. trying to register RDMA memory while using a cgroup swap limit cause
> > the process get killed).
> >
> > But the GIFT flag patch works (my understanding is that GIFT flag allows the
> > adapter to transmit stale memory information, it does not have anything to
> > do with cgroups specifically).
> 
> The point of the GIFT patch is to avoid triggering copy-on-write so
> that memory doesn't blow up during migration.  If that doesn't work
> then there's no point to the patch.
> 
>  - R.

Absolutely. Checking whether an OOM gets triggered looks like a heavy
handed approach to testing the feature though.
It's relevant, but there could be many other reasons for it to trigger.
See Documentation/cgroups/memory.txt section "Troubleshooting".

It's easier to just check whether this patch reduces the memory consumption,
that's the point really.

-- 
MST
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
