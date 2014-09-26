From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v6] rsockets: fine grained interception mechanism for rsocket
 preloading
Date: Fri, 26 Sep 2014 14:09:13 +0530
Message-ID: <008e50f7c84829d33c8d71b9e192b890@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_2c81b5520a25b723d66e5f7dea317d44"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--=_2c81b5520a25b723d66e5f7dea317d44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

Note: Minor modification to the latest change set from Sean
       Also attached the patch file for convenience

 From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Fri Sep 26 12:29:00 2014 +0530

     By default the R-Sockets pre-loading library intercepts all
     the stream and datagram sockets belonging to a launched
     program processes and threads.

     However, distributed application and database servers may
     require fine grained interception to ensure that only the
     processes which are listening for remote connections on the
     RDMA transport need to be enabled with RDMA while remaining
     can continue to use TCP as before.  This allows proper
     communication happening between various server components locally.

     A configuration file based mechanism is introduced to facilitate
     this fine grained interception mechanism.  As part of preload
     initialization, the configuration file is scanned and an
     in-memory record store is created with all the entries found.
     When a request is made to intercept a socket, its attributes
     are cross checked with stored records to see whether we
     should proceed with rsocket switch over.

     Note: Right now, the fine grained interception mechanism is
     enabled only for newly created sockets.  Going forward,
     this can be extened to select connections based on the
     specified host/IP addresses and ports as well.

     "preload_config" is the name of the configuration file which
     should exist in the default configuration location
     (usually the full path to this configuration file is:
     <install-root>/etc/rdma/rsocket/preload_config)
     of an installed rsocket library.

     The sample format for this configuration file is shown below:

     Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     Reviewed-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
     ---
     I made several adjustments to the submitted patch.  Please
     verify that these work for you.  Changes from v5:

     - Simplified input file format slightly.
     - Removed typedef
     - Rename entryp and removed unneeded variable
     - Replaced token parsing with sscanf
     - Added wildcard support for the program name
     - Wildcard values now stored as 0
     - Enhanced checks for domain, type, and protocol strings
     - Fixed realloc error handling
     - Simplified free_config implementation
     - Added support for app passing in 0 for protocol

     Additional minor change:
     - Compare only first n chars of program name

diff --git a/src/preload.c b/src/preload.c
index fb2149b..1e62a06 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -50,6 +50,9 @@
  #include <netinet/tcp.h>
  #include <unistd.h>
  #include <semaphore.h>
+#include <ctype.h>
+#include <stdlib.h>
+#include <stdio.h>

  #include <rdma/rdma_cma.h>
  #include <rdma/rdma_verbs.h>
@@ -122,6 +125,135 @@ struct fd_info {
         atomic_t refcnt;
  };

