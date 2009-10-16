From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fix LFT allocation size
Date: Fri, 16 Oct 2009 13:53:26 +0200
Message-ID: <20091016115326.GN20210@me>
References: <20091016002810.GA16243@sgi.com>
 <20091016105811.GM20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091016105811.GM20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dale Purdy <purdy-sJ/iWh9BUns@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix LFT allocation size - count zero entry as well.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_switch.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_switch.c b/opensm/opensm/osm_switch.c
index ed0bc66..67e3ede 100644
--- a/opensm/opensm/osm_switch.c
+++ b/opensm/opensm/osm_switch.c
@@ -497,8 +497,7 @@ static int alloc_lft(IN osm_switch_t * p_sw, uint16_t lids)
 	uint16_t lft_size;
 
 	/* Ensure LFT is in units of LFT block size */
-	lft_size = (lids + IB_SMP_DATA_SIZE - 1) / IB_SMP_DATA_SIZE * IB_SMP_DATA_SIZE;
-
+	lft_size = (lids / IB_SMP_DATA_SIZE + 1) * IB_SMP_DATA_SIZE;
 	if (lft_size > p_sw->lft_size) {
 		uint8_t *new_lft = realloc(p_sw->lft, lft_size);
 		if (!new_lft)
-- 
1.6.5
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
