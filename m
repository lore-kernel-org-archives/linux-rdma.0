From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: Re: [PATCH] C++ style coding does not compile
Date: Sun, 4 Oct 2009 02:15:30 +0200
Message-ID: <20091004001530.GL17846@me>
References: <3F6F638B8D880340AB536D29CD4C1E1912C86E8BA3@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1912C86E8BA3@orsmsx501.amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Smith, Stan" <stan.smith@intel.com>
Cc: "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 16:09 Thu 01 Oct     , Smith, Stan wrote:
> 
> Move C++ in-stream var declarations to top of {} block as in C style; Var assignments left in place.
> MSFT compiler errors out with Missing ';' before 'type', 'Illegal use of this type osm_prefix_route_t as an expression'?
> 
> 
> Signed-off-by: stan smith <stan.smith@intel.com>

In this patch whitespace characters are mangled.

Applied by hands. Thanks.

Sasha

> 
> diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
> index 2247ebe..1166def 100644
> --- a/opensm/opensm/osm_sa_path_record.c
> +++ b/opensm/opensm/osm_sa_path_record.c
> @@ -1214,6 +1214,10 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
>                         if (!ib_gid_is_multicast(&p_pr->dgid) &&
>                             ib_gid_get_subnet_prefix(&p_pr->dgid) !=
>                             sa->p_subn->opt.subnet_prefix) {
> +
> +                               osm_prefix_route_t *route;
> +                               osm_prefix_route_t *r;
> +
>                                 OSM_LOG(sa->p_log, OSM_LOG_VERBOSE,
>                                         "Non local DGID subnet prefix 0x%016"
>                                         PRIx64 "\n",
> @@ -1221,11 +1225,9 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
> 
>                                 /* Find the router port that is configured to
>                                    handle this prefix, if any */
> -                               osm_prefix_route_t *route = NULL;
> -                               osm_prefix_route_t *r = (osm_prefix_route_t *)
> -                                   cl_qlist_head(&sa->p_subn->
> -                                                 prefix_routes_list);
> -
> +                               route = NULL;
> +                               r = (osm_prefix_route_t *) cl_qlist_head(
> +                                       &sa->p_subn->prefix_routes_list);
>                                 while (r != (osm_prefix_route_t *)
>                                        cl_qlist_end(&sa->p_subn->
>                                                     prefix_routes_list)) {
> 
