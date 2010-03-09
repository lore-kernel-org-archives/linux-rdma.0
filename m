From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: infiniband-diags/ibstatus: add link_layer for RoCEE support
Date: Tue, 09 Mar 2010 12:37:38 +0200
Message-ID: <4B9624F2.1000507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RoCEE introduces new file in sysfs: "link_layer".
Assume IB if the file doesn't exist (driver w/o RoCEE support).

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 infiniband-diags/scripts/ibstatus |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/scripts/ibstatus b/infiniband-diags/scripts/ibstatus
index 87fbb0c..f7fbbc2 100755
--- a/infiniband-diags/scripts/ibstatus
+++ b/infiniband-diags/scripts/ibstatus
@@ -31,6 +31,7 @@ port_status() {
 	echo "	state:		" `[ -r $port_dir/state ] && cat $port_dir/state || echo unknown`
 	echo "	phys state:	" `[ -r $port_dir/phys_state ] && cat $port_dir/phys_state || echo unknown`
 	echo "	rate:		" `[ -r $port_dir/rate ] && cat $port_dir/rate || echo unknown`
+	echo "	link_layer:	" `[ -r $port_dir/link_layer ] && cat $port_dir/link_layer || echo IB`
 	echo
 }

-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
