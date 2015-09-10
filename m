From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA/CM and multiple QPs
Date: Thu, 10 Sep 2015 23:25:24 +0530
Message-ID: <CAG53R5VRzJaemM-_AyE9gZ5YNRw_nPePn_zrQGjYx5mCU9RN6Q@mail.gmail.com>
References: <20150906064550.GA30683@infradead.org>
	<1828884A29C6694DAF28B7E6B8A82373A903A082@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A903A082-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry if you find that I am imposing, but there were not much inputs
on below thoughts in this email chain for abstraction, so iterating
again to see if there is different view now.

I understood the Christoph's requirement is relatively lean where
block-mq's MQ can be bound to CPU and/or to RDMA QP.
That session layer is probably is the right place, to attach the
connection(s) to a session.

Establishing multiple QP is just one part of it.
Bigger challenge is how do we distribute the work request among
multiple QPs specially when STAG advertisements, their invalidation is
agnostic at Verbs layer (which is not part of the IB spec and every
ULP has their own method possibly for good reason).

Few months back when I was working on this problem; solution we
considered is similar to what networking stack currently does.
As below:

1. instead of having pure ib_send, write, read verbs, invalidate, we
need to have more higher level verbs for data transport.
such send_data, receive_data, advertise data_buffers etc. Of course
keeping zero copy semantics in mind.

2. Perform device aggregation similar to Ethernet netdev link aggregation.
So two ib_device forms the pair on which one or more QPs will be created.
This virtual device provides higher level data transfer APIS than just
raw IB semantics.
By doing so, this layer decides how to advertise memory, when to
invalidate, which QP to use for transport (load balance or failover).

3. I have not thought through on how we can port existing ULPs whose
specification is IB driven to migrate on this newly defined interface.

4. Accelio is one such framework come close to this design philosophy,
however its current implementation brings resource overhead for MRs
and as we go along we have scope to optimize it.

5. Since this layer is located above raw IB verbs layer and above
RDMA-CM, core is untouched for the functionality. Once we have it many
of the migration related issue can be solved, where node can
disconnect and reconnect in stateful way.

6. This way pure hardware resource is detached from transport
acceleration, it gives flexibility to implement services which is
often difficult to do at raw IB verbs level.


On Thu, Sep 10, 2015 at 10:00 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> right now RDMA/CM works on a QP basis, but seems very awakward if you
>> want multiple QPs as part of a single logical device, which will be
>> useful for a lot of modern protocols.  For example we will need to check
>> in the CM handler that we're not getting a different ib_device if we
>> want to apply the device limit in any sort of global scope, and it's
>> generally very hard to get a struct ib_device that can be used as
>> a driver model parent.
>>
>> Is there any interest in trying to add an API to the CM to do a single
>> address resolution and allocate multiple QPs with these checks in
>> place?
>
> IMO, you want a completely different level of abstraction.  One not based on a specific hardware implementation.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
