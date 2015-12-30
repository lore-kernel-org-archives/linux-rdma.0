From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] IB/mlx4: Configure device to work in RoCEv2
Date: Wed, 30 Dec 2015 10:46:43 +0200
Message-ID: <568399F3.1090502@mellanox.com>
References: <1451395447-5198-1-git-send-email-matanb@mellanox.com>
 <1451395447-5198-4-git-send-email-matanb@mellanox.com>
 <56829AB0.3080805@mellanox.com> <56839469.3070508@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56839469.3070508-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/30/2015 10:23 AM, Matan Barak wrote:
>
> int mlx4_CONFIG_DEV_wrapper(struct mlx4_dev *dev, int slave,
>                             struct mlx4_vhcr *vhcr,
>                             struct mlx4_cmd_mailbox *inbox,
>                             struct mlx4_cmd_mailbox *outbox,
>                             struct mlx4_cmd_info *cmd)
> {
>         int err;
>         u8 get = vhcr->op_modifier;
>
>         if (get != 1)
>                 return -EPERM;
>
>         err = mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
>
>         return err;
> }
>
> Only "get" is permitted in multi-function setups.

good, thanks for clarifying this out.

>
> Anyway, mlx4_config_roce_v2_port is not called for these setups 
> because of this condition:
> if (mlx4_is_mfunc(dev)) {
>     dev->caps.flags &= ~MLX4_DEV_CAP_FLAG_SENSE_SUPPORT;
>     dev_cap->flags2 &= ~MLX4_DEV_CAP_FLAG2_ROCE_V1_V2;
>     mlx4_dbg(dev, "RoCE V2 is not supported when SR-IOV is enabled\n");
> } 

wrong again, you assume your Linux VF driver, but the VM can run other 
driver.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
