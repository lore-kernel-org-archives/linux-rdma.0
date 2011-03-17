From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Infiniband poll_cq : nothing on queue
Date: Thu, 17 Mar 2011 16:30:12 -0600
Message-ID: <20110317223012.GF31317@obsidianresearch.com>
References: <201103171809.19293.kerr.g@husky.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201103171809.19293.kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 17, 2011 at 06:09:18PM -0400, Greg Kerr wrote:

> To provide more background information I ran ibdump on my program (on both
> nodes) and then analyzed the output in Wireshark. Basically node1 shows
> nothing but RC Acknowledge packets and Node 2 shows nothing but RC Send
> First packets. Does that reveal anything about where the problem likely
> lies?

That means node 2 is not getting/dropping the ACK packets from node
1.

Best choices, wrong PSN, wrong DLID, wrong QPN on on node 1, or the
QP is not in RTS on node 2.
 
Remember all three of the values are supposed to be swapped, node
1/node 2 rq_psn/sq_psn, DLID/SLID, qpn/dest_qp_num, and you have to
modify_qp three times all the way to RTS on both sides.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
