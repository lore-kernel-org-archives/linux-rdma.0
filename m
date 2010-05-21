From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ib_types.h add debug assert
Date: Fri, 21 May 2010 10:49:27 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E192562EBBC01@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add a debug assert to catch incorrect MAD attr offset size.
This proved to be useful in catching incorrect struct sizes as MAD attrs need to be a multiple of 8 bytes.

signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
index e1bc102..203c319 100644
--- a/opensm/include/iba/ib_types.h
+++ b/opensm/include/iba/ib_types.h
@@ -4395,6 +4395,7 @@ static inline uint32_t OSM_API ib_get_attr_size(IN const ib_net16_t attr_offset)

 static inline ib_net16_t OSM_API ib_get_attr_offset(IN const uint32_t attr_size)
 {
+       CL_ASSERT((attr_size & 0x07) == 0);
        return (cl_hton16((uint16_t) (attr_size >> 3)));
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
