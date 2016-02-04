From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [v1] libmlx5: Add support for RAW_ETH TX/RX checksum offload
Date: Thu, 4 Feb 2016 18:15:34 +0200
Message-ID: <56B37926.1070204@dev.mellanox.co.il>
References: <1454519132-46636-1-git-send-email-bodong@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454519132-46636-1-git-send-email-bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzXQFizaE/u3fw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/3/2016 7:05 PM, Bodong Wang wrote:
> RX checksum verification status is reported through wc_flag when polling
> CQ. When IBV_WC_IP_CSUM_OK is set, that means both IPv4 header checksum and
> TCP/UDP checksum are OK.
>
> TX checksum offload will be enabled for TCP/UDP over IPv4 if user sets
> send_flag IBV_SEND_IP_CSUM.
>
> A new field, qp_cap_cache, is added to mlx5_qp in order to 'cache'
> the csum capabilities to minimize perfromance hit on poll_one
> function. The device and port capabilities are cached inside
> mlx5_init_context.
>
> Change-Id: I4d26f43027c08e7142e77a977744e2abe08a6e58
> Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   src/cq.c    | 31 ++++++++++++++++++++++++++++---
>   src/mlx5.c  | 12 ++++++++++++
>   src/mlx5.h  | 16 ++++++++++++++++
>   src/qp.c    | 10 ++++++++++
>   src/verbs.c | 16 ++++++++++++++++
>   src/wqe.h   |  5 +++++
>   6 files changed, 87 insertions(+), 3 deletions(-)
>

Applied.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
