From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 ib-next 2/3] IB/core: IB/core: Allow legacy verbs
 through extended interfaces
Date: Tue, 10 Nov 2015 13:11:47 -0700
Message-ID: <20151110201147.GA21593@obsidianresearch.com>
References: <1447178410-15360-1-git-send-email-eli@mellanox.com>
 <1447178410-15360-3-git-send-email-eli@mellanox.com>
 <20151110182107.GG12667@obsidianresearch.com>
 <20151110195713.GA21849@x-vnc01.mtx.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110195713.GA21849-lgQlq6cFzJSjLWYaRI30zHI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 09:57:13PM +0200, Eli Cohen wrote:

> Yes, we can do this but I think this should be the subject for another
> patch, agree?

Sure

> Regarding using stabs, it may be nice but I don't think performance is
> the issue here. Most verbs implementations involve relatively long i/o
> operations anyway so the gain will not be noticable.

Intel keeps optimizing this common path since they use it for post..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
