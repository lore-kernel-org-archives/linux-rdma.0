From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] IB/mad: In validate_mad, validate CM send method for
 attributes other than ClassPortInfo
Date: Fri, 13 Nov 2015 15:22:22 -0500
Message-ID: <5646467E.2000509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Receipt of CM MAD with other than the Send method for an attribute
other than the ClassPortInfo attribute is invalid.

CM attributes other than ClassPortInfo only use the send method.

The SRP initiator does not maintain a timeout policy for CM connect
requests relies on the CM layer to do that. The result was that
the SRP initiator hung as the connect request never completed.

A new SRP target has been observed to respond to Send CM REQ
with GetResp of CM REQ with bad status. This is non conformant
with IBA spec but exposes a vulnerability in the current MAD/CM
code which will respond to the incoming GetResp of CM REQ as if
it was a valid incoming Send of CM REQ rather than tossing
this on the floor. It also causes the MAD layer not to
retransmit the original REQ even though it has not received a REP.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
Removed ClassPortInfo method validation

 drivers/infiniband/core/mad.c |    5 +++++
 include/rdma/ib_mad.h         |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 8d8af7a..2281de1 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1811,6 +1811,11 @@ static int validate_mad(const struct ib_mad_hdr *mad_hdr,
 		if (qp_num == 0)
 			valid = 1;
 	} else {
+		/* CM attributes other than ClassPortInfo only use Send method */
+		if ((mad_hdr->mgmt_class == IB_MGMT_CLASS_CM) &&
+		    (mad_hdr->attr_id != IB_MGMT_CLASSPORTINFO_ATTR_ID) &&
+		    (mad_hdr->method != IB_MGMT_METHOD_SEND))
+			goto out;
 		/* Filter GSI packets sent to QP0 */
 		if (qp_num != 0)
 			valid = 1;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 188df91..ec9b44d 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -237,6 +237,8 @@ struct ib_vendor_mad {
 	u8			data[IB_MGMT_VENDOR_DATA];
 };
 
+#define IB_MGMT_CLASSPORTINFO_ATTR_ID	cpu_to_be16(0x0001)
+
 struct ib_class_port_info {
 	u8			base_version;
 	u8			class_version;
-- 
1.7.8.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
