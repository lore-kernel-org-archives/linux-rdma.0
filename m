From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: support 2.6.9
Date: Tue, 1 Jun 2010 10:33:51 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F3A661F@orsmsx501.amr.corp.intel.com>
References: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com>
 <4C024C35.2090703@dev.mellanox.co.il>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF255F3A63BD@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F3A63BD-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Redhat 4.x is based on 2.6.9.  Add support for older kernels.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This should fix the OFED build errors on RH 4.x.  When testing this on a
RH 4.x system, I noticed additional build warnings on 32-bit systems.
I'll add a fix for these warnings separately. 

 include/infiniband/ib.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/ib.h b/include/infiniband/ib.h
index 3a97322..2e5029a 100644
--- a/include/infiniband/ib.h
+++ b/include/infiniband/ib.h
@@ -43,6 +43,16 @@
 #define PF_IB AF_IB
 #endif
 
+#ifndef __be16
+#define __be16 __u16
+#endif
+#ifndef __be32
+#define __be32 __u32
+#endif
+#ifndef __be64
+#define __be64 __u64
+#endif
+
 struct ib_addr {
 	union {
 		__u8		uib_addr8[16];


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
