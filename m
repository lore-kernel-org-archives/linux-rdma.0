From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: iw_cxgb4: use wildcard mapping for getting remote addr info
Date: Thu, 7 May 2015 15:09:28 -0600
Message-ID: <20150507210928.GA1597@obsidianresearch.com>
References: <20150507145224.28735.97977.stgit@build.ogc.int>
 <20150507204508.GA1195@obsidianresearch.com>
 <554BD282.7060800@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <554BD282.7060800-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 07, 2015 at 04:00:50PM -0500, Steve Wise wrote:

> This does not need to hit stable because the remote_info logic was
> just added in 4.1 with:

> commit 5b6b8fe64053b2649660ded2f3c5be25ebddbfdb
> Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Date:   Tue Apr 21 16:28:41 2015 -0400
> 
>     RDMA/cxgb4: Report the actual address of the remote connecting peer
> 
> 
> Doug, shall I resend the patch with an updated comment?

I would, you also need to supply a Fixes tag anyhow, and there should
have been a brief note after '--' that this is a bug fix for 4.1 so it
gets prioritized and doesn't wait for the next merge window.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
