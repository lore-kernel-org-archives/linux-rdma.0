From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Add infrastructure  support for PortInfo
 IsMulticastPkeyTrapSuppressionSupported
Date: Tue, 13 Oct 2009 21:17:01 +0200
Message-ID: <20091013191701.GV13830@me>
References: <20091013181037.GA8839@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091013181037.GA8839-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 14:10 Tue 13 Oct     , Hal Rosenstock wrote:
> 
> Per published MgtWG errata RefID 4576
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Changes since v2:
> Changed ib_port_info_set_client_rereg similarly to ib_port_info_set_mcast_pkey_trap_suppress
> 
> Changes since v1:
> Don't reset reserved bits packed with subnet timeout
> 
> diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
> index aa566f7..79e5f53 100644
> --- a/opensm/include/iba/ib_types.h
> +++ b/opensm/include/iba/ib_types.h
> @@ -4431,7 +4431,7 @@ typedef struct _ib_port_info {
>  	ib_net16_t p_key_violations;
>  	ib_net16_t q_key_violations;
>  	uint8_t guid_cap;
> -	uint8_t subnet_timeout;	/* cli_rereg(1b), resrv(2b), timeout(5b) */
> +	uint8_t subnet_timeout;	/* cli_rereg(1b), mcast_pkey_trap_suppr(1b), resrv(1b), timeout(5b) */
>  	uint8_t resp_time_value;
>  	uint8_t error_threshold; /* local phy errors(4b), overrun errors(4b) */
>  	ib_net16_t max_credit_hint;
> @@ -5281,7 +5281,7 @@ ib_port_info_set_timeout(IN ib_port_info_t * const p_pi,
>  {
>  	CL_ASSERT(timeout <= 0x1F);
>  	p_pi->subnet_timeout =
> -	    (uint8_t) ((p_pi->subnet_timeout & 0x80) | (timeout & 0x1F));
> +	    (uint8_t) ((p_pi->subnet_timeout & 0xE0) | (timeout & 0x1F));
>  }
>  
>  /*
> @@ -5315,8 +5315,7 @@ ib_port_info_set_client_rereg(IN ib_port_info_t * const p_pi,
>  {
>  	CL_ASSERT(client_rereg <= 0x1);
>  	p_pi->subnet_timeout =
> -	    (uint8_t) ((p_pi->
> -			subnet_timeout & 0x1F) | ((client_rereg << 7) & 0x80));
> +	    (uint8_t) ((p_pi->subnet_timeout & 0x9F) | (client_rereg << 7));

I don't think that you wanted this - 0x9f will reset newly assigned bit.
Guess it should be:

+	    (uint8_t) (p_pi->subnet_timeout | (client_rereg << 7));

Reapplying...

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
