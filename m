From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v6 00/26] IB/Verbs: IB Management Helpers
Date: Mon, 27 Apr 2015 07:19:32 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD5DC48926@CMEXMB1.ad.emulex.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
 <553A415D.1030502@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <553A415D.1030502-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tested-By: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

I am still in process of reviewing the series. Will respond soon.

-Regards
Devesh
> -----Original Message-----
> From: Michael Wang [mailto:yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org]
> Sent: Friday, April 24, 2015 6:43 PM
> To: Roland Dreier; Sean Hefty; Hal Rosenstock; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Tom Tucker; Steve Wise; Hoang-Nam Nguyen; Christoph Raisch; Mike
> Marciniszyn; Eli Cohen; Faisal Latif; Jack Morgenstein; Or Gerlitz; Haggai Eran;
> Ira Weiny; Tom Talpey; Jason Gunthorpe; Doug Ledford; Devesh Sharma; Liran
> Liss; Dave Goodell
> Subject: Re: [PATCH v6 00/26] IB/Verbs: IB Management Helpers
> 
> Add missing Cc:
> Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>"
> Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>"
> Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>"
> 
> Regards,
> Michael Wang
> 
> On 04/24/2015 02:23 PM, Michael Wang wrote:
> > Since v5:
> >   * Thanks to Ira, Devesh for the review and testing :-)
> >   * Thanks for the comments from Steve, Tom, Jason, Hal, Devesh, Ira,
> >     Liran, Jason, Dave :-) Please remind me if anything missed :-P
> >   * Trivial fix for 4#
> >   * Drop the reform on acquiring link-layer in 9#
> >   * Drop cap_ipoib()
> >
> > There are plenty of lengthy code to check the transport type of IB
> > device, or the link layer type of it's port, but actually we are just
> > speculating whether a particular management/feature is supported by the
> device/port.
> >
> > Thus instead of inferring, we should have our own mechanism for IB
> > management capability/protocol/feature checking, several proposals below.
> >
> > This patch set will reform the method of getting transport type, we
> > will now using query_transport() instead of inferring from transport
> > and link layer respectively, also we defined the new transport type to
> > make the concept more reasonable.
> >
> > Mapping List:
> > 		node-type	link-layer	old-transport	new-transport
> > nes		RNIC		ETH		IWARP		IWARP
> > amso1100	RNIC		ETH		IWARP		IWARP
> > cxgb3   	RNIC		ETH		IWARP		IWARP
> > cxgb4   	RNIC		ETH		IWARP		IWARP
> > usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
> > ocrdma  	IB_CA		ETH		IB		IBOE
> > mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
> > mlx5    	IB_CA		IB		IB		IB
> > ehca    	IB_CA		IB		IB		IB
> > ipath   	IB_CA		IB		IB		IB
> > mthca   	IB_CA		IB		IB		IB
> > qib     	IB_CA		IB		IB		IB
> >
> > For example:
> > 	if (transport == IB) && (link-layer == ETH) will now become:
> > 	if (query_transport() == IBOE)
> >
> > Thus we will be able to get rid of the respective transport and
> > link-layer checking, and it will help us to add new
> > protocol/Technology (like OPA) more easier, also with the introduced
> > management helpers, IB management logical will be more clear and easier
> for extending.
> >
> > Highlights:
> >     The patch set covered a wide range of IB stuff, thus for those who are
> >     familiar with the particular part, your suggestion would be
> > invaluable ;-)
> >
> >     Patch 1#~15# included all the logical reform, 16#~25# introduced the
> >     management helpers, 26#~27# do clean up.
> >
> >     we appreciate for those one who have the HW willing to provide
> > Tested-by :-)
> >
> >     Doug suggested the bitmask mechanism:
> > 	https://www.mail-archive.com/linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html
> >     which could be the plan for future reforming, we prefer that to be another
> >     series which focus on semantic and performance.
> >
> >     This patch-set is somewhat 'bloated' now and it may be a good timing for
> >     staging, I'd like to suggest we focus on improving existed helpers and push
> >     all the further reforms into next series ;-)
> >
> >     We now have a repository based on latest infiniband/for-next with this
> >     series applied:
> >         git-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org:ywang-pb/infiniband-wy.git
> >
> > Proposals:
> >     Sean:
> > 	https://www.mail-archive.com/linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23339.html
> >     Doug:
> > 	https://www.mail-archive.com/linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23418.html
> > 	https://www.mail-archive.com/linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html
> >     Jason:
> > 	https://www.mail-archive.com/linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23425.html
> >
> > Michael Wang (26):
> >   IB/Verbs: Implement new callback query_transport()
> >   IB/Verbs: Implement raw management helpers
> >   IB/Verbs: Reform IB-core mad/agent/user_mad
> >   IB/Verbs: Reform IB-core cm
> >   IB/Verbs: Reform IB-core sa_query
> >   IB/Verbs: Reform IB-core multicast
> >   IB/Verbs: Reform IB-ulp ipoib
> >   IB/Verbs: Reform IB-ulp xprtrdma
> >   IB/Verbs: Reform IB-core verbs
> >   IB/Verbs: Reform cm related part in IB-core cma/ucm
> >   IB/Verbs: Reform route related part in IB-core cma
> >   IB/Verbs: Reform mcast related part in IB-core cma
> >   IB/Verbs: Reserve legacy transport type in 'dev_addr'
> >   IB/Verbs: Reform cma_acquire_dev()
> >   IB/Verbs: Reform rest part in IB-core cma
> >   IB/Verbs: Use management helper cap_ib_mad()
> >   IB/Verbs: Use management helper cap_ib_smi()
> >   IB/Verbs: Use management helper cap_ib_cm()
> >   IB/Verbs: Use management helper cap_iw_cm()
> >   IB/Verbs: Use management helper cap_ib_sa()
> >   IB/Verbs: Use management helper cap_ib_mcast()
> >   IB/Verbs: Use management helper cap_read_multi_sge()
> >   IB/Verbs: Use management helper cap_af_ib()
> >   IB/Verbs: Use management helper cap_eth_ah()
> >   IB/Verbs: Clean up rdma_ib_or_iboe()
> >   IB/Verbs: Cleanup rdma_node_get_transport()
> >
> >  drivers/infiniband/core/agent.c              |   2 +-
> >  drivers/infiniband/core/cm.c                 |  20 +-
> >  drivers/infiniband/core/cma.c                | 282 ++++++++++++---------------
> >  drivers/infiniband/core/device.c             |   1 +
> >  drivers/infiniband/core/mad.c                |  43 ++--
> >  drivers/infiniband/core/multicast.c          |  12 +-
> >  drivers/infiniband/core/sa_query.c           |  30 +--
> >  drivers/infiniband/core/ucm.c                |   3 +-
> >  drivers/infiniband/core/ucma.c               |  25 +--
> >  drivers/infiniband/core/user_mad.c           |  26 ++-
> >  drivers/infiniband/core/verbs.c              |  31 +--
> >  drivers/infiniband/hw/amso1100/c2_provider.c |   7 +
> >  drivers/infiniband/hw/cxgb3/iwch_provider.c  |   7 +
> >  drivers/infiniband/hw/cxgb4/provider.c       |   7 +
> >  drivers/infiniband/hw/ehca/ehca_hca.c        |   6 +
> >  drivers/infiniband/hw/ehca/ehca_iverbs.h     |   3 +
> >  drivers/infiniband/hw/ehca/ehca_main.c       |   1 +
> >  drivers/infiniband/hw/ipath/ipath_verbs.c    |   7 +
> >  drivers/infiniband/hw/mlx4/main.c            |  10 +
> >  drivers/infiniband/hw/mlx5/main.c            |   7 +
> >  drivers/infiniband/hw/mthca/mthca_provider.c |   7 +
> >  drivers/infiniband/hw/nes/nes_verbs.c        |   6 +
> >  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |   1 +
> >  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |   6 +
> >  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |   3 +
> >  drivers/infiniband/hw/qib/qib_verbs.c        |   7 +
> >  drivers/infiniband/hw/usnic/usnic_ib_main.c  |   1 +
> >  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |   6 +
> >  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |   2 +
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c    |  15 +-
> >  include/rdma/ib_verbs.h                      | 169 +++++++++++++++-
> >  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |   4 +-
> >  net/sunrpc/xprtrdma/svc_rdma_transport.c     |  47 ++---
> >  33 files changed, 503 insertions(+), 301 deletions(-)
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
