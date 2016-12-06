From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 00/28] Broadcom RoCE Driver (bnxt_re)
Date: Tue, 6 Dec 2016 09:34:56 -0700
Message-ID: <20161206163456.GB28066@obsidianresearch.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com>
 <20161205165144.GB24852@obsidianresearch.com>
 <CA+sbYW1sUrv8CBHScMjU7ozBm709-tiVWaynDQK_Dq3AqAfggA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+sbYW1sUrv8CBHScMjU7ozBm709-tiVWaynDQK_Dq3AqAfggA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 06, 2016 at 11:31:14AM +0530, Selvin Xavier wrote:
> > Do you have a git tree someplace for this?

> I assume you are referring to our uverbs library.

No, I mean this series for linux. It is very hard to read these
patches when they touch the same file again and again and have
dependencies on net trees and things. I encourage people to include a
git tree for such large works..

> > Do you have the user space component ready for rdma-core as well?
> >
> This is not ready yet. Currently working on it.

I'm also encouraging people to have their user space ready so the
kernel driver can be properly reviewed.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
