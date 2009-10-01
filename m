From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [OPENSM] cast to remove warnings about signed vs. unsigned
 comparisons
Date: Thu, 1 Oct 2009 09:14:50 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C86E862B@orsmsx501.amr.corp.intel.com>
References: <839303D0FDC14F77AE516FDC9CF8B6A7@amr.corp.intel.com>
 <20091001155613.GN17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001155613.GN17846@me>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Sasha Khapyorsky wrote:
> On 13:30 Wed 30 Sep     , Stan C. Smith wrote:
>>
>> Use (unsigned) cast to remove compiler warnings for signed component
>> in comparison (for loops) . In a couple of cases use unsigned
>> instead of int for the variable declaration.
>>
>> Signed-off-by: Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Applied. Thanks.
>
> Basically I prefer to avoid castings when possible - much better is to
> use proper types. So I'm adding the patch below, hope that it is fine
> for you.

Hello,
  I agree, avoiding casting when possible is a much better approach. Currently I have been attempting to minimize code changes and leaning towards cosmetic casting in lieu of potentially breaking working code.

You know the code base far better than I, these patches are for review from eyes with more OpenSM experience.

Upcoming patches do contain a fair amount of casting for those assignment cases where IB defined fields uint8_t/uint16_t are assiged from larger sized variable. Will examine code in further detail favoring var declaration changes for signed/unsigned comparisions.
W.r.t. opensm/* files, the end is in sight. There are 18 more patch files coming, will reinspect for less casting.

Stan.

>
> In general to simplify a detection of such cases we can consider to
> use -Wsign-compare gcc flag in linux environment.
>
> Sasha
>
>
> commit 3b30f3b1311b44f3e2042ea2c4e180ffa8291532
> Author: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
> Date:   Thu Oct 1 17:50:04 2009 +0200
>
>     opensm/osm_mesh.c: remove some castings
>
>     Instead of casting for preventing different sign comparison
>     warnings use unsigned types for affected variables.
>
>     Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>
> diff --git a/opensm/opensm/osm_mesh.c b/opensm/opensm/osm_mesh.c
> index 8235e55..e5c53d9 100644
> --- a/opensm/opensm/osm_mesh.c
> +++ b/opensm/opensm/osm_mesh.c
> @@ -58,7 +58,7 @@
>  static const struct mesh_info {
>       int dimension;                  /* dimension of the torus */
>       int size[MAX_DIMENSION];        /* size of the torus */
> -     int degree;                     /* degree of polynomial */
> +     unsigned int degree;            /* degree of polynomial */
>       int poly[MAX_DEGREE+1];         /* polynomial */
>  } mesh_info[] = {
>       {0, {0},       0, {0},                                  },
> @@ -263,7 +263,7 @@ static char *poly_print(int n, int *coeff)
>   *
>   * return a nonzero value if polynomials differ else 0
>   */
> -static int poly_diff(int n, const int *p, switch_t *s)
> +static int poly_diff(unsigned int n, const int *p, switch_t *s)
>  {
>       if (s->node->num_links != n)
>               return 1;
> @@ -591,13 +591,13 @@ static int get_switch_metric(lash_t *p_lash,
>  int sw) {
>       osm_log_t *p_log = &p_lash->p_osm->log;
>       int ret = -1;
> -     int i, j, change;
> +     unsigned int i, j, change;
>       int sw1, sw2, sw3;
>       switch_t *s = p_lash->switches[sw];
>       switch_t *s1, *s2, *s3;
>       int **m;
>       mesh_node_t *node = s->node;
> -     int num_links = node->num_links;
> +     unsigned int num_links = node->num_links;
>
>       OSM_LOG_ENTER(p_log);
>
> @@ -622,7 +622,7 @@ static int get_switch_metric(lash_t *p_lash, int
>                                       sw) s2 = p_lash->switches[sw2];
>                                       if (s2->node->temp == LARGE)
>                                               continue;
> -                                     for (j = 0; (unsigned)j < s2->node->num_links; j++) {
> +                                     for (j = 0; j < s2->node->num_links; j++) {
>                                               sw3 = s2->node->links[j]->switch_id;
>                                               s3 = p_lash->switches[sw3];
>
> @@ -925,8 +925,8 @@ static void make_geometry(lash_t *p_lash, int sw)
>       int num_switches = p_lash->num_switches;
>       int sw1, sw2;
>       switch_t *s, *s1, *s2, *seed;
> -     int i, j, k, l, n, m;
> -     int change;
> +     unsigned int i, j, k, l, n, m;
> +     unsigned int change;
>
>       OSM_LOG_ENTER(p_log);
>
> @@ -956,7 +956,7 @@ static void make_geometry(lash_t *p_lash, int sw)
>                       /*
>                        * ignore chain fragments
>                        */
> -                     if ((unsigned)n < seed->node->num_links && n <= 2)
> +                     if (n < seed->node->num_links && n <= 2)
>                               continue;
>
>                       /*
> @@ -1068,11 +1068,11 @@ static void make_geometry(lash_t *p_lash, int
> sw)
>                                        * find switch (other than s1) that neighbors i and j
>                                        * have in common
>                                        */
> -                                     for (k = 0; (unsigned)k < s1->node->num_links; k++) {
> +                                     for (k = 0; k < s1->node->num_links; k++) {
>                                               if (s1->node->links[k]->switch_id == sw1)
>                                                       continue;
>
> -                                             for (l = 0; (unsigned)l < s2->node->num_links; l++) {
> +                                             for (l = 0; l < s2->node->num_links; l++) {
>                                                       if (s2->node->links[l]->switch_id == sw1)
>                                                               continue;
>
> @@ -1204,11 +1204,11 @@ static int reorder_node_links(lash_t *p_lash,
>  mesh_t *mesh, int sw) static int make_coord(lash_t *p_lash, mesh_t
>  *mesh, int seed) {
>       osm_log_t *p_log = &p_lash->p_osm->log;
> -     int i, j, k;
> +     unsigned int i, j, k;
>       int sw;
>       switch_t *s, *s1;
> -     int change;
> -     int dimension = mesh->dimension;
> +     unsigned int change;
> +     unsigned int dimension = mesh->dimension;
>       int num_switches = p_lash->num_switches;
>       int assigned_axes = 0, unassigned_axes = 0;
>
> @@ -1228,7 +1228,7 @@ static int make_coord(lash_t *p_lash, mesh_t
>               *mesh, int seed) for (i = 0; i < dimension; i++)
>                       s->node->coord[i] = (sw == seed) ? 0 : LARGE;
>
> -             for (i = 0; (unsigned)i < s->node->num_links; i++)
> +             for (i = 0; i < s->node->num_links; i++)
>                       if (s->node->axes[i] == 0)
>                               unassigned_axes++;
>                       else
> @@ -1246,7 +1246,7 @@ static int make_coord(lash_t *p_lash, mesh_t
>                       *mesh, int seed) if (s->node->coord[0] == LARGE)
>                               continue;
>
> -                     for (j = 0; (unsigned)j < s->node->num_links; j++) {
> +                     for (j = 0; j < s->node->num_links; j++) {
>                               if (!s->node->axes[j])
>                                       continue;
>
> @@ -1254,7 +1254,7 @@ static int make_coord(lash_t *p_lash, mesh_t
> *mesh, int seed)
>
>                               for (k = 0; k < dimension; k++) {
>                                       int coord = s->node->coord[k];
> -                                     int axis = s->node->axes[j] - 1;
> +                                     unsigned axis = s->node->axes[j] - 1;
>
>                                       if (k == axis/2)
>                                               coord += (axis & 1)? -1 : +1;
> @@ -1395,8 +1395,8 @@ static int compare_switches(const void *p1,
>   const void *p2) */
>  static void sort_switches(lash_t *p_lash, mesh_t *mesh)
>  {
> -     int i, j;
> -     int num_switches = p_lash->num_switches;
> +     unsigned int i, j;
> +     unsigned int num_switches = p_lash->num_switches;
>       comp_t *comp;
>       int *reverse;
>       switch_t *s;
> @@ -1426,7 +1426,7 @@ static void sort_switches(lash_t *p_lash,
>               mesh_t *mesh) s = p_lash->switches[comp[i].index];
>               switches[i] = s;
>               s->id = i;
> -             for (j = 0; (unsigned)j < s->node->num_links; j++)
> +             for (j = 0; j < s->node->num_links; j++)
>                       s->node->links[j]->switch_id =
>                               reverse[s->node->links[j]->switch_id];
>       }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
