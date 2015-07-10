From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH v1 09/12] xprtrdma: Prepare rpcrdma_ep_post() for
 RDMA_NOMSG calls
Date: Fri, 10 Jul 2015 19:41:25 +0530
Message-ID: <CANjDDBipaXMO7Z5wirG127E9kQ0aHdWJ1s6ZM21th5RWLNh-4Q@mail.gmail.com>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
	<20150709204305.26247.39173.stgit@manet.1015granger.net>
	<CANjDDBh38PrxGgWGuKYCYcbjqY9ELrpkGqaRZ_ueKfD7FEQP8g@mail.gmail.com>
	<559FC17A.7060502@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559FC17A.7060502-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 10, 2015 at 6:28 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
> On 7/10/2015 7:29 AM, Devesh Sharma wrote:
>>
>> we need to honor the max limits of device by checking
>> dev_attr.max_sge? a vendor may not support 4 sges.
>
>
> iWARP requires a minimum of 4 send SGEs (draft-hilland-verbs 8.1.3.2)
>
>    An RI MUST support at least four Scatter/Gather Elements per
>    Scatter/Gather List when the Scatter/Gather List refers to the Data
>    Source of a Send Operation Type or the Data Sink of a Receive
>    Operation. An RI is NOT REQUIRED to support more than one
>    Scatter/Gather Element per Scatter/Gather List when the
>    Scatter/Gather List refers to the Data Source of an RDMA Write.
>
> I'm not certain if IB and RoCE state a similar minimum requirement,
> but it seems a very bad idea to have fewer.

To my knowledge IBTA Spec do not pose any such minimum requirement.
RoCE also do not puts any minimum requirement. I think its fine if
xprtrdma honors the device limits, thus covering iWARP devices because
all iWARP devices would support minimum 4.

Chuck would correct me if xprtrdma do have any minimum requirements

>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
