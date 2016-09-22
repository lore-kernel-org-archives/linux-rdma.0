From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 04/23] mlx5: Add cmake options to replace
 --with-mlx5_debug/mw_debug
Date: Thu, 22 Sep 2016 09:29:13 -0600
Message-ID: <20160922152913.GA15212@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474495729-17604-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <6249c5da-7ff1-6727-9c5f-2315054bcf5d@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6249c5da-7ff1-6727-9c5f-2315054bcf5d-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Need to consider whether there are other symbols in the original
> repositories that require similar patch. (e.g. valgrind, resolve-neigh,
> etc.)

Those two are taken care of already.

However, I'm of the opinion we should drop !resolve-neigh and nl1 as a
compile time option.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
