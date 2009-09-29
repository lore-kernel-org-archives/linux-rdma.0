From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_get_port_by_lid(): speedup a port lookup
Date: Tue, 29 Sep 2009 13:02:44 +0200
Message-ID: <20090929110244.GL26931@me>
References: <20090929110215.GK26931@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090929110215.GK26931@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Speedup a port lookup over LMC array - it is not necessary to match LMC
exactly for found port because base lid should be equal to requested lid
masked value, so '<=' comparison should be enough and we don't need to
loop up to an actual port's lmc value match.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_subnet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_subnet.c b/opensm/opensm/osm_subnet.c
index 67bc7e1..30f8af5 100644
--- a/opensm/opensm/osm_subnet.c
+++ b/opensm/opensm/osm_subnet.c
@@ -661,7 +661,7 @@ osm_port_t *osm_get_port_by_lid(IN osm_subn_t const * subn, IN ib_net16_t lid)
 		port = cl_ptr_vector_get(&subn->port_lid_tbl, base_lid);
 		/* Determine if base LID "tested" is the real base LID */
 		/* This is true if the LMC "tested" is the port's actual LMC */
-		if (port && lmc == osm_port_get_lmc(port))
+		if (port && lmc <= osm_port_get_lmc(port))
 			return port;
 	}
 
-- 
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
