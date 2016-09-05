From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 4/6] RDMA/core: Move HFI1 IOCTL declarations
 to common file
Date: Sun, 4 Sep 2016 20:41:58 -0600
Message-ID: <20160905024158.GE21542@obsidianresearch.com>
References: <1472988635-31463-1-git-send-email-leon@kernel.org>
 <1472988635-31463-5-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472988635-31463-5-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 04, 2016 at 02:30:33PM +0300, Leon Romanovsky wrote:

> +/* User commands. */
> +#define HFI1_CMD_ASSIGN_CTXT     1	/* allocate HFI and context */

> +#define HFI1_IOCTL_ASSIGN_CTXT \
> +	_IOWR(IB_IOCTL_MAGIC, __NUM(ASSIGN_CTXT), struct hfi1_user_info)

I still vote for dropping the HFI1_CMD_ASSIGN_CTXT defines. Inlining
the number is far more readable than that ugly __NUM macro.

If it was done consistently you might have an arugment, but just doing
it in one place with no purpose is silly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
