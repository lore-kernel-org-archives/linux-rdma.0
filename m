From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/3] ibverbs: Add support for packet pacing
Date: Mon, 9 Jan 2017 10:02:00 -0700
Message-ID: <20170109170200.GB13960@obsidianresearch.com>
References: <1483893148-8211-1-git-send-email-yishaih@mellanox.com>
 <1483893148-8211-3-git-send-email-yishaih@mellanox.com>
 <20170109153856.GA29687@obsidianresearch.com>
 <b9cca64f-0d67-6174-74e5-291f93b48c1c@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b9cca64f-0d67-6174-74e5-291f93b48c1c-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 09, 2017 at 06:46:33PM +0200, Yishai Hadas wrote:

> >cmd->rate_limit is not being 0'd if it isn't set
> 
> The 'cmd' was fully set to 0'd by the provider, see usage in the last patch.

Why are some providers zeroing this and other are not?

> In case we want to do it in this layer I would vote on using memset at the
> beginning of that function to prevent repeating this for any new field. Your
> last patch in that area could do it as well.

Sounds like you should clean this all up and use = {} consistently in
the providers and drop the explicit = 0.

> >>@@ -829,7 +829,8 @@ enum ibv_qp_attr_mask {
> >> 	IBV_QP_MAX_DEST_RD_ATOMIC	= 1 << 17,
> >> 	IBV_QP_PATH_MIG_STATE		= 1 << 18,
> >> 	IBV_QP_CAP			= 1 << 19,
> >>-	IBV_QP_DEST_QPN			= 1 << 20
> >>+	IBV_QP_DEST_QPN			= 1 << 20,
> >>+	IBV_QP_RATE_LIMIT		= 1 << 25,
> >> };
> >
> >Why 25? 21 I think.
> 
> To match kernel, 21-24 are reserved.

Hm, Ok

> >
> >> enum ibv_qp_state {
> >>@@ -875,6 +876,7 @@ struct ibv_qp_attr {
> >> 	uint8_t			rnr_retry;
> >> 	uint8_t			alt_port_num;
> >> 	uint8_t			alt_timeout;
> >>+	uint32_t		rate_limit;
> >> };
> >
> >Nope, this is returned by query_qp so you cannot just extend it.
> It's safe, please see below.
 
> >
> >You are supporting query_qp, right?
> At the moment the kernel doesn't support an extended command for query_qp so
> user space doesn't get and touch this field.

Yuk, why would you do this?

> Once support will be added in the kernel, the attr_mask field of
> ibv_query_qp should be used to indicate whether application asked for that
> field (i.e. IBV_QP_RATE_LIMIT) and supplied an input structure that has
> memory to hold this output so it's safe to extend the above structure. Same
> idea was used in this series for accessing this field in modify_qp as an
> input.

Insane as it may be, 'attr_mask' is defined as a hint for
ibv_query_qp, you are redefining it to be a hard requirement for ABI
purposes.

> We can consider adding an extra check in ibv_cmd_query_qp as part of this
> series to check whether IBV_QP_RATE_LIMIT or higher bits were asked, if yes
> return an error as there is no support for that value without using an
> extended command, makes sense ?

Absolutely.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
