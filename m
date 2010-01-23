From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Add support for optimized SLtoVLMappingTable
	programming
Date: Sat, 23 Jan 2010 07:26:14 -0500
Message-ID: <f0e08f231001230426t2e48aa58pbcb2d3f1323c6e56@mail.gmail.com>
References: <20091201194110.GA26753@comcast.net> <20100105111841.GO26940@me>
	 <20100105112334.GP26940@me>
	 <f0e08f231001070535l382f1d54t7f6290607e52b196@mail.gmail.com>
	 <20100112105516.GK26089@me>
	 <f0e08f231001131214w790b1f34s46cbbda8b6454ac3@mail.gmail.com>
	 <20100116203304.GB574@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100116203304.GB574@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 16, 2010 at 3:33 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 15:14 Wed 13 Jan =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>> >> > @@ -223,12 +222,20 @@ static int qos_extports_setup(osm_sm_t * =
sm, osm_node_t *node,
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!(p0->port_info.capability_mask =
& IB_PORT_CAP_HAS_SL_MAP))
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return r=
et;
>> >> >
>> >> > + =C2=A0 =C2=A0 =C2=A0 if (ib_switch_info_get_opt_sl2vlmapping(=
&node->sw->switch_info) &&
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sm->p_subn->opt.use_optimi=
zed_slvl) {
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p =3D osm_no=
de_get_physp_ptr(node, 1);
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 force_update=
 =3D p->need_update || sm->p_subn->need_update;
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return sl2vl=
_update_table(sm, p, 1, 0x30000, force_update,
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 &qcfg->sl2vl);
>> >> > + =C2=A0 =C2=A0 =C2=A0 }
>> >> > +
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 1; i < num_ports; i++) {
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D os=
m_node_get_physp_ptr(node, i);
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_up=
date =3D p->need_update || sm->p_subn->need_update;
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (j =3D=
 0; j < num_ports; j++)
>> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 if (sl2vl_update_table(sm, p, i, j, force_update,
>> >> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0&qcfg->sl2vl))
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 if (sl2vl_update_table(sm, p, i, i << 8 | j,
>> >> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0force_update, &qcfg->sl2vl))
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -1;
>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>> >> >
>> >> >
>> >> > , does it look fine for you?
>> >>
>> >> In the optimized case, doesn't this send extra SL2VL mapping tabl=
e ?
>> >
>> > I don't see how, could you elaborate?
>>
>> Doesn't this send a table for the endport even when optimized ?
>
> Yes, and how is this different from the original patch?

The original patch didn't do this but missed accounting for the switch
port 0 configuration.

> Remember, that there is a different configuration for switch's port 0
> (needed or not - this is another question), so we must to take it int=
o
> account.

Yes but is there a need for this if they are the same and wildcarding
is used ? That will save what seems to me to be an unneeded MAD
request/response pair per switch.

-- Hal

> Sasha
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
