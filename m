From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: static_rate broken in mlx4?
Date: Mon, 6 Dec 2010 13:00:50 -0700
Message-ID: <20101206200050.GA16788@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Does this work? Has anyone seen it work?

I'm testing it on a pair of mlx4 MT25418 and I'm trying to get down to
2.5Gbps and I can't see any effect from twiddling the static_rate AH
attribute for an RC QP. The value seems to be working, I put 30 in to
a ibv_modify_qp with IBV_QP_AV and 2 comes back (the max, it looks
like..)

Anyone know?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
