From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] IB core: Support 64 bit values in the port counters
Date: Fri, 11 Dec 2015 12:25:34 -0600
Message-ID: <20151211182543.229518282@linux.com>
References: <20151211182532.332343651@linux.com>
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=0002-IB-core-Support-64-bit-values-in-the-port-counters.patch
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a branch to display 64 bit values

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 1c8716f..0083a4f 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -378,6 +378,11 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
 		ret = sprintf(buf, "%u\n",
 			      be32_to_cpup((__be32 *)(out_mad->data + 40 + offset / 8)));
 		break;
+	case 64:
+		ret = sprintf(buf, "%llu\n",
+				be64_to_cpup((__be64 *)(out_mad->data + 40 + offset / 8)));
+		break;
+
 	default:
 		ret = 0;
 	}
-- 
2.5.0


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
