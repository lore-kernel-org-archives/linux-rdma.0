From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 03/13] Attach/detach SoftiWarp to/from network and RDMA subsystem
Date: Tue, 23 Jan 2018 11:42:20 -0600
Message-ID: <014501d39471$84cdee20$8e69ca60$@opengridcomputing.com>
References: <20180114223603.19961-1-bmt@zurich.ibm.com> <20180114223603.19961-4-bmt@zurich.ibm.com> <00ff01d39467$f1f31b60$d5d95220$@opengridcomputing.com> <20180123164316.GC30670@ziepe.ca> <011801d3946b$53ef0060$fbcd0120$@opengridcomputing.com> <20180123170517.GE30670@ziepe.ca> <013a01d3946f$034683f0$09d38bd0$@opengridcomputing.com> <20180123172830.GF30670@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180123172830.GF30670-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>
Cc: 'Bernard Metzler' <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Tue, Jan 23, 2018 at 11:24:24AM -0600, Steve Wise wrote:
> > >
> > > On Tue, Jan 23, 2018 at 10:58:01AM -0600, Steve Wise wrote:
> > >
> > > > From: https://tools.ietf.org/html/rfc5041#section-5.2
> > > >
> > > > "At the Data Source, the DDP layer MUST segment the data contained
in
> > > >    a ULP message into a series of DDP Segments, where each DDP
Segment
> > > >    contains a DDP Header and ULP Payload, and MUST be no larger than
the
> > > >    MULPDU value Advertised by the LLP."
> > > >
> > > > Where MULDPDU is the maximum ULP PDU that will fit in the TCP MSS...
> > >
> > > But exceeding the MULPDU has nothing to do with the netstack GSO
> > > function.. right? GSO is entirely a local node optimization that
> > > should not be detectable on the wire.
> >
> > It is not detectable by TCP on the wire, however the iWARP protocols
that
> > impose message boundaries, among other things, require that the iWARP
PDU
> > fits in a single TCP segment.  Since softiwarp is building the iwarp
PDU, if
> > it builds one based on a 64K GSO advertised MSS, then the resulting wire
> > packets will have man TCP segments all containing parts of a single
iWARP
> > PDU, which violates the spec I quoted.
> 
> But that still has nothing to do with GSO, can't you GSS up to MULPDU?
> 

I don't understand your question.

> Isn't the issue here more that, as Bernard says, siw is totally broken
> since it can't control the TCP layer segmentation boundaries? :(
> 

Since the iwarp protocols run on top of TCP/IP, there is always the case
that some middle box resegments tcp segments differently, so a good iwarp HW
implementation should deal with funny alignments, partial iWARP PDUs
arriving, etc.   But the RFCs, as I read them, want implementations to try
"really hard" to avoid spanning an iWARP PDU across many TCP segments.  And
I think siw should do the same, by default.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
