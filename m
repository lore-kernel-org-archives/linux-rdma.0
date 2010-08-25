From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Fix sl2vl configuration
Date: Wed, 25 Aug 2010 11:43:20 +0300
Message-ID: <4C74D7A8.10502@gmail.com>
References: <4C505A39.4020201@gmail.com>	<AANLkTinpju=SXu_PUmd_8gt8uPazNJnz6HhWU=RLgw+M@mail.gmail.com>	<AANLkTimbKes214zYF0so0tHgjvFwiwu83sP3MYnnbBd6@mail.gmail.com> <AANLkTi=uiAQb6jKTPVGUTBUPfDJoeA80RTKNNi+a_Q1J@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=uiAQb6jKTPVGUTBUPfDJoeA80RTKNNi+a_Q1J-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock wrote:
> Hi Eli,
> 
> On Mon, Aug 23, 2010 at 3:37 PM, Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Hal,
>>
>> On Mon, Aug 23, 2010 at 5:25 PM, Hal Rosenstock
>> <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Wed, Jul 28, 2010 at 12:26 PM, Eli Dorfman (Voltaire)
>>> <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> Subject: [PATCH] Fix sl2vl configuration
>>>>
>>>> For non-optimized sl2vl configuration in and out ports were reversed.
>>> Are you sure these are reversed ? Any idea which commit introduced
>>> this reversal of in and out ports ?
>> I'm sure they are reversed.
> 
> I looked at it some more and the ports look reversed to me too.
> 
>> This patch was also tested by Jim Schutt.
> 
> That only means it works in his environment rather than "correctness".
It was tested in mine enviornment as well.
Usually I test the patch in my environment to verify its correctness (in addition to code review).
I assume you do the same.

Do you expect me to test the patch in your environment as well?


> 
>> I didn't check which commit introduced this - why is it important?
> 
> I'd like to understand which patch introduced the reversal. I don't
> see it but might have missed it.  I think it's important to know which
> versions are broken.

I think that the following commit added the bug:

commit 051a1dd514e63f3a971afad38e377932efca5e18
Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Date:   Mon Jan 4 21:06:19 2010 +0200

    opensm/osm_qos.c: split switch external and end ports setup

    This splits QoS related port parameters setup over switch external ports
    and end ports. Such separation leaves us with simpler code and saves
    some repeated flows in case of switch external ports (actually required
    per switch and not per port).

    Another advantages: Optimized Sl2VL Mapping procedure can be implemented
    easier using this model. A low level port QoS related parameters setup
    infrastructure is ready for supporting per port QoS related configuration
    (which hopefully will be implemented some days).



