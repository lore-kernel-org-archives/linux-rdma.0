From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_base.h: remove trailing '/' in
 OSM_DEFAULT_CACHE_DIR
Date: Sat, 28 Nov 2009 16:27:21 +0200
Message-ID: <20091128142721.GC16607@me>
References: <784A3771E5D143179461A7D5151AE78C@amr.corp.intel.com>
 <20091012215455.GK13830@me>
 <3F6F638B8D880340AB536D29CD4C1E1912C896BBDA@orsmsx501.amr.corp.intel.com>
 <20091128142342.GA16607@me>
 <20091128142626.GB16607@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091128142626.GB16607@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Remove trailing '/' character in OSM_DEFAULT_CACHE_DIR definition as
well as misleading comment about its mandatory status.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/opensm/osm_base.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/opensm/include/opensm/osm_base.h b/opensm/include/opensm/osm_base.h
index 9d8bf98..4e9aaa9 100644
--- a/opensm/include/opensm/osm_base.h
+++ b/opensm/include/opensm/osm_base.h
@@ -192,14 +192,13 @@ BEGIN_C_DECLS
 *
 * DESCRIPTION
 *	Specifies the default cache directory for the db files.
-*	Note that the directory must appear with "/" ("\\" for windows) at the end.
 *
 * SYNOPSIS
 */
 #ifdef __WIN__
 #define OSM_DEFAULT_CACHE_DIR GetOsmCachePath()
 #else
-#define OSM_DEFAULT_CACHE_DIR "/var/cache/opensm/"
+#define OSM_DEFAULT_CACHE_DIR "/var/cache/opensm"
 #endif
 /***********/
 /****d* OpenSM: Base/OSM_DEFAULT_LOG_FILE
-- 
1.6.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
