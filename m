From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 1/4] rsockets: fine grained interception mechanism for
 rsocket preloading
Date: Thu, 18 Sep 2014 16:03:27 +0530
Message-ID: <87f9777bcbfe4f5daa8bd9b78d74ac9f@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_a9ea670af75c08f8fb32108b1972ca9c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--=_a9ea670af75c08f8fb32108b1972ca9c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

Note: This patch is reformatted and is being resent as suggested by Sean
       Also attached the patch file for convenience

 From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Date:   Thu Sep 18 11:33:21 2014 +0530

     By default the R-Sockets pre-loading library intercepts all the 
stream
     and datagram sockets belonging to a launched program processes and 
threads.

     However, distributed application and database servers may require 
fine
     grained interception to ensure that only the processes which are 
listening
     for remote connections on the RDMA transport need to be enabled with 
RDMA
     while remaining can continue to use TCP as before.  This allows 
proper
     communication happening between various server components locally.

     A configuration file based mechanism is introduced to facilitate 
this
     fine grained interception mechanism.  As part of preload 
initialization,
     the configuration file is scanned and an in-memory record store is 
created
     with all the entries found.  When a request is made to intercept a 
socket,
     its attributes are cross checked with stored records to see whether 
we
     should proceed with rsocket switch over.

     Note: Right now, the fine grained interception mechanism is enabled 
only
     for newly created sockets.  Going forward, this can be extened to
     select connections based on the specified host/IP addresses and
     ports as well.

     "preload_config" is the name of the configuration file which should 
exist
     in the default configuration location (usually the full path to this
     configuration file is: 
<install-root>/etc/rdma/rsocket/preload_config)
     of an installed rsocket library.

     The sample format for this configuration file is shown below:

     @#
     @# Sample config file for preloading in a program specific way
     @#
     @# Each line entry should have the following format:
     @#
     @#   prog_name <space> dom_spec <space> type_spec <space> proto_spec
     @#
     @# where,
     @#
     @# prog_name  - program or command name (string without spaces)
     @# dom_spec   - one or more socket domain strings separated by 
commas
     @#            - format: {*|domain,[,domain,...]}
     @#            - '*' means any valid domain
     @#            - valid domains: inet/inet6/ib
     @# type_spec  - one or more socket type strings separated by commas
     @#            - format: {*|type[,type,...]}
     @#            - '*' means any valid type
     @#            - valid types: stream/dgram
     @# proto_spec - one or more socket protocol strings separated by 
commas
     @#            - format: {*|protocol[,protocol,...]}
     @#            - '*' means any valid protocol
     @#            - valid protocols: tcp/udp
     @# <space>    - one ore more tab or space characters
     @#
     @# Note:
     @#  Lines beginning with '#' character are treated as comments.
     @#  Comments at the end of an entry are allowed and should be 
preceded
     @#  by '#' character.
     @#  Blank lines are ignored.
     @
     @progA inet stream tcp # intercept progA's internet stream sockets
     @progB inet6 dgram udp # intercept progB's ipv6 datagram sockets
     @progC * * * # intercept progC's sockets

     Signed-off-by: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     Reviewed-by: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
     ---

diff --git a/src/preload.c b/src/preload.c
index fb2149b..b597616 100644
--- a/src/preload.c
+++ b/src/preload.c
@@ -50,6 +50,8 @@
  #include <netinet/tcp.h>
  #include <unistd.h>
  #include <semaphore.h>
+#include <ctype.h>
+#include <stdlib.h>

  #include <rdma/rdma_cma.h>
  #include <rdma/rdma_verbs.h>
@@ -122,6 +124,217 @@ struct fd_info {
         atomic_t refcnt;
  };

