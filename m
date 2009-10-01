From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] osm_subnet.c
Date: Thu, 1 Oct 2009 14:35:01 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C86E8A8F@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Set function return type to match that of cl_pfn_fmap_cmp_t to align with how the function is invoked.

Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--- a/opensm/opensm/osm_subnet.c        2009-10-01 12:45:52.000000000 -0700
+++ b/opensm/opensm/osm_subnet.c        2009-10-01 14:24:18.000000000 -0700
@@ -397,7 +397,7 @@

 /**********************************************************************
  **********************************************************************/
-static long compar_mgids(const void *m1, const void *m2)
+static intn_t compar_mgids(const void *m1, const void *m2)
 {
        return memcmp(m1, m2, sizeof(ib_gid_t));
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
