From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
Subject: [RFC PATCH 1/3] libibverbs: Fix libtool configure warning
Date: Thu, 29 Jul 2010 11:31:51 -0500
Message-ID: <20100729163151.14901.60182.stgit@build.ogc.int>
References: <20100729163030.14901.87547.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100729163030.14901.87547.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, brandt-4OHPYypu0djtX7QSmKvirg@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org, swise-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Added AC_PROG_LIBTOOL to configure.in to fix an autogen.sh warning about
LIBTOOL configuration.

Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
---

 configure.in |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/configure.in b/configure.in
index 927c406..2bb4aee 100644
--- a/configure.in
+++ b/configure.in
@@ -12,6 +12,7 @@ dnl Checks for programs
 AC_PROG_CC
 AC_GNU_SOURCE
 AC_PROG_LN_S
+AC_PROG_LIBTOOL
 
 LT_INIT
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
