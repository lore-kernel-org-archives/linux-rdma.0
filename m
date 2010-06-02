From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libibverbs and versions
Date: Wed, 2 Jun 2010 11:32:45 -0600
Message-ID: <20100602173245.GG15969@obsidianresearch.com>
References: <4C067DE0.8020508@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C067DE0.8020508-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 02, 2010 at 10:50:56AM -0500, Steve Wise wrote:

> I have this library I'm writing that uses libibverbs.  Somehow it seems  
> to be using the 1.0 version instead of the newer version (I'm guessing).  
> When I call ibv_create_cq()  I get a seg fault and the stack looks like 
> this:

Make sure you link your library to libibverbs and do not rely on
linking the app to libibverbs to resolve the symbols. Check with 
ldd foo.so

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
