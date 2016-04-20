From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared Topic Branch For ABI Changes
Date: Wed, 20 Apr 2016 09:29:24 -0600
Message-ID: <20160420152924.GA25424@obsidianresearch.com>
References: <20160420055221.GT6349@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160420055221.GT6349-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 20, 2016 at 08:52:21AM +0300, Leon Romanovsky wrote:

> The supplementary user space (libibverbs) repository will be set a
> little bit later.

We should also re-consider the idea that has been floated a few times
over the years:

 Combine all the RMDA plumbing libraries into one git repository.

This is librdmacm, libibverbs, libucm, libumad, libmad,
libmlx4/5/mtcha/ipath/cxgb/etc/etc

With the scope of the planned work this would seem essential to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
