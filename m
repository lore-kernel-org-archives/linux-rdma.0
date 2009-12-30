From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_slvl_map_rcv.c: verify port number values
	received from network
Date: Wed, 30 Dec 2009 11:09:47 -0500
Message-ID: <f0e08f230912300809l7c794daat9490c64a2cf63525@mail.gmail.com>
References: <20091201194110.GA26753@comcast.net> <20091229150528.GV26940@me>
	 <20091229150735.GX26940@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091229150735.GX26940@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 29, 2009 at 10:07 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
>
> Verify that port number values received from network are in range and
> valid for access. Report error otherwise.

Won't this spam the OpenSM log ?

> Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> ---
> =C2=A0opensm/opensm/osm_slvl_map_rcv.c | =C2=A0 =C2=A09 +++++++++
> =C2=A01 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/opensm/opensm/osm_slvl_map_rcv.c b/opensm/opensm/osm_slv=
l_map_rcv.c
> index b35d867..6229db9 100644
> --- a/opensm/opensm/osm_slvl_map_rcv.c
> +++ b/opensm/opensm/osm_slvl_map_rcv.c
> @@ -104,8 +104,17 @@ void osm_slvl_rcv_process(IN void *context, IN v=
oid *p_data)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* in case of a non switch node the attr m=
odifier should be ignored */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (osm_node_get_type(p_node) =3D=3D IB_NO=
DE_TYPE_SWITCH) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned num_ports=
 =3D osm_node_get_num_physp(p_node) - 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0out_port_num =3D=
 cl_ntoh32(p_smp->attr_mod) & 0xff;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in_port_num =3D=
 (cl_ntoh32(p_smp->attr_mod) >> 8) & 0xff;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (in_port_num > =
num_ports || out_port_num > num_ports) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2C07"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Invalid attribute modifier 0x%x re=
veived in"

           ^^^^^^^^

            typo

-- Hal

> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " response from switch 0x%" PRIx64 =
"\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh32(p_smp->attr_mod),
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh64(node_guid));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto Exit;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_physp =3D os=
m_node_get_physp_ptr(p_node, out_port_num);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_physp =3D p_=
port->p_physp;
> --
> 1.6.6.rc4
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
