From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 1/4] IB/mlx5: Add create_cq extended command
Date: Mon, 9 Nov 2015 16:24:00 -0700
Message-ID: <20151109232400.GC20707@obsidianresearch.com>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
 <1447086657-15358-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447086657-15358-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2015 at 06:30:54PM +0200, Matan Barak wrote:
> @@ -1385,7 +1385,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
>  		(1ull << IB_USER_VERBS_CMD_CREATE_XSRQ)		|
>  		(1ull << IB_USER_VERBS_CMD_OPEN_QP);
>  	dev->ib_dev.uverbs_ex_cmd_mask =
> -		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE);
> +		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE)	|
> +		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ);

Eli posted a series that gets rid of this stuff, can you please
coordinate?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
