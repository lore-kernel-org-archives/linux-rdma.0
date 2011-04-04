From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags.spec.in: Added dump2psl.pl and dump2slvl.pl
 scripts
Date: Mon, 04 Apr 2011 10:21:09 -0400
Message-ID: <4D99D3D5.4080809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags.spec.in |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index c50ce09..93af427 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -44,6 +44,8 @@ rm -rf $RPM_BUILD_ROOT
 %{_sbindir}/vendstat
 %{_sbindir}/dump_mfts.sh
 %{_sbindir}/dump_lfts.sh
+%{_sbindir}/dump2psl.pl
+%{_sbindir}/dump2slvl.pl
 %{_sbindir}/check_lft_balance.pl
 %{_sbindir}/set_nodedesc.sh
 %{_sbindir}/sm*
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
