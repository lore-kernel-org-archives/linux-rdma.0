From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ibnetdiscover: fix error when discovery started on node
 with more that one port
Date: Mon, 4 Oct 2010 06:57:36 -0400
Message-ID: <AANLkTinY3P9qqe5dx=pCnQVELQDtSdjswdRp=JFOxwx+@mail.gmail.com>
References: <4CA9A875.4050604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CA9A875.4050604-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli,

Isn't this the same as what I submitted back on 8/25 and subsequently
applied (http://www.spinics.net/lists/linux-rdma/msg05590.html) ?

-- Hal

On Mon, Oct 4, 2010 at 6:12 AM, Eli Dorfman (Voltaire)
<dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> When discovery is started on a node with more than one active port
> it tries to send mads from second Hca port and fails.
> ibnetdiscover should not try and extend_path from Hca except for star=
ting point.
>
> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0.../libibnetdisc/include/infiniband/ibnetdisc.h =C2=A0 =C2=A0| =
=C2=A0 =C2=A01 +
> =C2=A0infiniband-diags/libibnetdisc/src/ibnetdisc.c =C2=A0 =C2=A0 =C2=
=A0| =C2=A0 =C2=A07 ++++---
> =C2=A02 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdi=
sc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
> index cfd3bbe..fe953e6 100644
> --- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
> +++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
> @@ -149,6 +149,7 @@ typedef struct ibnd_fabric {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * or by default the node you ar running o=
n
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ibnd_node_t *from_node;
> + =C2=A0 =C2=A0 =C2=A0 int from_port;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* NULL term list of all nodes in the fabr=
ic */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ibnd_node_t *nodes;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* NULL terminated list of all chassis fou=
nd in the fabric */
> diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniba=
nd-diags/libibnetdisc/src/ibnetdisc.c
> index f525d71..64e1c60 100644
> --- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> +++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> @@ -199,7 +199,7 @@ static int recv_port_info(smp_engine_t * engine, =
ibnd_smp_t * smp,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (port_num && mad_get_field(port->info, =
0, IB_PORT_PHYS_STATE_F)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=3D IB_PORT_PHYS_STATE_LI=
NKUP
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&& ((node->type =3D=3D IB_NO=
DE_SWITCH && port_num !=3D local_port) ||
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (node =3D=3D fabri=
c->from_node && port_num =3D=3D local_port))) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (node =3D=3D fabri=
c->from_node && port_num =3D=3D fabric->from_port))) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ib_portid_t pa=
th =3D smp->path;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (extend_dpa=
th(engine, &path, port_num) > 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0query_node_info(engine, &path, node);
> @@ -324,9 +324,10 @@ static int recv_node_info(smp_engine_t * engine,=
 ibnd_smp_t * smp,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dump_endnode(&=
smp->path, node_is_new ? "new" : "known",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 node, port);
>
> - =C2=A0 =C2=A0 =C2=A0 if (rem_node =3D=3D NULL) =C2=A0 /* this is th=
e start node */
> + =C2=A0 =C2=A0 =C2=A0 if (rem_node =3D=3D NULL) { /* this is the sta=
rt node */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fabric->from_n=
ode =3D node;
> - =C2=A0 =C2=A0 =C2=A0 else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fabric->from_port =
=3D port_num;
> + =C2=A0 =C2=A0 =C2=A0 } else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* link ports.=
=2E. */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int rem_port_n=
um =3D get_last_port(&smp->path);
>
> --
> 1.7.2.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
