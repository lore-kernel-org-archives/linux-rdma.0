From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CQEs in unreliable connection
Date: Fri, 29 Nov 2013 07:07:46 +0530
Message-ID: <CADPSxAj-d+yP0=xs33bJPpXLv=8K0edJAvH6-ttdH2CvVcXtPQ@mail.gmail.com>
References: <CADPSxAhQKoKOQVbixMXvQRpp0_h1iQCtChrF0v1UUR1cZsPZvA@mail.gmail.com>
	<52979E37.3080000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52979E37.3080000-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Dotan,

Thanks a lot for your reply. All my CQEs had status IBV_WC_SUCCESS
even when the responder was heavily loaded and I was wondering why
nothing was getting dropped...

I read your blog post and it was really helpful for understanding the
queue pair types. I had one small question though.

You say that: "There isn=92t any guaranteed that the messages will be
received by the other side: corrupted or out of sequence packets are
silently dropped. If a packet is being dropped, the whole message that
it belongs to will be dropped. In this case, the responder won=92t stop=
,
but continues to receive incoming packets. There isn=92t any guarantee
about the packet ordering."

Here's my question: if out of sequence packets are dropped, isn't
there an ordering guarantee? I assume that dropping of out of sequence
packets means that if the responder receives packets {2, 1, 3} (in
this order), then it drops packet number {1} and keeps {2, 3}.

Thanks again!
--Anuj

On Fri, Nov 29, 2013 at 1:19 AM, Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Anuj.
>
>
> On 28/11/2013 14:24, Anuj Kalia wrote:
>>
>> Hi.
>>
>> I had 2 questions related to RDMA operations (reads and writes) over
>> unreliable connections:
>>
>> 1. Are WQEs issued over an unreliable connection supposed to generat=
e
>> CQEs? The Infiniband spec says that such WQEs may not generate an
>> 'ACK'. I'm confused if ACK refers to CQE.
>
> ACK is an acknowledgment that was sent over the wire that the message=
 was
> received by the remote side.
> CQE is a mechanism to indicate that a Work Request isn't outstanding
> anymore.
>
> In RC QP, a CQE with successful status of a Send Request means that a=
n ACK
> was received by the sender.
> However, In UC QP, a CQE with successful status of a Send Request mea=
ns that
> the message was sent;
> it isn't indicate that the message was received by the remote side ..=
=2E
> (You will get a successful CQE even if the remote side didn't receive=
 this
> message)
>
>
>>
>> 2. If the status of the work completion (fetched using ibv_poll_cq()=
)
>> is IBV_WC_SUCCESS, does it mean that the operation was successful at
>> the remote host (even though we used an unreliable connection)?
>
> I answered your answer above ...
>
> If you want some more information, you are welcome to read it in:
> http://www.rdmamojo.com/2013/06/01/which-queue-pair-type-to-use/
>
>
> Thanks
> Dotan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
