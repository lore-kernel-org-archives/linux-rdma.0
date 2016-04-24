From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH V2] powerpc/infiniband: Use cache inhibitted and guarded mapping on powerpc
Date: Sun, 24 Apr 2016 23:03:10 +0530
Message-ID: <87shyanc89.fsf@skywalker.in.ibm.com>
References: <1461139097-10213-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1461278876.3135.18.camel@kernel.crashing.org> <20160422160927.GB12897@obsidianresearch.com> <1461399949.3135.52.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461399949.3135.52.camel-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org> writes:

> On Fri, 2016-04-22 at 10:09 -0600, Jason Gunthorpe wrote:
>> On Fri, Apr 22, 2016 at 08:47:56AM +1000, Benjamin Herrenschmidt
>> wrote:
>> > 
>> > On Wed, 2016-04-20 at 03:58 -0400, Aneesh Kumar K.V wrote:
>> > > 
>> > > The driver was requesting for a writethrough mapping. But with
>> > > thoses
>> > > flags we will end up with a SAO mapping because we now have
>> > > memory
>> > > conherence always enabled. ie, the existing mapping will end up
>> > > with
>> > > a WIMG value 0b1110 which is Strong Access Order.
>> > > 
>> > > Update this to use cache inhibitted guarded mapping
>> > Why guarded ? If it's performance sensitive (and the driver has
>> > appropriate barriers where needed), you will get write combining
>> > without guarded, you won't with it.
>> This driver uses uncached write combining on x86
>
> Right so if you want something similar on power, use the _wc variant,
> and make sure you have the appropriate barriers when you need to
> break combining.
>
> Cheers,
> Ben.

The code after change looks like below

#if defined(__powerpc__)
	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
#endif

	/*
	 * don't allow them to later change to readable with mprotect (for when
	 * not initially mapped readable, as is normally the case)
	 */
	vma->vm_flags &= ~VM_MAYREAD;
	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND;

	/* We used PAT if wc_cookie == 0 */
	if (!dd->wc_cookie)
		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);

So it uses pgprot_noncached_wc if (!dd->wc_cookie). Hence I was thinking
it needs more stricter mapping otherwise.

-aneesh

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
