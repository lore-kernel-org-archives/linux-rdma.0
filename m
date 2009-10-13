From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add infrastructure support for PortInfo
	IsMulticastPkeyTrapSuppressionSupported
Date: Tue, 13 Oct 2009 13:37:26 -0400
Message-ID: <f0e08f230910131037y3aa34806t65ae834c1cab3464@mail.gmail.com>
References: <20091009144659.GA17861@comcast.net> <20091012184523.GC13830@me>
	 <f0e08f230910130615of844fc4lb02265e5eaf25717@mail.gmail.com>
	 <20091013155630.GQ13830@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091013155630.GQ13830@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 13, 2009 at 11:56 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org=
> wrote:
> On 09:15 Tue 13 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> On Mon, Oct 12, 2009 at 2:45 PM, Sasha Khapyorsky <sashak@voltaire.c=
om> wrote:
>> > On 10:46 Fri 09 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >>
>> >> Per published MgtWG errata RefID 4576
>> >>
>> >> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> ---
>> >> diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/i=
b_types.h
>> >> index 25ed35f..c820372 100644
>> >> --- a/opensm/include/iba/ib_types.h
>> >> +++ b/opensm/include/iba/ib_types.h
>> >> @@ -4432,7 +4432,7 @@ typedef struct _ib_port_info {
>> >> =C2=A0 =C2=A0 =C2=A0 ib_net16_t p_key_violations;
>> >> =C2=A0 =C2=A0 =C2=A0 ib_net16_t q_key_violations;
>> >> =C2=A0 =C2=A0 =C2=A0 uint8_t guid_cap;
>> >> - =C2=A0 =C2=A0 uint8_t subnet_timeout; /* cli_rereg(1b), resrv(2=
b), timeout(5b) */
>> >> + =C2=A0 =C2=A0 uint8_t subnet_timeout; /* cli_rereg(1b), mcast_p=
key_trap_suppr(1b), resrv(1b), timeout(5b) */
>> >> =C2=A0 =C2=A0 =C2=A0 uint8_t resp_time_value;
>> >> =C2=A0 =C2=A0 =C2=A0 uint8_t error_threshold; /* local phy errors=
(4b), overrun errors(4b) */
>> >> =C2=A0 =C2=A0 =C2=A0 ib_net16_t max_credit_hint;
>> >> @@ -5282,7 +5282,7 @@ ib_port_info_set_timeout(IN ib_port_info_t =
* const p_pi,
>> >> =C2=A0{
>> >> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(timeout <=3D 0x1F);
>> >> =C2=A0 =C2=A0 =C2=A0 p_pi->subnet_timeout =3D
>> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->subnet_timeout & =
0x80) | (timeout & 0x1F));
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->subnet_timeout & =
0xC0) | (timeout & 0x1F));
>> >
>> > Why not 'p_pi->subnet_timeout & 0xe0' then (IOW why to bother with
>> > reserved bits reset)?
>>
>> Per this erratum (RefID 4576), this bit is no longer reserved. It is
>> now used for MulticastPKeyTrapSuppressionEnabled.
>
> It is bit 6 and I'm about bit 5 which still be reserved - We don't ne=
ed
> to clear this. IOW I think that here (and in other similar places) sh=
ould
> be:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0p_pi->subnet_timeout =3D (p_pi->subnet_tim=
eout & 0xe0) | (timeout & 0x1f);

Yes, that's better for the future.

-- Hal

>>
>> >
>> >> =C2=A0}
>> >>
>> >> =C2=A0/*
>> >> @@ -5317,7 +5317,7 @@ ib_port_info_set_client_rereg(IN ib_port_in=
fo_t * const p_pi,
>> >> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(client_rereg <=3D 0x1);
>> >> =C2=A0 =C2=A0 =C2=A0 p_pi->subnet_timeout =3D
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->
>> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 subnet_timeout & 0x1F) | ((client_rereg << 7) & 0x80));
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 subnet_timeout & 0x5F) | ((client_rereg << 7) & 0x80));
>> >
>> > Ditto.
>>
>> See above.
>>
>> >> =C2=A0}
>> >>
>> >> =C2=A0/*
>> >> @@ -5336,6 +5336,43 @@ ib_port_info_set_client_rereg(IN ib_port_i=
nfo_t * const p_pi,
>> >> =C2=A0* SEE ALSO
>> >> =C2=A0*********/
>> >>
>> >> +/****f* IBA Base: Types/ib_port_info_set_mcast_pkey_trap_suppres=
s
>> >> +* NAME
>> >> +* =C2=A0 =C2=A0ib_port_info_set_mcast_pkey_trap_suppress
>> >> +*
>> >> +* DESCRIPTION
>> >> +* =C2=A0 =C2=A0Sets the encoded multicast pkey trap suppresion e=
nabled bit value
>> >> +* =C2=A0 =C2=A0in the PortInfo attribute.
>> >> +*
>> >> +* SYNOPSIS
>> >> +*/
>> >> +static inline void OSM_API
>> >> +ib_port_info_set_mcast_pkey_trap_suppress(IN ib_port_info_t * co=
nst p_pi,
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 I=
N const uint8_t trap_suppress)
>> >> +{
>> >> + =C2=A0 =C2=A0 CL_ASSERT(trap_suppress <=3D 0x1);
>> >> + =C2=A0 =C2=A0 p_pi->subnet_timeout =3D
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 (uint8_t) ((p_pi->
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 subnet_timeout & 0x9F) | ((trap_suppress << 6) & 0x40));
>> >
>> > Ditto.
>>
>> See above.
>>
>> > And whoudn't this:
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0p_pi->subnet_timeout =3D (p_pi->subnet_=
timeout & 0xbf) |
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(trap_suppr=
ess << 6)
>> >
>> > just work?
>>
>> Sure, Do you want an updated patch with this change ?
>
> Yes, please.
>
> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
