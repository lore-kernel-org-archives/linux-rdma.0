From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [RFC PATCH] Set HopLimit based on off subnet Re: SRP issues with
 OpenSM 3.3.3
Date: Tue, 15 Dec 2009 18:55:11 -0800
Message-ID: <20091215185511.3ae458cc.weiny2@llnl.gov>
References: <20091214164334.064102f0.weiny2@llnl.gov>
	<20091215170317.GV5262@me>
	<20091215171532.GA8288@obsidianresearch.com>
	<20091215091819.c217cf36.weiny2@llnl.gov>
	<f0e08f230912150959j536667bbg51b8381724681880@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f230912150959j536667bbg51b8381724681880-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 15 Dec 2009 12:59:11 -0500
Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Dec 15, 2009 at 12:18 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

[snip]

> 
> > The follow on would be that if they specify a
> > DGID in the PathRecord query and the result is subnet local they must still
> > use a GRH even if the packet is going to stay local?
> 
> No; with subnet local traffic, GRH is optional.
> 

Ok, if the GRH is optional with local traffic then I think the appropriate fix
is:

diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
index be0cd71..1fa83a1 100644
--- a/opensm/opensm/osm_sa_path_record.c
+++ b/opensm/opensm/osm_sa_path_record.c
@@ -757,6 +757,14 @@ Exit:
        return (status);
 }
 
+static int gid_is_off_subnet(IN osm_sa_t * sa, IN const ib_gid_t * p_dgid)
+{
+       return (!ib_gid_is_link_local(p_dgid) &&
+               !ib_gid_is_multicast(p_dgid) &&
+               ib_gid_get_subnet_prefix(p_dgid) !=
+               sa->p_subn->opt.subnet_prefix);
+}
+
 /**********************************************************************
  **********************************************************************/
 static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
@@ -770,16 +778,12 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
 {
        const osm_physp_t *p_src_physp;
        const osm_physp_t *p_dest_physp;
-       boolean_t is_nonzero_gid = 0;
 
        OSM_LOG_ENTER(sa->p_log);
 
        p_src_physp = p_src_port->p_physp;
 
        if (p_dgid)
-               is_nonzero_gid = ib_gid_is_notzero(p_dgid);
-
-       if (is_nonzero_gid)
                p_pr->dgid = *p_dgid;
        else {
                p_dest_physp = p_dest_port->p_physp;
@@ -799,7 +803,7 @@ static void pr_rcv_build_pr(IN osm_sa_t * sa, IN const osm_port_t * p_src_port,
        p_pr->hop_flow_raw &= cl_hton32(1 << 31);
 
        /* Only set HopLimit if going through a router */
-       if (is_nonzero_gid)
+       if (gid_is_off_subnet(sa, &p_pr->dgid))
                p_pr->hop_flow_raw |= cl_hton32(IB_HOPLIMIT_MAX);
 
        p_pr->pkey = p_parms->pkey;
@@ -1248,10 +1252,7 @@ static ib_net16_t pr_rcv_get_end_points(IN osm_sa_t * sa,
                memset(p_dgid, 0, sizeof(*p_dgid));
 
        if (comp_mask & IB_PR_COMPMASK_DGID) {
-               if (!ib_gid_is_link_local(&p_pr->dgid) &&
-                   !ib_gid_is_multicast(&p_pr->dgid) &&
-                   ib_gid_get_subnet_prefix(&p_pr->dgid) !=
-                   sa->p_subn->opt.subnet_prefix) {
+               if (gid_is_off_subnet(sa, &p_pr->dgid)) {
                        dest_guid = find_router(sa, p_pr->dgid.unicast.prefix);
                        if (!dest_guid) {
                                char gid_str[INET6_ADDRSTRLEN];


This maintains the p_dgid found in pr_rcv_get_end_points but appropriately
set's the HopLimit when the DGID is off subnet.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
