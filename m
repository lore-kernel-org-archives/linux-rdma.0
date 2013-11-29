From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CQEs in unreliable connection
Date: Fri, 29 Nov 2013 09:53:30 -0500
Message-ID: <CADPSxAh1_iea41miuYpv4dzvfud3AqxCgUDsr8jUeTSrxMfVpA@mail.gmail.com>
References: <CADPSxAhQKoKOQVbixMXvQRpp0_h1iQCtChrF0v1UUR1cZsPZvA@mail.gmail.com>
	<52979E37.3080000@gmail.com>
	<CADPSxAj-d+yP0=xs33bJPpXLv=8K0edJAvH6-ttdH2CvVcXtPQ@mail.gmail.com>
	<CAGUk2tHz6AE6WdmJAXnAj8Q=StaZ1V75i5ho0=kmRdSqOVd==g@mail.gmail.com>
	<CADPSxAjc-a0+icNH_MwVyCni9DkuyZvS_pcuWQ0x18mVDXWzvg@mail.gmail.com>
	<52982D04.70503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52982D04.70503-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Hari Subramoni <subramoni.1-ZbGKxL/pcrQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Dotan,

In the example that I asked about, the 5 packets do not form one
message - they are each individual messages. I assume this in the
following.

I now understand that packet reordering cannot happen in IB - thanks!
Only packet loss can happen. From this, I can conclude the following
(please correct me if I'm wrong somewhere):

"If the requester sends a sequence of single packet messages: {M_1,
M_2, ..., M_n}, then the sequence of packets at the responder will be
{M_i1, M_i2, ..., M_ik}, where i1 < i2 < ... < ik. Which is just
saying that messages can be lost, but not reordered."

Is there a case where messages can be reordered in UC transport? i.e.
if the requester issues an RDMA write to buf[0] followed by an RDMA
write to buf[1], is it possible that at the responder the write to
buf[1] is done before the write to buf[0]? I don't think that this is
possible.

Thanks again. Your comments and blog have been really useful.

--Anuj.

