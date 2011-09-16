From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH/ibsim] Provide support for SubnSet(GUIDInfo)
Date: Fri, 16 Sep 2011 15:06:11 -0600
Message-ID: <20110916210611.GA6926@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hardwire PortInfo.GUIDCap to 1 for both the switch and HCA case,
then simply verify that the incoming SubnSet matches the RO data
in block 0.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibsim/sim_mad.c |   25 +++++++++++++++++--------
 ibsim/sim_net.c |    2 +-
 2 files changed, 18 insertions(+), 9 deletions(-)

I've put all our patches for ibsim on my github page:

git://github.com/jgunthorpe/ibsim.git

diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
index 83d4e3b..60da7d2 100644
--- a/ibsim/sim_mad.c
+++ b/ibsim/sim_mad.c
@@ -385,17 +385,26 @@ static int do_guidinfo(Port * port, unsigned op, uint32_t mod, uint8_t * data)
 	Node *node = port->node;
 	int status = 0;
 	uint64_t portguid = node->nodeguid + port->portnum;
+	if (node->type == SWITCH_NODE)
+		portguid = node->nodeguid;
 
-	if (op != IB_MAD_METHOD_GET)    // only get currently supported (non compliant)
-		status = ERR_METHOD_UNSUPPORTED;
-
-	memset(data, 0, IB_SMP_DATA_SIZE);
-	if (mod == 0) {
-		if (node->type == SWITCH_NODE)
-			mad_encode_field(data, IB_GUID_GUID0_F, &node->nodeguid);
-		else
+	if (op == IB_MAD_METHOD_SET) {
+		/* The PortInfo.GuidCap is hardwired to 1, so the only valid input
+		   to a Set is the port GUID followed by zeros on block 0. */
+		int i = mod == 0?1:0;
+		for (; i != 8; ++i)
+			if (mad_get_field64(data, i*8, IB_GUID_GUID0_F) != 0)
+				status = ERR_BAD_PARAM;
+		if (mod != 0 ||
+		    mad_get_field64(data, 0, IB_GUID_GUID0_F) != portguid)
+			status = ERR_BAD_PARAM;
+	} else if (op == IB_MAD_METHOD_GET) {
+		memset(data, 0, IB_SMP_DATA_SIZE);
+		if (mod == 0)
 			mad_encode_field(data, IB_GUID_GUID0_F, &portguid);
 	}
+	else
+		status = ERR_METHOD_UNSUPPORTED;
 
 	return status;
 }
diff --git a/ibsim/sim_net.c b/ibsim/sim_net.c
index 13c3b8c..59fc28e 100644
--- a/ibsim/sim_net.c
+++ b/ibsim/sim_net.c
@@ -104,7 +104,7 @@ static const uint8_t hcaport[] = {
 	0x00, 0x00, 0x0F, 0xF9, 0x01, 0x03, 0x03, 0x02,
 	0x12, 0x52, 0x00, 0x11, 0x40, 0x40, 0x00, 0x08,
 	0x08, 0x04, 0xFF, 0x10, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x20, 0x1F, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x01, 0x1F, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 };
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
