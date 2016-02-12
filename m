From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc] IB/mlx5: Fix RC transport send queue overhead
 computation
Date: Fri, 12 Feb 2016 16:19:58 +0200
Message-ID: <56BDEA0E.5090104@dev.mellanox.co.il>
References: <1455217797-15635-1-git-send-email-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455217797-15635-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Fix the RC QPs send queue overhead computation to take into account
> two additional segments in the WQE which are needed for registration
> operations.
>
> The ATOMIC and UMR segments can't coexist together, so chose maximum out
> of them.
>
> The commit 9e65dc371b5c ("IB/mlx5: Fix RC transport send queue overhead
> computation") was intended to update RC transport as commit messages
> states, but added the code to UC transport.
>
> Fixes: 9e65dc371b5c ("IB/mlx5: Fix RC transport send queue overhead computation")
> Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
