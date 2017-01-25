From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/8] mlx4: Add inline functions to read
 completion's attributes
Date: Wed, 25 Jan 2017 10:09:50 -0700
Message-ID: <20170125170950.GD16579@obsidianresearch.com>
References: <1485355791-27646-1-git-send-email-yishaih@mellanox.com>
 <1485355791-27646-5-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485355791-27646-5-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 25, 2017 at 04:49:47PM +0200, Yishai Hadas wrote:
> From: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add inline functions in order to read various completion's
> attributes. These functions will be assigned in the ibv_cq_ex
> structure in order to allow the user to read the completion's
> attributes.
> 
> Signed-off-by: Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  providers/mlx4/cq.c   | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  providers/mlx4/mlx4.h |  13 +++--
>  2 files changed, 157 insertions(+), 3 deletions(-)
> 
> diff --git a/providers/mlx4/cq.c b/providers/mlx4/cq.c
> index 6c4b3c4..a80b2fb 100644
> +++ b/providers/mlx4/cq.c
> @@ -416,6 +416,153 @@ int mlx4_poll_cq(struct ibv_cq *ibcq, int ne, struct ibv_wc *wc)
>  	return err == CQ_POLL_ERR ? err : npolled;
>  }
>  
> +static inline enum ibv_wc_opcode mlx4_cq_read_wc_opcode(struct ibv_cq_ex *ibcq)
> +{

Why are these inline?

At the end of the series the only user of this function is here:

+	cq->ibv_cq.read_opcode = mlx4_cq_read_wc_opcode;

Which is using it as a function pointer, so it cannot be inlined.

Drop all the unncessary 'static inline', they are confusing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
