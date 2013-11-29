From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CQEs in unreliable connection
Date: Fri, 29 Nov 2013 08:41:19 +0530
Message-ID: <CADPSxAjc-a0+icNH_MwVyCni9DkuyZvS_pcuWQ0x18mVDXWzvg@mail.gmail.com>
References: <CADPSxAhQKoKOQVbixMXvQRpp0_h1iQCtChrF0v1UUR1cZsPZvA@mail.gmail.com>
	<52979E37.3080000@gmail.com>
	<CADPSxAj-d+yP0=xs33bJPpXLv=8K0edJAvH6-ttdH2CvVcXtPQ@mail.gmail.com>
	<CAGUk2tHz6AE6WdmJAXnAj8Q=StaZ1V75i5ho0=kmRdSqOVd==g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGUk2tHz6AE6WdmJAXnAj8Q=StaZ1V75i5ho0=kmRdSqOVd==g@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hari Subramoni <subramoni.1-ZbGKxL/pcrQ@public.gmane.org>
Cc: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hari,

Thanks for your reply. Yes, I'm talking about the Unreliable
Connection transport type

I'm concerned with small messages (128 byte RDMA writes or reads), so
I assume that my messages fit inside one packet.

I'm confused with this: "Receiver detects and drops out of order
packets.". For example, if the packet sequence at the receiver is {P1,
P2, P4, P3, P5}, where the numbers denote PSNs, then what are the
packets that get dropped?

Does P4 get dropped because it is after P2 (and not P3)? Or is P4
preserved (because it's still in the increasing order), and P3 dropped
later?

I guess I'm confused between packets and messages..

--Anuj


On Fri, Nov 29, 2013 at 8:30 AM, Hari Subramoni <subramoni.1-ZbGKxL/pcrQ@public.gmane.org> w=
rote:
> Hi Anuj,
>
> When you say "unreliable connection", I am assuming that you are stil=
l
> talking about the "Unreliable Connection" transport type. Are you?
>
> If so, here are some characteristics of an unreliable connection as s=
tated
> by the IB spec
>
>  - No delivery guarantees to the sender. Receiver may drop messages.
>  - No ordering guarantee. Sender / Receiver cannot rely on msgs arriv=
ing in
> order.
>  - Receiver detects and drops out of order packets.
>  - Dropped packets may cause the message to be dropped.
>  - After dropping a packet, receiver resumes with the first packet of=
 a new
> message.
>
> Now, to answer you - There is no ordering guarantee and if one packet=
 in a
> message is lost, the entire message "could" be lost.
>
> Thanks,
> Hari.
>
>
> On Thu, Nov 28, 2013 at 8:37 PM, Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
>>
>> Dotan,
>>
>> Thanks a lot for your reply. All my CQEs had status IBV_WC_SUCCESS
>> even when the responder was heavily loaded and I was wondering why
>> nothing was getting dropped...
>>
>> I read your blog post and it was really helpful for understanding th=
e
>> queue pair types. I had one small question though.
>>
>> You say that: "There isn=92t any guaranteed that the messages will b=
e
>> received by the other side: corrupted or out of sequence packets are
>> silently dropped. If a packet is being dropped, the whole message th=
at
>> it belongs to will be dropped. In this case, the responder won=92t s=
top,
>> but continues to receive incoming packets. There isn=92t any guarant=
ee
>> about the packet ordering."
>>
>> Here's my question: if out of sequence packets are dropped, isn't
>> there an ordering guarantee? I assume that dropping of out of sequen=
ce
>> packets means that if the responder receives packets {2, 1, 3} (in
>> this order), then it drops packet number {1} and keeps {2, 3}.
>>
>> Thanks again!
>> --Anuj
>>
>> On Fri, Nov 29, 2013 at 1:19 AM, Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> > Hi Anuj.
>> >
>> >
>> > On 28/11/2013 14:24, Anuj Kalia wrote:
>> >>
>> >> Hi.
>> >>
>> >> I had 2 questions related to RDMA operations (reads and writes) o=
ver
>> >> unreliable connections:
>> >>
>> >> 1. Are WQEs issued over an unreliable connection supposed to gene=
rate
>> >> CQEs? The Infiniband spec says that such WQEs may not generate an
>> >> 'ACK'. I'm confused if ACK refers to CQE.
>> >
>> > ACK is an acknowledgment that was sent over the wire that the mess=
age
>> > was
>> > received by the remote side.
>> > CQE is a mechanism to indicate that a Work Request isn't outstandi=
ng
>> > anymore.
>> >
>> > In RC QP, a CQE with successful status of a Send Request means tha=
t an
>> > ACK
>> > was received by the sender.
>> > However, In UC QP, a CQE with successful status of a Send Request =
means
>> > that
>> > the message was sent;
>> > it isn't indicate that the message was received by the remote side=
 ...
>> > (You will get a successful CQE even if the remote side didn't rece=
ive
>> > this
>> > message)
>> >
>> >
>> >>
>> >> 2. If the status of the work completion (fetched using ibv_poll_c=
q())
>> >> is IBV_WC_SUCCESS, does it mean that the operation was successful=
 at
>> >> the remote host (even though we used an unreliable connection)?
>> >
>> > I answered your answer above ...
>> >
>> > If you want some more information, you are welcome to read it in:
>> > http://www.rdmamojo.com/2013/06/01/which-queue-pair-type-to-use/
>> >
>> >
>> > Thanks
>> > Dotan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
