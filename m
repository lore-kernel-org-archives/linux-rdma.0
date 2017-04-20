From: Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Why RXE_COMP_MASK on RDMA SEND without immediate?
Date: Thu, 20 Apr 2017 14:44:39 -0400
Message-ID: <CAE=AiON97u2jV+oToqR2_KYy+F+zs2sO4-tdU1JkjkW+dx-V4w@mail.gmail.com>
References: <CAE=AiON6wECr=y3H2hbe47FRujCAbQQ-EoCHWFpnnOM8M58wCg@mail.gmail.com>
 <B4300DDE-B053-4F01-BA9C-B10D81F34B3E@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B4300DDE-B053-4F01-BA9C-B10D81F34B3E-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Majd,

 >> Page 170 of the Infiniband spec (vol 1, release 1.3) suggests the CQE
>> is only created for such packets with immediate data (ImmDt header).
> This is basically the reason.
> RDMA READ and WRITE, and ATOMIC operations do not consume any receive buf=
fers in the receiver side, and thus no completion is generated.

I had not realized SEND always needed a receive WQE to operate, even
in the plain SEND without immediate case.  Page 100:

"For a SEND operation, the WQE specifies a block of data in the
consumer=E2=80=99s memory space for the hardware to send to the desti-
nation, letting a receive WQE already queued at the destination
specify where to place that data."

>From that, I think I now understand that SEND always requires a
receive WQE, and that is why the CQ gets activated.

Thanks,
-J
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
