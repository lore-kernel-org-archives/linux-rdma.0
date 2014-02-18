From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v1 04/12] Target/sbc: don't return from sbc_check for
 non prot_sg
Date: Tue, 18 Feb 2014 11:55:49 -0800
Message-ID: <1392753349.28946.21.camel@haakon3.risingtidesystems.com>
References: <1392572297-5333-1-git-send-email-sagig@mellanox.com>
	 <1392572297-5333-5-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1392572297-5333-5-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Sun, 2014-02-16 at 19:38 +0200, Sagi Grimberg wrote:
> For transports which use generic new command these
> buffers have yet to be allocated. Instead check afterwards
> if command required prot buffers but none are provided.
> 
> Also this way, target may support protection information
> against legacy initiators (writes are inserted and reads
> are stripped).
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/target/target_core_sbc.c       |    3 ---
>  drivers/target/target_core_transport.c |   21 +++++++++++++++++----
>  2 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index dfeb1c2..3f12726 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -649,9 +649,6 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
>  {
>  	u8 protect = rwprotect(cdb);
>  
> -	if (!cmd->t_prot_sg || !cmd->t_prot_nents)
> -		return true;
> -
>  	switch (dev->dev_attrib.pi_prot_type) {
>  	case TARGET_DIF_TYPE3_PROT:
>  		cmd->reftag_seed = 0xffffffff;
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index f029bb7..3a5550a 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1365,6 +1365,13 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>  		target_put_sess_cmd(se_sess, se_cmd);
>  		return 0;
>  	}
> +
> +	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
> +	if (rc != 0) {
> +		transport_generic_request_failure(se_cmd, rc);
> +		return 0;
> +	}
> +
>  	/*
>  	 * Save pointers for SGLs containing protection information,
>  	 * if present.
> @@ -1374,11 +1381,17 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>  		se_cmd->t_prot_nents = sgl_prot_count;
>  	}
>  
> -	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
> -	if (rc != 0) {
> -		transport_generic_request_failure(se_cmd, rc);
> -		return 0;
> +	/*
> +	 * Fail if protection operation requiers protection
> +	 * information buffers but None are provided!
> +	 */
> +	if ((!se_cmd->t_prot_sg || !se_cmd->t_prot_nents) &&
> +	    (se_cmd->prot_op != TARGET_PROT_NORMAL)) {
> +		pr_err("ERROR: protection information was requested but "
> +		       "protection buffers weren't provided.\n");
> +		return -EINVAL;
>  	}

A failure here requires the call to transport_generic_request_failure()
to complete the request with CHECK_CONDITION status, and should return 0
following the failure case for target_setup_cmd_from_cdb() above..

--nab
