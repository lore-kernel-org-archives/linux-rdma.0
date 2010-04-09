From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] fix libibnetdisc corner case when user tries to
	re-cache a loaded cache
Date: Fri, 09 Apr 2010 10:24:50 -0700
Message-ID: <1270833890.17987.16.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-4Izw8VEN07aYF7FXZ9+F"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-4Izw8VEN07aYF7FXZ9+F
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

Noticed this corner case.  If I load a ibnetdiscover cache, then try to
re-cache it, the cache doesn't store things properly b/c I didn't
reconstruct one fabric data structure properly.  This fixes that bug.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-4Izw8VEN07aYF7FXZ9+F
Content-Disposition: attachment; filename*0=0001-fix-libibnetdisc-corner-case-when-user-tries-to-re-c.pat; filename*1=ch
Content-Type: message/rfc822; name=0001-fix-libibnetdisc-corner-case-when-user-tries-to-re-c.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Fri, 9 Apr 2010 10:12:47 -0700
Subject: [PATCH] fix libibnetdisc corner case when user tries to re-cache a
	loaded cache
Message-Id: <1270833600.17987.15.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/src/ibnetdisc_cache.c             |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
index d94b85a..9cd5981 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
@@ -501,6 +501,10 @@ static int _fill_port(ibnd_fabric_cache_t * fabric_cache, ibnd_node_t * node,
 
 	node->ports[port_cache->port->portnum] = port_cache->port;
 
+	/* achu: needed if user wishes to re-cache a loaded fabric.
+	 * Otherwise, mostly unnecessary to do this.
+	 */
+	add_to_portguid_hash(port_cache->port, fabric_cache->fabric->portstbl);
 	return 0;
 }
 
-- 
1.5.4.5


--=-4Izw8VEN07aYF7FXZ9+F--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
