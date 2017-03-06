From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [Query] iSER-Target: QP errors observed on increasing
 MaxXmitDataSegmentLength to 16384 (default = 8192)
Date: Mon, 6 Mar 2017 17:20:56 +0200
Message-ID: <5397c9f1-a059-e288-8057-8f537c5b413e@grimberg.me>
References: <20170224091455.GA11766@chelsio.com>
 <1488443433.21712.111.camel@haakon3.risingtidesystems.com>
 <20170302090101.GA31347@chelsio.com>
 <1488449150.21712.129.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488449150.21712.129.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Nic,

> After reading your email again, I may have mistaken one important bit..
>
> If the initiator is proposing MRDSL != 8192, are there still problems
> with iser-initiator hard-coded limits vs. what iser-target is actually
> posting for outgoing non RDMA_WRITE transfers of != 8192..?
>
> Or rather, does initiator proposed MRDSL != 8192 work as expected with
> existing iser-initiator + iser-target code..?
>
> If this is true and it's only a iser-target + MXDSL specific bug vs.
> hard-coded ISER_RX_PAYLOAD_SIZE definitions mentioned above, then we can
> avoid messing with the initiator proposed MRDSL.

Reading this thread and revisiting the code it looks like both the
target and the initiator and not broken at the same time.

Starting from 7145:

6.2.  MaxRecvDataSegmentLength

    For an iSCSI connection belonging to a session in which
    RDMAExtensions=Yes was negotiated on the leading connection of the
    session, MaxRecvDataSegmentLength need not be declared in the Login
    Phase, and MUST be ignored if it is declared.  Instead,
    InitiatorRecvDataSegmentLength (as described in Section 6.5) and
    TargetRecvDataSegmentLength (as described in Section 6.4) keys are
    negotiated.  The values of the local and remote
    MaxRecvDataSegmentLength are derived from the
    InitiatorRecvDataSegmentLength and TargetRecvDataSegmentLength keys.

    In the Full Feature Phase, the initiator MUST consider the value of
    its local MaxRecvDataSegmentLength (that it would have declared to
    the target) as having the value of InitiatorRecvDataSegmentLength,
    and the value of the remote MaxRecvDataSegmentLength (that would have
    been declared by the target) as having the value of

    TargetRecvDataSegmentLength.  Similarly, the target MUST consider the
    value of its local MaxRecvDataSegmentLength (that it would have
    declared to the initiator) as having the value of
    TargetRecvDataSegmentLength, and the value of the remote
    MaxRecvDataSegmentLength (that would have been declared by the
    initiator) as having the value of InitiatorRecvDataSegmentLength.

So both the target and the initiator ignores MaxRecvDataSegmentLength
value :)

And:
6.4.  TargetRecvDataSegmentLength

    Use: IO (Initialize only)

    Senders: Initiator and Target

    Scope: CO (connection-only)

    Irrelevant when: RDMAExtensions=No

    TargetRecvDataSegmentLength=<numerical-value-512-to-(2**24-1)>

    Default is 8192 bytes

    Result function is minimum

6.5.  InitiatorRecvDataSegmentLength

    Use: IO (Initialize only)

    Senders: Initiator and Target

    Scope: CO (connection-only)

    Irrelevant when: RDMAExtensions=No

    InitiatorRecvDataSegmentLength=<numerical-value-512-to-(2**24-1)>

    Default is 8192 bytes


On the other hand, not only they never negotiate 
InitiatorRecvDataSegmentLength, TargetMaxRecvDataSegmentLength but its
not exposed at all. At least the default are correct :)

I think that iscsi_target_parameters.c almost got it right, it needs to
respond with TargetMaxRecvDataSegmentLength in response to
InitiatorRecvDataSegmentLength and both should respect it.

>
> If this is the case, then following (untested) patch should do the
> trick.

I think we are better off by doing this the right way. Have open-iscsi
negotiate InitiatorMaxRecvDataSegmentLength and have the target
reply TargetMaxRecvDataSegmentLength and have both sides honor the
replies. Would be nice to expose user config knob for it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
