From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: APM support for IPoIB
Date: Mon, 1 Oct 2012 17:53:03 -0600
Message-ID: <20121001235303.GH22342@obsidianresearch.com>
References: <506A17EA.8080400@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <506A17EA.8080400-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bang Nguyen <bang.nguyen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Frank <richard.frank-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 01, 2012 at 03:23:38PM -0700, Bang Nguyen wrote:

> Adding APM support for IPoIB seems like something worthwhile and
> we're thinking about it..but are wondering why has hasn't been done
> already..any comments/suggestions?

I've been quite supportive of APM in the past, IMHO I think it is
something unique to IB that should be exploited as often as possible.

Improving the RDMA-CM to setup APM at all would be a great first step,
but some SM work is also ultimately needed to get sufficiently
independent/redundant paths.

I would like to see the full APM support eventually implemented - this
would be fail over across adaptor ports, where each port is on a
seperate subnet - so you get full redundancy of cabling, switching and
management software.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
