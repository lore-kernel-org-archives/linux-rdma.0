From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Why RXE_COMP_MASK on RDMA SEND without immediate?
Date: Thu, 20 Apr 2017 18:20:23 +0000
Message-ID: <B4300DDE-B053-4F01-BA9C-B10D81F34B3E@mellanox.com>
References: <CAE=AiON6wECr=y3H2hbe47FRujCAbQQ-EoCHWFpnnOM8M58wCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE=AiON6wECr=y3H2hbe47FRujCAbQQ-EoCHWFpnnOM8M58wCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Sent from my iPhone
> On Apr 20, 2017, at 1:53 PM, Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> Hello,
Hi Josh,
>=20
> I am still new to RoCEv2 and have created a test utility patterned
> after the rc_pingpong.c libibverbs example, but using RDMA WRITE
> instead of RDMA SEND.
>=20
> I discovered that when one machine sends a read, the other machine
> acknowledges but does not indicate any completion on the CQ.  This
> means userspace never wakes up to do its "pong" code.
>=20
>=20
> The cause of this is that IB_OPCODE_RC_SEND_LAST has RXE_COMP_MASK
> associated (http://lxr.free-electrons.com/source/drivers/infiniband/sw/rx=
e/rxe_opcode.c#L149),
> but IB_OPCODE_RC_RDMA_WRITE_LAST does not.  Can someone please help me
> understand why SEND LAST would trigger the CQ (creating a CQE, if I
> understand correctly) even in the non-immediate case?
>=20
> Page 170 of the Infiniband spec (vol 1, release 1.3) suggests the CQE
> is only created for such packets with immediate data (ImmDt header).
This is basically the reason.
RDMA READ and WRITE, and ATOMIC operations do not consume any receive buffe=
rs in the receiver side, and thus no completion is generated.
>=20
> Also for reference, page 531 of the Infiniband spec talks about
> signaled completions and the conditions which cause a CQE to be
> generated.
>=20
>=20
> Thanks,
> -J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
