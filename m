From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/rxe: Cache dst in QP instead of getting
 it for each send
Date: Thu, 20 Apr 2017 12:01:14 -0600
Message-ID: <20170420180114.GA6763@obsidianresearch.com>
References: <20170420175556.8573-1-leon@kernel.org>
 <20170420175556.8573-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170420175556.8573-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 20, 2017 at 08:55:56PM +0300, Leon Romanovsky wrote:
> From: yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> In RC QP there is no need to resolve the outgoing interface
> for each packet, as this does not change during QP life cycle.

At first blush that seems wonky, shouldn't a QP act like a TCP socket
and be able to migrate around when things are reconfigured?

IIRC there is some kind of dst cache scheme you should use instead?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
