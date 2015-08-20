From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Thu, 20 Aug 2015 11:52:35 +0300
Message-ID: <55D59553.4080306@dev.mellanox.co.il>
References: <1440002254-795-1-git-send-email-hch@lst.de>
 <1440002254-795-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1440002254-795-2-git-send-email-hch@lst.de>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Eli Cohen <eli@mellanox.com>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 8/19/2015 7:37 PM, Christoph Hellwig wrote:
> We have many WR opcodes that are only supported in kernel space
> and/or require optional information to be copied into the WR
> structure.  Reject all those not explicitly handled so that we
> can't pass invalid information to drivers.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/infiniband/core/uverbs_cmd.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index a15318a..f9f3921 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2372,6 +2372,12 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
>   		next->send_flags = user_wr->send_flags;
>
>   		if (is_ud) {
> +			if (next->opcode != IB_WR_SEND &&
> +			    next->opcode != IB_WR_SEND_WITH_IMM) {
> +				ret = -EINVAL;
> +				goto out_put;
> +			}
> +
>   			next->wr.ud.ah = idr_read_ah(user_wr->wr.ud.ah,
>   						     file->ucontext);
>   			if (!next->wr.ud.ah) {
> @@ -2413,7 +2419,8 @@ ssize_t ib_uverbs_post_send(struct ib_uverbs_file *file,
>   				next->wr.atomic.rkey = user_wr->wr.atomic.rkey;
>   				break;
>   			default:
> -				break;
> +				ret = -EINVAL;
> +				goto out_put;
>   			}
>   		}
>
>

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

Haggai, can you also have a look?
