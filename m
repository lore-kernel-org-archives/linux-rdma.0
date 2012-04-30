From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/src/ibccquery.c: Fix
 CACongestionSetting inputs
Date: Mon, 30 Apr 2012 15:24:03 -0700
Message-ID: <20120430152403.fc8be56d.weiny2@llnl.gov>
References: <1335476593.5973.178.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335476593.5973.178.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 26 Apr 2012 14:43:13 -0700
Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:

> Make inputs to CACongestionSetting more like MAD packet, allowing
> multiple SLs to be configured at one time.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Thanks applied,
Ira

> ---
>  man/ibccconfig.8 |    4 +-
>  src/ibccconfig.c |   61 ++++++++++++++++++++++++-----------------------------
>  2 files changed, 30 insertions(+), 35 deletions(-)
> 
> diff --git a/man/ibccconfig.8 b/man/ibccconfig.8
> index a0bea2d..38af5fd 100644
> --- a/man/ibccconfig.8
> +++ b/man/ibccconfig.8
> @@ -24,7 +24,7 @@ Current supported operations and their parameters:
>    CongestionKeyInfo (CK) <lid|guid> <cckey> <cckeyprotectbit> <cckeyleaseperiod> <cckeyviolations>
>    SwitchCongestionSetting (SS) <lid|guid> <controlmap> <victimmask> <creditmask> <threshold> <packetsize> <csthreshold> <csreturndelay> <markingrate>
>    SwitchPortCongestionSetting (SP) <lid|guid> <portnum> <valid> <control_type> <threshold> <packet_size> <cong_parm_marking_rate> 
> -  CACongestionSetting (CS) <lid|guid> <port_control> <control_map> <sl> <ccti_timer> <ccti_increase> <trigger_threshold> <ccti_min> 
> +  CACongestionSetting (CS) <lid|guid> <port_control> <control_map> <ccti_timer> <ccti_increase> <trigger_threshold> <ccti_min> 
>    CongestionControlTable (CT) <lid|guid> <cctilimit> <index> <cctentry> <cctentry> ...
>  
>  .TP
> @@ -75,7 +75,7 @@ attempted to be fulfilled, and will fail if it is not possible.
>  .PP
>  ibccconfig SwitchCongestionSetting 2 0x1F 0x1FFFFFFFFF 0x0 0xF 8 0 0:0 1    # Configure Switch Congestion Settings
>  .PP
> -ibccconfig CACongestionSetting 1 0 0x3 0 150 1 0 0          # Configure CA Congestion Settings
> +ibccconfig CACongestionSetting 1 0 0x3 150 1 0 0          # Configure CA Congestion Settings
>  .PP
>  ibccconfig CongestionControlTable 1 63 0 0:0 0:1 ...        # Configure first block of Congestion Control Table
>  .PP
> diff --git a/src/ibccconfig.c b/src/ibccconfig.c
> index c81b7fa..4ae5386 100644
> --- a/src/ibccconfig.c
> +++ b/src/ibccconfig.c
> @@ -80,7 +80,7 @@ static const match_rec_t match_tbl[] = {
>  	{"SwitchPortCongestionSetting", "SP", switch_port_congestion_setting, 1,
>  	 "<valid> <control_type> <threshold> <packet_size> <cong_parm_marking_rate>"},
>  	{"CACongestionSetting", "CS", ca_congestion_setting, 0,
> -	 "<port_control> <control_map> <sl> <ccti_timer> <ccti_increase> "
> +	 "<port_control> <control_map> <ccti_timer> <ccti_increase> "
>  	 "<trigger_threshold> <ccti_min>"},
>  	{"CongestionControlTable", "CT", congestion_control_table, 0,
>  	 "<cctilimit> <index> <cctentry> <cctentry> ..."},
> @@ -436,15 +436,14 @@ static char *ca_congestion_setting(ib_portid_t * dest, char **argv, int argc)
>  	uint8_t payload[IB_CC_DATA_SZ] = { 0 };
>  	uint32_t port_control;
>  	uint32_t control_map;
> -	uint32_t sl;
>  	uint32_t ccti_timer;
>  	uint32_t ccti_increase;
>  	uint32_t trigger_threshold;
>  	uint32_t ccti_min;
> -	uint8_t *ptr;
>  	char *errstr;
> +	int i;
>  
> -	if (argc != 7)
> +	if (argc != 6)
>  		return "invalid number of parameters for CACongestionSetting";
>  
>  	if ((errstr = parseint(argv[0], &port_control, 0)))
> @@ -453,29 +452,18 @@ static char *ca_congestion_setting(ib_portid_t * dest, char **argv, int argc)
>  	if ((errstr = parseint(argv[1], &control_map, 0)))
>  		return errstr;
>  
> -	if ((errstr = parseint(argv[2], &sl, 0)))
> -		return errstr;
> -			
> -	if ((errstr = parseint(argv[3], &ccti_timer, 0)))
> +	if ((errstr = parseint(argv[2], &ccti_timer, 0)))
>  		return errstr;
>  
> -	if ((errstr = parseint(argv[4], &ccti_increase, 0)))
> +	if ((errstr = parseint(argv[3], &ccti_increase, 0)))
>  		return errstr;
>  
> -	if ((errstr = parseint(argv[5], &trigger_threshold, 0)))
> +	if ((errstr = parseint(argv[4], &trigger_threshold, 0)))
>  		return errstr;
>  
> -	if ((errstr = parseint(argv[6], &ccti_min, 0)))
> +	if ((errstr = parseint(argv[5], &ccti_min, 0)))
>  		return errstr;
>  
> -	if (sl > 15)
> -		return "invalid SL specified";
> -
> -	/* We are modifying only 1 SL at a time, so get the current config */
> -	if (!cc_query_status_via(payload, dest, IB_CC_ATTR_CA_CONGESTION_SETTING,
> -				 0, 0, NULL, srcport, cckey))
> -		return "ca congestion setting query failed";
> -
>  	mad_encode_field(payload,
>  			 IB_CC_CA_CONGESTION_SETTING_PORT_CONTROL_F,
>  			 &port_control);
> @@ -484,23 +472,30 @@ static char *ca_congestion_setting(ib_portid_t * dest, char **argv, int argc)
>  			 IB_CC_CA_CONGESTION_SETTING_CONTROL_MAP_F,
>  			 &control_map);
>  
> -	ptr = payload + 2 + 2 + sl * 8;
> +	for (i = 0; i < 16; i++) {
> +		uint8_t *ptr;
>  
> -	mad_encode_field(ptr,
> -			 IB_CC_CA_CONGESTION_ENTRY_CCTI_TIMER_F,
> -			 &ccti_timer);
> +		if (!(control_map & (0x1 << i)))
> +			continue;
>  
> -	mad_encode_field(ptr,
> -			 IB_CC_CA_CONGESTION_ENTRY_CCTI_INCREASE_F,
> -			 &ccti_increase);
> +		ptr = payload + 2 + 2 + i * 8;
>  
> -	mad_encode_field(ptr,
> -			 IB_CC_CA_CONGESTION_ENTRY_TRIGGER_THRESHOLD_F,
> -			 &trigger_threshold);
> +		mad_encode_field(ptr,
> +				 IB_CC_CA_CONGESTION_ENTRY_CCTI_TIMER_F,
> +				 &ccti_timer);
>  
> -	mad_encode_field(ptr,
> -			 IB_CC_CA_CONGESTION_ENTRY_CCTI_MIN_F,
> -			 &ccti_min);
> +		mad_encode_field(ptr,
> +				 IB_CC_CA_CONGESTION_ENTRY_CCTI_INCREASE_F,
> +				 &ccti_increase);
> +
> +		mad_encode_field(ptr,
> +				 IB_CC_CA_CONGESTION_ENTRY_TRIGGER_THRESHOLD_F,
> +				 &trigger_threshold);
> +
> +		mad_encode_field(ptr,
> +				 IB_CC_CA_CONGESTION_ENTRY_CCTI_MIN_F,
> +				 &ccti_min);
> +	}
>  			 
>  	if (!cc_config_status_via(payload, rcv, dest, IB_CC_ATTR_CA_CONGESTION_SETTING,
>  				  0, 0, NULL, srcport, cckey))
> @@ -598,7 +593,7 @@ int main(int argc, char **argv)
>  	};
>  	const char *usage_examples[] = {
>  		"SwitchCongestionSetting 2 0x1F 0x1FFFFFFFFF 0x0 0xF 8 0 0:0 1\t# Configure Switch Congestion Settings",
> -		"CACongestionSetting 1 0 0x3 0 150 1 0 0\t\t# Configure CA Congestion Settings",
> +		"CACongestionSetting 1 0 0x3 150 1 0 0\t\t# Configure CA Congestion Settings",
>  		"CongestionControlTable 1 63 0 0:0 0:1 ...\t# Configure first block of Congestion Control Table",
>  		"CongestionControlTable 1 127 0 0:64 0:65 ...\t# Configure second block of Congestion Control Table",
>  		NULL
> -- 
> 1.7.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
