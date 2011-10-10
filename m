From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: libmlx4 and setting the doorbell qpn
Date: Mon, 10 Oct 2011 09:28:10 -0700
Message-ID: <CAL1RGDVJFwzv8ggnEYbOXtGriLKxYyFxbV9tGOF1ah8rcG9gvQ@mail.gmail.com>
References: <CAO+b5-pXXBmVBomOFed7Js4LqyRqseoPEeVCsoeinA1VSTT==Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pXXBmVBomOFed7Js4LqyRqseoPEeVCsoeinA1VSTT==Q@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 8, 2011 at 8:12 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wr=
ote:
> While reviewing the compiler warnings triggered by the libmlx4 source
> code, I came across this statement in src/qp.c:
>
> =A0 =A0 =A0 =A0*(uint32_t *) ctrl->reserved |=3D qp->doorbell_qpn;
>
> which triggers this warning:
>
> =A0 =A0src/qp.c:399:3: warning: dereferencing type-punned pointer wil=
l
> break strict-aliasing rules
>
> because "reserved" is declared as follows:
>
> struct mlx4_wqe_raddr_seg {
> =A0 =A0uint64_t =A0 =A0 =A0 =A0raddr;
> =A0 =A0uint32_t =A0 =A0 =A0 =A0rkey;
> =A0 =A0uint32_t =A0 =A0 =A0 =A0reserved;
> };

actually I think the relevant definitions are:

        struct mlx4_wqe_ctrl_seg *ctrl;

and

struct mlx4_wqe_ctrl_seg {
        uint32_t                owner_opcode;
        uint8_t                 reserved[3];
        ...

so reserved actually is a pointer to a 3-byte area.

So aliasing rules aside, I think the code is fine and
can be fixed by inserting a cast to void * before the
cast to uint32_t *.

Unless I'm misreading things...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
