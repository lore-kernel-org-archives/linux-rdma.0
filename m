From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add infrastructure support for PortInfo
 IsMulticastPkeyTrapSuppressionSupported
Date: Tue, 13 Oct 2009 17:56:30 +0200
Message-ID: <20091013155630.GQ13830@me>
References: <20091009144659.GA17861@comcast.net>
 <20091012184523.GC13830@me>
 <f0e08f230910130615of844fc4lb02265e5eaf25717@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230910130615of844fc4lb02265e5eaf25717-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:15 Tue 13 Oct     , Hal Rosenstock wrote:
> On Mon, Oct 12, 2009 at 2:45 PM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
> > On 10:46 Fri 09 Oct =A0 =A0 , Hal Rosenstock wrote:
> >>
> >> Per published MgtWG errata RefID 4576
> >>
> >> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib=
_types.h
> >> index 25ed35f..c820372 100644
> >> --- a/opensm/include/iba/ib_types.h
> >> +++ b/opensm/include/iba/ib_types.h
> >> @@ -4432,7 +4432,7 @@ typedef struct _ib_port_info {
> >> =A0 =A0 =A0 ib_net16_t p_key_violations;
> >> =A0 =A0 =A0 ib_net16_t q_key_violations;
> >> =A0 =A0 =A0 uint8_t guid_cap;
> >> - =A0 =A0 uint8_t subnet_timeout; /* cli_rereg(1b), resrv(2b), tim=
eout(5b) */
> >> + =A0 =A0 uint8_t subnet_timeout; /* cli_rereg(1b), mcast_pkey_tra=
p_suppr(1b), resrv(1b), timeout(5b) */
> >> =A0 =A0 =A0 uint8_t resp_time_value;
> >> =A0 =A0 =A0 uint8_t error_threshold; /* local phy errors(4b), over=
run errors(4b) */
> >> =A0 =A0 =A0 ib_net16_t max_credit_hint;
> >> @@ -5282,7 +5282,7 @@ ib_port_info_set_timeout(IN ib_port_info_t *=
 const p_pi,
> >> =A0{
> >> =A0 =A0 =A0 CL_ASSERT(timeout <=3D 0x1F);
> >> =A0 =A0 =A0 p_pi->subnet_timeout =3D
> >> - =A0 =A0 =A0 =A0 (uint8_t) ((p_pi->subnet_timeout & 0x80) | (time=
out & 0x1F));
> >> + =A0 =A0 =A0 =A0 (uint8_t) ((p_pi->subnet_timeout & 0xC0) | (time=
out & 0x1F));
> >
> > Why not 'p_pi->subnet_timeout & 0xe0' then (IOW why to bother with
> > reserved bits reset)?
>=20
> Per this erratum (RefID 4576), this bit is no longer reserved. It is
> now used for MulticastPKeyTrapSuppressionEnabled.

It is bit 6 and I'm about bit 5 which still be reserved - We don't need
to clear this. IOW I think that here (and in other similar places) shou=
ld
be:

	p_pi->subnet_timeout =3D (p_pi->subnet_timeout & 0xe0) | (timeout & 0x=
1f);

>=20
> >
> >> =A0}
> >>
> >> =A0/*
> >> @@ -5317,7 +5317,7 @@ ib_port_info_set_client_rereg(IN ib_port_inf=
o_t * const p_pi,
> >> =A0 =A0 =A0 CL_ASSERT(client_rereg <=3D 0x1);
> >> =A0 =A0 =A0 p_pi->subnet_timeout =3D
> >> =A0 =A0 =A0 =A0 =A0 (uint8_t) ((p_pi->
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 subnet_timeout & 0x1F) |=
 ((client_rereg << 7) & 0x80));
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 subnet_timeout & 0x5F) |=
 ((client_rereg << 7) & 0x80));
> >
> > Ditto.
>=20
> See above.
>=20
> >> =A0}
> >>
> >> =A0/*
> >> @@ -5336,6 +5336,43 @@ ib_port_info_set_client_rereg(IN ib_port_in=
fo_t * const p_pi,
> >> =A0* SEE ALSO
> >> =A0*********/
> >>
> >> +/****f* IBA Base: Types/ib_port_info_set_mcast_pkey_trap_suppress
> >> +* NAME
> >> +* =A0 =A0ib_port_info_set_mcast_pkey_trap_suppress
> >> +*
> >> +* DESCRIPTION
> >> +* =A0 =A0Sets the encoded multicast pkey trap suppresion enabled =
bit value
> >> +* =A0 =A0in the PortInfo attribute.
> >> +*
> >> +* SYNOPSIS
> >> +*/
> >> +static inline void OSM_API
> >> +ib_port_info_set_mcast_pkey_trap_suppress(IN ib_port_info_t * con=
st p_pi,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 IN const uint8_t trap_suppress)
> >> +{
> >> + =A0 =A0 CL_ASSERT(trap_suppress <=3D 0x1);
> >> + =A0 =A0 p_pi->subnet_timeout =3D
> >> + =A0 =A0 =A0 =A0 (uint8_t) ((p_pi->
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 subnet_timeout & 0x9F) |=
 ((trap_suppress << 6) & 0x40));
> >
> > Ditto.
>=20
> See above.
>=20
> > And whoudn't this:
> >
> > =A0 =A0 =A0 =A0p_pi->subnet_timeout =3D (p_pi->subnet_timeout & 0xb=
f) |
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(trap_suppress << 6)
> >
> > just work?
>=20
> Sure, Do you want an updated patch with this change ?

Yes, please.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
