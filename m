From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 24 Mar 2016 00:37:55 +0200
Message-ID: <CAJ3xEMhu7pKONneEAMDhJUtiz2nqnibynHMWe8vmgPCy+7DH5A@mail.gmail.com>
References: <56F1B00F.7010406@redhat.com>
	<CAJ3xEMhG0x_+DAAY+Cv0OAnW=2VmMuHZUv8DOP_YCkNHfSjX9A@mail.gmail.com>
	<56F1F579.3080403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56F1F579.3080403-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 23, 2016 at 3:46 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 3/22/2016 6:23 PM, Or Gerlitz wrote:
>> On Tue, Mar 22, 2016 at 10:50 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

>>> Mitko Haralanov (41):
>> [...]
>>>       IB/hfi1: Re-factor MMU notification code
>>>       IB/hfi1: Allow MMU function execution in IRQ context
>>>       IB/hfi1: Prevent NULL pointer dereference
>>>       IB/hfi1: Allow remove MMU callbacks to free nodes
>>>       IB/hfi1: Remove the use of add/remove RB function pointers
>>>       IB/hfi1: Notify remove MMU/RB callback of calling context
>>>       IB/hfi1: Use interval RB trees
>>>       IB/hfi1: Add MMU tracing
>>>       IB/hfi1: Remove compare callback
>>>       IB/hfi1: Add filter callback
>>>       IB/hfi1: Adjust last address values for intervals
>>>       IB/hfi1: Implement SDMA-side buffer caching
>>>       IB/hfi1: Add pin query function
>>>       IB/hfi1: Specify mm when releasing pages
>>>       IB/hfi1: Switch to using the pin query function
>>>       IB/hfi1: Add SDMA cache eviction algorithm

>> Doug, this series is under review and a reviewer (me...) have posted
>> comments claiming that such pin down cache doesn't belong to kernel
>> but rather to be part of a user-space library [1]

>> This comment still hold even though the cache is serving a proprietary
>> (non verbs) user-space code b/c it claims that code X doesn't belong
>> to the kernel and we need not load into the kernel what doesn't belong
>> there.

>> Could you please comment why not let the discussion converge and/or
>> hear your maintainer opinion on the matter before this is pushed up to Linus?

>> [1] http://marc.info/?t=145746462200001&r=1&w=2

> You made your arguments, which I thought were nebulous in the first
> place ("does not belong in the kernel" is not a well defined objection,
> it's like saying "I don't like that", you would need a more concise
> objection to carry stronger weight).

Doug, by all means my review was not in a "you should do X, period" or
"Y doesn't belong to the kernel, bump", take 5m and see:

OG:"Actually, the cache itself belongs to user space. What is needed
in the kernel is code that uses MMU notifications to invalidate the
cache when munmap and friends were done on a cache entry. This is too
generic functionality that you
can add to the IB core which does have a char device or (better) to a
generic char device you will write and PSM to use. There have been
some works on that in the 2000s, look for code from Roland Dreier
and/or Pete Wyckoff"

DD:"Our position continues to be that this is best located in the hfi1 driver."

DD: few more email w.o technical justifications for the cache to be in
the kernel

DD: "Taking a performance standpoint we don't want this in user space.
If the cache were at the user level there would end up being a system
call to pin the buffer, another to do the SDMA transfer from said
buffer, and another to unpin the buffer when the kernel notifier has
invalidated that buffer.  This gets even more complex when you
consider cache evictions due to reaching the limit on pinned pages.
These extra system calls add overhead, which may be acceptable for a
normal server or desktop environment, but are not acceptable when
dealing with a high performance interconnect where we want the
absolute best performance."

OG: "The cache comes to amortize the cost of pin/unpin and such,
correct? this means that over longs runs, if there's nice locality of
the same process using the same pages,  you pay the register/pin cost
once, later use lazy de-registration/pinning, and only do that when
MMU notifier tells you this is a must, or under some eviction policy.
Since the cost is amortized, the system calls over-head should be
negligible (also, the same system call can be used to evict X and
register Y), do you have performance data that shows otherwise?"

DD: "I did check into the performance aspect here and have been
assured there is a performance problem with the increased number of
system calls. Though I do not have any published data to point you to.
We are particularly worried about the eviction case which is where the
amortization argument doesn't hold up. If the eviction policy is set
to evict buffers which have not been used recently in favor of a new
buffer (which is a very common policy), this happens more often than
you realize.  We do not want any additional cost in this case."

> Their response to your argument
> was that putting it in the kernel saves multiple context switches per
> memory region in the cache.  This was a sufficient answer IMO (context
> switches are expensive and on 100GBit hardware, multiple context
> switches that aren't needed is positively huge).

So it tool quiet a lot of time and effort to have Denny make these
statements which are still not backed up by any published performance
data. This review is incomplete by far, we never heard the author of
the patches speaking and the driver maintainer made the comments deep
into the 4.6 merge window.

> This was a sufficient answer IMO

Any reason we can't hear you speaking in real time over a reviewing
thread, and have a fair chance to convince you that things are
actually the other way around vs. your position, but rather get your
opinion in the form of blank pulling of patches? Should someone be Al
V and/or Linus T to make comments over this list which will get you to
speak up and have a conversation/discussion?

In bunch of other cases w. reviews done over this list, e.g by you,
Jason, Ira, Sean and others to code posted e.g by Matan, Leon and
others the submitter had to work really hard and make lots of changes
in their code for the patches to go in and respond to reviewers in
proper time and with proper content. This is very far what what
happened here.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
