From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: bug in trap report for MC create(66) and delete(67)
 traps
Date: Sun, 07 Feb 2010 11:47:50 +0200
Message-ID: <4B6E8C46.5020807@gmail.com>
References: <4B6832F8.9090200@gmail.com> <20100203094923.GQ26338@me>	 <4B6B0736.9010001@gmail.com>	 <f0e08f231002041252s4c2f9c66jaa43d25bb3c75cbc@mail.gmail.com>	 <694d48601002050618s2af59695xa36522c04027d8af@mail.gmail.com> <f0e08f231002050820j1df2b425ia44203957257a6fb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f231002050820j1df2b425ia44203957257a6fb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock wrote:
> On Fri, Feb 5, 2010 at 9:18 AM, Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Thu, Feb 4, 2010 at 10:52 PM, Hal Rosenstock
>> <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Thu, Feb 4, 2010 at 12:43 PM, Eli Dorfman (Voltaire)
>>> <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> Subject: [PATCH] Wrong handling of MC create and delete traps
>>>>
>>>> For these traps the GID in the data details is the MGID and
>>>> not the source port gid.
>>>> So the SM should check that subscriber port has the pkey of the MC group.
>>>> There was also an error in comparing the subnet prefix and guid due to
>>>> host/network order mismatch.
>>>>
>>>> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>>  opensm/opensm/osm_inform.c |  151 ++++++++++++++++++++++++++++---------------
>>>>  1 files changed, 98 insertions(+), 53 deletions(-)
>>>>
>>>> diff --git a/opensm/opensm/osm_inform.c b/opensm/opensm/osm_inform.c
>>>> index 8108213..ae4fe71 100644
>>>> --- a/opensm/opensm/osm_inform.c
>>>> +++ b/opensm/opensm/osm_inform.c
>>>> @@ -341,6 +341,103 @@ Exit:
>>>>        return status;
>>>>  }
>>>>
>>>> +static int is_access_permitted( osm_infr_t *p_infr_rec,
>>>> +                               osm_infr_match_ctxt_t *p_infr_match )
>>>> +{
>>>> +       cl_list_t *p_infr_to_remove_list = p_infr_match->p_remove_infr_list;
>>>> +       ib_inform_info_t *p_ii = &(p_infr_rec->inform_record.inform_info);
>>>> +       ib_mad_notice_attr_t *p_ntc = p_infr_match->p_ntc;
>>>> +       uint16_t trap_num = cl_ntoh16(p_ntc->g_or_v.generic.trap_num);
>>>> +       osm_subn_t *p_subn = p_infr_rec->sa->p_subn;
>>>> +       osm_log_t *p_log = p_infr_rec->sa->p_log;
>>>> +       char gid_str[INET6_ADDRSTRLEN];
>>>> +       osm_mgrp_t *p_mgrp;
>>>> +       ib_gid_t source_gid;
>>>> +       osm_port_t *p_src_port;
>>>> +       osm_port_t *p_dest_port;
>>>> +
>>>> +       /* In case of GID_IN(64) or GID_OUT(65) traps the source gid
>>>> +          comparison should be done on the trap source (saved as the gid in the
>>>> +          data details field).
>>>> +          For traps MC_CREATE(66) or MC_DELETE(67) the data details gid is
>>>> +          the MGID. We need to check whether subscriber has the pky of
>>>
>>>                   typo  ^^^^
>>>
>>>                           pkey
>>>
>>>
>>>> +          the MC group.
>>> Shouldn't this be the subscriber has a compatible pkey with MC group ?
>>> The MC group has a full member PKey and the members can be full or
>>> limited.
>> I accept the correction.
> 
> Doesn't this require a code change for handling trap cases 66-67 ?

I think that you referred to the comment since the code is handling this properly (in my opinion).

> 
>> Sasha, can you please change this in the commit (only if there are not
>> other remarks).
> 
> Is that what you are asking Sasha to do (beyond the typos) ?

I asked Sasha to fix only the typo in commit.

> 
>> BTW, there is no explicit reference in the IB spec for MC group
>> create/delete trap (at least I didn't find it).
> 
> Not sure what you mean by this. What didn't you find ?

in the spec see o13-17.1.2

Thanks,
Eli
> 
> -- Hal
> 
>>>> +          In all other cases the issuer gis is the trap source.
>>>                                               typo  ^^^
>>>                                                       gid
>>>
>> and this typo of course.
>>
>> Thanks,
>> Eli
>>> -- Hal
>>>
>>>> +       */
>>>> +       if (trap_num >= 64 && trap_num <= 67 )
>>>> +               /* The issuer of these traps is the SM so source_gid
>>>> +                  is the gid saved on the data details */
>>>> +               source_gid = p_ntc->data_details.ntc_64_67.gid;
>>>> +       else
>>>> +               source_gid = p_ntc->issuer_gid;
>>>> +
>>>> +       p_dest_port =
>>>> +           cl_ptr_vector_get(&p_subn->port_lid_tbl,
>>>> +                             cl_ntoh16(p_infr_rec->report_addr.dest_lid));
>>>> +       if (!p_dest_port) {
>>>> +               OSM_LOG(p_log, OSM_LOG_INFO,
>>>> +                       "Cannot find destination port with LID:%u\n",
>>>> +                       cl_ntoh16(p_infr_rec->report_addr.dest_lid));
>>>> +               goto Exit;
>>>> +       }
>>>> +
>>>> +       switch (trap_num) {
>>>> +               case 66:
>>>> +               case 67:
>>>> +                       p_mgrp = osm_get_mgrp_by_mgid(p_subn, &source_gid);
>>>> +                       if (!p_mgrp) {
>>>> +                               OSM_LOG(p_log, OSM_LOG_INFO,
>>>> +                                       "Cannot find MGID %s\n",
>>>> +                                       inet_ntop(AF_INET6, source_gid.raw, gid_str, sizeof gid_str));
>>>> +                               goto Exit;
>>>> +                       }
>>>> +
>>>> +                       if (!osm_physp_has_pkey(p_log,
>>>> +                                               p_mgrp->mcmember_rec.pkey,
>>>> +                                               p_dest_port->p_physp)) {
>>>> +                               OSM_LOG(p_log, OSM_LOG_INFO,
>>>> +                                       "MGID %s and port GUID:0x%016" PRIx64 " do not share same pkey\n",
>>>> +                                       inet_ntop(AF_INET6, source_gid.raw, gid_str, sizeof gid_str),
>>>> +                                       cl_ntoh64(p_dest_port->guid));
>>>> +                               goto Exit;
>>>> +                       }
>>>> +                       break;
>>>> +
>>>> +               default:
>>>> +                       p_src_port =
>>>> +                           osm_get_port_by_guid(p_subn, source_gid.unicast.interface_id);
>>>> +                       if (!p_src_port) {
>>>> +                               OSM_LOG(p_log, OSM_LOG_INFO,
>>>> +                                       "Cannot find source port with GUID:0x%016" PRIx64 "\n",
>>>> +                                       cl_ntoh64(source_gid.unicast.interface_id));
>>>> +                               goto Exit;
>>>> +                       }
>>>> +
>>>> +
>>>> +                       /* Check if there is a pkey match. o13-17.1.1 */
>>>> +                       if (osm_port_share_pkey(p_log, p_src_port, p_dest_port) == FALSE) {
>>>> +                               OSM_LOG(p_log, OSM_LOG_DEBUG, "Mismatch by Pkey\n");
>>>> +                               /* According to o13-17.1.2 - If this informInfo does not have
>>>> +                                  lid_range_begin of 0xFFFF, then this informInfo request
>>>> +                                  should be removed from database */
>>>> +                               if (p_ii->lid_range_begin != 0xFFFF) {
>>>> +                                       OSM_LOG(p_log, OSM_LOG_VERBOSE,
>>>> +                                               "Pkey mismatch on lid_range_begin != 0xFFFF. "
>>>> +                                               "Need to remove this informInfo from db\n");
>>>> +                                       /* add the informInfo record to the remove_infr list */
>>>> +                                       cl_list_insert_tail(p_infr_to_remove_list, p_infr_rec);
>>>> +                               }
>>>> +                               goto Exit;
>>>> +                       }
>>>> +                       break;
>>>> +       }
>>>> +
>>>> +       return 1;
>>>> +Exit:
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +
>>>>  /**********************************************************************
>>>>  * This routine compares a given Notice and a ListItem of InformInfo type.
>>>>  * PREREQUISITE:
>>>> @@ -351,15 +448,10 @@ static void match_notice_to_inf_rec(IN cl_list_item_t * p_list_item,
>>>>  {
>>>>        osm_infr_match_ctxt_t *p_infr_match = (osm_infr_match_ctxt_t *) context;
>>>>        ib_mad_notice_attr_t *p_ntc = p_infr_match->p_ntc;
>>>> -       cl_list_t *p_infr_to_remove_list = p_infr_match->p_remove_infr_list;
>>>>        osm_infr_t *p_infr_rec = (osm_infr_t *) p_list_item;
>>>>        ib_inform_info_t *p_ii = &(p_infr_rec->inform_record.inform_info);
>>>>        cl_status_t status = CL_NOT_FOUND;
>>>>        osm_log_t *p_log = p_infr_rec->sa->p_log;
>>>> -       osm_subn_t *p_subn = p_infr_rec->sa->p_subn;
>>>> -       ib_gid_t source_gid;
>>>> -       osm_port_t *p_src_port;
>>>> -       osm_port_t *p_dest_port;
>>>>
>>>>        OSM_LOG_ENTER(p_log);
>>>>
>>>> @@ -460,55 +552,8 @@ static void match_notice_to_inf_rec(IN cl_list_item_t * p_list_item,
>>>>                }
>>>>        }
>>>>
>>>> -       /* Check if there is a pkey match. o13-17.1.1 */
>>>> -       /* Check if the issuer of the trap is the SM. If it is, then the gid
>>>> -          comparison should be done on the trap source (saved as the gid in the
>>>> -          data details field).
>>>> -          If the issuer gid is not the SM - then it is the guid of the trap
>>>> -          source */
>>>> -       if ((cl_ntoh64(p_ntc->issuer_gid.unicast.prefix) ==
>>>> -            p_subn->opt.subnet_prefix)
>>>> -           && (cl_ntoh64(p_ntc->issuer_gid.unicast.interface_id) ==
>>>> -               p_subn->sm_port_guid))
>>>> -               /* The issuer is the SM then this is trap 64-67 - compare the gid
>>>> -                  with the gid saved on the data details */
>>>> -               source_gid = p_ntc->data_details.ntc_64_67.gid;
>>>> -       else
>>>> -               source_gid = p_ntc->issuer_gid;
>>>> -
>>>> -       p_src_port =
>>>> -           osm_get_port_by_guid(p_subn, source_gid.unicast.interface_id);
>>>> -       if (!p_src_port) {
>>>> -               OSM_LOG(p_log, OSM_LOG_INFO,
>>>> -                       "Cannot find source port with GUID:0x%016" PRIx64 "\n",
>>>> -                       cl_ntoh64(source_gid.unicast.interface_id));
>>>> +       if (!is_access_permitted(p_infr_rec, p_infr_match))
>>>>                goto Exit;
>>>> -       }
>>>> -
>>>> -       p_dest_port =
>>>> -           cl_ptr_vector_get(&p_subn->port_lid_tbl,
>>>> -                             cl_ntoh16(p_infr_rec->report_addr.dest_lid));
>>>> -       if (!p_dest_port) {
>>>> -               OSM_LOG(p_log, OSM_LOG_INFO,
>>>> -                       "Cannot find destination port with LID:%u\n",
>>>> -                       cl_ntoh16(p_infr_rec->report_addr.dest_lid));
>>>> -               goto Exit;
>>>> -       }
>>>> -
>>>> -       if (osm_port_share_pkey(p_log, p_src_port, p_dest_port) == FALSE) {
>>>> -               OSM_LOG(p_log, OSM_LOG_DEBUG, "Mismatch by Pkey\n");
>>>> -               /* According to o13-17.1.2 - If this informInfo does not have
>>>> -                  lid_range_begin of 0xFFFF, then this informInfo request
>>>> -                  should be removed from database */
>>>> -               if (p_ii->lid_range_begin != 0xFFFF) {
>>>> -                       OSM_LOG(p_log, OSM_LOG_VERBOSE,
>>>> -                               "Pkey mismatch on lid_range_begin != 0xFFFF. "
>>>> -                               "Need to remove this informInfo from db\n");
>>>> -                       /* add the informInfo record to the remove_infr list */
>>>> -                       cl_list_insert_tail(p_infr_to_remove_list, p_infr_rec);
>>>> -               }
>>>> -               goto Exit;
>>>> -       }
>>>>
>>>>        /* send the report to the address provided in the inform record */
>>>>        OSM_LOG(p_log, OSM_LOG_DEBUG, "MATCH! Sending Report...\n");
>>>> --
>>>> 1.5.5
>>>>
>>>> There is still a problem with GID OUT trap that is not sent since source port
>>>> was already removed.
>>>> Patch will follow.
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
