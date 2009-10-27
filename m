From: "Stan C. Smith" <stan.smith@intel.com>
Subject: [PATCH] opemsm code cleanup
Date: Tue, 27 Oct 2009 10:43:38 -0700
Message-ID: <394674AC37584063BC9059F30CB083C9@amr.corp.intel.com>
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
Cc: linux-rdma@vger.kernel.org, ofw@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org


Cleanup code by removing if statement which does nothing.

Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
index 9e43a9c..ee9626f 100644
--- a/opensm/opensm/osm_vl15intf.c
+++ b/opensm/opensm/osm_vl15intf.c
@@ -271,9 +271,6 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
         */
        status = cl_thread_init(&p_vl->poller, vl15_poller, p_vl,
                                "opensm poller");
-       if (status != IB_SUCCESS)
-               goto Exit;
-
 Exit:
        OSM_LOG_EXIT(p_log);
        return (status);
