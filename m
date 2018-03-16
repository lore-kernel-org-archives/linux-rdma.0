From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [PATCH] IB/mlx5: Set the default active rate and width to QDR and
 4X
Date: Fri, 16 Mar 2018 10:59:34 -0400
Message-ID: <ec18ffec-d7af-9a52-2da3-d4abea23e1a0@dev.mellanox.co.il>
References: <20180316023713.30323-1-honli@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180316023713.30323-1-honli@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Honggang LI <honli@redhat.com>, dledford@redhat.com, jgg@ziepe.ca, matanb@mellanox.com, leonro@mellanox.com, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, noaos@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On 3/15/2018 10:37 PM, Honggang LI wrote:
> From: Honggang Li <honli@redhat.com>
> 
> commit f1b65df5a232 ("IB/mlx5: Add support for active_width and
> active_speed in RoCE"). Before this patch applied, the mlx5_ib
> driver set default active_width and active_speed to IB_WIDTH_4X
> and IB_SPEED_QDR.
> 
> When the RoCE port is down, the RoCE port did not negotiate the
> active width with remote side. The active width is zero. If run
> ibstat to require the port status, ibstat will panic as it read
> invalid width from sys file.
> 
> This patch restores the original behavior.
> 
> Fixes: f1b65df5a232 ("IB/mlx5: Add support for active_width and active_speed in RoCE").
> Signed-off-by: Honggang Li <honli@redhat.com>

Reviewed-by: Hal Rosenstock <hal@mellanox.com>

> ---
>  drivers/infiniband/hw/mlx5/main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index 033b6af90de9..a48e9730fab8 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -388,6 +388,9 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
>  	if (err)
>  		goto out;
>  
> +	props->active_width     = IB_WIDTH_4X;
> +	props->active_speed     = IB_SPEED_QDR;
> +
>  	translate_eth_proto_oper(eth_prot_oper, &props->active_speed,
>  				 &props->active_width);
>  
> 
