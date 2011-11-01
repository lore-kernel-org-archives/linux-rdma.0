From: Vlad Weinbaum <vlad.weinbaum-adSD+vzF2QdBDgjK7y7TUQ@public.gmane.org>
Subject: Re: cq error timeout issue
Date: Tue, 1 Nov 2011 15:25:49 +0200
Message-ID: <CAFAcbYOsaAVumnRQu_MYvH1-RL1gB+9_-GApPHSdJ_2E4H_j4Q@mail.gmail.com>
References: <CAFAcbYPXqcOc79fcWHK7iHkfEX0ecmg4CBSUgUk=C=xiScSRRw@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E8B236@ORSMSX101.amr.corp.intel.com>
	<CAFAcbYNJFH0n=gFwki0uLUzDd6cu7MxuHR99x9i9wUY3xp+Hdg@mail.gmail.com>
	<CAJZOPZKr3Jz4r=bfN18HRH7My_8haw+XtJznk7R5N92ZZn4=4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKr3Jz4r=bfN18HRH7My_8haw+XtJznk7R5N92ZZn4=4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

packet_life_time is 12 in sm.conf.

I'm debugging the polling process and see that ibv_poll_cq returns
error when mlx4_cqe->owner_sr_opcode gets MLX4_CQE_OPCODE_ERROR value
(in libmlx4, mlx4_poll_one). Where this value came from?

Thanks,
Vlad


On Mon, Oct 31, 2011 at 3:00 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> On Mon, Oct 31, 2011 at 9:08 AM, Vlad Weinbaum
> <vlad.weinbaum-adSD+vzF2QdBDgjK7y7TUQ@public.gmane.org> wrote:
>> [...] I found detail that I cannot explain. I query the QP after con=
nect and get timeout value 16,
>> =A0that must be 4 us * 2^16 =3D 256 ms, but I get about 800 ms.
>
> As Sean indicated, the timeout is **based** on the packet_life_time,
> in case you're configuring
> your QP through the rdma-cm, the IB stack code actually adds one to
> the packet_life_time quantity
> as a rough estimate for the local hca ack delay, still maybe there is
> a hole here and the query qp verb
> isn't reporting correctly, what was the value you configured on the s=
m
> side, and how many retries did
> you use for the qp? each retry will double the time you should be
> observing in practice.
>
> Or.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
