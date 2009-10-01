From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [OPENSM] match functions to prototypes in header file
Date: Thu, 1 Oct 2009 20:31:27 +0200
Message-ID: <20091001183127.GX17846@me>
References: <3DE88517D38A4EB0B49A2E3AAF96D005@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3DE88517D38A4EB0B49A2E3AAF96D005-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:44 Wed 30 Sep     , Stan C. Smith wrote:
> 
> From the looks of the cut-n-past from git diff output the emailer is not expanding tabs
>  as envisioned, hence the attached Linux EOL patch file; grrrrrrrrrrr.

I'm not using Outlook, but guess that there are other people on the list
which are, maybe they could suggest some useful techniques.

> Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
> index 4b4e320..28edb04 100644
> --- a/opensm/opensm/osm_helper.c
> +++ b/opensm/opensm/osm_helper.c
> @@ -780,10 +780,11 @@ static void dbg_get_capabilities_str(IN char *p_buf, IN const uint32_t buf_size,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_port_info(IN osm_log_t * p_log, IN const ib_net64_t node_guid,
> +void osm_dump_port_info(IN osm_log_t * const p_log,
> +			IN const ib_net64_t node_guid,
>  			IN const ib_net64_t port_guid,
>  			IN const uint8_t port_num,
> -			IN const ib_port_info_t * p_pi,
> +			IN const ib_port_info_t * const p_pi,
>  			IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -870,8 +871,8 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN const ib_net64_t node_guid,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_portinfo_record(IN osm_log_t * p_log,
> -			      IN const ib_portinfo_record_t * p_pir,
> +void osm_dump_portinfo_record(IN osm_log_t * const p_log,
> +			      IN const ib_portinfo_record_t * const p_pir,
>  			      IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -956,8 +957,8 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_guidinfo_record(IN osm_log_t * p_log,
> -			      IN const ib_guidinfo_record_t * p_gir,
> +void osm_dump_guidinfo_record(IN osm_log_t * const p_log,
> +			      IN const ib_guidinfo_record_t * const p_gir,
>  			      IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -995,7 +996,8 @@ void osm_dump_guidinfo_record(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_node_info(IN osm_log_t * p_log, IN const ib_node_info_t * p_ni,
> +void osm_dump_node_info(IN osm_log_t * const p_log,
> +			IN const ib_node_info_t * const p_ni,
>  			IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1030,8 +1032,8 @@ void osm_dump_node_info(IN osm_log_t * p_log, IN const ib_node_info_t * p_ni,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_node_record(IN osm_log_t * p_log,
> -			  IN const ib_node_record_t * p_nr,
> +void osm_dump_node_record(IN osm_log_t * const p_log,
> +			  IN const ib_node_record_t * const p_nr,
>  			  IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1080,7 +1082,8 @@ void osm_dump_node_record(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
> +void osm_dump_path_record(IN osm_log_t * const p_log,
> +			  IN const ib_path_rec_t * const p_pr,
>  			  IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1106,9 +1109,9 @@ void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
>  			"\t\t\t\tresv2...................0x%X\n"
>  			"\t\t\t\tresv3...................0x%X\n",
>  			cl_ntoh64(p_pr->service_id),
> -			inet_ntop(AF_INET6, p_pr->dgid.raw, gid_str,
> +			inet_ntop(AF_INET6, (void*)p_pr->dgid.raw, gid_str,

And why is such casting(s) needed?

Also wouldn't it be simpler to remove 'const' in "type * const var"
function parameter definitions? This restricts only value of a pointer
(not structure content), and since function parameters are passed by
values such restriction is only related to a function implementation
and actually meanless in sense of API. Thoughts?

Sasha

>  				  sizeof gid_str),
> -			inet_ntop(AF_INET6, p_pr->sgid.raw, gid_str2,
> +			inet_ntop(AF_INET6, (void*)p_pr->sgid.raw, gid_str2,
>  				  sizeof gid_str2),
>  			cl_ntoh16(p_pr->dlid),
>  			cl_ntoh16(p_pr->slid),
> @@ -1129,8 +1132,8 @@ void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_multipath_record(IN osm_log_t * p_log,
> -			       IN const ib_multipath_rec_t * p_mpr,
> +void osm_dump_multipath_record(IN osm_log_t * const p_log,
> +			       IN const ib_multipath_rec_t * const p_mpr,
>  			       IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1144,7 +1147,7 @@ void osm_dump_multipath_record(IN osm_log_t * p_log,
>  				n += sprintf(buf_line + n,
>  					     "\t\t\t\tsgid%02d.................."
>  					     "%s\n", i + 1,
> -					     inet_ntop(AF_INET6, p_gid->raw,
> +					     inet_ntop(AF_INET6, (void*)p_gid->raw,
>  						       gid_str, sizeof gid_str));
>  				p_gid++;
>  			}
> @@ -1154,7 +1157,7 @@ void osm_dump_multipath_record(IN osm_log_t * p_log,
>  				n += sprintf(buf_line + n,
>  					     "\t\t\t\tdgid%02d.................."
>  					     "%s\n", i + 1,
> -					     inet_ntop(AF_INET6, p_gid->raw,
> +					     inet_ntop(AF_INET6, (void*)p_gid->raw,
>  						       gid_str, sizeof gid_str));
>  				p_gid++;
>  			}
> @@ -1193,7 +1196,8 @@ void osm_dump_multipath_record(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_mc_record(IN osm_log_t * p_log, IN const ib_member_rec_t * p_mcmr,
> +void osm_dump_mc_record(IN osm_log_t * const p_log,
> +			IN const ib_member_rec_t * const p_mcmr,
>  			IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1213,9 +1217,9 @@ void osm_dump_mc_record(IN osm_log_t * p_log, IN const ib_member_rec_t * p_mcmr,
>  			"\t\t\t\tSLFlowLabelHopLimit.....0x%X\n"
>  			"\t\t\t\tScopeState..............0x%X\n"
>  			"\t\t\t\tProxyJoin...............0x%X\n",
> -			inet_ntop(AF_INET6, p_mcmr->mgid.raw, gid_str,
> +			inet_ntop(AF_INET6, (void*)p_mcmr->mgid.raw, gid_str,
>  				  sizeof gid_str),
> -			inet_ntop(AF_INET6, p_mcmr->port_gid.raw, gid_str2,
> +			inet_ntop(AF_INET6, (void*)p_mcmr->port_gid.raw, gid_str2,
>  				  sizeof gid_str2),
>  			cl_ntoh32(p_mcmr->qkey),
>  			cl_ntoh16(p_mcmr->mlid),
> @@ -1231,8 +1235,8 @@ void osm_dump_mc_record(IN osm_log_t * p_log, IN const ib_member_rec_t * p_mcmr,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_service_record(IN osm_log_t * p_log,
> -			     IN const ib_service_record_t * p_sr,
> +void osm_dump_service_record(IN osm_log_t * const p_log,
> +			     IN const ib_service_record_t * const p_sr,
>  			     IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1299,7 +1303,7 @@ void osm_dump_service_record(IN osm_log_t * p_log,
>  			"\t\t\t\tServiceData64.1.........0x%016" PRIx64 "\n"
>  			"\t\t\t\tServiceData64.2.........0x%016" PRIx64 "\n",
>  			cl_ntoh64(p_sr->service_id),
> -			inet_ntop(AF_INET6, p_sr->service_gid.raw, gid_str,
> +			inet_ntop(AF_INET6, (void*)p_sr->service_gid.raw, gid_str,
>  				  sizeof gid_str),
>  			cl_ntoh16(p_sr->service_pkey),
>  			cl_ntoh32(p_sr->service_lease),
> @@ -1332,8 +1336,8 @@ void osm_dump_service_record(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_inform_info(IN osm_log_t * p_log,
> -			  IN const ib_inform_info_t * p_ii,
> +void osm_dump_inform_info(IN osm_log_t * const p_log,
> +			  IN const ib_inform_info_t * const p_ii,
>  			  IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1356,7 +1360,7 @@ void osm_dump_inform_info(IN osm_log_t * p_log,
>  				"\t\t\t\tqpn.....................0x%06X\n"
>  				"\t\t\t\tresp_time_val...........0x%X\n"
>  				"\t\t\t\tnode_type...............0x%06X\n" "",
> -				inet_ntop(AF_INET6, p_ii->gid.raw, gid_str,
> +				inet_ntop(AF_INET6, (void*)p_ii->gid.raw, gid_str,
>  					  sizeof gid_str),
>  				cl_ntoh16(p_ii->lid_range_begin),
>  				cl_ntoh16(p_ii->lid_range_end),
> @@ -1378,7 +1382,7 @@ void osm_dump_inform_info(IN osm_log_t * p_log,
>  				"\t\t\t\tqpn.....................0x%06X\n"
>  				"\t\t\t\tresp_time_val...........0x%X\n"
>  				"\t\t\t\tvendor_id...............0x%06X\n" "",
> -				inet_ntop(AF_INET6, p_ii->gid.raw, gid_str,
> +				inet_ntop(AF_INET6, (void*)p_ii->gid.raw, gid_str,
>  					  sizeof gid_str),
>  				cl_ntoh16(p_ii->lid_range_begin),
>  				cl_ntoh16(p_ii->lid_range_end),
> @@ -1393,8 +1397,8 @@ void osm_dump_inform_info(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_inform_info_record(IN osm_log_t * p_log,
> -				 IN const ib_inform_info_record_t * p_iir,
> +void osm_dump_inform_info_record(IN osm_log_t * const p_log,
> +				 IN const ib_inform_info_record_t * const p_iir,
>  				 IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1423,10 +1427,10 @@ void osm_dump_inform_info_record(IN osm_log_t * p_log,
>  				"\t\t\t\tqpn.....................0x%06X\n"
>  				"\t\t\t\tresp_time_val...........0x%X\n"
>  				"\t\t\t\tnode_type...............0x%06X\n" "",
> -				inet_ntop(AF_INET6, p_iir->subscriber_gid.raw,
> +				inet_ntop(AF_INET6, (void*)p_iir->subscriber_gid.raw,
>  					  gid_str, sizeof gid_str),
>  				cl_ntoh16(p_iir->subscriber_enum),
> -				inet_ntop(AF_INET6, p_iir->inform_info.gid.raw,
> +				inet_ntop(AF_INET6, (void*)p_iir->inform_info.gid.raw,
>  					  gid_str2, sizeof gid_str2),
>  				cl_ntoh16(p_iir->inform_info.lid_range_begin),
>  				cl_ntoh16(p_iir->inform_info.lid_range_end),
> @@ -1455,10 +1459,10 @@ void osm_dump_inform_info_record(IN osm_log_t * p_log,
>  				"\t\t\t\tqpn.....................0x%06X\n"
>  				"\t\t\t\tresp_time_val...........0x%X\n"
>  				"\t\t\t\tvendor_id...............0x%06X\n" "",
> -				inet_ntop(AF_INET6, p_iir->subscriber_gid.raw,
> +				inet_ntop(AF_INET6, (void*)p_iir->subscriber_gid.raw,
>  					  gid_str, sizeof gid_str),
>  				cl_ntoh16(p_iir->subscriber_enum),
> -				inet_ntop(AF_INET6, p_iir->inform_info.gid.raw,
> +				inet_ntop(AF_INET6, (void*)p_iir->inform_info.gid.raw,
>  					  gid_str2, sizeof gid_str2),
>  				cl_ntoh16(p_iir->inform_info.lid_range_begin),
>  				cl_ntoh16(p_iir->inform_info.lid_range_end),
> @@ -1476,8 +1480,8 @@ void osm_dump_inform_info_record(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_link_record(IN osm_log_t * p_log,
> -			  IN const ib_link_record_t * p_lr,
> +void osm_dump_link_record(IN osm_log_t * const p_log,
> +			  IN const ib_link_record_t * const p_lr,
>  			  IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1495,8 +1499,8 @@ void osm_dump_link_record(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_switch_info(IN osm_log_t * p_log,
> -			  IN const ib_switch_info_t * p_si,
> +void osm_dump_switch_info(IN osm_log_t * const p_log,
> +			  IN const ib_switch_info_t * const p_si,
>  			  IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1530,8 +1534,8 @@ void osm_dump_switch_info(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_switch_info_record(IN osm_log_t * p_log,
> -				 IN const ib_switch_info_record_t * p_sir,
> +void osm_dump_switch_info_record(IN osm_log_t * const p_log,
> +				 IN const ib_switch_info_record_t * const p_sir,
>  				 IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1568,9 +1572,9 @@ void osm_dump_switch_info_record(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_pkey_block(IN osm_log_t * p_log, IN uint64_t port_guid,
> +void osm_dump_pkey_block(IN osm_log_t * const p_log, IN uint64_t port_guid,
>  			 IN uint16_t block_num, IN uint8_t port_num,
> -			 IN const ib_pkey_table_t * p_pkey_tbl,
> +			 IN const ib_pkey_table_t * const p_pkey_tbl,
>  			 IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1592,9 +1596,9 @@ void osm_dump_pkey_block(IN osm_log_t * p_log, IN uint64_t port_guid,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_slvl_map_table(IN osm_log_t * p_log, IN uint64_t port_guid,
> +void osm_dump_slvl_map_table(IN osm_log_t * const p_log, IN uint64_t port_guid,
>  			     IN uint8_t in_port_num, IN uint8_t out_port_num,
> -			     IN const ib_slvl_table_t * p_slvl_tbl,
> +			     IN const ib_slvl_table_t * const p_slvl_tbl,
>  			     IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1619,9 +1623,9 @@ void osm_dump_slvl_map_table(IN osm_log_t * p_log, IN uint64_t port_guid,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_vl_arb_table(IN osm_log_t * p_log, IN uint64_t port_guid,
> +void osm_dump_vl_arb_table(IN osm_log_t * const p_log, IN uint64_t port_guid,
>  			   IN uint8_t block_num, IN uint8_t port_num,
> -			   IN const ib_vl_arb_table_t * p_vla_tbl,
> +			   IN const ib_vl_arb_table_t * const p_vla_tbl,
>  			   IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1645,7 +1649,8 @@ void osm_dump_vl_arb_table(IN osm_log_t * p_log, IN uint64_t port_guid,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_sm_info(IN osm_log_t * p_log, IN const ib_sm_info_t * p_smi,
> +void osm_dump_sm_info(IN osm_log_t * const p_log,
> +		      IN const ib_sm_info_t * const p_smi,
>  		      IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1666,8 +1671,8 @@ void osm_dump_sm_info(IN osm_log_t * p_log, IN const ib_sm_info_t * p_smi,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_sm_info_record(IN osm_log_t * p_log,
> -			     IN const ib_sminfo_record_t * p_smir,
> +void osm_dump_sm_info_record(IN osm_log_t * const p_log,
> +			     IN const ib_sminfo_record_t * const p_smir,
>  			     IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1694,7 +1699,7 @@ void osm_dump_sm_info_record(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_notice(IN osm_log_t * p_log,
> +void osm_dump_notice(IN osm_log_t * const p_log,
>  		     IN const ib_mad_notice_attr_t * p_ntci,
>  		     IN const osm_log_level_t log_level)
>  {
> @@ -1716,7 +1721,7 @@ void osm_dump_notice(IN osm_log_t * p_log,
>  		case 67:
>  			sprintf(buff,
>  				"\t\t\t\tsrc_gid..................%s\n",
> -				inet_ntop(AF_INET6, p_ntci->data_details.
> +				inet_ntop(AF_INET6, (void*)p_ntci->data_details.
>  					  ntc_64_67.gid.raw, gid_str,
>  					  sizeof gid_str));
>  			break;
> @@ -1824,10 +1829,10 @@ void osm_dump_notice(IN osm_log_t * p_log,
>  					  qp1) & 0xffffff,
>  				cl_ntoh32(p_ntci->data_details.ntc_257_258.
>  					  qp2) & 0xffffff,
> -				inet_ntop(AF_INET6, p_ntci->data_details.
> +				inet_ntop(AF_INET6, (void*)p_ntci->data_details.
>  					  ntc_257_258.gid1.raw, gid_str,
>  					  sizeof gid_str),
> -				inet_ntop(AF_INET6, p_ntci->data_details.
> +				inet_ntop(AF_INET6, (void*)p_ntci->data_details.
>  					  ntc_257_258.gid2.raw, gid_str2,
>  					  sizeof gid_str2));
>  			break;
> @@ -1854,10 +1859,10 @@ void osm_dump_notice(IN osm_log_t * p_log,
>  				cl_ntoh32(p_ntci->data_details.ntc_259.
>  					  sl_qp1) & 0xffffff,
>  				cl_ntoh32(p_ntci->data_details.ntc_259.qp2),
> -				inet_ntop(AF_INET6, p_ntci->data_details.
> +				inet_ntop(AF_INET6, (void*)p_ntci->data_details.
>  					  ntc_259.gid1.raw, gid_str,
>  					  sizeof gid_str),
> -				inet_ntop(AF_INET6, p_ntci->data_details.
> +				inet_ntop(AF_INET6, (void*)p_ntci->data_details.
>  					  ntc_259.gid2.raw, gid_str2,
>  					  sizeof gid_str2),
>  				cl_ntoh16(p_ntci->data_details.ntc_259.sw_lid),
> @@ -1889,7 +1894,8 @@ void osm_dump_notice(IN osm_log_t * p_log,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_dr_smp(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
> +void osm_dump_dr_smp(IN osm_log_t * const p_log,
> +		     IN const ib_smp_t * const p_smp,
>  		     IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -1996,7 +2002,8 @@ void osm_dump_dr_smp(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_sa_mad(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_mad,
> +void osm_dump_sa_mad(IN osm_log_t * const p_log,
> +		     IN const ib_sa_mad_t * const p_mad,
>  		     IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -2059,7 +2066,8 @@ void osm_dump_sa_mad(IN osm_log_t * p_log, IN const ib_sa_mad_t * p_mad,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
> +void osm_dump_dr_path(IN osm_log_t * const p_log,
> +		      IN const osm_dr_path_t * const p_path,
>  		      IN const osm_log_level_t log_level)
>  {
>  	if (osm_log_is_active(p_log, log_level)) {
> @@ -2077,7 +2085,8 @@ void osm_dump_dr_path(IN osm_log_t * p_log, IN const osm_dr_path_t * p_path,
>  
>  /**********************************************************************
>   **********************************************************************/
> -void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
> +void osm_dump_smp_dr_path(IN osm_log_t * const p_log,
> +			  IN const ib_smp_t * const p_smp,
>  			  IN const osm_log_level_t log_level)
>  {
>  


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
