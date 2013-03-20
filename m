From: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all ports
 of HCA are connected]
Date: Wed, 20 Mar 2013 22:44:47 +0000
Message-ID: <514A3BDF.2090105@oracle.com>
References: <5140E1A3.9070706@oracle.com> <51427819.7000505@oracle.com> <514278CA.8010809@oracle.com> <2807E5FD2F6FDA4886F6618EAC48510EBB3F62@CRSMSX102.amr.corp.intel.com> <514A0156.2070009@oracle.com> <20130320190208.GA23478@obsidianresearch.com> <2807E5FD2F6FDA4886F6618EAC48510EBB4214@CRSMSX102.amr.corp.intel.com> <514A3169.7000501@oracle.com> <20130320222422.GA30100@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130320222422.GA30100-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 20/03/2013 22:24, Jason Gunthorpe wrote:
> On Wed, Mar 20, 2013 at 10:00:09PM +0000, brendan doyle wrote:
>
>>>>> As far as I can see the library is not documented at all, I can't find
>>>>> any man pages. So setting errno is not breaking the interface, and I
>>>>> would argue that if it adds value, which it does in this case, then
>>>>> what is the objection. Additionally I think if the approach is that
>>>>> errno is not set unless documented in a man page, then we should have
>>>>> some consistency, a quick grep of errno in libibmad reveals that errno
>>>>> is being set in other parts of the library, in libibumad too, we see
>>>>> errno set, but again it is not documented in the umad man pages.
>>>> Ideally we would have consistency amongst the IB libraries - try hard to
>>>> return -ERRNO like verbs, and only use errno for cases where an int return is
>>>> not possible.
>>> Since these calls return int I thought about this.  But I am
>>> worried about breaking users who may be explicitly checking for -1.
>>> OTOH nothing is documented.
>   
>> Well there are man pages for umad and verbs and though some verbs
>> man pages say errno is set for failure, they don't indicate what it
>> is set to, and umad man pages say nothing of errno. In any case the
>> proposed changes don't change the return value, and so won't break
>> existing users, again I can only see goodness being added, and fail
>> to see any negative implications?
> Patches adding inconsistency are not 'goodness'.

Where is the inconsistency? failure is still returned as -1, and errno 
is still
undefined, it is set in some parts of libibmad and not others, so nothing
has changed from a consumer perspective?

Also this is just one aspect of the proposed update the other hardens the
lib from trying to use an invalid SM LID.


>
> People have to use this stuff and try to write correct
> applications. Playing wack a mole on 'how does this call return
> errors' is a special kind of nightmare.

Again the patch does not break the existing API -1 is still failure.

>
> .. and look, I already got it wrong in my memory, verbs consistently
> uses the POSIX +ERRNO convention, not the kernel's -ERRNO convention.
>
> Ira, do you know any place that would break if +ERRNO is returned, or
> is this just a hypothetical? Even so, I'm not sure I have much
> sympathy for people checking against -1... that is only appropriate
> for FDs.
>
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
