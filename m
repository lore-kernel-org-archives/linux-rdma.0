From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] opensm: Create all directories in database path on
 Windows
Date: Thu, 28 Apr 2011 10:31:01 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3BD2@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCD82F9D@orsmsx501.amr.corp.intel.com>
 <3F6F638B8D880340AB536D29CD4C1E1925F1EFC4F0@orsmsx501.amr.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCD8326A@orsmsx501.amr.corp.intel.com>
 <BANLkTincBjF3CuHq+q2-Xr5Fby9y-Xox4g@mail.gmail.com>
 <3F6F638B8D880340AB536D29CD4C1E1925F1EFC9BC@orsmsx501.amr.corp.intel.com>
 <BANLkTi=pqaQSir3iCNLiety-jvF2xGJBcw@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCD83A1B@orsmsx501.amr.corp.intel.com>
 <20110426134141.GA9750@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110426134141.GA9750-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Replace CreateDirectory with SHCreateDirectoryEx, so that
intermediate directories in the database path are created.

This fixes an issue where opensm fails to start unless the
path has been created beforehand.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
change from v1: used common error handling

 opensm/osm_db_files.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)
 mode change 100644 => 100755 opensm/osm_db_files.c

diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
index 18ac830..3182da4
--- a/opensm/osm_db_files.c
+++ b/opensm/osm_db_files.c
@@ -169,19 +169,19 @@ int osm_db_init(IN osm_db_t * p_db, IN osm_log_t * p_log)
 	/* Create the directory if it doesn't exist */
 	/* There is a difference in creating directory between windows and linux */
 #ifdef __WIN__
-	/* Check if the directory exists. If not - create it. */
-	CreateDirectory(p_db_imp->db_dir_name, NULL);
+	{
+		int ret;
+
+		ret = SHCreateDirectoryEx(NULL, p_db_imp->db_dir_name, NULL);
+		if (ret != ERROR_SUCCESS && ret != ERROR_ALREADY_EXISTS &&
+			ret != ERROR_FILE_EXISTS)
+			goto err;
+	}
 #else				/* __WIN__ */
 	/* make sure the directory exists */
 	if (lstat(p_db_imp->db_dir_name, &dstat)) {
-		if (mkdir(p_db_imp->db_dir_name, 0755)) {
-			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6101: "
-				"Failed to create the db directory:%s\n",
-				p_db_imp->db_dir_name);
-			free(p_db_imp);
-			OSM_LOG_EXIT(p_log);
-			return 1;
-		}
+		if (mkdir(p_db_imp->db_dir_name, 0755))
+			goto err;
 	}
 #endif
 
@@ -193,6 +193,14 @@ int osm_db_init(IN osm_db_t * p_db, IN osm_log_t * p_log)
 	OSM_LOG_EXIT(p_log);
 
 	return 0;
+
+err:
+	OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 6101: "
+		"Failed to create the db directory:%s\n",
+		p_db_imp->db_dir_name);
+	free(p_db_imp);
+	OSM_LOG_EXIT(p_log);
+	return 1;
 }
 
 osm_db_domain_t *osm_db_domain_init(IN osm_db_t * p_db, IN char *domain_name)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
