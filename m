From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 6/7] mlx5: Add direct verbs man pages
Date: Mon, 13 Feb 2017 14:59:10 -0700
Message-ID: <20170213215910.GA16726@obsidianresearch.com>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
 <1486909012-15064-7-git-send-email-yishaih@mellanox.com>
 <20170213165445.GC25430@obsidianresearch.com>
 <20170213181338.GB6989@mtr-leonro.local>
 <20170213184551.GB12224@obsidianresearch.com>
 <156c0448-5e9b-9879-1d6b-06cbaec3ce6b@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <156c0448-5e9b-9879-1d6b-06cbaec3ce6b-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 13, 2017 at 11:52:33PM +0200, Yishai Hadas wrote:

> There is nothing wrong with current usage of comp_mask, it just
> follows the usage of ibv_query_rt_values_ex where it's used as both
> in/out.(see below from its man page) We can update the man pages to
> say it explicitly so that it will be fully clear.

And I complained about that when you did it too - it is still *horrible*

> That way looks quite more simple than managing an input size which may still
> require a comp_mask as an output to mark which values were set in case few
> fields can have a valid value of 0 but might be ignored as of legacy driver.

The best is to just have unique functions or a sane multiplexor, stop
copying this bad idea.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
