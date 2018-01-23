From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and RDMA subsystem
Date: Tue, 23 Jan 2018 11:55:16 -0600
Message-ID: <014c01d39473$536ba5f0$fa42f1d0$@opengridcomputing.com>
References: <20180114223603.19961-1-bmt@zurich.ibm.com> <20180114223603.19961-4-bmt@zurich.ibm.com> <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com> <20180123164316.GC30670@ziepe.ca> <011801d3946b$53ef0060$fbcd0120$@opengridcomputing.com> <20180123170517.GE30670@ziepe.ca> <013a01d3946f$034683f0$09d38bd0$@opengridcomputing.com> <20180123172830.GF30670@ziepe.ca> <014501d39471$84cdee20$8e69ca60$@opengridcomputing.com> <20180123174758.GH30670@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123174758.GH30670-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>
Cc: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Tue, Jan 23, 2018 at 11:42:20AM -0600, Steve Wise wrote:
> 
> > Since the iwarp protocols run on top of TCP/IP, there is always the case
> > that some middle box resegments tcp segments differently, so a good
iwarp
> HW
> > implementation should deal with funny alignments, partial iWARP PDUs
> > arriving, etc.   But the RFCs, as I read them, want implementations to
try
> > "really hard" to avoid spanning an iWARP PDU across many TCP segments.
> And
> > I think siw should do the same, by default.
> 
> But Bernard just said siw doesn't interoperate in certain cases
> because of this - so that sounds like more than 'try really hard' ??
> 
> Or is that an overstatement and it just makes the rx side slower if
> segmentation is not optimal?

Creating 64K iWARP PDUs causes interoperability problems.  If siw builds
iWARP PDUs that fit within the TCP wire MSS, then these problems are
avoided, and siw becomes more spec compliant.  If the iWARP PDUs are built
this way, then nothing the tcp stack does will cause problems other than
slow down things.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
