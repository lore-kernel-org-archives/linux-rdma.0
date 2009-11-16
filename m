From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm: Cosmetic changes
Date: Mon, 16 Nov 2009 10:30:40 -0500
Message-ID: <f0e08f230911160730o2fc19cddh42382026c9510a5d@mail.gmail.com>
References: <20091113163720.GA13938@comcast.net> <20091115113920.GX7192@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091115113920.GX7192@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 15, 2009 at 6:39 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 11:37 Fri 13 Nov =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Compressed some type declarations and assignments into single line
>> Removed some unneeded underbars
>> Some minor reformatting including comment lines
>> Fixed some tabbing
>> Fixed some typos
>> Eliminated trailing periods in messages
>> Eliminated some unneeded braces
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Applied with one change (below). Thanks.
>
> [snip]
>
>> diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state=
_mgr.c
>> index 122a8d4..32b162c 100644
>> --- a/opensm/opensm/osm_state_mgr.c
>> +++ b/opensm/opensm/osm_state_mgr.c
>> @@ -174,8 +174,8 @@ static void state_mgr_get_remote_port_info(IN os=
m_sm_t * sm,
>> =C2=A0 =C2=A0 =C2=A0 mad_context.pi_context.light_sweep =3D TRUE;
>> =C2=A0 =C2=A0 =C2=A0 mad_context.pi_context.active_transition =3D FA=
LSE;
>>
>> - =C2=A0 =C2=A0 /* note that with some negative logic - if the query=
 failed it means that
>> - =C2=A0 =C2=A0 =C2=A0* there is no point in going to heavy sweep */
>> + =C2=A0 =C2=A0 /* note that with some negative logic - if the query=
 failed it means
>> + =C2=A0 =C2=A0 =C2=A0* that there is no point in going to heavy swe=
ep */
>> =C2=A0 =C2=A0 =C2=A0 status =3D osm_req_get(sm, &rem_node_dr_path,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0IB_MAD_ATTR_PORT_INFO, 0, CL_DISP_MSGID_NON=
E,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0&mad_context);
>> @@ -445,12 +445,12 @@ static ib_api_status_t state_mgr_sweep_hop_1(I=
N osm_sm_t * sm)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
>>
>> =C2=A0 =C2=A0 =C2=A0 case IB_NODE_TYPE_SWITCH:
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Need to go over all t=
he ports of the switch, and send a node_info
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* from them. This =
doesn't include the port 0 of the switch, which
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* hosts the SM.
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Note: We'll send=
 another switchInfo on port 0, since if no ports
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* are connected, w=
e still want to get some response, and have the
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* subnet come up.
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Need to go over all t=
he ports of the switch, and send a
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* node_info from t=
hem. This doesn't include the port 0 of the
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* switch, which ho=
sts the SM.
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Note: We'll send=
 another switchInfo on port 0, since if no
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* ports are connec=
ted, we still want to get some response, and
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* have the subnet =
come up.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 num_ports =3D osm_n=
ode_get_num_physp(p_node);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (port_num =3D 1=
; port_num < num_ports; port_num++) {
>> @@ -497,6 +497,7 @@ static void query_sm_info(cl_map_item_t * item, =
void *cxt)
>> =C2=A0 =C2=A0 =C2=A0 osm_sm_t *sm =3D cxt;
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t ret;
>>
>> +OSM_LOG(sm->p_log, OSM_LOG_ERROR, "GUID 0x%" PRIx64 "\n", cl_ntoh64=
(r_sm->p_port->guid));
>
> Assuming that this whole line is a typo (please review patches visual=
ly
> before hitting send) I'm removing it.

I did visually inspect but missed this.

-- Hal

>
> Sasha
>
>> =C2=A0 =C2=A0 =C2=A0 context.smi_context.port_guid =3D r_sm->p_port-=
>guid;
>> =C2=A0 =C2=A0 =C2=A0 context.smi_context.set_method =3D FALSE;
>> =C2=A0 =C2=A0 =C2=A0 context.smi_context.light_sweep =3D TRUE;
>> @@ -834,7 +835,7 @@ static void state_mgr_report_new_ports(IN osm_sm=
_t * sm)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* details of the n=
otice */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 notice.generic_type=
 =3D 0x83; =C2=A0 =C2=A0 /* is generic subn mgt type */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ib_notice_set_prod_=
type_ho(&notice, 4); /* A Class Manager generator */
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* endport becomes to be=
 reachable */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* endport becomes reach=
able */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 notice.g_or_v.gener=
ic.trap_num =3D CL_HTON16(64);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* The sm_base_lid =
is saved in network order already. */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 notice.issuer_lid =3D=
 sm->p_subn->sm_base_lid;
>> @@ -1125,7 +1126,7 @@ static void do_sweep(osm_sm_t * sm)
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 /* go to heavy sweep */
>> -_repeat_discovery:
>> +repeat_discovery:
>>
>> =C2=A0 =C2=A0 =C2=A0 /* First of all - unset all flags */
>> =C2=A0 =C2=A0 =C2=A0 sm->p_subn->force_heavy_sweep =3D FALSE;
>> @@ -1162,7 +1163,7 @@ _repeat_discovery:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wait_for_pending_transactions(&sm=
->p_subn->p_osm->stats))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>>
>> - =C2=A0 =C2=A0 /* discovery completed - check other sm presense */
>> + =C2=A0 =C2=A0 /* discovery completed - check other sm presence */
>> =C2=A0 =C2=A0 =C2=A0 if (sm->master_sm_found) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Call the sm=
_state_mgr with signal
>> @@ -1179,7 +1180,7 @@ _repeat_discovery:
>>
>> =C2=A0 =C2=A0 =C2=A0 /* if new sweep requested - don't bother with t=
he rest */
>> =C2=A0 =C2=A0 =C2=A0 if (sm->p_subn->force_heavy_sweep)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto _repeat_discovery;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto repeat_discovery;
>>
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE, "HE=
AVY SWEEP COMPLETE");
>>
>>
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
