From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Fix sl2vl configuration
Date: Tue, 24 Aug 2010 09:41:56 -0400
Message-ID: <AANLkTi=uiAQb6jKTPVGUTBUPfDJoeA80RTKNNi+a_Q1J@mail.gmail.com>
References: <4C505A39.4020201@gmail.com>
	<AANLkTinpju=SXu_PUmd_8gt8uPazNJnz6HhWU=RLgw+M@mail.gmail.com>
	<AANLkTimbKes214zYF0so0tHgjvFwiwu83sP3MYnnbBd6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimbKes214zYF0so0tHgjvFwiwu83sP3MYnnbBd6-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,

On Mon, Aug 23, 2010 at 3:37 PM, Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
> Hi Hal,
>
> On Mon, Aug 23, 2010 at 5:25 PM, Hal Rosenstock
> <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Wed, Jul 28, 2010 at 12:26 PM, Eli Dorfman (Voltaire)
>> <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>
>>> Subject: [PATCH] Fix sl2vl configuration
>>>
>>> For non-optimized sl2vl configuration in and out ports were reverse=
d.
>>
>> Are you sure these are reversed ? Any idea which commit introduced
>> this reversal of in and out ports ?
> I'm sure they are reversed.

I looked at it some more and the ports look reversed to me too.

> This patch was also tested by Jim Schutt.

That only means it works in his environment rather than "correctness".

> I didn't check which commit introduced this - why is it important?

I'd like to understand which patch introduced the reversal. I don't
see it but might have missed it.  I think it's important to know which
versions are broken.

>>
>>> For optimal sl2vl added override of default ALL settting with port'=
s
>>> sl2vl when operational VL was other than the default port.
>>
>> What is the motivation to override when the operational VLs is
>> different ? Why is that better than what is done currently ?
> The idea was to apply the default policy - set sl2vl modulo operation=
al VL.
> When applying ALL settings using port 1 we still want to override thi=
s
> setting for ports with different operational VL.

What makes the default policy modulo operational VLs ?

>
>>
>> Is this really a policy issue ?
>>
>> IMO there are two separate issues in this patch and they should be i=
n
>> separate patches (for better git bisection).
> Maybe, but I still think this patch fixes wrong setting for sl2vl
> using optimized and non optimized methods.
> I'm not sure this should be divided to 2 separate patches.

It's one thought per patch and to me this is two different thoughts.

>>
>> Also, a couple of (possibly related) questions below.
> It seems that you are referring to patch v1 which was modified
> according to Jim's comments.
> Please check the v2 patch .

I see my questions are moot in terms of the v2 patch.

-- Hal

> Thanks,
> Eli
>
>>
>>> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>> ---
>>> =C2=A0opensm/opensm/osm_qos.c | =C2=A0 25 ++++++++++++++++++++-----
>>> =C2=A01 files changed, 20 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
>>> index a571370..de0ae23 100644
>>> --- a/opensm/opensm/osm_qos.c
>>> +++ b/opensm/opensm/osm_qos.c
>>> @@ -182,7 +182,7 @@ static ib_api_status_t sl2vl_update_table(osm_s=
m_t * sm, osm_physp_t * p,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tbl.raw_vl_b=
y_sl[i] =3D (vl1 << 4) | vl2;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>>
>>> - =C2=A0 =C2=A0 =C2=A0 if (!force_update && (p_tbl =3D osm_physp_ge=
t_slvl_tbl(p, in_port)) &&
>>> + =C2=A0 =C2=A0 =C2=A0 if (!force_update && in_port && (p_tbl =3D o=
sm_physp_get_slvl_tbl(p, in_port)) &&
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!memcmp(p_tbl, &tbl, sizeo=
f(tbl)))
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return IB_SU=
CCESS;
>>
>> Why exclude port 0 here ? Is it related to the change noted below ?
>>
>>> @@ -209,6 +209,7 @@ static int qos_extports_setup(osm_sm_t * sm, os=
m_node_t *node,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned num_ports =3D osm_node_get_num_=
physp(node);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned i, j;
>>> + =C2=A0 =C2=A0 =C2=A0 uint8_t op_vl1;
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 1; i < num_ports; i++) {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D osm_no=
de_get_physp_ptr(node, i);
>>> @@ -225,17 +226,31 @@ static int qos_extports_setup(osm_sm_t * sm, =
osm_node_t *node,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ib_switch_info_get_opt_sl2vlmapping(=
&node->sw->switch_info) &&
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sm->p_subn->opt.use_optimi=
zed_slvl) {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D osm_no=
de_get_physp_ptr(node, 1);
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 op_vl1 =3D ib_po=
rt_info_get_op_vls(&p->port_info);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_update=
 =3D p->need_update || sm->p_subn->need_update;
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return sl2vl_upd=
ate_table(sm, p, 1, 0x30000, force_update,
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 &qcfg->sl2vl);
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sl2vl_update=
_table(sm, p, 0, 0x30000, force_update,
>>
>> Why is the third parameter (in_port) changed from 1 to 0 here ? Mayb=
e
>> that's related to the change above for the skipping of port 0 in
>> sl2vl_update_table.
>>
>> -- Hal
>>
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &qcf=
g->sl2vl))
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ret =3D -1;
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* overwrite def=
ault ALL configuration if port's
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0op_=
vl is different */
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 2; i =
< num_ports; i++) {
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 p =3D osm_node_get_physp_ptr(node, i);
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (ib_port_info_get_op_vls(&p->port_info) !=3D op_vl1 &&
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 sl2vl_update_table(sm, p, 0, 0x20000 | i, forc=
e_update,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 &qcfg->sl2vl))
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -1;
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>>
>>> - =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < num_ports; i++) {
>>> + =C2=A0 =C2=A0 =C2=A0 /* non optimized sl2vl configuration */
>>> + =C2=A0 =C2=A0 =C2=A0 i =3D ib_switch_info_is_enhanced_port0(&node=
->sw->switch_info) ? 0 : 1;
>>> + =C2=A0 =C2=A0 =C2=A0 for (; i < num_ports; i++) {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D osm_no=
de_get_physp_ptr(node, i);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_update=
 =3D p->need_update || sm->p_subn->need_update;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0j =3D ib_swi=
tch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; j < n=
um_ports; j++)
>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (sl2vl_update_table(sm, p, i, i << 8 | j,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (sl2vl_update_table(sm, p, j, j << 8 | i,
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 force_update, &qcfg->sl2vl))
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -1;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>> --
>>> 1.5.5
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
