From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 6/9] IB/core: Sysfs support for peer memory
Date: Mon, 6 Oct 2014 15:00:23 -0600
Message-ID: <20141006210023.GC28962@obsidianresearch.com>
References: <1412602019-30659-1-git-send-email-yishaih@mellanox.com>
 <1412602019-30659-7-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412602019-30659-7-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 06, 2014 at 04:26:56PM +0300, Yishai Hadas wrote:
> new file mode 100644
> index 0000000..c09cde2
> +++ b/Documentation/infiniband/peer_memory.txt

Um, no, these belong in Documentation/ABI/stable/sysfs-*

Please explain why these should not be in debugfs.

You are going to need to get someone other than Roland to sign off on
'/sys/kernel/mm/memory_peers'.

Actually, I'm skeptical this whole scheme even belongs under
Infiniband. Why couldn't this be used to read from a file with
O_DIRECT into a GPU, for instance?

Did you try to find a better home for this?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
