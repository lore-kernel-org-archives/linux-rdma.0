From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [2/2] check for duplicate port guids in
	libibnetdisc cache
Date: Wed, 14 Apr 2010 15:48:01 -0700
Message-ID: <1271285281.17987.140.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ASlxzUHL6WNw67n2qiu9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-ASlxzUHL6WNw67n2qiu9
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

This patch checks for duplicate port guids in a libibnetdisc cache when
it is loaded and report an error back to the user appropriately.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-ASlxzUHL6WNw67n2qiu9
Content-Disposition: attachment; filename*0=0002-check-for-duplicate-port-guids-in-libibnetdisc-cache.pat; filename*1=ch
Content-Type: message/rfc822; name=0002-check-for-duplicate-port-guids-in-libibnetdisc-cache.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 14 Apr 2010 15:25:11 -0700
Subject: [PATCH] check for duplicate port guids in libibnetdisc cache
Message-Id: <1271285070.17987.138.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/src/ibnetdisc_cache.c             |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
index 2ec353d..a02fcba 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
@@ -505,6 +505,11 @@ static int _fill_port(ibnd_fabric_cache_t * fabric_cache, ibnd_node_t * node,
 		return -1;
 	}
 
+	if (port_cache->port_stored_to_fabric) {
+		IBND_DEBUG("Cache invalid: duplicate port discovered\n");
+		return -1;
+	}
+
 	node->ports[port_cache->port->portnum] = port_cache->port;
 	port_cache->port_stored_to_fabric++;
 
-- 
1.5.4.5


--=-ASlxzUHL6WNw67n2qiu9--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