+struct config_entry {
+       char *name;
+       int domain;
+       int type;
+       int protocol;
+};
+
+static struct config_entry *config;
+static int config_cnt;
+extern char *program_invocation_short_name;
+
+
+static void free_config(void)
+{
+       while (config_cnt)
+               free(config[--config_cnt].name);
+
+       free(config);
+}
+
+/*
+ * Config file format:
+ * # Starting '#' indicates comment
+ * # wild card values are supported using '*'
+ * # domain - *, INET, INET6, IB
+ * # type - *, STREAM, DGRAM
+ * # protocol - *, TCP, UDP
+ * program_name domain type protocol
+ */
+static void scan_config(void)
+{
+       struct config_entry *new_config;
+       FILE *fp;
+       char line[120], prog[64], dom[16], type[16], proto[16];
+
+       fp = fopen(RS_CONF_DIR "/preload_config", "r");
+       if (!fp)
+               return;
+
+       while (fgets(line, sizeof(line), fp)) {
+               if (line[0] == '#')
+                       continue;
+
+               if (sscanf(line, "%64s%16s%16s%16s", prog, dom, type, 
proto) != 4)
+                       continue;
+
+               new_config = realloc(config, (config_cnt + 1) *
+                                            sizeof(struct 
config_entry));
+               if (!new_config)
+                       break;
+
+               config = new_config;
+               memset(&config[config_cnt], 0, sizeof(struct 
config_entry));
+
+               if (!strcasecmp(dom, "INET") ||
+                   !strcasecmp(dom, "AF_INET") ||
+                   !strcasecmp(dom, "PF_INET")) {
+                       config[config_cnt].domain = AF_INET;
+               } else if (!strcasecmp(dom, "INET6") ||
+                          !strcasecmp(dom, "AF_INET6") ||
+                          !strcasecmp(dom, "PF_INET6")) {
+                       config[config_cnt].domain = AF_INET6;
+               } else if (!strcasecmp(dom, "IB") ||
+                          !strcasecmp(dom, "AF_IB") ||
+                          !strcasecmp(dom, "PF_IB")) {
+                       config[config_cnt].domain = AF_IB;
+               } else if (strcmp(dom, "*")) {
+                       continue;
+               }
+
+               if (!strcasecmp(type, "STREAM") ||
+                   !strcasecmp(type, "SOCK_STREAM")) {
+                       config[config_cnt].type = SOCK_STREAM;
+               } else if (!strcasecmp(type, "DGRAM") ||
+                          !strcasecmp(type, "SOCK_DGRAM")) {
+                       config[config_cnt].type = SOCK_DGRAM;
+               } else if (strcmp(type, "*")) {
+                       continue;
+               }
+
+               if (!strcasecmp(proto, "TCP") ||
+                   !strcasecmp(proto, "IPPROTO_TCP")) {
+                       config[config_cnt].protocol = IPPROTO_TCP;
+               } else if (!strcasecmp(proto, "UDP") ||
+                          !strcasecmp(proto, "IPPROTO_UDP")) {
+                       config[config_cnt].protocol = IPPROTO_UDP;
+               } else if (strcmp(proto, "*")) {
+                       continue;
+               }
+
+               if (strcmp(prog, "*")) {
+                   if (!(config[config_cnt].name = strdup(prog)))
+                           continue;
+               }
+
+               config_cnt++;
+       }
+
+       fclose(fp);
+       if (config_cnt)
+               atexit(free_config);
+}
+
+static int intercept_socket(int domain, int type, int protocol)
+{
+       int i;
+
+       if (!config_cnt)
+               return 1;
+
+       if (!protocol) {
+               if (type == SOCK_STREAM)
+                       protocol = IPPROTO_TCP;
+               else if (type == SOCK_DGRAM)
+                       protocol = IPPROTO_UDP;
+       }
+
+       for (i = 0; i < config_cnt; i++) {
+               if ((!config[i].name ||
+                    !strncasecmp(config[i].name, 
program_invocation_short_name, strlen(config[i].name))) &&
+                   (!config[i].domain || config[i].domain == domain) &&
+                   (!config[i].type || config[i].type == type) &&
+                   (!config[i].protocol || config[i].protocol == 
protocol))
+                       return 1;
+       }
+
+       return 0;
+}
+
  static int fd_open(void)
  {
         struct fd_info *fdi;
@@ -308,6 +440,7 @@ static void init_preload(void)
         rs.fcntl = dlsym(RTLD_DEFAULT, "rfcntl");

         getenv_options();
+       scan_config();
         init = 1;
  out:
         pthread_mutex_unlock(&mut);
@@ -404,10 +537,11 @@ int socket(int domain, int type, int protocol)
         static __thread int recursive;
         int index, ret;

-       if (recursive)
+       init_preload();
+
+       if (recursive || !intercept_socket(domain, type, protocol))
                 goto real;

-       init_preload();
         index = fd_open();
         if (index < 0)
                 return index;

--=_2c81b5520a25b723d66e5f7dea317d44
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=librdmacm_src_rsocket_fine_grained_20140926.patch1
Content-Disposition: attachment;
 filename=librdmacm_src_rsocket_fine_grained_20140926.patch1;
 size=6605

Y29tbWl0IDVhZDhjNjg5MmU1NmU3ZTdjOGNkM2ExYWM1NzAyNTY4YTRhMzg0N2UKQXV0aG9yOiBT
cmVlZGhhciBLb2RhbGkgPHNya29kYWxpQGxpbnV4LnZuZXQuaWJtLmNvbT4KRGF0ZTogICBGcmkg
U2VwIDI2IDEyOjI5OjAwIDIwMTQgKzA1MzAKCiAgICBCeSBkZWZhdWx0IHRoZSBSLVNvY2tldHMg
cHJlLWxvYWRpbmcgbGlicmFyeSBpbnRlcmNlcHRzIGFsbAogICAgdGhlIHN0cmVhbSBhbmQgZGF0
YWdyYW0gc29ja2V0cyBiZWxvbmdpbmcgdG8gYSBsYXVuY2hlZAogICAgcHJvZ3JhbSBwcm9jZXNz
ZXMgYW5kIHRocmVhZHMuCiAgICAKICAgIEhvd2V2ZXIsIGRpc3RyaWJ1dGVkIGFwcGxpY2F0aW9u
IGFuZCBkYXRhYmFzZSBzZXJ2ZXJzIG1heQogICAgcmVxdWlyZSBmaW5lIGdyYWluZWQgaW50ZXJj
ZXB0aW9uIHRvIGVuc3VyZSB0aGF0IG9ubHkgdGhlCiAgICBwcm9jZXNzZXMgd2hpY2ggYXJlIGxp
c3RlbmluZyBmb3IgcmVtb3RlIGNvbm5lY3Rpb25zIG9uIHRoZQogICAgUkRNQSB0cmFuc3BvcnQg
bmVlZCB0byBiZSBlbmFibGVkIHdpdGggUkRNQSB3aGlsZSByZW1haW5pbmcKICAgIGNhbiBjb250
aW51ZSB0byB1c2UgVENQIGFzIGJlZm9yZS4gIFRoaXMgYWxsb3dzIHByb3BlcgogICAgY29tbXVu
aWNhdGlvbiBoYXBwZW5pbmcgYmV0d2VlbiB2YXJpb3VzIHNlcnZlciBjb21wb25lbnRzIGxvY2Fs
bHkuCiAgICAKICAgIEEgY29uZmlndXJhdGlvbiBmaWxlIGJhc2VkIG1lY2hhbmlzbSBpcyBpbnRy
b2R1Y2VkIHRvIGZhY2lsaXRhdGUKICAgIHRoaXMgZmluZSBncmFpbmVkIGludGVyY2VwdGlvbiBt
ZWNoYW5pc20uICBBcyBwYXJ0IG9mIHByZWxvYWQKICAgIGluaXRpYWxpemF0aW9uLCB0aGUgY29u
ZmlndXJhdGlvbiBmaWxlIGlzIHNjYW5uZWQgYW5kIGFuCiAgICBpbi1tZW1vcnkgcmVjb3JkIHN0
b3JlIGlzIGNyZWF0ZWQgd2l0aCBhbGwgdGhlIGVudHJpZXMgZm91bmQuCiAgICBXaGVuIGEgcmVx
dWVzdCBpcyBtYWRlIHRvIGludGVyY2VwdCBhIHNvY2tldCwgaXRzIGF0dHJpYnV0ZXMKICAgIGFy
ZSBjcm9zcyBjaGVja2VkIHdpdGggc3RvcmVkIHJlY29yZHMgdG8gc2VlIHdoZXRoZXIgd2UKICAg
IHNob3VsZCBwcm9jZWVkIHdpdGggcnNvY2tldCBzd2l0Y2ggb3Zlci4KICAgIAogICAgTm90ZTog
UmlnaHQgbm93LCB0aGUgZmluZSBncmFpbmVkIGludGVyY2VwdGlvbiBtZWNoYW5pc20gaXMKICAg
IGVuYWJsZWQgb25seSBmb3IgbmV3bHkgY3JlYXRlZCBzb2NrZXRzLiAgR29pbmcgZm9yd2FyZCwK
ICAgIHRoaXMgY2FuIGJlIGV4dGVuZWQgdG8gc2VsZWN0IGNvbm5lY3Rpb25zIGJhc2VkIG9uIHRo
ZQogICAgc3BlY2lmaWVkIGhvc3QvSVAgYWRkcmVzc2VzIGFuZCBwb3J0cyBhcyB3ZWxsLgogICAg
CiAgICAicHJlbG9hZF9jb25maWciIGlzIHRoZSBuYW1lIG9mIHRoZSBjb25maWd1cmF0aW9uIGZp
bGUgd2hpY2gKICAgIHNob3VsZCBleGlzdCBpbiB0aGUgZGVmYXVsdCBjb25maWd1cmF0aW9uIGxv
Y2F0aW9uCiAgICAodXN1YWxseSB0aGUgZnVsbCBwYXRoIHRvIHRoaXMgY29uZmlndXJhdGlvbiBm
aWxlIGlzOgogICAgPGluc3RhbGwtcm9vdD4vZXRjL3JkbWEvcnNvY2tldC9wcmVsb2FkX2NvbmZp
ZykKICAgIG9mIGFuIGluc3RhbGxlZCByc29ja2V0IGxpYnJhcnkuCiAgICAKICAgIFRoZSBzYW1w
bGUgZm9ybWF0IGZvciB0aGlzIGNvbmZpZ3VyYXRpb24gZmlsZSBpcyBzaG93biBiZWxvdzoKICAg
IAogICAgU2lnbmVkLW9mZi1ieTogU3JlZWRoYXIgS29kYWxpIDxzcmtvZGFsaUBsaW51eC52bmV0
LmlibS5jb20+CiAgICBSZXZpZXdlZC1ieTogUHJhZGVlcCBTYXR5YW5hcmF5YW5hIDxwcmFkZWVw
c0BsaW51eC52bmV0LmlibS5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBTZWFuIEhlZnR5IDxzZWFu
LmhlZnR5QGludGVsLmNvbT4KICAgIC0tLQogICAgSSBtYWRlIHNldmVyYWwgYWRqdXN0bWVudHMg
dG8gdGhlIHN1Ym1pdHRlZCBwYXRjaC4gIFBsZWFzZQogICAgdmVyaWZ5IHRoYXQgdGhlc2Ugd29y
ayBmb3IgeW91LiAgQ2hhbmdlcyBmcm9tIHY1OgogICAgCiAgICAtIFNpbXBsaWZpZWQgaW5wdXQg
ZmlsZSBmb3JtYXQgc2xpZ2h0bHkuCiAgICAtIFJlbW92ZWQgdHlwZWRlZgogICAgLSBSZW5hbWUg
ZW50cnlwIGFuZCByZW1vdmVkIHVubmVlZGVkIHZhcmlhYmxlCiAgICAtIFJlcGxhY2VkIHRva2Vu
IHBhcnNpbmcgd2l0aCBzc2NhbmYKICAgIC0gQWRkZWQgd2lsZGNhcmQgc3VwcG9ydCBmb3IgdGhl
IHByb2dyYW0gbmFtZQogICAgLSBXaWxkY2FyZCB2YWx1ZXMgbm93IHN0b3JlZCBhcyAwCiAgICAt
IEVuaGFuY2VkIGNoZWNrcyBmb3IgZG9tYWluLCB0eXBlLCBhbmQgcHJvdG9jb2wgc3RyaW5ncwog
ICAgLSBGaXhlZCByZWFsbG9jIGVycm9yIGhhbmRsaW5nCiAgICAtIFNpbXBsaWZpZWQgZnJlZV9j
b25maWcgaW1wbGVtZW50YXRpb24KICAgIC0gQWRkZWQgc3VwcG9ydCBmb3IgYXBwIHBhc3Npbmcg
aW4gMCBmb3IgcHJvdG9jb2wKICAgIAogICAgQWRkaXRpb25hbCBtaW5vciBjaGFuZ2U6CiAgICAt
IENvbXBhcmUgb25seSBmaXJzdCBuIGNoYXJzIG9mIHByb2dyYW0gbmFtZQoKZGlmZiAtLWdpdCBh
L3NyYy9wcmVsb2FkLmMgYi9zcmMvcHJlbG9hZC5jCmluZGV4IGZiMjE0OWIuLjFlNjJhMDYgMTAw
NjQ0Ci0tLSBhL3NyYy9wcmVsb2FkLmMKKysrIGIvc3JjL3ByZWxvYWQuYwpAQCAtNTAsNiArNTAs
OSBAQAogI2luY2x1ZGUgPG5ldGluZXQvdGNwLmg+CiAjaW5jbHVkZSA8dW5pc3RkLmg+CiAjaW5j
bHVkZSA8c2VtYXBob3JlLmg+CisjaW5jbHVkZSA8Y3R5cGUuaD4KKyNpbmNsdWRlIDxzdGRsaWIu
aD4KKyNpbmNsdWRlIDxzdGRpby5oPgogCiAjaW5jbHVkZSA8cmRtYS9yZG1hX2NtYS5oPgogI2lu
Y2x1ZGUgPHJkbWEvcmRtYV92ZXJicy5oPgpAQCAtMTIyLDYgKzEyNSwxMzUgQEAgc3RydWN0IGZk
X2luZm8gewogCWF0b21pY190IHJlZmNudDsKIH07CiAKK3N0cnVjdCBjb25maWdfZW50cnkgewor
CWNoYXIgKm5hbWU7CisJaW50IGRvbWFpbjsKKwlpbnQgdHlwZTsKKwlpbnQgcHJvdG9jb2w7Cit9
OworCitzdGF0aWMgc3RydWN0IGNvbmZpZ19lbnRyeSAqY29uZmlnOworc3RhdGljIGludCBjb25m
aWdfY250OworZXh0ZXJuIGNoYXIgKnByb2dyYW1faW52b2NhdGlvbl9zaG9ydF9uYW1lOworCisK
K3N0YXRpYyB2b2lkIGZyZWVfY29uZmlnKHZvaWQpCit7CisJd2hpbGUgKGNvbmZpZ19jbnQpCisJ
CWZyZWUoY29uZmlnWy0tY29uZmlnX2NudF0ubmFtZSk7CisKKwlmcmVlKGNvbmZpZyk7Cit9CisK
Ky8qCisgKiBDb25maWcgZmlsZSBmb3JtYXQ6CisgKiAjIFN0YXJ0aW5nICcjJyBpbmRpY2F0ZXMg
Y29tbWVudAorICogIyB3aWxkIGNhcmQgdmFsdWVzIGFyZSBzdXBwb3J0ZWQgdXNpbmcgJyonCisg
KiAjIGRvbWFpbiAtICosIElORVQsIElORVQ2LCBJQgorICogIyB0eXBlIC0gKiwgU1RSRUFNLCBE
R1JBTQorICogIyBwcm90b2NvbCAtICosIFRDUCwgVURQCisgKiBwcm9ncmFtX25hbWUgZG9tYWlu
IHR5cGUgcHJvdG9jb2wKKyAqLworc3RhdGljIHZvaWQgc2Nhbl9jb25maWcodm9pZCkKK3sKKwlz
dHJ1Y3QgY29uZmlnX2VudHJ5ICpuZXdfY29uZmlnOworCUZJTEUgKmZwOworCWNoYXIgbGluZVsx
MjBdLCBwcm9nWzY0XSwgZG9tWzE2XSwgdHlwZVsxNl0sIHByb3RvWzE2XTsKKworCWZwID0gZm9w
ZW4oUlNfQ09ORl9ESVIgIi9wcmVsb2FkX2NvbmZpZyIsICJyIik7CisJaWYgKCFmcCkKKwkJcmV0
dXJuOworCisJd2hpbGUgKGZnZXRzKGxpbmUsIHNpemVvZihsaW5lKSwgZnApKSB7CisJCWlmIChs
aW5lWzBdID09ICcjJykKKwkJCWNvbnRpbnVlOworCisJCWlmIChzc2NhbmYobGluZSwgIiU2NHMl
MTZzJTE2cyUxNnMiLCBwcm9nLCBkb20sIHR5cGUsIHByb3RvKSAhPSA0KQorCQkJY29udGludWU7
CisKKwkJbmV3X2NvbmZpZyA9IHJlYWxsb2MoY29uZmlnLCAoY29uZmlnX2NudCArIDEpICoKKwkJ
CQkJICAgICBzaXplb2Yoc3RydWN0IGNvbmZpZ19lbnRyeSkpOworCQlpZiAoIW5ld19jb25maWcp
CisJCQlicmVhazsKKworCQljb25maWcgPSBuZXdfY29uZmlnOworCQltZW1zZXQoJmNvbmZpZ1tj
b25maWdfY250XSwgMCwgc2l6ZW9mKHN0cnVjdCBjb25maWdfZW50cnkpKTsKKworCQlpZiAoIXN0
cmNhc2VjbXAoZG9tLCAiSU5FVCIpIHx8CisJCSAgICAhc3RyY2FzZWNtcChkb20sICJBRl9JTkVU
IikgfHwKKwkJICAgICFzdHJjYXNlY21wKGRvbSwgIlBGX0lORVQiKSkgeworCQkJY29uZmlnW2Nv
bmZpZ19jbnRdLmRvbWFpbiA9IEFGX0lORVQ7CisJCX0gZWxzZSBpZiAoIXN0cmNhc2VjbXAoZG9t
LCAiSU5FVDYiKSB8fAorCQkJICAgIXN0cmNhc2VjbXAoZG9tLCAiQUZfSU5FVDYiKSB8fAorCQkJ
ICAgIXN0cmNhc2VjbXAoZG9tLCAiUEZfSU5FVDYiKSkgeworCQkJY29uZmlnW2NvbmZpZ19jbnRd
LmRvbWFpbiA9IEFGX0lORVQ2OworCQl9IGVsc2UgaWYgKCFzdHJjYXNlY21wKGRvbSwgIklCIikg
fHwKKwkJCSAgICFzdHJjYXNlY21wKGRvbSwgIkFGX0lCIikgfHwKKwkJCSAgICFzdHJjYXNlY21w
KGRvbSwgIlBGX0lCIikpIHsKKwkJCWNvbmZpZ1tjb25maWdfY250XS5kb21haW4gPSBBRl9JQjsK
KwkJfSBlbHNlIGlmIChzdHJjbXAoZG9tLCAiKiIpKSB7CisJCQljb250aW51ZTsKKwkJfQorCisJ
CWlmICghc3RyY2FzZWNtcCh0eXBlLCAiU1RSRUFNIikgfHwKKwkJICAgICFzdHJjYXNlY21wKHR5
cGUsICJTT0NLX1NUUkVBTSIpKSB7CisJCQljb25maWdbY29uZmlnX2NudF0udHlwZSA9IFNPQ0tf
U1RSRUFNOworCQl9IGVsc2UgaWYgKCFzdHJjYXNlY21wKHR5cGUsICJER1JBTSIpIHx8CisJCQkg
ICAhc3RyY2FzZWNtcCh0eXBlLCAiU09DS19ER1JBTSIpKSB7CisJCQljb25maWdbY29uZmlnX2Nu
dF0udHlwZSA9IFNPQ0tfREdSQU07CisJCX0gZWxzZSBpZiAoc3RyY21wKHR5cGUsICIqIikpIHsK
KwkJCWNvbnRpbnVlOworCQl9CisKKwkJaWYgKCFzdHJjYXNlY21wKHByb3RvLCAiVENQIikgfHwK
KwkJICAgICFzdHJjYXNlY21wKHByb3RvLCAiSVBQUk9UT19UQ1AiKSkgeworCQkJY29uZmlnW2Nv
bmZpZ19jbnRdLnByb3RvY29sID0gSVBQUk9UT19UQ1A7CisJCX0gZWxzZSBpZiAoIXN0cmNhc2Vj
bXAocHJvdG8sICJVRFAiKSB8fAorCQkJICAgIXN0cmNhc2VjbXAocHJvdG8sICJJUFBST1RPX1VE
UCIpKSB7CisJCQljb25maWdbY29uZmlnX2NudF0ucHJvdG9jb2wgPSBJUFBST1RPX1VEUDsKKwkJ
fSBlbHNlIGlmIChzdHJjbXAocHJvdG8sICIqIikpIHsKKwkJCWNvbnRpbnVlOworCQl9CisKKwkJ
aWYgKHN0cmNtcChwcm9nLCAiKiIpKSB7CisJCSAgICBpZiAoIShjb25maWdbY29uZmlnX2NudF0u
bmFtZSA9IHN0cmR1cChwcm9nKSkpCisJCQkgICAgY29udGludWU7CisJCX0KKworCQljb25maWdf
Y250Kys7CisJfQorCisJZmNsb3NlKGZwKTsKKwlpZiAoY29uZmlnX2NudCkKKwkJYXRleGl0KGZy
ZWVfY29uZmlnKTsKK30KKworc3RhdGljIGludCBpbnRlcmNlcHRfc29ja2V0KGludCBkb21haW4s
IGludCB0eXBlLCBpbnQgcHJvdG9jb2wpCit7CisJaW50IGk7CisKKwlpZiAoIWNvbmZpZ19jbnQp
CisJCXJldHVybiAxOworCisJaWYgKCFwcm90b2NvbCkgeworCQlpZiAodHlwZSA9PSBTT0NLX1NU
UkVBTSkKKwkJCXByb3RvY29sID0gSVBQUk9UT19UQ1A7CisJCWVsc2UgaWYgKHR5cGUgPT0gU09D
S19ER1JBTSkKKwkJCXByb3RvY29sID0gSVBQUk9UT19VRFA7CisJfQorCisJZm9yIChpID0gMDsg
aSA8IGNvbmZpZ19jbnQ7IGkrKykgeworCQlpZiAoKCFjb25maWdbaV0ubmFtZSB8fAorCQkgICAg
ICFzdHJuY2FzZWNtcChjb25maWdbaV0ubmFtZSwgcHJvZ3JhbV9pbnZvY2F0aW9uX3Nob3J0X25h
bWUsIHN0cmxlbihjb25maWdbaV0ubmFtZSkpKSAmJgorCQkgICAgKCFjb25maWdbaV0uZG9tYWlu
IHx8IGNvbmZpZ1tpXS5kb21haW4gPT0gZG9tYWluKSAmJgorCQkgICAgKCFjb25maWdbaV0udHlw
ZSB8fCBjb25maWdbaV0udHlwZSA9PSB0eXBlKSAmJgorCQkgICAgKCFjb25maWdbaV0ucHJvdG9j
b2wgfHwgY29uZmlnW2ldLnByb3RvY29sID09IHByb3RvY29sKSkKKwkJCXJldHVybiAxOworCX0K
KworCXJldHVybiAwOworfQorCiBzdGF0aWMgaW50IGZkX29wZW4odm9pZCkKIHsKIAlzdHJ1Y3Qg
ZmRfaW5mbyAqZmRpOwpAQCAtMzA4LDYgKzQ0MCw3IEBAIHN0YXRpYyB2b2lkIGluaXRfcHJlbG9h
ZCh2b2lkKQogCXJzLmZjbnRsID0gZGxzeW0oUlRMRF9ERUZBVUxULCAicmZjbnRsIik7CiAKIAln
ZXRlbnZfb3B0aW9ucygpOworCXNjYW5fY29uZmlnKCk7CiAJaW5pdCA9IDE7CiBvdXQ6CiAJcHRo
cmVhZF9tdXRleF91bmxvY2soJm11dCk7CkBAIC00MDQsMTAgKzUzNywxMSBAQCBpbnQgc29ja2V0
KGludCBkb21haW4sIGludCB0eXBlLCBpbnQgcHJvdG9jb2wpCiAJc3RhdGljIF9fdGhyZWFkIGlu
dCByZWN1cnNpdmU7CiAJaW50IGluZGV4LCByZXQ7CiAKLQlpZiAocmVjdXJzaXZlKQorCWluaXRf
cHJlbG9hZCgpOworCisJaWYgKHJlY3Vyc2l2ZSB8fCAhaW50ZXJjZXB0X3NvY2tldChkb21haW4s
IHR5cGUsIHByb3RvY29sKSkKIAkJZ290byByZWFsOwogCi0JaW5pdF9wcmVsb2FkKCk7CiAJaW5k
ZXggPSBmZF9vcGVuKCk7CiAJaWYgKGluZGV4IDwgMCkKIAkJcmV0dXJuIGluZGV4Owo=
--=_2c81b5520a25b723d66e5f7dea317d44--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
