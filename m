From: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Adjusting minimum packet size or "wait to merge requests" in SRP
Date: Wed, 28 Oct 2009 13:38:37 -0600
Message-ID: <f3177b9e0910281238n1e53653eq3e667010caf8e745@mail.gmail.com>
References: <f3177b9e0910281147u5a47f75ao8bbe156d5b04969c@mail.gmail.com>
	 <e2e108260910281214y5e3b5f4u24438986672e81b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260910281214y5e3b5f4u24438986672e81b3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 1:14 PM, Bart Van Assche
<bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Oct 28, 2009 at 7:47 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> It appears that SRP tries to coalesce and fragment initiator I/O
>> requests into 64KB packets, as that looks to be the size requested
>> to/from the device on the target side (and the I/O scheduler is
>> disabled on the target).
>>
>> Is there a way to control this, where no coalescing occurs when
>> latency is an issue and requests are small, and no fragmentation
>> occurs when requests are large?
>>
>> Or, am I totally wrong in my assumption that SRP is coalescing/fragmenting data?
>
> Regarding avoiding coalescing of I/O requests: which I/O scheduler is
> being used on the initiator system and how has it been configured via
> sysfs ?

There is no scheduler running on either target or initiator on the
drives in question (sorry I worded that incorrectly initially), or so
I've been told (this information is second-hand).  I did see iostat
output from the initiator in his case, where there were long waits and
service times that I'm guessing was due to some coalescing/merging.
There was also a hint in the iostat output that a scheduler was
enabled, as there were non-zero values (occasionally) under the
[rw]qm/s columns, which, if I understand iostat correctly, means there
is a scheduler merging results.

So you're saying there is no hold-off for merging on the initiator
side of the IB/SRP stack?
>
> Adjusting the constant MAX_RDMA_SIZE in scst/srpt/src/ib_srpt.h might
> help to avoid fragmentation of large requests by the SRP protocol.
> Please post a follow-up message to the mailing list with your findings
> such that MAX_RDMA_SIZE can be converted from a compile-time constant
> to a sysfs variable if this would be useful.

Will do.

Thanks,

Chris
>
> Bart.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
