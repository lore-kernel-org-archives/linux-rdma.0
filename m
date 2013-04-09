From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Date: Tue, 9 Apr 2013 22:00:11 +0300
Message-ID: <20130409190011.GA8212@redhat.com>
References: <20130324155153.GA8597@redhat.com>
 <515F3160.4020007@linux.vnet.ibm.com>
 <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
 <515F3A0F.5030507@linux.vnet.ibm.com>
 <20130409163929.GA7661@redhat.com>
 <51645630.3030608@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51645630.3030608-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael R. Hines" <mrhines-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 09, 2013 at 01:56:00PM -0400, Michael R. Hines wrote:
> On 04/09/2013 12:39 PM, Michael S. Tsirkin wrote:
> >On Fri, Apr 05, 2013 at 04:54:39PM -0400, Michael R. Hines wrote:
> >>To be more specific, here's what I did:
> >>
> >>1. apply kernel module patch - re-insert module
> >>1. QEMU does: ibv_reg_mr(........IBV_ACCESS_GIFT | IBV_ACCESS_REMOTE_READ)
> >>2. Start the RDMA migration
> >>3. Migration completes without any errors
> >>
> >>This test does *not* work with a cgroup swap limit, however. The
> >>process gets killed. (Both with and without GIFT)
> >>
> >>- Michael
> >Try to attach a debugger and see where it is when it gets killed?
> >
> 
> It's killed by cgroups - not a CPU exception.
> 
> The same test works fine using TCP migration with cgroups -
> everything is fine there.
> 
> The memory that RDMA attempted to register hits some kind of cgroups policy
> which results in a kernel message saying that the cgroup swap limit was hit
> and then it goes ahead and kills the process altogether.
> 
> It's not a QEMU problem - it seems to be a kernel bug.

Maybe cgroup swap limit really is buggy. That's interesting, but not
really related to this patch.  What's interesting is whether we save
lots memory by using this patch.
Couldn't you dump the pagemap for the qemu process and calculate real
memory usage before and after applying the patch?


-- 
MST
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
