From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Improve symbol version support in ibverbs
 & providers
Date: Sun, 27 Aug 2017 15:41:34 -0600
Message-ID: <20170827214134.GA14542@obsidianresearch.com>
References: <1503612029-19854-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170827115806.GS1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170827115806.GS1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 27, 2017 at 02:58:06PM +0300, Leon Romanovsky wrote:

> Also I think that after this series, it will be safe to change default
> of "-DENABLE_STATIC" to be on.

I think there are still issues with static builds..

Notably we have to disable dlopen in libibverbs when it is built
statically as that absolutely will make a mess.

Would also be nice to find a way to avoid requiring --whole-archive
too.

Maybe some other things.. I haven't ever tested static builds ..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
