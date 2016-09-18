From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libmlx5 0/3] RoCE V2 support for UD traffic
Date: Sun, 18 Sep 2016 14:17:39 +0300
Message-ID: <e441db25-e5ea-c798-aa43-f42051781f07@dev.mellanox.co.il>
References: <1472577420-8592-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472577420-8592-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/30/2016 8:16 PM, Yishai Hadas wrote:
> This patch set from Noa comes with few changes to enable
> libmlx5 driver to work properly with RoCE V2 UD traffic.
>
> The first 2 patches are some pre bug fixes, the third patch uses
> the new helper function introduced by libibverbs series to detect
> RoCE V2 and work accordingly.
>
> Noa Osherovich (3):
>   Verify correctness of RoCE UD packets
>   Avoid setting Infiniband-only fields when link layer is Ethernet
>   Add support for RoCE v2 UD traffic
>
>  src/mlx5.h  |  3 ++-
>  src/verbs.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 54 insertions(+), 5 deletions(-)
>

Series applied.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
