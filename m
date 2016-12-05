From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/2] Optimize RoCE address handle creation
 for userspace
Date: Mon, 5 Dec 2016 10:07:02 -0700
Message-ID: <20161205170702.GA27306@obsidianresearch.com>
References: <1480866806-5052-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1480866806-5052-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 04, 2016 at 05:53:24PM +0200, Yishai Hadas wrote:

> Test results:
> Upon testing the above use case the provider couldn't be loaded as expected,
> "libibverbs: Warning: couldn't load driver 'libmlx5-rdmav2.so':
> libmlx5-rdmav2.so: cannot open shared object file: No such file or directory"

The dynmic linker didn't print something too? That is surprising..

I'm not sure where we are in the release cycle right now.. Doug - if
we didn't make a release with the 1.3 symbol tag (this was created
just before rdma-core) then this should go into 1.3 when it gets
merged..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
