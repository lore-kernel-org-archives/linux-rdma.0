From: Yann Droneaud <yann-WYdEh2jsUj5Wj0EZb7rXcA@public.gmane.org>
Subject: Re: libmlx4 and setting the doorbell qpn
Date: Mon, 10 Oct 2011 22:03:04 +0200
Message-ID: <1318276984.3573.13.camel@dworkin.quest-ce.net>
References: <CAO+b5-pXXBmVBomOFed7Js4LqyRqseoPEeVCsoeinA1VSTT==Q@mail.gmail.com>
	 <CAL1RGDVJFwzv8ggnEYbOXtGriLKxYyFxbV9tGOF1ah8rcG9gvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVJFwzv8ggnEYbOXtGriLKxYyFxbV9tGOF1ah8rcG9gvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Le lundi 10 octobre 2011 =C3=A0 09:28 -0700, Roland Dreier a =C3=A9crit=
 :
> actually I think the relevant definitions are:
>=20
>         struct mlx4_wqe_ctrl_seg *ctrl;
>=20
> and
>=20
> struct mlx4_wqe_ctrl_seg {
>         uint32_t                owner_opcode;
>         uint8_t                 reserved[3];
>         ...
>=20
> so reserved actually is a pointer to a 3-byte area.
>=20

But

>        *(uint32_t *) ctrl->reserved |=3D qp->doorbell_qpn;

is  updating 4 bytes: it seems it's doing some kind of overflow here,
it's reading and writing to next field of struct mlx4_wqe_ctrl_seg:

struct mlx4_wqe_ctrl_seg {
        uint32_t                owner_opcode;
        uint8_t                 reserved[3];
        uint8_t                 fence_size;
        ...

Is it the intended behavor ?

If yes, I suggest this (ugly hack)

struct mlx4_wqe_ctrl_seg {
        uint32_t                owner_opcode;
	union {
		uint8_t         reserved8[4];
		uint32_t	reserved32;
	} u;
	...

#define fence_size u.reserved8[3]

But we should choose some other names for the fields to be more
'unique'.

Regards

--=20
Yann Droneaud


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
