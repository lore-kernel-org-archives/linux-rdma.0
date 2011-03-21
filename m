From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PULL] SRP large IO request support
Date: Mon, 21 Mar 2011 14:02:49 -0400
Message-ID: <1300730569.3797.2.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-initiator.git external-indirect

to receive the following changes implementing support for large IO
requests through SRP.

Thanks!



David Dillow (6):
      IB/srp: always avoid non-zero offsets into an FMR
      IB/srp: move IB CM setup completion into its own function
      IB/srp: allow sg_tablesize to be set for each target
      IB/srp: rework mapping engine to use multiple FMR entries
      IB/srp: add support for indirect tables that don't fit in SRP_CMD
      IB/srp: try to use larger FMR sizes to cover our mappings

 drivers/infiniband/ulp/srp/ib_srp.c |  725 +++++++++++++++++++++++------------
 drivers/infiniband/ulp/srp/ib_srp.h |   38 ++-
 2 files changed, 514 insertions(+), 249 deletions(-)

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
