From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH 1/2] consistently type lids and lmcs
	libibnetdisc
Date: Fri, 06 Nov 2009 10:14:21 -0800
Message-ID: <1257531261.18550.69.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-VMe/YYLgIaojTvm95TNg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-VMe/YYLgIaojTvm95TNg
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

The ibnd_port_t lid and lmc are typed uint16_t/uint8_t, but the
ibnd_node_t smalid and smalmc are typed int/int.  This patch turns the
ints into uint16_t/uint8_t.

Naturally, we can do the opposite, but it should be consistent one way
or the other.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-VMe/YYLgIaojTvm95TNg
Content-Disposition: attachment; filename=0001-consistently-type-lids-and-lmcs-libibnetdisc.patch
Content-Type: text/plain; name=0001-consistently-type-lids-and-lmcs-libibnetdisc.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 5 Nov 2009 14:58:11 -0800
Subject: [PATCH] consistently type lids and lmcs libibnetdisc


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index 37de342..e8ceff7 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -49,8 +49,8 @@ typedef struct ibnd_node {
 	struct ibnd_node *next;	/* all node list in fabric */
 
 	ib_portid_t path_portid;	/* path from "from_node" */
-	int smalid;
-	int smalmc;
+	uint16_t smalid;
+	uint8_t smalmc;
 
 	/* quick cache of switchinfo below */
 	int smaenhsp0;
-- 
1.5.4.5


--=-VMe/YYLgIaojTvm95TNg--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
