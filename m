From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] osm_subnet.c change void* arithmetic to char*
Date: Thu, 1 Oct 2009 14:38:28 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C86E8A99@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


MS compiler doesn't Grok void* arithmetic, use char*

Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--- a/opensm/opensm/osm_subnet.c        2009-10-01 12:45:52.000000000 -0700
+++ b/opensm/opensm/osm_subnet.c        2009-10-01 14:24:18.000000000 -0700
@@ -1193,8 +1193,8 @@
                        if (strcmp(r->name, p_key))
                                continue;

-                       p_field1 = (void *)p_opts->file_opts + r->opt_offset;
-                       p_field2 = (void *)p_opts + r->opt_offset;
+                       p_field1 = (char *)p_opts->file_opts + r->opt_offset;
+                       p_field2 = (char *)p_opts + r->opt_offset;
                        /* don't call setup function first time */
                        r->parse_fn(NULL, p_key, p_val, p_field1, p_field2,
                                    NULL);
@@ -1253,8 +1253,8 @@
                        if (!r->can_update || strcmp(r->name, p_key))
                                continue;

-                       p_field1 = (void *)p_opts->file_opts + r->opt_offset;
-                       p_field2 = (void *)p_opts + r->opt_offset;
+                       p_field1 = (char *)p_opts->file_opts + r->opt_offset;
+                       p_field2 = (char *)p_opts + r->opt_offset;
                        r->parse_fn(p_subn, p_key, p_val, p_field1, p_field2,
                                    r->setup_fn);
                        break;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