On Fri, Nov 29, 2013 at 12:58 AM, Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> On 29/11/2013 05:11, Anuj Kalia wrote:
>>
>> Hari,
>>
>> Thanks for your reply. Yes, I'm talking about the Unreliable
>> Connection transport type
>>
>> I'm concerned with small messages (128 byte RDMA writes or reads), s=
o
>> I assume that my messages fit inside one packet.
>>
>> I'm confused with this: "Receiver detects and drops out of order
>> packets.". For example, if the packet sequence at the receiver is {P=
1,
>> P2, P4, P3, P5}, where the numbers denote PSNs, then what are the
>> packets that get dropped?
>>
>> Does P4 get dropped because it is after P2 (and not P3)? Or is P4
>> preserved (because it's still in the increasing order), and P3 dropp=
ed
>> later?
>>
>> I guess I'm confused between packets and messages..
>
>
> Here are some Quotes form the IB spec:
>
> C9-186: For an HCA responder using Unreliable Connection service, if =
a
> multi-packet message is in progress at the time that an out of order =
packet
> is detected, the current message shall be silently dropped. The respo=
nder
> then waits for the first packet of a new message. It is possible that=
 the
> present packet (the out of order packet) is the first packet of a new
> message.
> If so, it shall be treated as a new message.
>
> A =93new message=94 is denoted by an inbound request packet with an O=
p-
> Code in the BTH of =93first=94 or =93only=94.
>
> =93Current message=94 means all the packets received since the most r=
ecently
> received =93first=94 or =93only=94 OpCode, excluding the present pack=
et.
>
>
> From this, one can understand that the message will be dropped becaus=
e P4
> was detected,
> while P3 was received.
>
> But just remember, that Out Of Sequence (OOS) shouldn't happen in IB,=
 so
> usually if an OOS packet
> was received, this means that a packet was dropped in the way...
>
>
> I hope that I helped you with this.
>
> Thanks
> Dotan
>
>
>>
>> --Anuj
>>
>>
>> On Fri, Nov 29, 2013 at 8:30 AM, Hari Subramoni <subramoni.1-ZbGKxL/pcrQ@public.gmane.org=
>
>> wrote:
>>>
>>> Hi Anuj,
>>>
>>> When you say "unreliable connection", I am assuming that you are st=
ill
>>> talking about the "Unreliable Connection" transport type. Are you?
>>>
>>> If so, here are some characteristics of an unreliable connection as
>>> stated
>>> by the IB spec
>>>
>>>   - No delivery guarantees to the sender. Receiver may drop message=
s.
>>>   - No ordering guarantee. Sender / Receiver cannot rely on msgs ar=
riving
>>> in
>>> order.
>>>   - Receiver detects and drops out of order packets.
>>>   - Dropped packets may cause the message to be dropped.
>>>   - After dropping a packet, receiver resumes with the first packet=
 of a
>>> new
>>> message.
>>>
>>> Now, to answer you - There is no ordering guarantee and if one pack=
et in
>>> a
>>> message is lost, the entire message "could" be lost.
>>>
>>> Thanks,
>>> Hari.
>>>
>>>
>>> On Thu, Nov 28, 2013 at 8:37 PM, Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8@public.gmane.org=
m>
>>> wrote:
>>>>
>>>> Dotan,
>>>>
>>>> Thanks a lot for your reply. All my CQEs had status IBV_WC_SUCCESS
>>>> even when the responder was heavily loaded and I was wondering why
>>>> nothing was getting dropped...
>>>>
>>>> I read your blog post and it was really helpful for understanding =
the
>>>> queue pair types. I had one small question though.
>>>>
>>>> You say that: "There isn=92t any guaranteed that the messages will=
 be
>>>> received by the other side: corrupted or out of sequence packets a=
re
>>>> silently dropped. If a packet is being dropped, the whole message =
that
>>>> it belongs to will be dropped. In this case, the responder won=92t=
 stop,
>>>> but continues to receive incoming packets. There isn=92t any guara=
ntee
>>>> about the packet ordering."
>>>>
>>>> Here's my question: if out of sequence packets are dropped, isn't
>>>> there an ordering guarantee? I assume that dropping of out of sequ=
ence
>>>> packets means that if the responder receives packets {2, 1, 3} (in
>>>> this order), then it drops packet number {1} and keeps {2, 3}.
>>>>
>>>> Thanks again!
>>>> --Anuj
>>>>
>>>> On Fri, Nov 29, 2013 at 1:19 AM, Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>>>>
>>>>> Hi Anuj.
>>>>>
>>>>>
>>>>> On 28/11/2013 14:24, Anuj Kalia wrote:
>>>>>>
>>>>>> Hi.
>>>>>>
>>>>>> I had 2 questions related to RDMA operations (reads and writes) =
over
>>>>>> unreliable connections:
>>>>>>
>>>>>> 1. Are WQEs issued over an unreliable connection supposed to gen=
erate
>>>>>> CQEs? The Infiniband spec says that such WQEs may not generate a=
n
>>>>>> 'ACK'. I'm confused if ACK refers to CQE.
>>>>>
>>>>> ACK is an acknowledgment that was sent over the wire that the mes=
sage
>>>>> was
>>>>> received by the remote side.
>>>>> CQE is a mechanism to indicate that a Work Request isn't outstand=
ing
>>>>> anymore.
>>>>>
>>>>> In RC QP, a CQE with successful status of a Send Request means th=
at an
>>>>> ACK
>>>>> was received by the sender.
>>>>> However, In UC QP, a CQE with successful status of a Send Request=
 means
>>>>> that
>>>>> the message was sent;
>>>>> it isn't indicate that the message was received by the remote sid=
e ...
>>>>> (You will get a successful CQE even if the remote side didn't rec=
eive
>>>>> this
>>>>> message)
>>>>>
>>>>>
>>>>>> 2. If the status of the work completion (fetched using ibv_poll_=
cq())
>>>>>> is IBV_WC_SUCCESS, does it mean that the operation was successfu=
l at
>>>>>> the remote host (even though we used an unreliable connection)?
>>>>>
>>>>> I answered your answer above ...
>>>>>
>>>>> If you want some more information, you are welcome to read it in:
>>>>> http://www.rdmamojo.com/2013/06/01/which-queue-pair-type-to-use/
>>>>>
>>>>>
>>>>> Thanks
>>>>> Dotan
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
