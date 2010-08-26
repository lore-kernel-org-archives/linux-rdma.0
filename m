From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Fix sl2vl configuration
Date: Thu, 26 Aug 2010 07:17:20 -0400
Message-ID: <AANLkTiksies1Trpxk9Ai3bF-1V4fGExCeCpQ5SvmMK3x@mail.gmail.com>
References: <4C505A39.4020201@gmail.com>
	<AANLkTinpju=SXu_PUmd_8gt8uPazNJnz6HhWU=RLgw+M@mail.gmail.com>
	<AANLkTimbKes214zYF0so0tHgjvFwiwu83sP3MYnnbBd6@mail.gmail.com>
	<AANLkTi=uiAQb6jKTPVGUTBUPfDJoeA80RTKNNi+a_Q1J@mail.gmail.com>
	<4C74D7A8.10502@gmail.com>
	<AANLkTimgLAQt=nGk9Gw+6=sREfaSagJdRu3S9dG5Mu9Y@mail.gmail.com>
	<4C760896.5050306@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C760896.5050306-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,

On Thu, Aug 26, 2010 at 2:24 AM, Eli Dorfman (Voltaire)
<dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Hal,
>
> Hal Rosenstock wrote:
>> On Wed, Aug 25, 2010 at 4:43 AM, Eli Dorfman (Voltaire)
>> <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Hal Rosenstock wrote:
>>>> Hi Eli,
>>>>
>>>> On Mon, Aug 23, 2010 at 3:37 PM, Eli Dorfman <dorfman.eli-Re5JQEeQqe8@public.gmane.org=
m> wrote:
>>>>> Hi Hal,
>>>>>
>>>>> On Mon, Aug 23, 2010 at 5:25 PM, Hal Rosenstock
>>>>> <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>> On Wed, Jul 28, 2010 at 12:26 PM, Eli Dorfman (Voltaire)
>>>>>> <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>>> Subject: [PATCH] Fix sl2vl configuration
>>>>>>>
>>>>>>> For non-optimized sl2vl configuration in and out ports were rev=
ersed.
>>>>>> Are you sure these are reversed ? Any idea which commit introduc=
ed
>>>>>> this reversal of in and out ports ?
>>>>> I'm sure they are reversed.
>>>> I looked at it some more and the ports look reversed to me too.
>>>>
>>>>> This patch was also tested by Jim Schutt.
>>>> That only means it works in his environment rather than "correctne=
ss".
>>> It was tested in mine enviornment as well.
>>> Usually I test the patch in my environment to verify its correctnes=
s (in addition to code review).
>>> I assume you do the same.
>>>
>>> Do you expect me to test the patch in your environment as well?
>>
>> Huh ?
>>
>>>>> I didn't check which commit introduced this - why is it important=
?
>>>> I'd like to understand which patch introduced the reversal. I don'=
t
>>>> see it but might have missed it. =C2=A0I think it's important to k=
now which
>>>> versions are broken.
>>> I think that the following commit added the bug:
>>>
>>> commit 051a1dd514e63f3a971afad38e377932efca5e18
>>> Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>> Date: =C2=A0 Mon Jan 4 21:06:19 2010 +0200
>>>
>>> =C2=A0 =C2=A0opensm/osm_qos.c: split switch external and end ports =
setup
>>>
>>> =C2=A0 =C2=A0This splits QoS related port parameters setup over swi=
tch external ports
>>> =C2=A0 =C2=A0and end ports. Such separation leaves us with simpler =
code and saves
>>> =C2=A0 =C2=A0some repeated flows in case of switch external ports (=
actually required
>>> =C2=A0 =C2=A0per switch and not per port).
>>>
>>> =C2=A0 =C2=A0Another advantages: Optimized Sl2VL Mapping procedure =
can be implemented
>>> =C2=A0 =C2=A0easier using this model. A low level port QoS related =
parameters setup
>>> =C2=A0 =C2=A0infrastructure is ready for supporting per port QoS re=
lated configuration
>>> =C2=A0 =C2=A0(which hopefully will be implemented some days).
>>>
>>
>> I thought it might be that one but wasn't sure. Thanks.
>>
>>>>>>> For optimal sl2vl added override of default ALL settting with p=
ort's
>>>>>>> sl2vl when operational VL was other than the default port.
>>>>>> What is the motivation to override when the operational VLs is
>>>>>> different ? Why is that better than what is done currently ?
>>>>> The idea was to apply the default policy - set sl2vl modulo opera=
tional VL.
>>>>> When applying ALL settings using port 1 we still want to override=
 this
>>>>> setting for ports with different operational VL.
>>>> What makes the default policy modulo operational VLs ?
>>> This is how its implemented in sl2vl_update_table()
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0vl_mask =3D (1 << (ib_port_info_get_op_v=
ls(&p->port_info) - 1)) - 1;
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i < IB_MAX_NUM_VLS / 2; i+=
+) {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vl1 =3D sl2v=
l_table->raw_vl_by_sl[i] >> 4;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vl2 =3D sl2v=
l_table->raw_vl_by_sl[i] & 0xf;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vl1 !=3D=
 15)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0vl1 &=3D vl_mask;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vl2 !=3D=
 15)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0vl2 &=3D vl_mask;
