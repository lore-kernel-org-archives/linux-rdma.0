From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv2] opensm/osm_qos.c: Eliminate unneeded endport SL to VL
	setup
Date: Mon, 14 Jun 2010 09:09:47 -0400
Message-ID: <AANLkTilHxkXWzb-eEyWMLOtZXAnURNRvtw8-nZVL0OvW@mail.gmail.com>
References: <20100125202247.GA9197@comcast.net>
	<20100126132605.GJ26338@me>
	<f0e08f231001260530o6260986dice657109f4eea637@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f231001260530o6260986dice657109f4eea637-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sasha,

On Tue, Jan 26, 2010 at 9:30 AM, Hal Rosenstock
<hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Jan 26, 2010 at 8:26 AM, Sasha Khapyorsky <sashak-smomgflXvObQFizaE/u3fw@public.gmane.org=
m> wrote:
>> On 15:22 Mon 25 Jan =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>>
>>> when using optimized programming and it's supported by the switch
>>>
>>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>> Changes since v1:
>>> Add in update of vlarb tables for port 0 when optimized but no SL t=
o VL
>>> tables needed to be configured on that port
>>>
>>> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
>>> index f814ea8..218e128 100644
>>> --- a/opensm/opensm/osm_qos.c
>>> +++ b/opensm/opensm/osm_qos.c
>>> @@ -243,13 +243,15 @@ static int qos_extports_setup(osm_sm_t * sm, =
osm_node_t *node,
>>> =C2=A0}
>>>
>>> =C2=A0static int qos_endport_setup(osm_sm_t * sm, osm_physp_t * p,
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0const struct qos_config *qcfg)
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0const struct qos_config *qcfg, int vlarb_only)
>>> =C2=A0{
>>> =C2=A0 =C2=A0 =C2=A0 unsigned force_update =3D p->need_update || sm=
->p_subn->need_update;
>>>
>>> =C2=A0 =C2=A0 =C2=A0 p->vl_high_limit =3D qcfg->vl_high_limit;
>>> =C2=A0 =C2=A0 =C2=A0 if (vlarb_update(sm, p, 0, force_update, qcfg)=
)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
>>> + =C2=A0 =C2=A0 if (vlarb_only)
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
>>>
>>> =C2=A0 =C2=A0 =C2=A0 if (!(p->port_info.capability_mask & IB_PORT_C=
AP_HAS_SL_MAP))
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
>>> @@ -269,6 +271,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
>>> =C2=A0 =C2=A0 =C2=A0 osm_port_t *p_port;
>>> =C2=A0 =C2=A0 =C2=A0 osm_node_t *p_node;
>>> =C2=A0 =C2=A0 =C2=A0 int ret =3D 0;
>>> + =C2=A0 =C2=A0 int vlarb_only;
>>>
>>> =C2=A0 =C2=A0 =C2=A0 if (!p_osm->subn.opt.qos)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
>>> @@ -292,6 +295,7 @@ int osm_qos_setup(osm_opensm_t * p_osm)
>>> =C2=A0 =C2=A0 =C2=A0 p_tbl =3D &p_osm->subn.port_guid_tbl;
>>> =C2=A0 =C2=A0 =C2=A0 p_next =3D cl_qmap_head(p_tbl);
>>> =C2=A0 =C2=A0 =C2=A0 while (p_next !=3D cl_qmap_end(p_tbl)) {
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vlarb_only =3D 0;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_port =3D (osm_po=
rt_t *) p_next;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_next =3D cl_qmap=
_next(p_next);
>>>
>>> @@ -305,13 +309,20 @@ int osm_qos_setup(osm_opensm_t * p_osm)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 (&p_node->sw->switch_info))
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
>>>
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (ib_switch_info_get_opt_sl2vlmapping(&p_node->sw->switch_info) &=
&
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 p_osm->sm.p_subn->opt.use_optimized_slvl &&
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 !memcmp(&swe_config.sl2vl, &sw0_config.sl2vl,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sizeof(swe_config.sl2vl))=
)
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vlarb_only =3D 1;
>>> +
>>
>> qos_extports_setup() is running port setup loop (for both VLArb *and=
*
>> SL2VL) as:
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 1; i < num_ports; i++) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0...
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>
>> , starting from port '1'.
>>
>> So you case will just effectively skip any SL2VL setup for port 0
>> (it was commented for V1 too).
>
> This is intended. It's not needed since it's only doing this in the
> wildcarded case and the wildcarding includes port 0.

Any reason not to move ahead on this ? Thanks.

-- Hal

> -- Hal
>
>>
>> Sasha
>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cfg =3D &sw0_config;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (osm_nod=
e_get_type(p_node) =3D=3D IB_NODE_TYPE_ROUTER)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cfg =3D &rtr_config;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cfg =3D &ca_config;
>>>
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (qos_endport_setup(&=
p_osm->sm, p_port->p_physp, cfg))
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (qos_endport_setup(&=
p_osm->sm, p_port->p_physp, cfg,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vlarb_only))
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ret =3D -1;
>>> =C2=A0 =C2=A0 =C2=A0 }
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
