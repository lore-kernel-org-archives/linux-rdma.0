From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] verbs: fix compilation error with ICC
Date: Thu, 28 Sep 2017 10:44:08 -0600
Message-ID: <20170928164408.GD17880@obsidianresearch.com>
References: <1506434711-3828-1-git-send-email-nelio.laranjeiro@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506434711-3828-1-git-send-email-nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 26, 2017 at 04:05:11PM +0200, Nelio Laranjeiro wrote:

> -static void *__VERBS_ABI_IS_EXTENDED = ((uint8_t *) NULL) - 1;
> +static void *__VERBS_ABI_IS_EXTENDED = (void *)UINTPTR_MAX;

Hurm, this shouldn't be a static in a header file :(

Patch looks OK to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
