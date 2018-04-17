From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH 1/1] net/mlx4_core: avoid resetting HCA when accessing an
 offline device
Date: Tue, 17 Apr 2018 18:37:06 +0300
Message-ID: <6dd17e45-e27e-8451-42ab-1a4551d3a651@mellanox.com>
References: <1523840527-22746-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1523840527-22746-1-git-send-email-yanjun.zhu@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Zhu Yanjun <yanjun.zhu@oracle.com>, tariqt@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, haakon.bugge@oracle.com
List-Id: linux-rdma@vger.kernel.org



On 16/04/2018 4:02 AM, Zhu Yanjun wrote:
> While a faulty cable is used or HCA firmware error, HCA device will
> be offline. When the driver is accessing this offline device, the
> following call trace will pop out.
> 
> "
> ...
>    [<ffffffff816e4842>] dump_stack+0x63/0x81
>    [<ffffffff816e459e>] panic+0xcc/0x21b
>    [<ffffffffa03e5f8a>] mlx4_enter_error_state+0xba/0xf0 [mlx4_core]
>    [<ffffffffa03e7298>] mlx4_cmd_reset_flow+0x38/0x60 [mlx4_core]
>    [<ffffffffa03e7381>] mlx4_cmd_poll+0xc1/0x2e0 [mlx4_core]
>    [<ffffffffa03e9f00>] __mlx4_cmd+0xb0/0x160 [mlx4_core]
>    [<ffffffffa0406934>] mlx4_SENSE_PORT+0x54/0xd0 [mlx4_core]
>    [<ffffffffa03f5f54>] mlx4_dev_cap+0x4a4/0xb50 [mlx4_core]
> ...
> "
> In the above call trace, the function mlx4_cmd_poll calls the function
> mlx4_cmd_post to access the HCA while HCA is offline. Then mlx4_cmd_post
> returns an error -EIO. Per -EIO, the function mlx4_cmd_poll calls
> mlx4_cmd_reset_flow to reset HCA. And the above call trace pops out.
> 
> This is not reasonable. Since HCA device is offline when it is being
> accessed, it should not be reset again.
> 
> In this patch, since HCA is offline, the function mlx4_cmd_post returns
> an error -EINVAL. Per -EINVAL, the function mlx4_cmd_poll directly returns
> instead of resetting HCA.
> 
> CC: Srinivas Eeda <srinivas.eeda@oracle.com>
> CC: Junxiao Bi <junxiao.bi@oracle.com>
> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/cmd.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
> index 6a9086d..f1c8c42 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
> @@ -451,6 +451,8 @@ static int mlx4_cmd_post(struct mlx4_dev *dev, u64 in_param, u64 out_param,
>   		 * Device is going through error recovery
>   		 * and cannot accept commands.
>   		 */
> +		mlx4_err(dev, "%s : Device is in error recovery.\n", __func__);
> +		ret = -EINVAL;
>   		goto out;
>   	}
>   
> @@ -657,6 +659,9 @@ static int mlx4_cmd_poll(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
>   	}
>   
>   out_reset:
> +	if (err == -EINVAL)
> +		goto out;
> +

See below.

>   	if (err)
>   		err = mlx4_cmd_reset_flow(dev, op, op_modifier, err);
>   out:
> @@ -766,6 +771,9 @@ static int mlx4_cmd_wait(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
>   		*out_param = context->out_param;
>   
>   out_reset:
> +	if (err == -EINVAL)
> +		goto out;
> +
>   	if (err)

Instead, just do here: if (err && err != -EINVAL)

>   		err = mlx4_cmd_reset_flow(dev, op, op_modifier, err);
>   out:
> 

I am not sure this does not mistakenly cover other cases that already 
exist and have (err == -EINVAL).

For example, this line is hard to predict:
err = mlx4_status_to_errno
and later on, we might get into
if (mlx4_closing_cmd_fatal_error(op, stat))
which leads to out_reset.

We must have a deeper look at this.
But a better option is, change the error indication to uniquely indicate 
"already in error recovery".
