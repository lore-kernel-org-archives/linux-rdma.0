From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Date: Tue, 9 Apr 2013 19:39:30 +0300
Message-ID: <20130409163929.GA7661@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
 <515F3A0F.5030507@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515F3A0F.5030507-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 05, 2013 at 04:54:39PM -0400, Michael R. Hines wrote:
> To be more specific, here's what I did:
> 
> 1. apply kernel module patch - re-insert module
> 1. QEMU does: ibv_reg_mr(........IBV_ACCESS_GIFT | IBV_ACCESS_REMOTE_READ)
> 2. Start the RDMA migration
> 3. Migration completes without any errors
> 
> This test does *not* work with a cgroup swap limit, however. The
> process gets killed. (Both with and without GIFT)
> 
> - Michael

Try to attach a debugger and see where it is when it gets killed?

> On 04/05/2013 04:43 PM, Roland Dreier wrote:
> >On Fri, Apr 5, 2013 at 1:17 PM, Michael R. Hines
> ><mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> >>I also removed the IBV_*_WRITE flags on the sender-side and activated
> >>cgroups with the "memory.memsw.limit_in_bytes" activated and the migration
> >>with RDMA also succeeded without any problems (both with *and* without GIFT
> >>also worked).
> >Not sure I'm interpreting this correctly.  Are you saying that things
> >worked without actually setting the GIFT flag?   In which case why are
> >we adding this flag?
> >
> >  - R.
> >
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
