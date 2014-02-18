From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH v1 01/12] Target/transport: Allocate protection sg if
 needed
Date: Tue, 18 Feb 2014 11:49:39 -0800
Message-ID: <1392752979.28946.15.camel@haakon3.risingtidesystems.com>
References: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
	 <1392572297-5333-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392572297-5333-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2014-02-16 at 19:38 +0200, Sagi Grimberg wrote:
> In case protection information is involved, allocate
> protection SG-list for transport.
> 
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/target/target_core_transport.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 24b4f65..f029bb7 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2036,6 +2036,10 @@ static inline void transport_free_pages(struct se_cmd *cmd)
>  	transport_free_sgl(cmd->t_bidi_data_sg, cmd->t_bidi_data_nents);
>  	cmd->t_bidi_data_sg = NULL;
>  	cmd->t_bidi_data_nents = 0;
> +
> +	transport_free_sgl(cmd->t_prot_sg, cmd->t_prot_nents);
> +	cmd->t_prot_sg = NULL;
> +	cmd->t_prot_nents = 0;
>  }
>  
>  /**
> @@ -2199,6 +2203,14 @@ transport_generic_new_cmd(struct se_cmd *cmd)
>  				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  		}
>  
> +		if (cmd->prot_type != TARGET_PROT_NORMAL) {
> +			ret = target_alloc_sgl(&cmd->t_prot_sg,
> +					       &cmd->t_prot_nents,
> +					       cmd->prot_length, zero_flag);
> +			if (ret < 0)
> +				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +		}
> +
>  		ret = target_alloc_sgl(&cmd->t_data_sg, &cmd->t_data_nents,
>  				       cmd->data_length, zero_flag);
>  		if (ret < 0)

So the 'zero_flag' for the t_prot_sg allocation should always be true to
avoid garbage in the app-tag field..

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
