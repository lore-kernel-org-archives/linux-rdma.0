From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH]  use transportable constant attributes
Date: Wed, 7 Oct 2009 09:32:57 -0700
Message-ID: <743562BB0B3D481CBA03C8E21DA478D1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor/osm_vendor_ibumad.c
index e5f0c54..8d3c680 100644
--- a/opensm/libvendor/osm_vendor_ibumad.c
+++ b/opensm/libvendor/osm_vendor_ibumad.c
@@ -126,7 +126,7 @@ Exit:
 static osm_madw_t *get_madw(osm_vendor_t * p_vend, ib_net64_t * tid)
 {
 	umad_match_t *m, *e;
-	ib_net64_t mtid = (*tid & CL_HTON64(0x00000000ffffffffllu));
+	ib_net64_t mtid = (*tid & CL_HTON64(0x00000000ffffffffULL));
 	osm_madw_t *res;
 
 	/*
