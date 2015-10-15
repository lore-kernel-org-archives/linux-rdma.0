From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Create a common verbs transport library
Date: Thu, 15 Oct 2015 08:40:25 +0300
Message-ID: <CAG9sBKNKvpbRZgK+nsbuhycSnCMYnL3ObqfXmiab+akuFf99rw@mail.gmail.com>
References: <20150929125648.GA3433@phlsvsds.ph.intel.com>
	<CAG9sBKPqXk671c7obj4wd8drNaxPU3gue428y3Es_BJfuC-sVQ@mail.gmail.com>
	<20151014184903.GA12463@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151014184903.GA12463-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
>
> I assume by user-space driver we are talking about libverbs? We have
> separate libraries for ipath/qib and hfi. We should probably coalesce these
> into a single library but that is a separate issue. PSM is also unrelated to
> the work here since PSM is not verbs.
>
Not libibverbs but lib<provider> (e.g. libmlx4, libqib,...), like for
any other kernel verbs provider.
In other wordsm if the name of the SW verbs provider is called VT
(verbs transport) than the library we need to develop will be libVT.
However, the challenge here is larger than for other providers due to
different style of backends.
Take for example the ibv_post_send() verb. For some totally incapable
kernel bypass backends this requires that this verb go down to the
kernel (Soft RoCE for example) but for others it needs to put the WQE
directly on the HW in some HW specific manner.
This needs some architectural effort.

>> At a high-level, it seems that we should do as follows:
>>
>> - Decide on an initial code base for VT (rxe/hfi/qib), clone it, and
>> rename to VT
>>
>> - Split the code to VT and backend and create the initial backend APIs,
>> e.g.:
>
>
> We have been planning a bit of a different approach. My thoughts are we make
> VT a completely new kmod. It will start out life lettings verbs calls from
> the core go into the drivers to do their thing, but will contain a bunch of
> the duplicated code that we have in hfi1/qib/ipath. The next step is to move
> piece by piece the rest of the verbs code.
>
We agree with the kmod approach. However
1. Until we get rid completely from code duplication I don't think we
can get out from being in staging phase so the initial work better be
complete. Don't you think so?
2. Soft RoCE is a candidate driver (backend) for this framework and we
would like to make sure that the new VT provider meets out needs.
>> -- Send packet
>>
>> -- Deliver packet (receive)
>>
>> -- Attach multicast
>>
>> -- Packet buffer allocation
>>
>> -- Notify when more send space is available
>>
>> - In parallel, prepare the backends of other drivers while enhancing
>> VT as needed.
>
>
> Yes, we need to come up with an API, I'm not fully sure what that should
> look like yet, it is a work in progress.
I think that this will be a good place to start before implementation.
Can you please share API between backends and VT so we can comment on?
>
>> Do you have any preferences to the initial code base?
>>
>> Do you already have some code that we can look at?
>
>
> We'll be starting out with making changes to hfi1 and qib to follow shortly
> behind. No code just yet, but I should have something to post as an RFC very
> soon (in the next two weeks).
I suggest that implementation will start after we close the arch. Like
I said we want to make sure that Soft RoCE requirements are met in the
design.
I strongly recommend that we figure out a mechanism to allows us to cooperate.
I hope that you see it this way too,
>
> Thanks
>
>
> -Denny
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
