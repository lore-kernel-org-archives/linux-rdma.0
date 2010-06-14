From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] iba/ib_types.h: remove assertion in ib_get_attr_offset()
Date: Mon, 14 Jun 2010 16:04:04 +0300
Message-ID: <20100614130404.GZ20172@me>
References: <20100603134209.GA12225@comcast.net>
 <20100609054341.GK28549@me>
 <AANLkTilkr6KYG_TVJYwvNl7sZ8XBKmFljktxg8qCA9t9@mail.gmail.com>
 <20100609121036.GC20172@me>
 <AANLkTikTxpvb-Nw2V1PrBcX4rZ1GwElXV22CBtBZx1iK@mail.gmail.com>
 <20100609124848.GE20172@me>
 <AANLkTinxeLPtxYPvPBZfWq96BZjxDqcAlCzP2v_1VJnv@mail.gmail.com>
 <20100609171516.GI20172@me>
 <3F6F638B8D880340AB536D29CD4C1E1925634C8FE9@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1925634C8FE9-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This reverts the commit:

commit 7fc6cd3037f07190e483a047f17d37b6bebbb2b3
Author: Smith, Stan <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Fri May 21 10:49:27 2010 -0700

    ib_types.h add debug assert

    Add a debug assert to catch incorrect MAD attr offset size.
    This proved to be useful in catching incorrect struct sizes as MAD attrs need to be a multiple of 8 bytes.

Since not all SA attributes should be multiple of 8 bytes (specifically
InformInfo).

The issue was discovered by Hal Rosenstock.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/include/iba/ib_types.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
index 203c319..e1bc102 100644
--- a/opensm/include/iba/ib_types.h
+++ b/opensm/include/iba/ib_types.h
@@ -4395,7 +4395,6 @@ static inline uint32_t OSM_API ib_get_attr_size(IN const ib_net16_t attr_offset)
 
 static inline ib_net16_t OSM_API ib_get_attr_offset(IN const uint32_t attr_size)
 {
-	CL_ASSERT((attr_size & 0x07) == 0);
 	return (cl_hton16((uint16_t) (attr_size >> 3)));
 }
 
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
