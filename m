From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Wed, 25 May 2016 11:26:24 -0600
Message-ID: <20160525172624.GA4602@obsidianresearch.com>
References: <1464181344-11987-1-git-send-email-yishaih@mellanox.com>
 <1464181344-11987-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464181344-11987-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 25, 2016 at 04:02:19PM +0300, Yishai Hadas wrote:

>  struct ibv_cq_ex {
>  	struct ibv_context     *context;
>  	struct ibv_comp_channel *channel;
> @@ -869,6 +873,23 @@ struct ibv_cq_ex {
>  	uint32_t		async_events_completed;
>  
>  	uint32_t		comp_mask;

I'd also suggest looking at the cacheline layout of this structure,
grouping related things together to minimize the foot print.

I also think this is not enough to deal with future extention needs.

This:

+       struct ibv_cq_ex *(*create_cq_ex)(struct ibv_context *context,
+                                         struct ibv_cq_init_attr_ex *init_attr);

Should take sizeof(ibv_cq_ex) as an argument and allocate and zero at least
enough memory to cover the caller's struct size. Have the
ibv_create_cq_ex inline do this

This ensures if we add new function pointers to the end then they are
null'd even if libibverbs is older, which is a little safer than
overflowing memory.

This stuff:

+struct ibv_cq_init_attr_ex {
+       /* Minimum number of entries required for CQ */
+       int                     cqe;

And other similar should use 'unsigned int' for values that cannot be negative.

These two don't seem well thought out:

+enum ibv_create_cq_wc_flags {
+       IBV_WC_EX_WITH_BYTE_LEN         = 1 << 0,
+       IBV_WC_EX_WITH_IMM              = 1 << 1,

+enum {
+       IBV_WC_STANDARD_FLAGS = IBV_WC_EX_WITH_BYTE_LEN         |


Eg RC QP's do not have several of those fields.

I expect that if the caller asks for (eg) IBV_WC_EX_WITH_SLID then it
must be available. This means it is an error to ask for it on QPs that
do not deliver that value, like RC.

Thus IBV_WC_STANDARD_FLAGS is misnamed and/or useless.

You need to do a full audit of all the QP types and which fields they
can return and rethink these constants. Ensure the core code and/or
driver properly enforces the flags.

The driver should also null fields accessor function pointers that it
cannot return.

> +	uint16_t (*read_slid)(struct ibv_cq_ex *current);

Maybe make this uint32_t for OPA? Thoughts Intel?

You also need to post the driver side before this can be accepted...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
