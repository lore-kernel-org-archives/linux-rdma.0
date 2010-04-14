From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] fix libibnetdisc portguid hashing corner case
Date: Wed, 14 Apr 2010 10:48:03 -0700
Message-ID: <1271267283.17987.120.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-AGpxeOJ1+9KcFodBXF9V"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-AGpxeOJ1+9KcFodBXF9V
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

This patch fixes a corner case in libibnetdisc that was storing
portguids w/ a guid of 0.

This bug was relatively innoucuous for ibnetdiscover b/c ibnetdiscover
does not output these ports.  However, it became a problem for me in the
caching library as I attempted to reconstruct a fabric, and multiple
ports were identifying themselves with identical guids [1].

Al

[1] - The fact the caching code assumes duplicate guids can't exist is
also a bug.  But that's for another patch.  This is a bug by itself.

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-AGpxeOJ1+9KcFodBXF9V
Content-Disposition: attachment; filename=0001-fix-libibnetdisc-portguid-hashing-corner-case.patch
Content-Type: message/rfc822; name=0001-fix-libibnetdisc-portguid-hashing-corner-case.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 13 Apr 2010 14:01:43 -0700
Subject: [PATCH] fix libibnetdisc portguid hashing corner case
Message-Id: <1271264633.17987.112.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index c895de9..6010a28 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -173,6 +173,7 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			IBND_ERROR("Failed to allocate port\n");
 			return -1;
 		}
+		port->guid = mad_get_field64(node->info, 0, IB_NODE_PORT_GUID_F);
 	}
 
 	memcpy(port->info, port_info, sizeof(port->info));
-- 
1.5.4.5


--=-AGpxeOJ1+9KcFodBXF9V--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
