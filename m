From: "Smith, Stan" <stan.smith@intel.com>
Subject: [PATCH] C++ style coding does not compile
Date: Thu, 1 Oct 2009 16:09:42 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C86E8BA3@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: Sasha Khapyorsky <sashak@voltaire.com>
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


Move C++ in-stream var declarations to top of {} block as in C style; Var a=
ssignments left in place.
MSFT compiler errors out with Missing ';' before 'type', 'Illegal use of th=
is type osm_prefix_route_t as an expression'?


Signed-off-by: stan smith <stan.smith@intel.com>

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path=
_record.c
index 2247ebe..1166def 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -1214,6 +1214,10 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t =
* sa,
                        if (!ib_gid_is_multicast(&p_pr->dgid) &&
                            ib_gid_get_subnet_prefix(&p_pr->dgid) !=3D
                            sa->p_subn->opt.subnet_prefix) {
+
+                               osm_prefix_route_t *route;
+                               osm_prefix_route_t *r;
+
                                OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
                                        "Non local DGID subnet prefix 0x%01=
6"
                                        PRIx64 "\n",
@@ -1221,11 +1225,9 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t =
* sa,

                                /* Find the router port that is configured =
to
                                   handle this prefix, if any */
-                               osm_prefix_route_t *route =3D NULL;
-                               osm_prefix_route_t *r =3D (osm_prefix_route=
_t *)
-                                   cl_qlist_head(&sa->p_subn->
-                                                 prefix_routes_list);
-
+                               route =3D NULL;
+                               r =3D (osm_prefix_route_t *) cl_qlist_head(
+                                       &sa->p_subn->prefix_routes_list);
                                while (r !=3D (osm_prefix_route_t *)
                                       cl_qlist_end(&sa->p_subn->
                                                    prefix_routes_list)) {