+typedef struct {
+       char *name;
+       uint32_t domain;
+       uint32_t type;
+       uint32_t protocol;
+} config_entry_t;
+
+static config_entry_t *entryp;
+static int16_t nentries;
+static int16_t config_avail;
+extern char *program_invocation_short_name;
+
+/* scan preload configuration file and create
+ * in-memory config store
+ * should be called only once under lock
+ */
+static int scan_preload_config(void)
+{
+       FILE *fp;
+       char line[512];
+       char *lp, *cp, *str1, *str2;
+       char *token, *subtoken, *saveptr1, *saveptr2;
+       int i, j, ret = 0;
+
+       fp = fopen(RS_CONF_DIR "/preload_config", "r");
+       if (fp == NULL) {
+               return -1;
+       }
+
+       while ((lp = fgets(line, sizeof(line), fp)) != NULL) {
+
+               /* trim white space at the beginning of each line */
+               while (*lp != '\0') {
+                       if (isspace(*lp)) {
+                               lp++;
+                               continue;
+                       } else {
+                               break;
+                       }
+               }
+
+               /* skip comment and blank lines */
+               if (*lp == '\0' || *lp == '#') {
+                       continue;
+               }
+
+               /* trim comments and newlines at the end of each line */
+               if ((cp = strpbrk(lp, "#\n")) != NULL) {
+                       *cp = '\0';
+               }
+
+               /* now allocate memory for new configuration entry */
+               entryp = (config_entry_t *) realloc(entryp, (nentries + 
1) *
+                                               sizeof(config_entry_t));
+               if (!entryp) {
+                       ret = -1;
+                       goto scan_done;
+               }
+               memset(entryp + nentries, '\0', sizeof(config_entry_t));
+
+               /* tokenize the retrieved line and parse individual 
fields */
+               for (i = 1, str1 = lp; ; i++, str1 = NULL) {
+                       token = strtok_r(str1, " \t", &saveptr1);
+                       if (token == NULL) {
+                               break;
+                       }
+
+                       /* first field should contain program name */
+                       if (i == 1) {
+                               entryp[nentries].name = (char *) 
malloc((strlen(token) + 1));
+                               if (!entryp[nentries].name) {
+                                       ret = -1;
+                                       goto scan_done;
+                               }
+                               memcpy(entryp[nentries].name, token, 
strlen(token) + 1);
+                               continue;
+                       }
+
+                       /* second field onwards can contain multiple 
entries
+                        * separated by commas
+                        */
+                       for (j = 1, str2 = token; ; j++, str2 = NULL) {
+                               subtoken = strtok_r(str2, ",", 
&saveptr2);
+                               if (subtoken == NULL) {
+                                       break;
+                               }
+
+                               /* second field is socket domain
+                                * rsocket currently recognizes only 
AF_INET, AF_INET6
+                                * and AF_IB domains
+                                * '*' implies all the valid domains
+                                */
+                               if (i == 2) {
+                                       if (*subtoken == '*') {
+                                               entryp[nentries].domain 
|= (1 << AF_INET);
+                                               entryp[nentries].domain 
|= (1 << AF_INET6);
+                                               entryp[nentries].domain 
|= (1 << AF_IB);
+                                               break;
+                                       } else if (strcmp(subtoken, 
"inet6") == 0) {
+                                               entryp[nentries].domain 
|= (1 << AF_INET6);
+                                       } else if (strcmp(subtoken, 
"inet") == 0) {
+                                               entryp[nentries].domain 
|= (1 << AF_INET);
+                                       } else if (strcmp(subtoken, 
"ib") == 0) {
+                                               entryp[nentries].domain 
|= (1 << AF_IB);
+                                       }
+                                       continue;
+                               }
+
+                               /* third field is socket type
+                                * rsocket currently recognizes only 
SOCK_STREAM and
+                                * SOCK_DGRAM types
+                                * '*' implies all the valid types
+                                */
+                               if (i == 3) {
+                                       if (*subtoken == '*') {
+                                               entryp[nentries].type |= 
(1 << SOCK_STREAM);
+                                               entryp[nentries].type |= 
(1 << SOCK_DGRAM);
+                                               break;
+                                       } else if (strcmp(subtoken, 
"stream") == 0) {
+                                               entryp[nentries].type |= 
(1 << SOCK_STREAM);
+                                       } else if (strcmp(subtoken, 
"dgram") == 0) {
+                                               entryp[nentries].type |= 
(1 << SOCK_DGRAM);
+                                       }
+                                       continue;
+                               }
+
+                               /* fourth field is socket protocol
+                                * rsocket currently recgonizes only 
IPPROTO_TCP and
+                                * IPPROTO_UDP protocols
+                                * '*' implies all the valid protocols
+                                */
+                               if (i == 4) {
+                                       if (*subtoken == '*') {
+                                               
entryp[nentries].protocol |= (1 << IPPROTO_TCP);
+                                               
entryp[nentries].protocol |= (1 << IPPROTO_UDP);
+                                               break;
+                                       } else if (strcmp(subtoken, 
"tcp") == 0) {
+                                               
entryp[nentries].protocol |= (1 << IPPROTO_TCP);
+                                       } else if (strcmp(subtoken, 
"udp") == 0) {
+                                               
entryp[nentries].protocol |= (1 << IPPROTO_UDP);
+                                       }
+                                       continue;
+                               }
+                       }
+               }
+               nentries += 1;
+       }
+
+scan_done:
+       fclose(fp);
+       return ret;
+}
+
+/* free in-memory config store
+ * should be called only once during finalization
+ */
+static void free_preload_config(void)
+{
+       int i;
+
+       if (entryp) {
+               for (i = 0; i < nentries; i++) {
+                       if (entryp[i].name) {
+                               free(entryp[i].name);
+                       }
+               }
+               free(entryp);
+       }
+
+       return;
+}
+
+/* check whether interception is required for this socket
+ * compares the provided attributes with that available in the 
in-memory
+ * data store for the current process
+ * sets-up in-memory config store if it's already not done
+ */
+static int intercept_socket(int domain, int type, int protocol)
+{
+       int i;
+
+       /* locate the config entry */
+       for (i = 0; i < nentries; i++) {
+               if (strncmp(entryp[i].name, 
program_invocation_short_name,
+                                       strlen(entryp[i].name)) == 0) {
+                       break;
+               }
+       }
+       if (i == nentries) {
+               return 0;
+       }
+
+       /* match domain field */
+       if (!(entryp[i].domain & (1 << domain))) {
+               return 0;
+       }
+
+       /* match type field */
+       if (!(entryp[i].type & (1 << type))) {
+               return 0;
+       }
+
+       /* match protocol field only if protocol is specified */
+       if (protocol && !(entryp[i].protocol & (1 << protocol))) {
+               return 0;
+       }
+
+       /* entry matched */
+       return 1;
+}
+
  static int fd_open(void)
  {
         struct fd_info *fdi;
@@ -308,6 +521,14 @@ static void init_preload(void)
         rs.fcntl = dlsym(RTLD_DEFAULT, "rfcntl");

         getenv_options();
+
+       if (scan_preload_config() == 0) {
+               config_avail = 1;
+       }
+       if (entryp) {
+               atexit(free_preload_config);
+       }
+
         init = 1;
  out:
         pthread_mutex_unlock(&mut);
@@ -404,10 +625,15 @@ int socket(int domain, int type, int protocol)
         static __thread int recursive;
         int index, ret;

+       init_preload();
+
+       if (config_avail && intercept_socket(domain, type, protocol) == 
0) {
+               goto real;
+       }
+
         if (recursive)
                 goto real;

-       init_preload();
         index = fd_open();
         if (index < 0)
                 return index;

--=_a9ea670af75c08f8fb32108b1972ca9c
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=librdmacm_src_preload_fine_grained_20140918.patch1
Content-Disposition: attachment;
 filename=librdmacm_src_preload_fine_grained_20140918.patch1;
 size=9590

Y29tbWl0IDg5YWZkOGNmY2QxMzQ3Zjc5M2VkNzkyOGY2NDMyMTNiNmRiZDQ1OTkKQXV0aG9yOiBT
cmVlZGhhciBLb2RhbGkgPHNya29kYWxpQGxpbnV4LnZuZXQuaWJtLmNvbT4KRGF0ZTogICBUaHUg
U2VwIDE4IDExOjMzOjIxIDIwMTQgKzA1MzAKCiAgICBCeSBkZWZhdWx0IHRoZSBSLVNvY2tldHMg
cHJlLWxvYWRpbmcgbGlicmFyeSBpbnRlcmNlcHRzIGFsbCB0aGUgc3RyZWFtCiAgICBhbmQgZGF0
YWdyYW0gc29ja2V0cyBiZWxvbmdpbmcgdG8gYSBsYXVuY2hlZCBwcm9ncmFtIHByb2Nlc3NlcyBh
bmQgdGhyZWFkcy4KICAgIAogICAgSG93ZXZlciwgZGlzdHJpYnV0ZWQgYXBwbGljYXRpb24gYW5k
IGRhdGFiYXNlIHNlcnZlcnMgbWF5IHJlcXVpcmUgZmluZQogICAgZ3JhaW5lZCBpbnRlcmNlcHRp
b24gdG8gZW5zdXJlIHRoYXQgb25seSB0aGUgcHJvY2Vzc2VzIHdoaWNoIGFyZSBsaXN0ZW5pbmcK
ICAgIGZvciByZW1vdGUgY29ubmVjdGlvbnMgb24gdGhlIFJETUEgdHJhbnNwb3J0IG5lZWQgdG8g
YmUgZW5hYmxlZCB3aXRoIFJETUEKICAgIHdoaWxlIHJlbWFpbmluZyBjYW4gY29udGludWUgdG8g
dXNlIFRDUCBhcyBiZWZvcmUuICBUaGlzIGFsbG93cyBwcm9wZXIKICAgIGNvbW11bmljYXRpb24g
aGFwcGVuaW5nIGJldHdlZW4gdmFyaW91cyBzZXJ2ZXIgY29tcG9uZW50cyBsb2NhbGx5LgogICAg
CiAgICBBIGNvbmZpZ3VyYXRpb24gZmlsZSBiYXNlZCBtZWNoYW5pc20gaXMgaW50cm9kdWNlZCB0
byBmYWNpbGl0YXRlIHRoaXMKICAgIGZpbmUgZ3JhaW5lZCBpbnRlcmNlcHRpb24gbWVjaGFuaXNt
LiAgQXMgcGFydCBvZiBwcmVsb2FkIGluaXRpYWxpemF0aW9uLAogICAgdGhlIGNvbmZpZ3VyYXRp
b24gZmlsZSBpcyBzY2FubmVkIGFuZCBhbiBpbi1tZW1vcnkgcmVjb3JkIHN0b3JlIGlzIGNyZWF0
ZWQKICAgIHdpdGggYWxsIHRoZSBlbnRyaWVzIGZvdW5kLiAgV2hlbiBhIHJlcXVlc3QgaXMgbWFk
ZSB0byBpbnRlcmNlcHQgYSBzb2NrZXQsCiAgICBpdHMgYXR0cmlidXRlcyBhcmUgY3Jvc3MgY2hl
Y2tlZCB3aXRoIHN0b3JlZCByZWNvcmRzIHRvIHNlZSB3aGV0aGVyIHdlCiAgICBzaG91bGQgcHJv
Y2VlZCB3aXRoIHJzb2NrZXQgc3dpdGNoIG92ZXIuCiAgICAKICAgIE5vdGU6IFJpZ2h0IG5vdywg
dGhlIGZpbmUgZ3JhaW5lZCBpbnRlcmNlcHRpb24gbWVjaGFuaXNtIGlzIGVuYWJsZWQgb25seQog
ICAgZm9yIG5ld2x5IGNyZWF0ZWQgc29ja2V0cy4gIEdvaW5nIGZvcndhcmQsIHRoaXMgY2FuIGJl
IGV4dGVuZWQgdG8KICAgIHNlbGVjdCBjb25uZWN0aW9ucyBiYXNlZCBvbiB0aGUgc3BlY2lmaWVk
IGhvc3QvSVAgYWRkcmVzc2VzIGFuZAogICAgcG9ydHMgYXMgd2VsbC4KICAgIAogICAgInByZWxv
YWRfY29uZmlnIiBpcyB0aGUgbmFtZSBvZiB0aGUgY29uZmlndXJhdGlvbiBmaWxlIHdoaWNoIHNo
b3VsZCBleGlzdAogICAgaW4gdGhlIGRlZmF1bHQgY29uZmlndXJhdGlvbiBsb2NhdGlvbiAodXN1
YWxseSB0aGUgZnVsbCBwYXRoIHRvIHRoaXMKICAgIGNvbmZpZ3VyYXRpb24gZmlsZSBpczogPGlu
c3RhbGwtcm9vdD4vZXRjL3JkbWEvcnNvY2tldC9wcmVsb2FkX2NvbmZpZykKICAgIG9mIGFuIGlu
c3RhbGxlZCByc29ja2V0IGxpYnJhcnkuCiAgICAKICAgIFRoZSBzYW1wbGUgZm9ybWF0IGZvciB0
aGlzIGNvbmZpZ3VyYXRpb24gZmlsZSBpcyBzaG93biBiZWxvdzoKICAgIAogICAgQCMKICAgIEAj
IFNhbXBsZSBjb25maWcgZmlsZSBmb3IgcHJlbG9hZGluZyBpbiBhIHByb2dyYW0gc3BlY2lmaWMg
d2F5CiAgICBAIwogICAgQCMgRWFjaCBsaW5lIGVudHJ5IHNob3VsZCBoYXZlIHRoZSBmb2xsb3dp
bmcgZm9ybWF0OgogICAgQCMKICAgIEAjICAgcHJvZ19uYW1lIDxzcGFjZT4gZG9tX3NwZWMgPHNw
YWNlPiB0eXBlX3NwZWMgPHNwYWNlPiBwcm90b19zcGVjCiAgICBAIwogICAgQCMgd2hlcmUsCiAg
ICBAIwogICAgQCMgcHJvZ19uYW1lICAtIHByb2dyYW0gb3IgY29tbWFuZCBuYW1lIChzdHJpbmcg
d2l0aG91dCBzcGFjZXMpCiAgICBAIyBkb21fc3BlYyAgIC0gb25lIG9yIG1vcmUgc29ja2V0IGRv
bWFpbiBzdHJpbmdzIHNlcGFyYXRlZCBieSBjb21tYXMKICAgIEAjICAgICAgICAgICAgLSBmb3Jt
YXQ6IHsqfGRvbWFpbixbLGRvbWFpbiwuLi5dfQogICAgQCMgICAgICAgICAgICAtICcqJyBtZWFu
cyBhbnkgdmFsaWQgZG9tYWluCiAgICBAIyAgICAgICAgICAgIC0gdmFsaWQgZG9tYWluczogaW5l
dC9pbmV0Ni9pYgogICAgQCMgdHlwZV9zcGVjICAtIG9uZSBvciBtb3JlIHNvY2tldCB0eXBlIHN0
cmluZ3Mgc2VwYXJhdGVkIGJ5IGNvbW1hcwogICAgQCMgICAgICAgICAgICAtIGZvcm1hdDogeyp8
dHlwZVssdHlwZSwuLi5dfQogICAgQCMgICAgICAgICAgICAtICcqJyBtZWFucyBhbnkgdmFsaWQg
dHlwZQogICAgQCMgICAgICAgICAgICAtIHZhbGlkIHR5cGVzOiBzdHJlYW0vZGdyYW0KICAgIEAj
IHByb3RvX3NwZWMgLSBvbmUgb3IgbW9yZSBzb2NrZXQgcHJvdG9jb2wgc3RyaW5ncyBzZXBhcmF0
ZWQgYnkgY29tbWFzCiAgICBAIyAgICAgICAgICAgIC0gZm9ybWF0OiB7Knxwcm90b2NvbFsscHJv
dG9jb2wsLi4uXX0KICAgIEAjICAgICAgICAgICAgLSAnKicgbWVhbnMgYW55IHZhbGlkIHByb3Rv
Y29sCiAgICBAIyAgICAgICAgICAgIC0gdmFsaWQgcHJvdG9jb2xzOiB0Y3AvdWRwCiAgICBAIyA8
c3BhY2U+ICAgIC0gb25lIG9yZSBtb3JlIHRhYiBvciBzcGFjZSBjaGFyYWN0ZXJzCiAgICBAIwog
ICAgQCMgTm90ZToKICAgIEAjICBMaW5lcyBiZWdpbm5pbmcgd2l0aCAnIycgY2hhcmFjdGVyIGFy
ZSB0cmVhdGVkIGFzIGNvbW1lbnRzLgogICAgQCMgIENvbW1lbnRzIGF0IHRoZSBlbmQgb2YgYW4g
ZW50cnkgYXJlIGFsbG93ZWQgYW5kIHNob3VsZCBiZSBwcmVjZWRlZAogICAgQCMgIGJ5ICcjJyBj
aGFyYWN0ZXIuCiAgICBAIyAgQmxhbmsgbGluZXMgYXJlIGlnbm9yZWQuCiAgICBACiAgICBAcHJv
Z0EgaW5ldCBzdHJlYW0gdGNwICMgaW50ZXJjZXB0IHByb2dBJ3MgaW50ZXJuZXQgc3RyZWFtIHNv
Y2tldHMKICAgIEBwcm9nQiBpbmV0NiBkZ3JhbSB1ZHAgIyBpbnRlcmNlcHQgcHJvZ0IncyBpcHY2
IGRhdGFncmFtIHNvY2tldHMKICAgIEBwcm9nQyAqICogKiAjIGludGVyY2VwdCBwcm9nQydzIHNv
Y2tldHMKICAgIAogICAgU2lnbmVkLW9mZi1ieTogU3JlZWRoYXIgS29kYWxpIDxzcmtvZGFsaUBs
aW51eC52bmV0LmlibS5jb20+CiAgICBSZXZpZXdlZC1ieTogUHJhZGVlcCBTYXR5YW5hcmF5YW5h
IDxwcmFkZWVwc0BsaW51eC52bmV0LmlibS5jb20+CiAgICAtLS0KCmRpZmYgLS1naXQgYS9zcmMv
cHJlbG9hZC5jIGIvc3JjL3ByZWxvYWQuYwppbmRleCBmYjIxNDliLi5iNTk3NjE2IDEwMDY0NAot
LS0gYS9zcmMvcHJlbG9hZC5jCisrKyBiL3NyYy9wcmVsb2FkLmMKQEAgLTUwLDYgKzUwLDggQEAK
ICNpbmNsdWRlIDxuZXRpbmV0L3RjcC5oPgogI2luY2x1ZGUgPHVuaXN0ZC5oPgogI2luY2x1ZGUg
PHNlbWFwaG9yZS5oPgorI2luY2x1ZGUgPGN0eXBlLmg+CisjaW5jbHVkZSA8c3RkbGliLmg+CiAK
ICNpbmNsdWRlIDxyZG1hL3JkbWFfY21hLmg+CiAjaW5jbHVkZSA8cmRtYS9yZG1hX3ZlcmJzLmg+
CkBAIC0xMjIsNiArMTI0LDIxNyBAQCBzdHJ1Y3QgZmRfaW5mbyB7CiAJYXRvbWljX3QgcmVmY250
OwogfTsKIAordHlwZWRlZiBzdHJ1Y3QgeworCWNoYXIgKm5hbWU7CisJdWludDMyX3QgZG9tYWlu
OworCXVpbnQzMl90IHR5cGU7CisJdWludDMyX3QgcHJvdG9jb2w7Cit9IGNvbmZpZ19lbnRyeV90
OworCitzdGF0aWMgY29uZmlnX2VudHJ5X3QgKmVudHJ5cDsKK3N0YXRpYyBpbnQxNl90IG5lbnRy
aWVzOworc3RhdGljIGludDE2X3QgY29uZmlnX2F2YWlsOworZXh0ZXJuIGNoYXIgKnByb2dyYW1f
aW52b2NhdGlvbl9zaG9ydF9uYW1lOworCisvKiBzY2FuIHByZWxvYWQgY29uZmlndXJhdGlvbiBm
aWxlIGFuZCBjcmVhdGUKKyAqIGluLW1lbW9yeSBjb25maWcgc3RvcmUKKyAqIHNob3VsZCBiZSBj
YWxsZWQgb25seSBvbmNlIHVuZGVyIGxvY2sKKyAqLworc3RhdGljIGludCBzY2FuX3ByZWxvYWRf
Y29uZmlnKHZvaWQpCit7CisJRklMRSAqZnA7CisJY2hhciBsaW5lWzUxMl07CisJY2hhciAqbHAs
ICpjcCwgKnN0cjEsICpzdHIyOworCWNoYXIgKnRva2VuLCAqc3VidG9rZW4sICpzYXZlcHRyMSwg
KnNhdmVwdHIyOworCWludCBpLCBqLCByZXQgPSAwOworCisJZnAgPSBmb3BlbihSU19DT05GX0RJ
UiAiL3ByZWxvYWRfY29uZmlnIiwgInIiKTsKKwlpZiAoZnAgPT0gTlVMTCkgeworCQlyZXR1cm4g
LTE7CisJfQorCisJd2hpbGUgKChscCA9IGZnZXRzKGxpbmUsIHNpemVvZihsaW5lKSwgZnApKSAh
PSBOVUxMKSB7CisKKwkJLyogdHJpbSB3aGl0ZSBzcGFjZSBhdCB0aGUgYmVnaW5uaW5nIG9mIGVh
Y2ggbGluZSAqLworCQl3aGlsZSAoKmxwICE9ICdcMCcpIHsKKwkJCWlmIChpc3NwYWNlKCpscCkp
IHsKKwkJCQlscCsrOworCQkJCWNvbnRpbnVlOworCQkJfSBlbHNlIHsKKwkJCQlicmVhazsKKwkJ
CX0KKwkJfQorCisJCS8qIHNraXAgY29tbWVudCBhbmQgYmxhbmsgbGluZXMgKi8KKwkJaWYgKCps
cCA9PSAnXDAnIHx8ICpscCA9PSAnIycpIHsKKwkJCWNvbnRpbnVlOworCQl9CisKKwkJLyogdHJp
bSBjb21tZW50cyBhbmQgbmV3bGluZXMgYXQgdGhlIGVuZCBvZiBlYWNoIGxpbmUgKi8KKwkJaWYg
KChjcCA9IHN0cnBicmsobHAsICIjXG4iKSkgIT0gTlVMTCkgeworCQkJKmNwID0gJ1wwJzsKKwkJ
fQorCisJCS8qIG5vdyBhbGxvY2F0ZSBtZW1vcnkgZm9yIG5ldyBjb25maWd1cmF0aW9uIGVudHJ5
ICovCisJCWVudHJ5cCA9IChjb25maWdfZW50cnlfdCAqKSByZWFsbG9jKGVudHJ5cCwgKG5lbnRy
aWVzICsgMSkgKgorCQkJCQkJc2l6ZW9mKGNvbmZpZ19lbnRyeV90KSk7CisJCWlmICghZW50cnlw
KSB7CisJCQlyZXQgPSAtMTsKKwkJCWdvdG8gc2Nhbl9kb25lOworCQl9CisJCW1lbXNldChlbnRy
eXAgKyBuZW50cmllcywgJ1wwJywgc2l6ZW9mKGNvbmZpZ19lbnRyeV90KSk7CisKKwkJLyogdG9r
ZW5pemUgdGhlIHJldHJpZXZlZCBsaW5lIGFuZCBwYXJzZSBpbmRpdmlkdWFsIGZpZWxkcyAqLwor
CQlmb3IgKGkgPSAxLCBzdHIxID0gbHA7IDsgaSsrLCBzdHIxID0gTlVMTCkgeworCQkJdG9rZW4g
PSBzdHJ0b2tfcihzdHIxLCAiIFx0IiwgJnNhdmVwdHIxKTsKKwkJCWlmICh0b2tlbiA9PSBOVUxM
KSB7CisJCQkJYnJlYWs7CisJCQl9CisKKwkJCS8qIGZpcnN0IGZpZWxkIHNob3VsZCBjb250YWlu
IHByb2dyYW0gbmFtZSAqLworCQkJaWYgKGkgPT0gMSkgeworCQkJCWVudHJ5cFtuZW50cmllc10u
bmFtZSA9IChjaGFyICopIG1hbGxvYygoc3RybGVuKHRva2VuKSArIDEpKTsKKwkJCQlpZiAoIWVu
dHJ5cFtuZW50cmllc10ubmFtZSkgeworCQkJCQlyZXQgPSAtMTsKKwkJCQkJZ290byBzY2FuX2Rv
bmU7CisJCQkJfQorCQkJCW1lbWNweShlbnRyeXBbbmVudHJpZXNdLm5hbWUsIHRva2VuLCBzdHJs
ZW4odG9rZW4pICsgMSk7CisJCQkJY29udGludWU7CisJCQl9CisKKwkJCS8qIHNlY29uZCBmaWVs
ZCBvbndhcmRzIGNhbiBjb250YWluIG11bHRpcGxlIGVudHJpZXMKKwkJCSAqIHNlcGFyYXRlZCBi
eSBjb21tYXMKKwkJCSAqLworCQkJZm9yIChqID0gMSwgc3RyMiA9IHRva2VuOyA7IGorKywgc3Ry
MiA9IE5VTEwpIHsKKwkJCQlzdWJ0b2tlbiA9IHN0cnRva19yKHN0cjIsICIsIiwgJnNhdmVwdHIy
KTsKKwkJCQlpZiAoc3VidG9rZW4gPT0gTlVMTCkgeworCQkJCQlicmVhazsKKwkJCQl9CisKKwkJ
CQkvKiBzZWNvbmQgZmllbGQgaXMgc29ja2V0IGRvbWFpbgorCQkJCSAqIHJzb2NrZXQgY3VycmVu
dGx5IHJlY29nbml6ZXMgb25seSBBRl9JTkVULCBBRl9JTkVUNgorCQkJCSAqIGFuZCBBRl9JQiBk
b21haW5zCisJCQkJICogJyonIGltcGxpZXMgYWxsIHRoZSB2YWxpZCBkb21haW5zCisJCQkJICov
CisJCQkJaWYgKGkgPT0gMikgeworCQkJCQlpZiAoKnN1YnRva2VuID09ICcqJykgeworCQkJCQkJ
ZW50cnlwW25lbnRyaWVzXS5kb21haW4gfD0gKDEgPDwgQUZfSU5FVCk7CisJCQkJCQllbnRyeXBb
bmVudHJpZXNdLmRvbWFpbiB8PSAoMSA8PCBBRl9JTkVUNik7CisJCQkJCQllbnRyeXBbbmVudHJp
ZXNdLmRvbWFpbiB8PSAoMSA8PCBBRl9JQik7CisJCQkJCQlicmVhazsKKwkJCQkJfSBlbHNlIGlm
IChzdHJjbXAoc3VidG9rZW4sICJpbmV0NiIpID09IDApIHsKKwkJCQkJCWVudHJ5cFtuZW50cmll
c10uZG9tYWluIHw9ICgxIDw8IEFGX0lORVQ2KTsKKwkJCQkJfSBlbHNlIGlmIChzdHJjbXAoc3Vi
dG9rZW4sICJpbmV0IikgPT0gMCkgeworCQkJCQkJZW50cnlwW25lbnRyaWVzXS5kb21haW4gfD0g
KDEgPDwgQUZfSU5FVCk7CisJCQkJCX0gZWxzZSBpZiAoc3RyY21wKHN1YnRva2VuLCAiaWIiKSA9
PSAwKSB7CisJCQkJCQllbnRyeXBbbmVudHJpZXNdLmRvbWFpbiB8PSAoMSA8PCBBRl9JQik7CisJ
CQkJCX0KKwkJCQkJY29udGludWU7CisJCQkJfQorCisJCQkJLyogdGhpcmQgZmllbGQgaXMgc29j
a2V0IHR5cGUKKwkJCQkgKiByc29ja2V0IGN1cnJlbnRseSByZWNvZ25pemVzIG9ubHkgU09DS19T
VFJFQU0gYW5kCisJCQkJICogU09DS19ER1JBTSB0eXBlcworCQkJCSAqICcqJyBpbXBsaWVzIGFs
bCB0aGUgdmFsaWQgdHlwZXMKKwkJCQkgKi8KKwkJCQlpZiAoaSA9PSAzKSB7CisJCQkJCWlmICgq
c3VidG9rZW4gPT0gJyonKSB7CisJCQkJCQllbnRyeXBbbmVudHJpZXNdLnR5cGUgfD0gKDEgPDwg
U09DS19TVFJFQU0pOworCQkJCQkJZW50cnlwW25lbnRyaWVzXS50eXBlIHw9ICgxIDw8IFNPQ0tf
REdSQU0pOworCQkJCQkJYnJlYWs7CisJCQkJCX0gZWxzZSBpZiAoc3RyY21wKHN1YnRva2VuLCAi
c3RyZWFtIikgPT0gMCkgeworCQkJCQkJZW50cnlwW25lbnRyaWVzXS50eXBlIHw9ICgxIDw8IFNP
Q0tfU1RSRUFNKTsKKwkJCQkJfSBlbHNlIGlmIChzdHJjbXAoc3VidG9rZW4sICJkZ3JhbSIpID09
IDApIHsKKwkJCQkJCWVudHJ5cFtuZW50cmllc10udHlwZSB8PSAoMSA8PCBTT0NLX0RHUkFNKTsK
KwkJCQkJfQorCQkJCQljb250aW51ZTsKKwkJCQl9CisKKwkJCQkvKiBmb3VydGggZmllbGQgaXMg
c29ja2V0IHByb3RvY29sCisJCQkJICogcnNvY2tldCBjdXJyZW50bHkgcmVjZ29uaXplcyBvbmx5
IElQUFJPVE9fVENQIGFuZAorCQkJCSAqIElQUFJPVE9fVURQIHByb3RvY29scworCQkJCSAqICcq
JyBpbXBsaWVzIGFsbCB0aGUgdmFsaWQgcHJvdG9jb2xzCisJCQkJICovCisJCQkJaWYgKGkgPT0g
NCkgeworCQkJCQlpZiAoKnN1YnRva2VuID09ICcqJykgeworCQkJCQkJZW50cnlwW25lbnRyaWVz
XS5wcm90b2NvbCB8PSAoMSA8PCBJUFBST1RPX1RDUCk7CisJCQkJCQllbnRyeXBbbmVudHJpZXNd
LnByb3RvY29sIHw9ICgxIDw8IElQUFJPVE9fVURQKTsKKwkJCQkJCWJyZWFrOworCQkJCQl9IGVs
c2UgaWYgKHN0cmNtcChzdWJ0b2tlbiwgInRjcCIpID09IDApIHsKKwkJCQkJCWVudHJ5cFtuZW50
cmllc10ucHJvdG9jb2wgfD0gKDEgPDwgSVBQUk9UT19UQ1ApOworCQkJCQl9IGVsc2UgaWYgKHN0
cmNtcChzdWJ0b2tlbiwgInVkcCIpID09IDApIHsKKwkJCQkJCWVudHJ5cFtuZW50cmllc10ucHJv
dG9jb2wgfD0gKDEgPDwgSVBQUk9UT19VRFApOworCQkJCQl9CisJCQkJCWNvbnRpbnVlOworCQkJ
CX0KKwkJCX0KKwkJfQorCQluZW50cmllcyArPSAxOworCX0KKworc2Nhbl9kb25lOgorCWZjbG9z
ZShmcCk7CisJcmV0dXJuIHJldDsKK30KKworLyogZnJlZSBpbi1tZW1vcnkgY29uZmlnIHN0b3Jl
CisgKiBzaG91bGQgYmUgY2FsbGVkIG9ubHkgb25jZSBkdXJpbmcgZmluYWxpemF0aW9uCisgKi8K
K3N0YXRpYyB2b2lkIGZyZWVfcHJlbG9hZF9jb25maWcodm9pZCkKK3sKKwlpbnQgaTsKKworCWlm
IChlbnRyeXApIHsKKwkJZm9yIChpID0gMDsgaSA8IG5lbnRyaWVzOyBpKyspIHsKKwkJCWlmIChl
bnRyeXBbaV0ubmFtZSkgeworCQkJCWZyZWUoZW50cnlwW2ldLm5hbWUpOworCQkJfQorCQl9CisJ
CWZyZWUoZW50cnlwKTsKKwl9CisKKwlyZXR1cm47Cit9CisKKy8qIGNoZWNrIHdoZXRoZXIgaW50
ZXJjZXB0aW9uIGlzIHJlcXVpcmVkIGZvciB0aGlzIHNvY2tldAorICogY29tcGFyZXMgdGhlIHBy
b3ZpZGVkIGF0dHJpYnV0ZXMgd2l0aCB0aGF0IGF2YWlsYWJsZSBpbiB0aGUgaW4tbWVtb3J5Cisg
KiBkYXRhIHN0b3JlIGZvciB0aGUgY3VycmVudCBwcm9jZXNzCisgKiBzZXRzLXVwIGluLW1lbW9y
eSBjb25maWcgc3RvcmUgaWYgaXQncyBhbHJlYWR5IG5vdCBkb25lCisgKi8KK3N0YXRpYyBpbnQg
aW50ZXJjZXB0X3NvY2tldChpbnQgZG9tYWluLCBpbnQgdHlwZSwgaW50IHByb3RvY29sKQorewor
CWludCBpOworCisJLyogbG9jYXRlIHRoZSBjb25maWcgZW50cnkgKi8KKwlmb3IgKGkgPSAwOyBp
IDwgbmVudHJpZXM7IGkrKykgeworCQlpZiAoc3RybmNtcChlbnRyeXBbaV0ubmFtZSwgcHJvZ3Jh
bV9pbnZvY2F0aW9uX3Nob3J0X25hbWUsCisJCQkJCXN0cmxlbihlbnRyeXBbaV0ubmFtZSkpID09
IDApIHsKKwkJCWJyZWFrOworCQl9CisJfQorCWlmIChpID09IG5lbnRyaWVzKSB7CisJCXJldHVy
biAwOworCX0KKworCS8qIG1hdGNoIGRvbWFpbiBmaWVsZCAqLworCWlmICghKGVudHJ5cFtpXS5k
b21haW4gJiAoMSA8PCBkb21haW4pKSkgeworCQlyZXR1cm4gMDsKKwl9CisKKwkvKiBtYXRjaCB0
eXBlIGZpZWxkICovCisJaWYgKCEoZW50cnlwW2ldLnR5cGUgJiAoMSA8PCB0eXBlKSkpIHsKKwkJ
cmV0dXJuIDA7CisJfQorCisJLyogbWF0Y2ggcHJvdG9jb2wgZmllbGQgb25seSBpZiBwcm90b2Nv
bCBpcyBzcGVjaWZpZWQgKi8KKwlpZiAocHJvdG9jb2wgJiYgIShlbnRyeXBbaV0ucHJvdG9jb2wg
JiAoMSA8PCBwcm90b2NvbCkpKSB7CisJCXJldHVybiAwOworCX0KKworCS8qIGVudHJ5IG1hdGNo
ZWQgKi8KKwlyZXR1cm4gMTsKK30KKwogc3RhdGljIGludCBmZF9vcGVuKHZvaWQpCiB7CiAJc3Ry
dWN0IGZkX2luZm8gKmZkaTsKQEAgLTMwOCw2ICs1MjEsMTQgQEAgc3RhdGljIHZvaWQgaW5pdF9w
cmVsb2FkKHZvaWQpCiAJcnMuZmNudGwgPSBkbHN5bShSVExEX0RFRkFVTFQsICJyZmNudGwiKTsK
IAogCWdldGVudl9vcHRpb25zKCk7CisJCisJaWYgKHNjYW5fcHJlbG9hZF9jb25maWcoKSA9PSAw
KSB7CisJCWNvbmZpZ19hdmFpbCA9IDE7CisJfQorCWlmIChlbnRyeXApIHsKKwkJYXRleGl0KGZy
ZWVfcHJlbG9hZF9jb25maWcpOworCX0KKwogCWluaXQgPSAxOwogb3V0OgogCXB0aHJlYWRfbXV0
ZXhfdW5sb2NrKCZtdXQpOwpAQCAtNDA0LDEwICs2MjUsMTUgQEAgaW50IHNvY2tldChpbnQgZG9t
YWluLCBpbnQgdHlwZSwgaW50IHByb3RvY29sKQogCXN0YXRpYyBfX3RocmVhZCBpbnQgcmVjdXJz
aXZlOwogCWludCBpbmRleCwgcmV0OwogCisJaW5pdF9wcmVsb2FkKCk7CisKKwlpZiAoY29uZmln
X2F2YWlsICYmIGludGVyY2VwdF9zb2NrZXQoZG9tYWluLCB0eXBlLCBwcm90b2NvbCkgPT0gMCkg
eworCQlnb3RvIHJlYWw7CisJfQorCiAJaWYgKHJlY3Vyc2l2ZSkKIAkJZ290byByZWFsOwogCi0J
aW5pdF9wcmVsb2FkKCk7CiAJaW5kZXggPSBmZF9vcGVuKCk7CiAJaWYgKGluZGV4IDwgMCkKIAkJ
cmV0dXJuIGluZGV4Owo=
--=_a9ea670af75c08f8fb32108b1972ca9c--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
