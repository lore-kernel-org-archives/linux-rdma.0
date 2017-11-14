From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 1/6] debian: Let libibverbs1 16 break ibverbs-providers 15
Date: Tue, 14 Nov 2017 21:02:42 +0100
Message-ID: <20171114200247.25890-2-benjamin.drung@profitbricks.com>
References: <20171114200247.25890-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114200247.25890-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ibverbs-providers uses the private symbols of libibverbs1. Thus
libibverbs1 will not work with an old version version of
ibverbs-providers if the private symbol version is bumped.

Bump the ibverbs-providers version that libibverbs1 breaks which was
forgotten on the symbol version bump. See also commit
611b7cc3b8e0d79aa986f042f486fccc95d73679. Append a tilde to support
the lower version numbers (e.g. 16~201711132208) in the PPA builds.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index c5f7a052..8c0957c7 100644
--- a/debian/control
+++ b/debian/control
@@ -137,7 +137,7 @@ Section: libs
 Pre-Depends: ${misc:Pre-Depends}
 Depends: adduser, ${misc:Depends}, ${shlibs:Depends}
 Recommends: ibverbs-providers
-Breaks: ibverbs-providers (<< 14)
+Breaks: ibverbs-providers (<< 16~)
 Description: Library for direct userspace use of RDMA (InfiniBand/iWARP)
  libibverbs is a library that allows userspace processes to use RDMA
  "verbs" as described in the InfiniBand Architecture Specification and
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
