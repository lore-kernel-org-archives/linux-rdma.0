From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] libocrdma: Move ocrdma's list
 implementation into common directory
Date: Mon, 26 Sep 2016 15:14:40 -0700
Message-ID: <20160926221440.GA5878@infradead.org>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
 <1474786207-2149-5-git-send-email-leon@kernel.org>
 <20160925144121.GA12246@infradead.org>
 <20160925161315.GD4088@leon.nu>
 <20160925162203.GA32434@infradead.org>
 <20160926174057.GD22965@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160926174057.GD22965-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 26, 2016 at 11:40:57AM -0600, Jason Gunthorpe wrote:
> Copyright isn't a patent,

I know very well, thanks..

> assuming freebsd didn't copy any code and
> just implemented the same API independently (eg it is an Independent
> Creation) they should be OK from a copyright perspective.

That's a big IF, as I'm honestly not sure it is.  I don't want to blame
anywone because I really don't know but if I had to decided to use it
or not I would error on the safe side.

> As should be
> Rusty's version in CCAN.

That's a much safer choice.  It's a lightly different API, though.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
