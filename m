From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/16] IB/hfi1: Add a page pinning cache for PSM sdma
Date: Tue, 22 Mar 2016 07:46:44 -0400
Message-ID: <20160322114644.GA20139@phlsvsds.ph.intel.com>
References: <20160310045609.GC1977@leon.nu> <20160314070951.GB26456@leon.nu> <20160314120152.GA30838@phlsvsds.ph.intel.com> <CAJ3xEMiSgXFT46r0Y7DZGr3mpJFSLrtYrMdz+DbCXDozbMYZRA@mail.gmail.com> <20160315012049.GA30055@phlsvsds.ph.intel.com> <CAJ3xEMhToYOBMo_nNi2fFpTexUmUqb3zBX7zWWYjCDfPWpWn-w@mail.gmail.com> <20160315193731.GA20662@phlsvsds.ph.intel.com> <CAJ3xEMjWxdwM0wQR85_-wHpPhYSWz1W0T8H_nDjnp2JS7G29Qw@mail.gmail.com> <20160316172309.GB26530@phlsvsds.ph.intel.com> <CAJ3xEMg5OPBT63=VV4EKnZUWSHGatDRL0n7O4iBVrN9bMUw5dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMg5OPBT63=VV4EKnZUWSHGatDRL0n7O4iBVrN9bMUw5dg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 22, 2016 at 09:33:55AM +0200, Or Gerlitz wrote:
>On Wed, Mar 16, 2016 at 7:23 PM, Dennis Dalessandro
><dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> On Wed, Mar 16, 2016 at 05:53:37PM +0200, Or Gerlitz wrote:
>
>>> The cache comes to amortize the cost of pin/unpin and such, correct? this means
>>> that over longs runs, if there's nice locality of the same process
>>> using the same pages, you pay the register/pin cost once, later use lazy
>>> de-registration/pinning, and only do that
>>> when MMU notifier tells you this is a must, or under some eviction policy.
>
>>> Since the cost is amortized, the system calls over-head should be negligible
>>> (also, the same system call can be used to evict X and register Y), do you
>>> have performance data that shows otherwise?
>
>> I don't personally have the data but will check with some folks here.
>
>Dennis, didn't see a reply from you here...

I have been on out of the office for a few days. I did check into the 
performance aspect here and have been assured there is a performance problem 
with the increased number of system calls. Though I do not have any 
published data to point you to. 

We are particularly worried about the eviction case which is where the 
amortization argument doesn't hold up. If the eviction policy is set to 
evict buffers which have not been used recently in favor of a new buffer 
(which is a very common policy), this happens more often than you realize.  
We do not want any additional cost in this case.

Another reason we do not want this in user space is that it changes the 
semantic of the SDMA transfer call. Normally user space applications don't 
care what needs to be done under the covers to transfer a buffer. The user 
application/library calls into the kernel which takes care of the details, 
including pinning the pages while the underlying hardware pulls the data 
from the buffer. The user application does not (and should not) care about 
that. This is how SDMA transfers work as well.

However, if we move the cache into user space all of that changes. Now user 
space has to start caring about the state of the buffer. The normal SDMA 
transfer request cannot be used as it will, or might, pin/unpin pages it 
shouldn't. The kernel will have to provide effectively two semantically 
different versions of the calls - one which pins/unpins and one which does 
not. This is yet another complication that is being unnecessarily pushed 
into user space.

> Doug, as this is still review discussion in progress, I guess you'll wait 
> with
> finalizing the talks before adding this into your 2nd 4.6 pull request?

I think our position is clear why we do not want to put this in user space.  
Can we? Yes. But just because we could doesn't mean we should. So what is 
your technical reason that makes you feel so strongly this doesn't belong in 
our particular driver? Is there some way this impacts any other RDMA 
drivers, the IB core, or anything else?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
