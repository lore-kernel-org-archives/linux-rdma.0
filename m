From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: Re: data placement in-order guarantee ?
Date: Tue, 02 Feb 2010 17:05:59 +0100
Message-ID: <F1D9D0AC-1AB3-43F6-B04F-A7AD126ED543@Sun.com>
References: <b681c62b1002020714s70c24fa7l4fcbf05617986b47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <b681c62b1002020714s70c24fa7l4fcbf05617986b47-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yogeshwar sonawane <yogyas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mvapich discuss <mvapich-discuss-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Feb 2, 2010, at 16:14 , yogeshwar sonawane wrote:

> Hi all,
>=20
> Following question can be of na=EFve nature. Kindly, help me to clari=
fy
> the points.
> Thanks in Advance.
>=20
> [snip].
>=20
> It will be helpful if some information is shared as how mvapich2
> handles the situation regarding above point (while using rdma
> operations) ?

Snip from the InfiniBandTM Architecture Specification:

o9-20: An application shall not depend of the contents of an RDMA WRITE=
 buffer at the responder until one of the following has occurred:
19 20 21
=95	Arrival and Completion of the last RDMA WRITE request packet when u=
sed with Immediate data.
=95	Arrival and completion of a subsequent SEND message.
=95	Update of a memory element by a subsequent ATOMIC operation.

Now, most MPI implementation does not obey this; IIRC MVAPICH does rely=
 on the last byte (word?) being written after all other payload, Scali =
MPI relies on 4-byte write atomicy and uses a special encoding/decoding=
 which sustains any reordering of the payload (as long as each 4-byte w=
ord is written as an atomic unit). The benefit, besides robustness, is =
the capability of a worm-hole message consumption (the message can be d=
ecoded and copied into the MPI user buffer _before_ it has been fully r=
eceived). This method is currently a patent application, so I do not re=
commend you to copy-cat this method.

So your choice is to be a "nice guy" using one of the preferred methods=
 from the IB standard or rely on how different IB _implementations_ wor=
k.



H=E5kon




>=20
> I thought that i should mail to both the mailing lists as topic cover=
s
> both domains.
>=20
> Thanks and Regards,
> Yogeshwar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

H=E5kon Bugge
Haakon.bugge-U0mLk4xYmo8@public.gmane.org
+47 924 84 514



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
