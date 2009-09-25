From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: [ofa-general] [PATCH] opensm/osm_ucast_lash: fix use after free bug
Date: Fri, 25 Sep 2009 17:50:45 +0300
Message-ID: <20090925145045.GF26931@me>
References: <1251486496-24812-1-git-send-email-jaschut@sandia.gov>
	<1251486496-24812-2-git-send-email-jaschut@sandia.gov>
	<20090922185014.GF24398@me>
	<1253651343.4776.1125.camel@sale659.sandia.gov>
	<20090925135256.GE26931@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <20090925135256.GE26931@me>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: OpenIB <general@lists.openfabrics.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


When LASH runs its switch structures cleanup OpenSM can rediscover a
subnet and 'p_sw' pointer may refer already freed memory, so don't touch
it, just free our own stuff. (Note also that for valids OpenSM switches
objects' 'priv' pointers are cleared on lash_cleanup()).

Signed-off-by: Sasha Khapyorsky <sashak@voltaire.com>
---
 opensm/opensm/osm_ucast_lash.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_ucast_lash.c b/opensm/opensm/osm_ucast_lash.c
index dbc6bcc..3c424cb 100644
--- a/opensm/opensm/osm_ucast_lash.c
+++ b/opensm/opensm/osm_ucast_lash.c
@@ -628,8 +628,7 @@ static switch_t *switch_create(lash_t * p_lash, unsigned id, osm_switch_t * p_sw
 	}
 
 	sw->p_sw = p_sw;
-	if (p_sw)
-		p_sw->priv = sw;
+	p_sw->priv = sw;
 
 	if (osm_mesh_node_create(p_lash, sw)) {
 		free(sw->dij_channels);
@@ -644,8 +643,6 @@ static void switch_delete(lash_t *p_lash, switch_t * sw)
 {
 	if (sw->dij_channels)
 		free(sw->dij_channels);
-	if (sw->p_sw)
-		sw->p_sw->priv = NULL;
 	free(sw);
 }
 
-- 
1.6.5.rc1
