From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Wed, 23 Jun 2010 14:09:37 -0600
Message-ID: <20100623200937.GV4630@obsidianresearch.com>
References: <OF026C9B22.332F6F2C-ONC1257745.00429E02-C1257745.004E411D@ch.ibm.com> <ada8w65veq4.fsf@roland-alpha.cisco.com> <4C225078.6050001@opengridcomputing.com> <adar5jxtxho.fsf@roland-alpha.cisco.com> <4C225697.6060702@opengridcomputing.com> <20100623192909.GT4630@obsidianresearch.com> <4C2263B3.9010608@opengridcomputing.com> <20100623195210.GU4630@obsidianresearch.com> <4C226A6F.4000801@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C226A6F.4000801-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 23, 2010 at 03:11:27PM -0500, Steve Wise wrote:
> The IP address assigned for the cxgb3i iscsi device is _not_ assigned to  
> a netdev interface via ifconfig, as far as I understand it (by looking  
> at the cxgb3i code).  So the host stack doesn't know about this address.  
> There is an administrative requirement, I assume, that the secret iscsi 
> ipaddr is within a subnet that is bound to the T3 ethX interface.  
> Otherwise the routing lookup wouldn't work.

So who responds to neighbor queries, and how do outgoing queries get
sent with the right IP? Sounds odd...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
