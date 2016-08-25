From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libmlx5] Add TSO support for RAW Ethernet QP
Date: Thu, 25 Aug 2016 18:41:48 +0300
Message-ID: <affefccb-5fdb-7dbc-17f1-f81ba75c5594@dev.mellanox.co.il>
References: <1469710139-17063-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469710139-17063-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/28/2016 3:48 PM, Yishai Hadas wrote:
> From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> When sending TCP packets over RAW Ethernet QP with ibv_post_send, user
> has the option to set IBV_WR_TSO flag to enable large segment offload.
> The TSO header, header size and maximum segment size must be specified by
> the user through ibv_send_wr.
>
> Eligible hardware will break down large chunk of data into smaller
> segments per user setup. Error will be returned if TSO is not supported,
> or the size of chunk is too large for hardware to handle.
>
> Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> ---
>  src/cq.c       |   5 +++
>  src/mlx5-abi.h |   7 ++--
>  src/mlx5.c     |  13 +++++---
>  src/mlx5.h     |  10 +++++-
>  src/qp.c       | 103 +++++++++++++++++++++++++++++++++++++++++++++++++--------
>  src/verbs.c    |  49 ++++++++++++++++++++-------
>  src/wqe.h      |   1 +
>  7 files changed, 156 insertions(+), 32 deletions(-)
>

Applied.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
