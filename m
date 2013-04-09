From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Date: Tue, 9 Apr 2013 22:03:50 +0300
Message-ID: <20130409190350.GB8212@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
 <515F3948.40205@linux.vnet.ibm.com>
 <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com>
 <515F42EE.8060203@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515F42EE.8060203-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

presumably is_dup_page reads the page, so should not break COW ...

I'm not sure about the cgroups swap limit - you might have
too many non COW pages so attempting to fault them all in
makes you exceed the limit. You really should look at
what is going on in the pagemap, to see if there's
measureable gain from the patch.


On Fri, Apr 05, 2013 at 05:32:30PM -0400, Michael R. Hines wrote:
> Well, I have the "is_dup_page()" commented out.......when RDMA is
> activated.....
> 
> Is there something else in QEMU that could be touching the page that
> I don't know about?
> 
> - Michael
> 
> 
> On 04/05/2013 05:03 PM, Roland Dreier wrote:
> >On Fri, Apr 5, 2013 at 1:51 PM, Michael R. Hines
> ><mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> >>Sorry, I was wrong. ignore the comments about cgroups. That's still broken.
> >>(i.e. trying to register RDMA memory while using a cgroup swap limit cause
> >>the process get killed).
> >>
> >>But the GIFT flag patch works (my understanding is that GIFT flag allows the
> >>adapter to transmit stale memory information, it does not have anything to
> >>do with cgroups specifically).
> >The point of the GIFT patch is to avoid triggering copy-on-write so
> >that memory doesn't blow up during migration.  If that doesn't work
> >then there's no point to the patch.
> >
> >  - R.
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
