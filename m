From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Thu, 19 May 2016 12:19:33 -0600
Message-ID: <20160519181933.GB26130@obsidianresearch.com>
References: <1463658702-9975-1-git-send-email-yishaih@mellanox.com>
 <1463658702-9975-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463658702-9975-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 19, 2016 at 02:51:37PM +0300, Yishai Hadas wrote:
> +	int (*start_poll_ex)(struct ibv_cq_ex *current,
> +			     struct ibv_poll_cq_ex_attr *attr);
> +	int (*next_poll_ex)(struct ibv_cq_ex *current);
> +	void (*end_poll_ex)(struct ibv_cq_ex *current);

Probably don't need the _ex here..

> +	uint64_t (*read_wr_id)(struct ibv_cq_ex *current);
> +	enum ibv_wc_status (*read_status)(struct ibv_cq_ex *current);
> +	enum ibv_wc_opcode (*read_opcode)(struct ibv_cq_ex *current);

opcode, status and wr_id are always available in every WR, so I think
a faster way to return them should be devised. Perahps have the driver
write them to ibv_cq_ex and have the inline functions read the struct
directly?

How does this work multi-threaded? Is the locking done in
start_poll.end_poll?

> +	uint32_t (*read_vendor_err)(struct ibv_cq_ex *current);
> +	uint32_t (*read_byte_len)(struct ibv_cq_ex *current);
> +	uint32_t (*read_imm_data)(struct ibv_cq_ex *current);
> +	uint32_t (*read_qp_num)(struct ibv_cq_ex *current);
> +	uint32_t (*read_src_qp)(struct ibv_cq_ex *current);
> +	int (*read_wc_flags)(struct ibv_cq_ex *current);
> +	uint16_t (*read_pkey_index)(struct ibv_cq_ex *current);
> +	uint16_t (*read_slid)(struct ibv_cq_ex *current);
> +	uint8_t (*read_sl)(struct ibv_cq_ex *current);
> +	uint8_t (*read_dlid_path_bits)(struct ibv_cq_ex *current);

Maybe some of these should be grouped into a struct? What kind of
performance hit did you measure on these calls? Reading all the ud
parameters is not very expensive...

read_ud_info ?

What does the driver look like? I'm assuming it turned out as short
and jump free as I outlined?

Finally, these extended APIs really need to be always available - so
the core code should always provide a compatability wrapper for
providers that do not implement this API. The compat wrapper should
use the existing provider wc interface.

We should not have stuff like in your rc_pingpong example where
totally different code paths are required on something like wc
processing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
