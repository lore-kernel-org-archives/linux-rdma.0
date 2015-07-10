From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 09/12] xprtrdma: Prepare rpcrdma_ep_post() for RDMA_NOMSG calls
Date: Fri, 10 Jul 2015 10:53:40 -0400
Message-ID: <F5F5CAC4-866E-4BCA-8094-908CE9ED3B4B@oracle.com>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net> <20150709204305.26247.39173.stgit@manet.1015granger.net> <CANjDDBh38PrxGgWGuKYCYcbjqY9ELrpkGqaRZ_ueKfD7FEQP8g@mail.gmail.com> <559FC17A.7060502@talpey.com> <CANjDDBipaXMO7Z5wirG127E9kQ0aHdWJ1s6ZM21th5RWLNh-4Q@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBipaXMO7Z5wirG127E9kQ0aHdWJ1s6ZM21th5RWLNh-4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 10, 2015, at 10:11 AM, Devesh Sharma <devesh.sharma-1wcpHE2jlwOV7V7JEmyr7g@public.gmane.org=
m> wrote:

> On Fri, Jul 10, 2015 at 6:28 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>> On 7/10/2015 7:29 AM, Devesh Sharma wrote:
>>>=20
>>> we need to honor the max limits of device by checking
>>> dev_attr.max_sge? a vendor may not support 4 sges.
>>=20
>>=20
>> iWARP requires a minimum of 4 send SGEs (draft-hilland-verbs 8.1.3.2=
)
>>=20
>>   An RI MUST support at least four Scatter/Gather Elements per
>>   Scatter/Gather List when the Scatter/Gather List refers to the Dat=
a
>>   Source of a Send Operation Type or the Data Sink of a Receive
>>   Operation. An RI is NOT REQUIRED to support more than one
>>   Scatter/Gather Element per Scatter/Gather List when the
>>   Scatter/Gather List refers to the Data Source of an RDMA Write.
>>=20
>> I'm not certain if IB and RoCE state a similar minimum requirement,
>> but it seems a very bad idea to have fewer.
>=20
> To my knowledge IBTA Spec do not pose any such minimum requirement.
> RoCE also do not puts any minimum requirement. I think its fine if
> xprtrdma honors the device limits, thus covering iWARP devices becaus=
e
> all iWARP devices would support minimum 4.
>=20
> Chuck would correct me if xprtrdma do have any minimum requirements

At least 2 SGEs are required for normal operation. The code in
rpcrdma_marshal_req() sets up an iovec for the RPC/RDMA header
and one for the RPC message itself. These are used in
rpcrdma_ep_post() to SEND each request.

=46our SGEs are needed only for RDMA_MSGP type requests, but so far
I have never seen one of these used. I wonder if that logic can
be removed.

It is certainly possible to examine the device=92s max_sge field
in rpcrdma_ep_create() and fail transport creation if the
device=92s max_sge is less than RPC_MAX_IOVS.

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
