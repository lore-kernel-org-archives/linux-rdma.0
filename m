From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: stalled again
Date: Thu, 3 Dec 2015 00:46:28 -0800
Message-ID: <20151203084628.GA30399@infradead.org>
References: <565DCB24.7020304@mellanox.com>
 <20151202122927.GC28278@infradead.org>
 <20151202184201.GB17021@obsidianresearch.com>
 <565F5025.2090002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <565F5025.2090002-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

not having any maintainer available for an extended time is a problem,
and we actually had long discussions about that at kernel summit, with
a clear hint with a cluebat from Linus that he'd prefer maintainer
teams.  So I'd really love to know who was so ead set aginst them.

I personally don't really care if there is a real team (active/active)
or just a standby (active/passive), but I think we really need a
coherent tree of pending patches to avoid last minute rebases due to
conflicts, as well as some feedback for submitters.

I'd be happy to volunteer to collect all patches that were properly
review into a queue for you to consider to at least sort out these
mechanics, although I'd be even more happy if someone who has a longer
experience with the subsystem would volunteer instead.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
