From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Thu, 5 May 2016 11:21:29 +0300
Message-ID: <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com>
References: <alpine.DEB.2.20.1604271043540.20042@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB046AB1@ORSMSX109.amr.corp.intel.com>
 <5721C3AD.8050407@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB046FD8@ORSMSX109.amr.corp.intel.com>
 <d8f8d6bf-9fad-fcc9-5a15-2b2423349c26@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0480DB@ORSMSX109.amr.corp.intel.com>
 <20160502175011.GB32096@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04816A@ORSMSX109.amr.corp.intel.com>
 <20160502190619.GB32613@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB048E47@ORSMSX109.amr.corp.intel.com>
 <20160504181135.GA15355@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160504181135.GA15355-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/05/2016 21:11, Jason Gunthorpe wrote:
> On Wed, May 04, 2016 at 04:49:47PM +0000, Hefty, Sean wrote:
>
>> Okay - this isn't what I think about when I read LSO at all
>> (i.e. large segment offload, not large send [WR] offload).  We have
>> chained WRs.  What your describing sounds like some sort of
>> optimized version of that.
>
> Yes.
>
> But critically the typical LSO engine will have the ability to do header
> replication and editing as it splits up the send.
>
>> This concept should apply to the receive side as well.
>
> The receive side is asymmetric in this case, LRO is a different
> animal.
>
>>> The rules *must* be specified in the API. I think this is what you are
>>> thinking about when you say 'protocol', but this is not IB or iWarp,
>>> it is 'LSO packet format protocol #1' or something.
>>
>> I was under the impression that this was actually working at a
>> protocol level that was above the transport level of the QP --
>> i.e. TCP/UDP/IP segmentation offload.
>
> Sort of. The typical LSO rules the NIC vendors have designed are
> intended for TCP and UDP packet segmentation.
>
> But in our verbs context, we'd talk about this process as a
> transformation of 1xLSO_SEND WRs into NxSEND WRs and maintain strict
> layering. The use of LSO can not do anything the user could not do
> just by creating SENDs on their own.
>
> Further, a LSO rule set should always operate the same, no matter what
> sort of QP it is running on - the LSO rules don't change just because a
> QP is iwarp or IB.
>

Agree

> Matan: I think the take away here is that the API needs a lot more
> work on specifying exactly what 'LSO' means, in terms of what it
> actually does, and we almost certainly need some way to negotiate
> different rule-sets, as I doubt all NIC vendors agree on how this
> works. Even Linux net has a few variations over time (TSO, LSO/GSO)
> supported by the core code. And it is easy to predict that things like
> FCoX, SCTP and so forth will have their own unique rule sets.
>

I agree that we're lacking especially in the query capabilities area here.

> This should probably be done after creating the QP (and AH?), as a NIC
> may not be able to do certain LSO rules with certain QP/AH
> configurations.
>

So I guess we want something that after a user creates a QP, he can 
query which protocols (IP, TCP, etc) could be used in the NIC's 
segmentation offload mechanism.

> I'd probably also use the driver-specific channel to communicate the
> NIC's capability and prototype some kind of API in libibverbs.
>

If we would like to expose this feature in the uAPI, why would we want 
to use the vendor specific channel instead of the standard core channel?

> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
