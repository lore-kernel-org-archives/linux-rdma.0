From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 01/10] verbs: Hardware tag matching
Date: Mon, 23 Oct 2017 16:17:52 +0300
Message-ID: <1508764681-4531-2-git-send-email-yishaih@mellanox.com>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a document that provides terms and core explanations
for tag matching (TM). It describes its protocols, matching process and
the relation to RDMA.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Documentation/CMakeLists.txt  |   1 +
 Documentation/tag_matching.md | 132 ++++++++++++++++++++++++++++++++++++++++++
 debian/rdma-core.install      |   1 +
 redhat/rdma-core.spec         |   1 +
 suse/rdma-core.spec           |   1 +
 5 files changed, 136 insertions(+)
 create mode 100644 Documentation/tag_matching.md

diff --git a/Documentation/CMakeLists.txt b/Documentation/CMakeLists.txt
index d6e08de..4b9e07f 100644
--- a/Documentation/CMakeLists.txt
+++ b/Documentation/CMakeLists.txt
@@ -6,6 +6,7 @@ install(FILES
   librdmacm.md
   rxe.md
   udev.md
+  tag_matching.md
   ../README.md
   ../MAINTAINERS
   DESTINATION "${CMAKE_INSTALL_DOCDIR}")
diff --git a/Documentation/tag_matching.md b/Documentation/tag_matching.md
new file mode 100644
index 0000000..5b5cd7d
--- /dev/null
+++ b/Documentation/tag_matching.md
@@ -0,0 +1,132 @@
+# Hardware tag matching
+
+## Introduction
+
+The MPI standard defines a set of rules, known as tag-matching, for matching
+source send operations to destination receives according to the following
+attributes:
+
+* Communicator
+* User tag - wild card may be specified by the receiver
+* Source rank - wild card may be specified by the receiver
+* Destination rank - wild card may be specified by the receiver
+
+These matching attributes are specified by all Send and Receive operations.
+Send operations from a given source to a given destination are processed in
+the order in which the Sends were posted. Receive operations are associated
+with the earliest send operation (from any source) that matches the
+attributes, in the order in which the Receives were posted. Note that Receive
+tags are not necessarily consumed in the order they are created, e.g., a later
+generated tag may be consumed if earlier tags do not satisfy the matching
+rules.
+
+When a message arrives at the receiver, MPI implementations often classify it
+as either 'expected' or 'unexpected' according to whether a Receive operation
+with a matching tag has already been posted by the application. In the
+expected case, the message may be processed immediately. In the unexpected
+case, the message is saved in an unexpected message queue, and will be
+processed when a matching Receive operation is posted.
+
+To bound the amount of memory to hold unexpected messages, MPI implementations
+use 2 data transfer protocols. The 'eager' protocol is used for small
+messages. Eager messages are sent without any prior synchronization and
+processed/buffered at the receiver. Typically, with RDMA, a single RDMA-Send
+operation is used to transfer the data.
+
+The 'rendezvous' protocol is used for large messages. Initially, only the
+message tag is sent along with some meta-data. Only when the tag is matched to
+a Receive operation, will the receiver initiate the corresponding data
+transfer. A common RDMA implementation is to send the message tag with an
+RDMA-Send, and transfer the data with an RDMA-Read issued by the receiver.
+When the transfer is complete, the receiver will notify the sender that its
+buffer may be freed using an RDMA-Send.
+
+## RDMA tag-matching offload
+
+Tag-matching offload satisfies the following principals:
+-   Tag-matching is viewed as an RDMA application, and thus does not affect the
+    RDMA transport in any way [(*)](#m1)
+-   Tag-matching processing will be split between HW and SW.
+    *   HW will hold a bounded prefix of Receive tags
+-   HW will process and transfer any expected message that matches a tag held
+    in HW.
+    *   In case the message uses the rendezvous protocol, HW will also initiate
+	the RDMA-Read data transfer and send a notification message when the
+	data transfer completes.
+-   SW will handle any message that is either unexpected or whose tag is not
+    held in HW.
+
+<a name="m1">(*)</a>
+This concept can apply to additional application-specific offloads in the
+future.
+
+Tag-matching is initially defined for RC transport. Tag-matching messages are
+encapsulated in RDMA-Send messages and contain the following headers:
+
+```
+    0                   1                   2                   3
+    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+   Tag Matching Header (TMH):
+   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+   |    Operation  |                  reserved                     |
+   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+   |                      User data (optional)                     |
+   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+   |                             Tag                               |
+   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+   |                             Tag                               |
+   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+
+   Rendezvous Header (RVH):
+   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+   |                         Virtual Address                       |
+   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+   |                         Virtual Address                       |
+   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+   |                           Remote Key                          |
+   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+   |                             Length                            |
+   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+```
+
+Tag-matching messages always contain a TMH. An RHV is added for Rendezvous
+request messages. The following message formats are defined:
+-   Eager request: TMH | payload
+-   Rendezvous request: TMH | RHV | optional meta-data [(**)](#m2)
+-   Rendezvous response: TMH
+
+Note that rendezvous data transfers are standard RDMA-Reads
+
+<a name="m2">(**)</a>
+Rendezvous request messages may also arrive unexpected; in this case, the
+message is handled in SW, optionally leveraging additional meta-data passed by
+the sender.
+
+As tag-matching messages are standard RDMA-Sends, no special HW support is
+needed at the sender. At the receiver, we introduce a new SRQ type - a
+Tag-Matching SRQ (TM-SRQ). The TM-SRQ forms the serialization point for
+matching messages coming from any of the associated RC connections, and reports
+all tag matching completions and events to a dedicated CQ.
+2 kinds of buffers may be posted to the TM-SRQ:
+-   Buffers associated with tags (tagged-buffers), which are used when a match
+    is made by HW
+-   Standard SRQ buffers, which are used for unexpected messages (from HW's
+    perspective)
+When a message is matched by HW, the payload is transferred directly to the
+application buffer (both in the eager and the rendezvous case), while skipping
+any TM headers. Otherwise, the entire message, including any TM headers, is
+scattered to the SRQ buffer.
+
+Since unexpected messages are handled in SW, there exists an inherent race
+between the arrival of messages from the wire and posting of new tagged
+buffers. For example, consider 2 incoming messages m1 and m2 and matching
+buffers b1 and b2 that are posted asynchronously. If b1 is posted after m1
+arrives but before m2, m1 would be delivered as an unexpected message while m2
+would match b1, violating the ordering rules.
+
+Consequently, whenever HW deems a message unexpected, tag matching must be
+disabled for new tags until SW and HW synchronize. This synchronization is
+achieved by reporting to HW the number of unexpected messages handled by SW
+(with respect to the current posted tags). When the SW and HW are in synch, tag
+matching resumes normally.
+
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index ca08a9d..da3e73c 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -27,6 +27,7 @@ usr/share/doc/rdma-core/MAINTAINERS
 usr/share/doc/rdma-core/README.md
 usr/share/doc/rdma-core/rxe.md
 usr/share/doc/rdma-core/udev.md
+usr/share/doc/rdma-core/tag_matching.md
 usr/share/man/man5/iwpmd.conf.5
 usr/share/man/man7/rxe.7
 usr/share/man/man8/iwpmd.8
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 48b7d30..ae399df 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -318,6 +318,7 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 %doc %{_docdir}/%{name}-%{version}/README.md
 %doc %{_docdir}/%{name}-%{version}/rxe.md
 %doc %{_docdir}/%{name}-%{version}/udev.md
+%doc %{_docdir}/%{name}-%{version}/tag_matching.md
 %config(noreplace) %{_sysconfdir}/rdma/mlx4.conf
 %config(noreplace) %{_sysconfdir}/rdma/modules/infiniband.conf
 %config(noreplace) %{_sysconfdir}/rdma/modules/iwarp.conf
diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
index defe3b4..03c4a29 100644
--- a/suse/rdma-core.spec
+++ b/suse/rdma-core.spec
@@ -544,6 +544,7 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 %doc %{_docdir}/%{name}-%{version}/libibverbs.md
 %doc %{_docdir}/%{name}-%{version}/rxe.md
 %doc %{_docdir}/%{name}-%{version}/udev.md
+%doc %{_docdir}/%{name}-%{version}/tag_matching.md
 %{_bindir}/rxe_cfg
 %{_mandir}/man7/rxe*
 %{_mandir}/man8/rxe*
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
