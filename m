From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] opensm: osm_subnet.c: Updated patch to add error-reporting
 to the parsing of opensm.conf
Date: Wed, 29 Feb 2012 12:54:16 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5B8B5D0@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've recently seen two different users on different fabrics make the same
mistake: They made a syntax error in their opensm.conf file and then couldn't
figure out why their changes didn't take effect.

Looking at the code that parses the opensm.conf file, it appears to treat any
line it cannot parse as a comment and silently passes over it.

This patch modifies the parse logic as follows:

1. Truncate the line at the first '#' character.
2. If the result is blank, skip to the next line.
3. If the first token in the line can be matched against a known token,
   process it as usual.
4. If the token cannot be matched against a known token, log an error message.

The result is that if, for example, the user typed "force_link_speed=5" the
system log will read:

Feb 24 14:57:09 ifs001 OpenSM[17517]: OpenSM 3.3.13
Feb 24 14:57:09 ifs001 OpenSM[17517]: Entering DISCOVERING state
Feb 24 14:57:09 ifs001 OpenSM[17517]: Unrecognized token: "force_link_speed=5"
Feb 24 14:57:09 ifs001 opensm[17517]: Entering MASTER state
Feb 24 14:57:09 ifs001 opensm[17517]: SUBNET UP
.
.
.

In addition, error messages will also be reported to the command line and
the opensm logfile. For example:

[root@ifs001]# opensm
-------------------------------------------------
OpenSM 3.3.13
 Reading Cached Option File: /etc/opensm/opensm.conf
Unrecognized token: "1`243561"
Command Line Arguments:
 Log File: /var/log/opensm.log
-------------------------------------------------
OpenSM 3.3.13

Entering DISCOVERING state

Using default GUID 0x117500007918d2
Unrecognized token: "1`243561"
Entering MASTER state

SUBNET UP
.
.
.

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 1b30e1e..faccea2 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1264,6 +1264,13 @@ int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * p_opts)
        p_opts->file_opts->file_opts = NULL;

        while (fgets(line, 1023, opts_file) != NULL) {
+               char *pound_sign = strchr(line,'#');
+               int token_matched = 0;
+
+               /* Truncate any comments. */
+               if (pound_sign)
+                       *pound_sign = '\0';
+
                /* get the first token */
                p_key = strtok_r(line, " \t\n", &p_val);
                if (!p_key)
@@ -1275,6 +1282,7 @@ int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * p_opts)
                        if (strcmp(r->name, p_key))
                                continue;

+                       token_matched = 1;
                        p_field1 = (void *)p_opts->file_opts + r->opt_offset;
                        p_field2 = (void *)p_opts + r->opt_offset;
                        /* don't call setup function first time */
@@ -1282,6 +1290,13 @@ int osm_subn_parse_conf_file(char *file_name, osm_subn_opt_t * p_opts)
                                    NULL);
                        break;
                }
+
+               if (!token_matched) {
+                       char buf[256];
+                       snprintf(buf,sizeof(buf),"Unrecognized token: \"%s\"",p_key);
+                       cl_log_event("OpenSM", CL_LOG_ERROR, buf, NULL, 0);
+                       log_report("%s\n",buf);
+               }
        }
        fclose(opts_file);

@@ -1324,6 +1339,13 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
                              &p_opts->file_opts->qos_rtr_options);

        while (fgets(line, 1023, opts_file) != NULL) {
+               char *pound_sign = strchr(line,'#');
+               int token_matched = 0;
+
+               /* Truncate any comments. */
+               if (pound_sign)
+                       *pound_sign = '\0';
+
                /* get the first token */
                p_key = strtok_r(line, " \t\n", &p_val);
                if (!p_key)
@@ -1332,7 +1354,12 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
                p_val = clean_val(p_val);

                for (r = opt_tbl; r->name; r++) {
-                       if (!r->can_update || strcmp(r->name, p_key))
+                       if (strcmp(r->name, p_key))
+                               continue;
+
+                       token_matched = 1;
+
+                       if (!r->can_update)
                                continue;

                        p_field1 = (void *)p_opts->file_opts + r->opt_offset;
@@ -1341,6 +1368,13 @@ int osm_subn_rescan_conf_files(IN osm_subn_t * p_subn)
                                    r->setup_fn);
                        break;
                }
+
+               if (!token_matched) {
+                       char buf[256];
+                       snprintf(buf,sizeof(buf),"Unrecognized token: \"%s\"",p_key);
+                       cl_log_event("OpenSM", CL_LOG_ERROR, buf, NULL, 0);
+                       log_report("%s\n",buf);
+               }
        }
        fclose(opts_file);


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
