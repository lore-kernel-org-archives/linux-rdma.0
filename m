From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Tue, 23 Jan 2018 10:47:58 -0700
Message-ID: <20180123174758.GH30670@ziepe.ca>
References: <20180114223603.19961-1-bmt@zurich.ibm.com>
 <20180114223603.19961-4-bmt@zurich.ibm.com>
 <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com>
 <20180123164316.GC30670@ziepe.ca>
 <011801d3946b$53ef0060$fbcd0120$@opengridcomputing.com>
 <20180123170517.GE30670@ziepe.ca>
 <013a01d3946f$034683f0$09d38bd0$@opengridcomputing.com>
 <20180123172830.GF30670@ziepe.ca>
 <014501d39471$84cdee20$8e69ca60$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <014501d39471$84cdee20$8e69ca60$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 23, 2018 at 11:42:20AM -0600, Steve Wise wrote:

> Since the iwarp protocols run on top of TCP/IP, there is always the case
> that some middle box resegments tcp segments differently, so a good iwarp HW
> implementation should deal with funny alignments, partial iWARP PDUs
> arriving, etc.   But the RFCs, as I read them, want implementations to try
> "really hard" to avoid spanning an iWARP PDU across many TCP segments.  And
> I think siw should do the same, by default.

But Bernard just said siw doesn't interoperate in certain cases
because of this - so that sounds like more than 'try really hard' ??

Or is that an overstatement and it just makes the rx side slower if
segmentation is not optimal?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
