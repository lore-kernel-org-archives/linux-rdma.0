From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Thu, 25 Jun 2015 18:30:22 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FF9D60@ORSMSX109.amr.corp.intel.com>
References: <20150625153754.13272.432.stgit@build.ogc.int>
 <20150625153922.13272.41789.stgit@build.ogc.int>
 <20150625182505.GA15337@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625182505.GA15337-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +	 * IWARP transports need REMOTE_WRITE for MRs used as the target of
> > +	 * an RDMA_READ.  Since the DMA MR is used for all ports, then if
> > +	 * any port is running IWARP, add REMOTE_WRITE.
> > +	 */
> > +	if (any_port_is_iwarp(device))
> 
> It would be nice to have a new-style cap test for this instead of open
> coding iwarp. Similar to rdma_cap_read_multi_sge

This should be pushed down into the devices, or at least within verbs, rather than having ULPs needing to know this oddness.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