>>>
>>> Default startup switches configuration uses the same policy.
>>
>> I view this as further modification on the configuration based on th=
e
>> operational VLs. Besides, any VL specified above the op VLs is a dro=
p
>> (same as indicating VL15).
>
> This code is already in the trunk and my patch does not change that.
> The only diff in the patch is the fix of reversed in/out ports and co=
rresponding fix for
> optimized sl2vl configuration.
>
>>
>> I think what you are doing is changing the default behavior and henc=
e
>> perhaps an additional policy switch is needed if this change really =
is
>> needed and I'm unsure of that.
>
> I don't change the default behavior and this change is needed.
> Without it for example, if you connect a switch with opVL=3D4 (VL0-VL=
7) to a node that
> supports only VL0 and try to send traffic on sl>SL0 it will be droppe=
d.

Yes, you are right. I stand corrected.

-- Hal

> Eli
>
>>
>>>>>> Is this really a policy issue ?
>>>>>>
>>>>>> IMO there are two separate issues in this patch and they should =
be in
>>>>>> separate patches (for better git bisection).
>>>>> Maybe, but I still think this patch fixes wrong setting for sl2vl
>>>>> using optimized and non optimized methods.
>>>>> I'm not sure this should be divided to 2 separate patches.
>>>> It's one thought per patch and to me this is two different thought=
s.
>>> If this is the only issue, I can split this patch to 2 separate pat=
ches.
>>
>> It's also the issue noted above.
>>
>> -- Hal
>>
>>> Eli
>>>>>> Also, a couple of (possibly related) questions below.
>>>>> It seems that you are referring to patch v1 which was modified
>>>>> according to Jim's comments.
>>>>> Please check the v2 patch .
>>>> I see my questions are moot in terms of the v2 patch.
>>>>
>>>> -- Hal
>>>>
>>>>> Thanks,
>>>>> Eli
>>>>>
>>>>>>> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>>>>>> ---
>>>>>>> =C2=A0opensm/opensm/osm_qos.c | =C2=A0 25 ++++++++++++++++++++-=
----
>>>>>>> =C2=A01 files changed, 20 insertions(+), 5 deletions(-)
>>>>>>>
>>>>>>> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
>>>>>>> index a571370..de0ae23 100644
>>>>>>> --- a/opensm/opensm/osm_qos.c
>>>>>>> +++ b/opensm/opensm/osm_qos.c
>>>>>>> @@ -182,7 +182,7 @@ static ib_api_status_t sl2vl_update_table(o=
sm_sm_t * sm, osm_physp_t * p,
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tbl.raw_=
vl_by_sl[i] =3D (vl1 << 4) | vl2;
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>>>>>>
>>>>>>> - =C2=A0 =C2=A0 =C2=A0 if (!force_update && (p_tbl =3D osm_phys=
p_get_slvl_tbl(p, in_port)) &&
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 if (!force_update && in_port && (p_tbl =3D=
 osm_physp_get_slvl_tbl(p, in_port)) &&
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!memcmp(p_tbl, &tbl, s=
izeof(tbl)))
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return I=
B_SUCCESS;
>>>>>> Why exclude port 0 here ? Is it related to the change noted belo=
w ?
>>>>>>
>>>>>>> @@ -209,6 +209,7 @@ static int qos_extports_setup(osm_sm_t * sm=
, osm_node_t *node,
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned num_ports =3D osm_node_get_=
num_physp(node);
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret =3D 0;
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned i, j;
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 uint8_t op_vl1;
>>>>>>>
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 1; i < num_ports; i++) {
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D os=
m_node_get_physp_ptr(node, i);
>>>>>>> @@ -225,17 +226,31 @@ static int qos_extports_setup(osm_sm_t * =
sm, osm_node_t *node,
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ib_switch_info_get_opt_sl2vlmapp=
ing(&node->sw->switch_info) &&
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sm->p_subn->opt.use_op=
timized_slvl) {
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D os=
m_node_get_physp_ptr(node, 1);
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 op_vl1 =3D i=
b_port_info_get_op_vls(&p->port_info);
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_up=
date =3D p->need_update || sm->p_subn->need_update;
>>>>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return sl2vl=
_update_table(sm, p, 1, 0x30000, force_update,
>>>>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 &qcfg->sl2vl);
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sl2vl_up=
date_table(sm, p, 0, 0x30000, force_update,
>>>>>> Why is the third parameter (in_port) changed from 1 to 0 here ? =
Maybe
>>>>>> that's related to the change above for the skipping of port 0 in
>>>>>> sl2vl_update_table.
>>>>>>
>>>>>> -- Hal
>>>>>>
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
&qcfg->sl2vl))
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 ret =3D -1;
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* overwrite=
 default ALL configuration if port's
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
op_vl is different */
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 2=
; i < num_ports; i++) {
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 p =3D osm_node_get_physp_ptr(node, i);
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 if (ib_port_info_get_op_vls(&p->port_info) !=3D op_vl1 &=
&
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sl2vl_update_table(sm, p, 0, 0x20000 | i, =
force_update,
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &qcfg->sl2vl))
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -1;
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>>>>>>
>>>>>>> - =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < num_ports; i++) {
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 /* non optimized sl2vl configuration */
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 i =3D ib_switch_info_is_enhanced_port0(&=
node->sw->switch_info) ? 0 : 1;
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 for (; i < num_ports; i++) {
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D os=
m_node_get_physp_ptr(node, i);
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_up=
date =3D p->need_update || sm->p_subn->need_update;
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0j =3D ib=
_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (; j=
 < num_ports; j++)
>>>>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 if (sl2vl_update_table(sm, p, i, i << 8 | j,
>>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 if (sl2vl_update_table(sm, p, j, j << 8 | i,
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 force_update, &qcfg->sl2vl))
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -1;
>>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>>>>>> --
>>>>>>> 1.5.5
>>>>>>>
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-rdma" in
>>>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-i=
nfo.html
>>>>>>>
>>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
