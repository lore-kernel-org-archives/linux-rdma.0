From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
Date: Thu, 29 Sep 2016 10:16:59 -0600
Message-ID: <20160929161659.GA774@obsidianresearch.com>
References: <20160923041340.GA11269@obsidianresearch.com>
 <20160929160053.GA11879@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160929160053.GA11879-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 09:00:53AM -0700, Christoph Hellwig wrote:
> Hi Jason,
> 
> any chance you could simply follow the modern debian copyright file
> format:

I was thinking about doing that.. But choose not to for this first
draft.

1) I'd have to go and unwind on a file by file basis exactly what
   every licnese is. Right now I've just done a survey. There are many
   copyrightable files with no license text, and many potentially
   non-copyrightable files with no license text as well. All that
   needs to be figured out first.

   I would like to add at least short license headers to every file.
2) It seems to require listing the copyright owners for every file,
   this is a royal pain, IMHO. Many copyrightable files do not have
   copyright data, so it would have to be mined out of git. I have
   a script that does that someplace..

My thinking was to start small, document the survey results (and agree
my interpetation is sensible), then work on achiveing full copyright
headers, then use that to build the debian format.

I'd appreciate help, eg patches moving toward #1 and eliminating the
free COPYING files and unlicnesed items. I think it will take a bit to
get there, I still have a bit wack of patches to get applied on other
topics..


Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
