From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/3] iser-target: Fix error path in isert_create_pi_ctx()
Date: Sun, 31 May 2015 15:54:01 +0300
Message-ID: <556B0469.4080501@dev.mellanox.co.il>
References: <1432966330-12230-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432966330-12230-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Doug Ledford <dledford@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/30/2015 9:12 AM, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
>
> We don't assign pi_ctx to desc->pi_ctx until we're certain to succeed
> in the function.  That means the cleanup path should use the local
> pi_ctx variable, not desc->pi_ctx.
>
> This was detected by Coverity (CID 1260062).
>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 327529ee85eb..3f40319a55da 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -547,11 +547,11 @@ isert_create_pi_ctx(struct fast_reg_descriptor *desc,
>   	return 0;
>
>   err_prot_mr:
> -	ib_dereg_mr(desc->pi_ctx->prot_mr);
> +	ib_dereg_mr(pi_ctx->prot_mr);
>   err_prot_frpl:
> -	ib_free_fast_reg_page_list(desc->pi_ctx->prot_frpl);
> +	ib_free_fast_reg_page_list(pi_ctx->prot_frpl);
>   err_pi_ctx:
> -	kfree(desc->pi_ctx);
> +	kfree(pi_ctx);
>
>   	return ret;
>   }
>

Acked-by: Sagi Grimberg <sagig@mellanox.com>
