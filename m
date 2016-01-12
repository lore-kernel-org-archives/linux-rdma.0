From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Reduce mlx5_ib_wq cacheline bouncing
Date: Tue, 12 Jan 2016 14:16:42 +0200
Message-ID: <5694EEAA.3050600@mellanox.com>
References: <1452594732-9573-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452594732-9573-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/12/2016 12:32 PM, Sagi Grimberg wrote:
> mlx5 keeps a lot of internal accounting for wr processing.
> mlx5_ib_wq consists of multiple arrays:
> struct mlx5_ib_wq {
> 	u64		       *wrid;
> 	u32		       *wr_data;
> 	struct wr_list	       *w_list;
> 	unsigned	       *wqe_head;
> 	...
> }
>
> Each time we access each of these arrays, even for a single index
> we fetch a cacheline. Reduce cacheline bounces by fitting these members
> in a cacheline aligned struct (swr_ctx) and allocate an array. Accessing
> this array will fetch all of these members in a single shot.
>
> Since the receive queue needs only the wrid we use a nameless union
> where in the rwr_ctx we only have wrid member.

Have some performance numbers before/after this patch to support the 
proposed change?

Also, I have asked you the same question re the iser remote invalidation 
series [1], this datais needed there too.

Or.

[1] http://marc.info/?l=linux-rdma&m=145188949807652&w=2

--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -129,11 +129,24 @@ struct wr_list {
  	u16	next;
  };
  
+/* Please don't let this exceed a single cacheline */
+struct swr_ctx {
+	u64		wrid;
+	u32		wr_data;
+	struct wr_list	w_list;
+	u32		wqe_head;
+	u8		rsvd[12];
+}__packed;


what the role of the reserved field, is that for alignment purposes? if 
yes, maybe better namewould be "align"

Nit, (same) checkpatch error here and below

ERROR: space required after that close brace '}'
#111: FILE: drivers/infiniband/hw/mlx5/mlx5_ib.h:139:
+}__packed;

> +
> +struct rwr_ctx {
> +	u64		       wrid;
> +}__packed;
> +

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
