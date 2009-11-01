From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb,
 set init failure on PKeyTable and QoS initialization failure
Date: Sun, 1 Nov 2009 17:52:48 +0200
Message-ID: <20091101155248.GD29434@me>
References: <20091030012213.GR20136@me>
 <949139550.4222411256937590346.JavaMail.root@sz0074a.westchester.pa.mail.comcast.net>
 <f0e08f230910301445q6a4790aam295c254c430f0f82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910301445q6a4790aam295c254c430f0f82-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 17:45 Fri 30 Oct     , Hal Rosenstock wrote:
> On Thu, Oct 29, 2009 at 9:22 PM,  Sasha Khapyorsky <sashak@voltaire.c=
om> wrote:
> >
> >
> > On 09:13 Mon 10 Aug =A0 =A0 , Hal Rosenstock wrote:
> >>
> >> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> diff --git a/opensm/opensm/osm_sm_mad_ctrl.c
> >> b/opensm/opensm/osm_sm_mad_ctrl.c
> >> index 791c848..f0bc407 100644
> >> --- a/opensm/opensm/osm_sm_mad_ctrl.c
> >> +++ b/opensm/opensm/osm_sm_mad_ctrl.c
> >> @@ -723,7 +723,10 @@ static void sm_mad_ctrl_send_err_cb(IN void *=
context,
> >> IN osm_madw_t * p_madw)
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0(p_smp->attr_id =3D=3D IB_MAD_A=
TTR_PORT_INFO ||
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 p_smp->attr_id =3D=3D IB_MAD_A=
TTR_MCAST_FWD_TBL ||
> >> =A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 p_smp->attr_id =3D=3D IB_MAD_A=
TTR_SWITCH_INFO ||
> >> -=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 p_smp->attr_id =3D=3D IB_MAD_ATT=
R_LIN_FWD_TBL)) {
> >> +=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 p_smp->attr_id =3D=3D IB_MAD_ATT=
R_LIN_FWD_TBL ||
> >> +=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 p_smp->attr_id =3D=3D IB_MAD_ATT=
R_P_KEY_TABLE ||
> >> +=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 p_smp->attr_id =3D=3D IB_MAD_ATT=
R_SLVL_TABLE ||
> >> +=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 p_smp->attr_id =3D=3D IB_MAD_ATT=
R_VL_ARBITRATION)) {
> >
> > Why this change?
>=20
> Why not ? Aren't these initialization failures ? Why should they be
> excluded ? If I recall correctly, they were originally excluded due t=
o
> "newness" but that was years ago.

Ok, let's try this.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
