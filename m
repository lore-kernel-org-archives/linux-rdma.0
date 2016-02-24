From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 1/8] Add ibv_poll_cq_ex verb
Date: Wed, 24 Feb 2016 12:02:30 -0700
Message-ID: <20160224190230.GA10588@obsidianresearch.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
 <1456306924-31298-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456306924-31298-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 24, 2016 at 11:41:57AM +0200, Yishai Hadas wrote:

> +enum {
> +	IBV_WC_EX_WITH_8BIT_FIELDS = IBV_WC_EX_WITH_SL			|
> +				     IBV_WC_EX_WITH_DLID_PATH_BITS
> +};
> +
> +struct ibv_wc_ex {
> +	uint64_t		wr_id;
> +	/* wc_flags is a combination of ibv_wc_flags_ex flags. The IBV_WC_EX_WITH_XXX
> +	 * flags dynamically define the valid fields in buffer[0].
> +	 */
> +	uint64_t		wc_flags;
> +	uint32_t		status;
> +	uint32_t		opcode;
> +	uint32_t		vendor_err;
> +	uint32_t		reserved;
> +	uint8_t			buffer[0];
> +};

Um, maybe you should give an example of how on earth anyone is
supposed to use this, all of this looks like a *really bad idea* to
me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
