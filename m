From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: Re: [PATCH] remove unnecessary leading '/' from filename
Date: Mon, 12 Oct 2009 23:54:55 +0200
Message-ID: <20091012215455.GK13830@me>
References: <784A3771E5D143179461A7D5151AE78C@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <784A3771E5D143179461A7D5151AE78C@amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Stan C. Smith" <stan.smith@intel.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 16:46 Wed 07 Oct     , Stan C. Smith wrote:
> 
> In osm_db_domain_init() the filename is appended to a path string 'db_dir_name' which contains a trailing '/'.
> Remove extra '/'.
> 
> Signed-off-by: stan smith <stan.smith@intel.com>
> 
> diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
> index 947fe7a..1704054 100644
> --- a/opensm/opensm/osm_lid_mgr.c
> +++ b/opensm/opensm/osm_lid_mgr.c
> @@ -239,7 +239,7 @@ ib_api_status_t osm_lid_mgr_init(IN osm_lid_mgr_t * p_mgr, IN osm_sm_t * sm)
>  	p_mgr->p_lock = sm->p_lock;
>  
>  	/* we initialize and restore the db domain of guid to lid map */
> -	p_mgr->p_g2l = osm_db_domain_init(p_mgr->p_db, "/guid2lid");
> +	p_mgr->p_g2l = osm_db_domain_init(p_mgr->p_db, "guid2lid");

I think that this can break when OSM_CACHE_DIR is supplied as
environment variable and its value doesn't have '/' at the end. The
patch below is from 2007 and it fixed this issue.

Sasha


commit 907b95ec02d6a794ee8f6d6996cc6350a476bd15
Author: Albert L. Chu <chu11@llnl.gov>
Date:   Wed Mar 14 07:08:58 2007 -0500

    OpenSM: Fix cache filename corner case
    
    Signed-off-by: Albert L. Chu <chu11@llnl.gov>
    Signed-off-by: Hal Rosenstock <halr@voltaire.com>

diff --git a/osm/opensm/osm_lid_mgr.c b/osm/opensm/osm_lid_mgr.c
index 89adc48..bd5945f 100644
--- a/osm/opensm/osm_lid_mgr.c
+++ b/osm/opensm/osm_lid_mgr.c
@@ -282,7 +282,7 @@ osm_lid_mgr_init(
   p_mgr->p_req = p_req;
 
   /* we initialize and restore the db domain of guid to lid map */
-  p_mgr->p_g2l = osm_db_domain_init(p_mgr->p_db, "guid2lid");
+  p_mgr->p_g2l = osm_db_domain_init(p_mgr->p_db, "/guid2lid");
   if (! p_mgr->p_g2l)
   {
     osm_log( p_mgr->p_log, OSM_LOG_ERROR,
diff --git a/osm/opensm/osm_subnet.c b/osm/opensm/osm_subnet.c
index 99e39aa..cbb3549 100644
--- a/osm/opensm/osm_subnet.c
+++ b/osm/opensm/osm_subnet.c
@@ -745,7 +745,7 @@ osm_subn_rescan_conf_file(
     p_cache_dir = OSM_DEFAULT_CACHE_DIR;
 
   strcpy(file_name, p_cache_dir);
-  strcat(file_name, "opensm.opts");
+  strcat(file_name, "/opensm.opts");
   
   opts_file = fopen(file_name, "r");
   if (!opts_file)
@@ -838,7 +838,7 @@ osm_subn_parse_conf_file(
     p_cache_dir = OSM_DEFAULT_CACHE_DIR;
 
   strcpy(file_name, p_cache_dir);
-  strcat(file_name, "opensm.opts");
+  strcat(file_name, "/opensm.opts");
   
   opts_file = fopen(file_name, "r");
   if (!opts_file) return;
@@ -1096,7 +1096,7 @@ osm_subn_write_conf_file(
     p_cache_dir = OSM_DEFAULT_CACHE_DIR;
 
   strcpy(file_name, p_cache_dir);
-  strcat(file_name, "opensm.opts");
+  strcat(file_name, "/opensm.opts");
   
   opts_file = fopen(file_name, "w");
   if (!opts_file) return;

>  	if (!p_mgr->p_g2l) {
>  		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 0316: "
>  			"Error initializing Guid-to-Lid persistent database\n");
> 
