From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Add new verb: uv_query_port_max_datagram()
Date: Mon, 19 Aug 2013 14:19:04 -0600
Message-ID: <20130819201904.GA5121@obsidianresearch.com>
References: <1376942704-25270-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1376942704-25270-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 19, 2013 at 01:05:04PM -0700, Jeff Squyres wrote:
> +int uv_cmd_query_port_max_datagram(struct ibv_context *context, uint8_t port_num,
> +				   uint32_t *max_datagram,
> +				   struct uv_query_port_max_datagram *cmd,
> +				   size_t cmd_size)
> +{
> +	struct uv_query_port_max_datagram_resp resp;
> +
> +	if (abi_ver < 7)
> +		return -ENOSYS;

What about doing query port in this case and returning that value,
decoded to an enum? Otherwise apps have to include that logic anyhow.

I'm assuming the kernel will do basically the same?

Bascially, the only failure for this call should be due to a bad port
number..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
