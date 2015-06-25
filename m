From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Thu, 25 Jun 2015 13:33:33 -0500
Message-ID: <005a01d0af75$70c9eb60$525dc220$@opengridcomputing.com>
References: <20150625153754.13272.432.stgit@build.ogc.int> <20150625153922.13272.41789.stgit@build.ogc.int> <20150625182505.GA15337@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FF9D60@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FF9D60-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
> Sent: Thursday, June 25, 2015 1:30 PM
> To: Jason Gunthorpe; Steve Wise
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; raid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> Subject: RE: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
> 
> > > +	 * IWARP transports need REMOTE_WRITE for MRs used as the target of
> > > +	 * an RDMA_READ.  Since the DMA MR is used for all ports, then if
> > > +	 * any port is running IWARP, add REMOTE_WRITE.
> > > +	 */
> > > +	if (any_port_is_iwarp(device))
> >
> > It would be nice to have a new-style cap test for this instead of open
> > coding iwarp. Similar to rdma_cap_read_multi_sge
> 
> This should be pushed down into the devices, or at least within verbs, rather than having ULPs needing to know this oddness.

How would you envision doing this?  At the time a MR is registered the device driver doesn't know if the application will be doing
RDMA reads or not on that MR.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
