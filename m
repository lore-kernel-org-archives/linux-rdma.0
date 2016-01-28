From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-4.5-rc1 1/5] IB/mlx5: Add CREATE_CQ and CREATE_QP
 to uverbs_ex_cmd_mask
Date: Thu, 28 Jan 2016 17:30:19 +0200
Message-ID: <56AA340B.3020106@mellanox.com>
References: <1453979055-25285-1-git-send-email-matanb@mellanox.com>
 <1453979055-25285-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453979055-25285-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/28/2016 1:04 PM, Matan Barak wrote:
> The mlx5_ib supports the extended create_cq and create_qp user verbs.
> In the current mechanism, a vendor supporting an exteded uverb should
> set the appropriate bit in the uverbs_ex_cmd_mask field. There was a
> proposal [1] that lifts this requirement, however, this proposal
> hasn't been accepted yet. Adding the actual support by setting the
> required bits in order to support features like completion
> timestamping and cross-channel.
>
> [1]http://www.spinics.net/lists/linux-rdma/msg30019.html
>
> Fixes: 972ecb821379 ('IB/mlx5: Add create_cq extended command')
> Fixes: ddf9529be19c ('IB/core: Allow setting create flags in QP init
>                        attribute')
> Signed-off-by: Matan Barak<matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This change-log is going to stay in the kernel log forever... lets drop 
the email archive reference
out of the change-log and put it before the --- lines for ref while 
reviewing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
