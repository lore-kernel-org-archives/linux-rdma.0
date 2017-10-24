From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibqueryerrors.c: Add support for additional counters in
 PortCountersExtended
Date: Tue, 24 Oct 2017 20:20:00 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E67D4459A@CRSMSX101.amr.corp.intel.com>
References: <2807E5FD2F6FDA4886F6618EAC48510E67D31C52@CRSMSX101.amr.corp.intel.com>
 <DB6PR0501MB2245E78D6118FE145C8141D8A87C0@DB6PR0501MB2245.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB6PR0501MB2245E78D6118FE145C8141D8A87C0-wTfl6qNNZ1OA0EDQtjEfCcDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)'" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> Hi Ira,
> 
> Users don't set thresholds for old/new counters, they just set thresholds and if
> new counters are supported then thresholds are checked against new counters
> and if only old counters are supported then thresholds are checked against old
> counters.

But you are not checking the same set of counters.

        IB_PC_EXT_ERR_SYM_F,                                                                                                                               
        IB_PC_EXT_LINK_RECOVERS_F,                                              
        IB_PC_EXT_LINK_DOWNED_F,                                                
        IB_PC_EXT_ERR_RCV_F,                                                    
        IB_PC_EXT_ERR_PHYSRCV_F,                                                
        IB_PC_EXT_ERR_SWITCH_REL_F,                                             
        IB_PC_EXT_XMT_DISCARDS_F,                                               
        IB_PC_EXT_ERR_XMTCONSTR_F,                                              
        IB_PC_EXT_ERR_RCVCONSTR_F,                                              
        IB_PC_EXT_ERR_LOCALINTEG_F,                                             
        IB_PC_EXT_ERR_EXCESS_OVR_F,                                             
        IB_PC_EXT_VL15_DROPPED_F,                                               
        IB_PC_EXT_XMT_WAIT_F,                                                   
        IB_PC_EXT_QP1_DROP_F,                                                   
        IB_PC_EXT_ERR_LAST_F,                                                   


VS.

        /*                                                                      
         * GS Performance                                                       
         */                                                                     
        IB_PC_FIRST_F,                                                          
        IB_PC_PORT_SELECT_F = IB_PC_FIRST_F,                                    
        IB_PC_COUNTER_SELECT_F,                                                 
        IB_PC_ERR_SYM_F,                                                        
        IB_PC_LINK_RECOVERS_F,                                                  
        IB_PC_LINK_DOWNED_F,                                                    
        IB_PC_ERR_RCV_F,                                                        
        IB_PC_ERR_PHYSRCV_F,                                                    
        IB_PC_ERR_SWITCH_REL_F,                                                 
        IB_PC_XMT_DISCARDS_F,                                                   
        IB_PC_ERR_XMTCONSTR_F,                                                  
        IB_PC_ERR_RCVCONSTR_F,                                                  
        IB_PC_COUNTER_SELECT2_F,                                                
        IB_PC_ERR_LOCALINTEG_F,                                                 
        IB_PC_ERR_EXCESS_OVR_F,                                                 
        IB_PC_VL15_DROPPED_F,                                                   
        IB_PC_XMT_BYTES_F,                                                      
        IB_PC_RCV_BYTES_F,                                                      
        IB_PC_XMT_PKTS_F,                                                       
        IB_PC_RCV_PKTS_F,                                                       
        IB_PC_XMT_WAIT_F,                                                       
        IB_PC_LAST_F,                                                           

For example you no longer can specify IB_PC_XMT_BYTES_F.

As I don't think anyone uses these thresholds for this counter I'm going to let the patch go.  But generally this probably should be cleaned up somehow.  I just don't have the time as I am sure you don't...  ;-)

Ira


> 
> -----Original Message-----
> From: Weiny, Ira [mailto:ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
> Sent: Saturday, September 30, 2017 4:42 AM
> To: 'Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>; Oded
> Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: RE: ibqueryerrors.c: Add support for additional counters in
> PortCountersExtended
> 
> Hal, Oded,
> 
> I have lost the original email from this submission but got it off of patchwork.
> 
> Question on the hunk below.
> 
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 304dc154c4b4..4ea762a1f344 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -105,15 +105,15 @@ static unsigned valid_gid(ib_gid_t * gid)
>         return memcmp(&zero_gid, gid, sizeof(*gid));
>  }
> 
> -static void set_thres(char *name, uint32_t val)
> +static void set_thres(char *name, uint64_t val)
>  {
>         int f;
>         int n;
>         char tmp[256];
> -       for (f = IB_PC_FIRST_F; f <= IB_PC_LAST_F; f++) {
> +       for (f = IB_PC_EXT_ERR_SYM_F; f <= IB_PC_EXT_XMT_WAIT_F; f++) {
> 
> How does this change allow for users to set the old Port Counters thresholds?
> 
> Ira
> 
> 
>                 if (strcmp(name, mad_field_name(f)) == 0) {
>                         mad_encode_field(thresholds, f, &val);
> -                       snprintf(tmp, 255, "[%s = %u]", name, val);
> +                       snprintf(tmp, 255, "[%s = %lu]", name, val);
>                         threshold_str = realloc(threshold_str,
>                                         strlen(threshold_str)+strlen(tmp)+1);
>                         if (!threshold_str) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
