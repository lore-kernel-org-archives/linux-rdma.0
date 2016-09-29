From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
Date: Thu, 29 Sep 2016 16:55:18 -0600
Message-ID: <20160929225518.GB7421@obsidianresearch.com>
References: <20160923041340.GA11269@obsidianresearch.com>
 <20160929160053.GA11879@infradead.org>
 <20160929161659.GA774@obsidianresearch.com>
 <57ED40C8.901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57ED40C8.901-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 12:26:48PM -0400, Doug Ledford wrote:

> I just merged a pull request of yours, and that was the last outstanding
> pull request in the github.  I still have to sort through patches on the
> list that aren't in the github interface...but at least 20 or so of your
> outstanding patches were taken in today.

Yep thanks, making progress, sent another 13 or so, I think there are
about 10 left now. Most of what remains in my preview tree needs a bit
more work I think.

The last big useful item is the directory rename/flatting patches, eg
to move libX/src/ to under providers/ and to flatten other directories.

Oh, and the packaging files..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
