From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/CMA: fix iWARP adapter TCP port space usage
Date: Wed, 23 Jun 2010 10:30:27 -0700
Message-ID: <ada8w65veq4.fsf@roland-alpha.cisco.com>
References: <OF026C9B22.332F6F2C-ONC1257745.00429E02-C1257745.004E411D@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF026C9B22.332F6F2C-ONC1257745.00429E02-C1257745.004E411D-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
	(Bernard Metzler's message of "Thu, 17 Jun 2010 16:14:44 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > iWARP is just another protocol on top of TCP - like iSCSI. There is
 > no good reason to invent another TCP port maintainer per TCP user
 > type trying to synchonize with the kernel if the resource is host
 > global and already maintained by the kernel.

I think the counter-argument to this is than an iWARP offload NIC is an
independent TCP stack and hence should not be tied into the host stack.
It's interesting that you bring up iSCSI -- as I understand things,
iSCSI offload HBAs are typically configured with their own IP, through a
separate mechanism.  (The port collision problem is not likely to be hit
with iSCSI, since the HBA is an initiator and hence does only active
connections, and a 4-tuple collision between connections to the iSCSI
target is not likely and other host stack traffic is extremely unlikely)

 > Since we are developing and already open sourced a full software
 > implementation (SoftiWARP) of RDMA, our view on the optimal solution
 > must be different. Like kernel iSCSI, we are running on top of regular
 > kernel sockets. With that, there is no point having a connection manager
 > blocking just the port we wanted to use for communication - SoftiWARP
 > uses kernel sockets for data communication.

I think this is an extremely strong argument against the patch that
started the thread.  Breaking soft iWARP seems a fatal flaw.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
