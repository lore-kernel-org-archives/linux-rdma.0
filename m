From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/6] Add RSS support in mlx4
Date: Thu, 14 Sep 2017 11:22:52 +0300
Message-ID: <14e4f18c-c140-a6ae-d815-df432c01ae27@dev.mellanox.co.il>
References: <1505220788-23849-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505220788-23849-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/12/2017 3:53 PM, Yishai Hadas wrote:
> This patch set from Guy Levi implements the RSS related verbs for ConnectX-3
> devices in the mlx4 provider.
> 
> The matching kernel part was already merged into 4.14.
> 
> PR was sent:
> https://github.com/linux-rdma/rdma-core/pull/218
> 
> Guy Levi (6):
>    mlx4: Add support for WQ control path related verbs
>    mlx4: Introduce the direct verb mlx4dv_set_ctx_attr
>    mlx4: Add support for WQ indirection table related verbs
>    mlx4: Add support for RSS QP
>    mlx4: Add WQ data path support
>    mlx4: Support WQ object type in direct verb mlx4dv_init_obj
> 
>   debian/ibverbs-providers.symbols     |   1 +
>   providers/mlx4/cq.c                  |   5 +-
>   providers/mlx4/libmlx4.map           |   1 +
>   providers/mlx4/man/mlx4dv_init_obj.3 |  20 +++
>   providers/mlx4/mlx4-abi.h            |  33 ++++
>   providers/mlx4/mlx4.c                |  42 +++++
>   providers/mlx4/mlx4.h                |  30 +++-
>   providers/mlx4/mlx4dv.h              |  32 +++-
>   providers/mlx4/qp.c                  |  34 +++-
>   providers/mlx4/verbs.c               | 339 ++++++++++++++++++++++++++++++++++-
>   10 files changed, 525 insertions(+), 12 deletions(-)
> 

Series was merged, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
