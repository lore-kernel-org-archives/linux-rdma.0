From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH 04/12] opensm: Fix up some torus-2QoS comments to match
 code.
Date: Fri, 18 Dec 2009 13:50:54 -0700
Message-ID: <1261169461-2516-5-git-send-email-jaschut@sandia.gov>
References: <1258744509-11148-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1258744509-11148-1-git-send-email-jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_ucast_torus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_ucast_torus.c b/opensm/opensm/osm_ucast_torus.c
index 42582ce..9e4a9eb 100644
--- a/opensm/opensm/osm_ucast_torus.c
+++ b/opensm/opensm/osm_ucast_torus.c
@@ -169,11 +169,11 @@ struct port_grp {
 /*
  * A struct t_switch is used to represent a switch as placed in a torus.
  *
- * A t_switch used to build an N-dimensional torus will have N+1 port groups,
+ * A t_switch used to build an N-dimensional torus will have 2N+1 port groups,
  * used as follows, assuming 0 <= d < N:
  *   port_grp[2d]   => links leaving in negative direction for coordinate d
  *   port_grp[2d+1] => links leaving in positive direction for coordinate d
- *   port_grp[N]    => endpoints local to switch; i.e., hosts on switch
+ *   port_grp[2N]   => endpoints local to switch; i.e., hosts on switch
  *
  * struct link objects referenced by a t_switch are assumed to be oriented:
  * traversing a link from link.end[0] to link.end[1] is always in the positive
-- 
1.5.6.GIT


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
