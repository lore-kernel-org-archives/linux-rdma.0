From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 02/37] add opcodes to ib_pack.h
Date: Mon, 15 Aug 2011 11:13:21 +0200
Message-ID: <CAO+b5-pb3p0n5MZYNSJicAdUfZ4PtMNG5vdzDOiZNQwLnB3Wcw@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.204265835@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201228.204265835-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote=
:
>
> Bring up to date with the current version of the IBTA spec.
> =A0 =A0 =A0 =A0- add new opcodes for RC and RD
> =A0 =A0 =A0 =A0- add new groups of opcodes for CN and XRC
>
> Signed-off-by: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
>
> ---
> =A0include/rdma/ib_pack.h | =A0 39 ++++++++++++++++++++++++++++++++++=
++++-
> =A01 file changed, 38 insertions(+), 1 deletion(-)
>
> Index: infiniband/include/rdma/ib_pack.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- infiniband.orig/include/rdma/ib_pack.h
> +++ infiniband/include/rdma/ib_pack.h
> @@ -75,6 +75,8 @@ enum {
> =A0 =A0 =A0 =A0IB_OPCODE_UC =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0=3D 0x20,
> =A0 =A0 =A0 =A0IB_OPCODE_RD =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0=3D 0x40,
> =A0 =A0 =A0 =A0IB_OPCODE_UD =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0=3D 0x60,
> + =A0 =A0 =A0 IB_OPCODE_CN =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0=3D 0x80,
> + =A0 =A0 =A0 IB_OPCODE_XRC =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =3D 0xA0,

A convention when submitting Linux kernel patches is to add only those
constants that are actually used in the code submitted in the same
patch series. So I'm not sure it's fine to add the XRC constants in
ib_pack.h through the rxe patch series.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
