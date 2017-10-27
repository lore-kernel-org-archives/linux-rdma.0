From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH] IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Thu, 26 Oct 2017 20:33:39 -0400
Message-ID: <70843f43-03c5-8295-643a-4f228ff2e907@intel.com>
References: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 10/26/2017 12:12 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 26 Oct 2017 17:54:15 +0200
> 
> Add a jump target so that a bit of exception handling can be better reused
> at the end of this function.

I'm not sure this is that big of a win. I mean you aren't really making 
the code any smaller and it's not making it any easier to read really.

> This issue was detected by using the Coccinelle software.

Assuming there was no testing done for this?

> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>   drivers/infiniband/hw/mlx4/main.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> index c636842c5be0..4a598c48ea1c 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -1691,8 +1691,8 @@ static int __mlx4_ib_create_flow(struct ib_qp *qp, struct ib_flow_attr *flow_att
>   				mdev, qp, default_table + default_flow,
>   				mailbox->buf + size);
>   		if (ret < 0) {
> -			mlx4_free_cmd_mailbox(mdev->dev, mailbox);
> -			return -EINVAL;
> +			ret = -EINVAL;
> +			goto free_mailbox;

This might be a good opportunity to bubble up the return value rather 
than just blindly returning -EINVAL. That's really a question for 
Mellanox though.

-Denny
