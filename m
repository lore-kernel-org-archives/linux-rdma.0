From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH rdma-core 7/7] mlx5: Export mlx5 direct verbs interface
Date: Fri, 3 Feb 2017 08:04:19 -0800
Message-ID: <20170203160419.GA28953@infradead.org>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
 <1485446182-5109-8-git-send-email-yishaih@mellanox.com>
 <20170126173005.GD16562@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170126173005.GD16562-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2017 at 10:30:05AM -0700, Jason Gunthorpe wrote:
> No, this is no longer just a provider so it doesn't get to use
> provider.map
> 
> mlx5 will need its own map file and the various magic I described to
> become a proper library and a plugin at once.

Honestly, I don't think it should be both at once.  The library for
direct access needs to be in /usr/lib and the provider hidden in the
providers directory, and not export anything not in the providers API.

I think what needs to happen is a new library for the direct access,
and the provider should be layered on top of it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
