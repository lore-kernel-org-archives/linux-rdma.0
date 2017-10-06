From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 40/47] IB/qib: Make qib_inc_eeprom_err() macro more safe to use
Date: Fri,  6 Oct 2017 14:33:26 -0700
Message-ID: <20171006213333.6721-41-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that using the qib_inc_eeprom_err() macro in an if-statement
triggers the following compiler warning:

warning: suggest braces around empty body in an 'if' statement [-Wempty-body]

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 1167a9c1776b..f2fffbd3e95c 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1297,7 +1297,7 @@ int qib_twsi_blk_rd(struct qib_devdata *dd, int dev, int addr, void *buffer,
 int qib_twsi_blk_wr(struct qib_devdata *dd, int dev, int addr,
 		    const void *buffer, int len);
 void qib_get_eeprom_info(struct qib_devdata *);
-#define qib_inc_eeprom_err(dd, eidx, incr)
+#define qib_inc_eeprom_err(dd, eidx, incr) do { } while (0)
 void qib_dump_lookup_output_queue(struct qib_devdata *);
 void qib_force_pio_avail_update(struct qib_devdata *);
 void qib_clear_symerror_on_linkup(unsigned long opaque);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