> 
>>>> For optimal sl2vl added override of default ALL settting with port's
>>>> sl2vl when operational VL was other than the default port.
>>> What is the motivation to override when the operational VLs is
>>> different ? Why is that better than what is done currently ?
>> The idea was to apply the default policy - set sl2vl modulo operational VL.
>> When applying ALL settings using port 1 we still want to override this
>> setting for ports with different operational VL.
> 
> What makes the default policy modulo operational VLs ?
This is how its implemented in sl2vl_update_table()

        vl_mask = (1 << (ib_port_info_get_op_vls(&p->port_info) - 1)) - 1;

        for (i = 0; i < IB_MAX_NUM_VLS / 2; i++) {
                vl1 = sl2vl_table->raw_vl_by_sl[i] >> 4;
                vl2 = sl2vl_table->raw_vl_by_sl[i] & 0xf;
                if (vl1 != 15)
                        vl1 &= vl_mask;
                if (vl2 != 15)
                        vl2 &= vl_mask;

Default startup switches configuration uses the same policy.


> 
>>> Is this really a policy issue ?
>>>
>>> IMO there are two separate issues in this patch and they should be in
>>> separate patches (for better git bisection).
>> Maybe, but I still think this patch fixes wrong setting for sl2vl
>> using optimized and non optimized methods.
>> I'm not sure this should be divided to 2 separate patches.
> 
> It's one thought per patch and to me this is two different thoughts.
If this is the only issue, I can split this patch to 2 separate patches.

Eli
> 
>>> Also, a couple of (possibly related) questions below.
>> It seems that you are referring to patch v1 which was modified
>> according to Jim's comments.
>> Please check the v2 patch .
> 
> I see my questions are moot in terms of the v2 patch.
> 
> -- Hal
> 
>> Thanks,
>> Eli
>>
>>>> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>>  opensm/opensm/osm_qos.c |   25 ++++++++++++++++++++-----
>>>>  1 files changed, 20 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
>>>> index a571370..de0ae23 100644
>>>> --- a/opensm/opensm/osm_qos.c
>>>> +++ b/opensm/opensm/osm_qos.c
>>>> @@ -182,7 +182,7 @@ static ib_api_status_t sl2vl_update_table(osm_sm_t * sm, osm_physp_t * p,
>>>>                tbl.raw_vl_by_sl[i] = (vl1 << 4) | vl2;
>>>>        }
>>>>
>>>> -       if (!force_update && (p_tbl = osm_physp_get_slvl_tbl(p, in_port)) &&
>>>> +       if (!force_update && in_port && (p_tbl = osm_physp_get_slvl_tbl(p, in_port)) &&
>>>>            !memcmp(p_tbl, &tbl, sizeof(tbl)))
>>>>                return IB_SUCCESS;
>>> Why exclude port 0 here ? Is it related to the change noted below ?
>>>
>>>> @@ -209,6 +209,7 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
>>>>        unsigned num_ports = osm_node_get_num_physp(node);
>>>>        int ret = 0;
>>>>        unsigned i, j;
>>>> +       uint8_t op_vl1;
>>>>
>>>>        for (i = 1; i < num_ports; i++) {
>>>>                p = osm_node_get_physp_ptr(node, i);
>>>> @@ -225,17 +226,31 @@ static int qos_extports_setup(osm_sm_t * sm, osm_node_t *node,
>>>>        if (ib_switch_info_get_opt_sl2vlmapping(&node->sw->switch_info) &&
>>>>            sm->p_subn->opt.use_optimized_slvl) {
>>>>                p = osm_node_get_physp_ptr(node, 1);
>>>> +               op_vl1 = ib_port_info_get_op_vls(&p->port_info);
>>>>                force_update = p->need_update || sm->p_subn->need_update;
>>>> -               return sl2vl_update_table(sm, p, 1, 0x30000, force_update,
>>>> -                                         &qcfg->sl2vl);
>>>> +               if (sl2vl_update_table(sm, p, 0, 0x30000, force_update,
>>> Why is the third parameter (in_port) changed from 1 to 0 here ? Maybe
>>> that's related to the change above for the skipping of port 0 in
>>> sl2vl_update_table.
>>>
>>> -- Hal
>>>
>>>> +                                       &qcfg->sl2vl))
>>>> +                       ret = -1;
>>>> +               /* overwrite default ALL configuration if port's
>>>> +                  op_vl is different */
>>>> +               for (i = 2; i < num_ports; i++) {
>>>> +                       p = osm_node_get_physp_ptr(node, i);
>>>> +                       if (ib_port_info_get_op_vls(&p->port_info) != op_vl1 &&
>>>> +                           sl2vl_update_table(sm, p, 0, 0x20000 | i, force_update,
>>>> +                                               &qcfg->sl2vl))
>>>> +                               ret = -1;
>>>> +               }
>>>> +               return ret;
>>>>        }
>>>>
>>>> -       for (i = 0; i < num_ports; i++) {
>>>> +       /* non optimized sl2vl configuration */
>>>> +       i = ib_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
>>>> +       for (; i < num_ports; i++) {
>>>>                p = osm_node_get_physp_ptr(node, i);
>>>>                force_update = p->need_update || sm->p_subn->need_update;
>>>>                j = ib_switch_info_is_enhanced_port0(&node->sw->switch_info) ? 0 : 1;
>>>>                for (; j < num_ports; j++)
>>>> -                       if (sl2vl_update_table(sm, p, i, i << 8 | j,
>>>> +                       if (sl2vl_update_table(sm, p, j, j << 8 | i,
>>>>                                               force_update, &qcfg->sl2vl))
>>>>                                ret = -1;
>>>>        }
>>>> --
>>>> 1.5.5
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
