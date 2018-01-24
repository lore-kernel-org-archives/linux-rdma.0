From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/4] Introduce IBV_QPT_DRIVER for mlx5 DC
Date: Wed, 24 Jan 2018 14:33:53 +0200
Message-ID: <18fb144e-5de1-d49d-4fae-3febf309e8fb@dev.mellanox.co.il>
References: <1516551419-12829-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516551419-12829-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/21/2018 6:16 PM, Yishai Hadas wrote:
> This series from Moni is the supplementary part of the kernel series that was
> accepted for 4.16.
> 
> In General:
> Vendors can implement types of QPs that are not described in the InfiniBand
> specification. The verbs layer doesn't know which services this QP provides but
> it assumes that the hardware driver does. The new QP type IBV_QPT_DRIVER
> should be used for this kind of QP. Any extra data that describes this QP
> should be stored in a context in the hardware driver that is associated with
> this QP.
> 
> The Dynamically Connected (DC) Transport Service provides a datagram-like
> model that allows a DC QP to target multiple remote processes in multiple
> remote nodes. As far as reachability is concerned, the DC model is somewhat
> similar to the Unreliable Datagram (UD) model in the sense that each WR
> submitted to the DC SQ carries the information that identifies the remote
> destination.
> 
> The patches in this series add the DC support to the mlx5 driver by using the
> IBV_QPT_DRIVER and some extensions in the mlx5 DV path to create a QP.
> 
> PR was sent:
> https://github.com/linux-rdma/rdma-core/pull/285
> 
> Note:
> The error in GITHUB looks as some environment issue in Travis.
> 
> Changes from V0:
> - Refactor the mlx5 code around the DCT usage.
> 
> Yishai
> 
> 
> Moni Shoua (4):
>    verbs: Introduce driver QP type
>    mlx5: Add interface to create DC transport QPs
>    mlx5: Create DC transport QPs
>    mlx5: Destroy and modify a DC target QP
> 
>   libibverbs/man/ibv_create_qp.3    |   5 +-
>   libibverbs/man/ibv_create_qp_ex.3 |   5 +-
>   libibverbs/verbs.h                |   3 +-
>   providers/mlx5/mlx5-abi.h         |  24 +++++-
>   providers/mlx5/mlx5.h             |   1 +
>   providers/mlx5/mlx5dv.h           |  12 +++
>   providers/mlx5/verbs.c            | 171 ++++++++++++++++++++++++++++++++++++--
>   7 files changed, 209 insertions(+), 12 deletions(-)
> 

The series was merged, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
