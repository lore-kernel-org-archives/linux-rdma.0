From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 09/28] mlx5: Fix gcc 6.4 uninitialized variable warning
Date: Wed, 14 Sep 2016 18:39:10 +0300
Message-ID: <0ba444b7-6af4-72f3-d3d6-c27b73421679@dev.mellanox.co.il>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-10-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473109698-31408-10-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/6/2016 12:07 AM, Jason Gunthorpe wrote:
> gcc 6.4 remarks:
>
> ../providers/mlx5/cq.c:647:10: warning: 'wc_byte_len' may be used uninitialized in this function [-Wmaybe-uninitialized]
>     err = mlx5_copy_to_send_wqe(mqp, wqe_ctr, cqe,
>            lazy ? wc_byte_len : wc->byte_len);
> The path is because handle_good_req_lazy does not set its wc_byte_len
> outputs under certain case conditions.

wc_byte_len defined as uint32_t uninitialized_var(wc_byte_len) to 
prevent this warning, isn't this macro applicable ?

> Perhaps it is possible that the hardware never produces a completion
> with opcodes and scatter flags that could trigger this,
It can't happen, no real functional issue.

> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  libmlx5/src/cq.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/libmlx5/src/cq.c b/libmlx5/src/cq.c
> index 88097037eea0..163205bddeb8 100644
> --- a/libmlx5/src/cq.c
> +++ b/libmlx5/src/cq.c
> @@ -235,7 +235,10 @@ static inline void handle_good_req_lazy(struct mlx5_cqe64 *cqe, uint32_t *pwc_by
>  		break;
>  	case MLX5_OPCODE_UMR:
>  		*umr_opcode = wq->wr_data[idx];
> +		*pwc_byte_len = 0;

This case is a data path flow, need to prevent adding non applicable code.

>  		break;
> +	default:
> +		*pwc_byte_len = 0;
>  	}
>  }
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
