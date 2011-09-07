From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] [for-3.2] ib/mad: Verify mgmt class in received MADs
Date: Wed, 7 Sep 2011 23:27:26 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E5A0C0@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a received MAD contains an invalid or reserved mgmt class,
we will attempt to access method_table outside of its range.
Add a check to ensure that mgmt class falls within the
handled range.

Found by code inspection.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index b4d8672..0563892 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1596,6 +1596,9 @@ find_mad_agent(struct ib_mad_port_private *port_priv,
 					mad->mad_hdr.class_version].class;
 			if (!class)
 				goto out;
+			if (convert_mgmt_class(mad->mad_hdr.mgmt_class) >=
+			    IB_MGMT_MAX_METHODS)
+				goto out;
 			method = class->method_table[convert_mgmt_class(
 							mad->mad_hdr.mgmt_class)];
 			if (method)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
