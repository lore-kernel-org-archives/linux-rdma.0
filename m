From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 8/8] IB/mlx5: Add helper mlx5_ib_post_send_wait
Date: Tue, 25 Oct 2016 14:23:43 +0200
Message-ID: <5098701.SVmQeRIiho@wuerfel>
References: <1477396919-27669-1-git-send-email-binoy.jayan@linaro.org> <1477396919-27669-9-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477396919-27669-9-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tuesday, October 25, 2016 5:31:59 PM CEST Binoy Jayan wrote:
> Clean up common code (to post a list of work requests to the send queue of
> the specified QP) at various places and add a helper function
> 'mlx5_ib_post_send_wait' to implement the same. The counting semaphore
> 'umr_common:sem' is also moved into the helper. This may later be modified
> to replace the semaphore with an alternative.
> 
> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>

Looks reasonable.

> ---
>  drivers/infiniband/hw/mlx5/mr.c | 96 +++++++++++++----------------------------
>  1 file changed, 29 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> index d4ad672..261984b 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -856,16 +856,38 @@ static inline void mlx5_ib_init_umr_context(struct mlx5_ib_umr_context *context)
>  	init_completion(&context->done);
>  }
>  
> +static inline int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
> +					 struct mlx5_ib_umr_context *umr_context,
> +					 struct mlx5_umr_wr *umrwr)
> +{
> +	struct umr_common *umrc = &dev->umrc;
> +	struct ib_send_wr __maybe_unused *bad;

Did you get a warning about 'bad' being unused here? I would have
guessed not, since the original code was not that different and
it does get passed into a function.

Why not move the umr_context variable into this function too?
The only thing we ever seem to do to is initialize it and
assign the wr_cqe pointer, both of which can be done here.

	Arnd
