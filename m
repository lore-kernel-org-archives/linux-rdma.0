From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCHv2 1/1] net/mlx4_core: avoid resetting HCA when accessing
 an offline device
Date: Thu, 10 May 2018 17:24:56 +0300
Message-ID: <4307774e-9dff-50a2-b83e-117f620cdcac@mellanox.com>
References: <1524058303-379-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1524058303-379-1-git-send-email-yanjun.zhu@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Zhu Yanjun <yanjun.zhu@oracle.com>, tariqt@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 18/04/2018 4:31 PM, Zhu Yanjun wrote:
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
> Suggested-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
> V1->V2: Follow Tariq's advice, avoid the disturbance from other returned errors.
> Since the returned values from the function mlx4_cmd_post are -EIO and -EINVAL,
> to -EIO, the HCA device should be reset. To -EINVAL, that means that the function
> mlx4_cmd_post is accessing an offline device. It is not necessary to reset HCA.
> Go to label out directly.
> ---
>   drivers/net/ethernet/mellanox/mlx4/cmd.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@mellanox.com>

Thanks Zhu.
