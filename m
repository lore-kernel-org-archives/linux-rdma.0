From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 8/8] opensm: Ensure sweep interval/mkey lease are
 sensibly set
Date: Tue, 24 Jul 2012 12:01:30 +0300
Message-ID: <20120724090130.GA2413@calypso>
References: <1340672058.5218.97.camel@auk75.llnl.gov>
 <1340672104-18039-1-git-send-email-foraker1@llnl.gov>
 <1340672104-18039-8-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1340672104-18039-8-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, weiny2-i2BcT+NCU+M@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Jim,

On 17:55 Mon 25 Jun     , Jim Foraker wrote:
> If mkeys are protected, sweep should always be enabled and
> set to an interval < the lease timeout, to ensure a missed trap
> doesn't lead to mkey exposure.

This is a minimal requirement, but it might not be enough to avoid mkey
exposure completely. In noisy fabrics, sweep duration may take more
time than sweep interval (and lease timeout), so theoretically we can still
get mkey exposure. However, I don't know how can we completely avoid this.

> 
> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> ---
>  opensm/osm_subnet.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
> index ddee955..3f336d8 100644
> --- a/opensm/osm_subnet.c
> +++ b/opensm/osm_subnet.c
> @@ -1502,6 +1502,26 @@ int osm_subn_verify_config(IN osm_subn_opt_t * p_opts)
>  			   "instead\n", p_opts->m_key_protect_bits, 2);
>  		p_opts->m_key_protect_bits = 2;
>  	}
> +	if (p_opts->m_key_protect_bits && p_opts->m_key_lease_period) {
> +		if (!p_opts->sweep_interval) {
> +			log_report(" Sweep disabled with protected mkey "
> +				   "leases in effect; re-enabling sweeping "
> +				   "with interval %u\n",
> +				   cl_ntoh16(p_opts->m_key_lease_period) - 1);
> +			p_opts->sweep_interval =
> +				cl_ntoh16(p_opts->m_key_lease_period) - 1;
> +		}
> +		if (p_opts->sweep_interval >=
> +			cl_ntoh16(p_opts->m_key_lease_period)) {
> +			log_report(" Sweep interval %u >= mkey lease period "
> +				   "%u. Setting lease period to %u\n",
> +				   p_opts->sweep_interval,
> +				   cl_ntoh16(p_opts->m_key_lease_period),
> +				   p_opts->sweep_interval + 1);
> +			p_opts->m_key_lease_period =
> +				cl_hton16(p_opts->sweep_interval + 1);
> +		}
> +	}
>  
>  	if (p_opts->root_guid_file != NULL) {
>  		FILE *root_file = fopen(p_opts->root_guid_file, "r");
> -- 
> 1.7.9.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
