From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Expose CQ moderation to user space
Date: Mon, 23 Oct 2017 09:26:38 -0600
Message-ID: <20171023152638.GB11952@obsidianresearch.com>
References: <20171019053524.11135-1-leon@kernel.org>
 <20171023094744.GH2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023094744.GH2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 23, 2017 at 12:47:44PM +0300, Leon Romanovsky wrote:

> Mellanox,
> I would like to use this opportunity and to ask publicly, please submit kernel
> and user spaces altogether.

+1

I was looking at the flow counters patches and they make no sense
without also seeing the man pages that describe what the heck this
stuff is.

At the very least put a rdma-core branch someplace and reference it in
your kernel patch series, and it better have really good man pages for
the verbs features being added.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
