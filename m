From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 18/23] iwpmd: Add man pages
Date: Wed, 21 Sep 2016 16:08:44 -0600
Message-ID: <1474495729-17604-19-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474495729-17604-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474495729-17604-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt       |  1 +
 iwpmd/CMakeLists.txt |  4 ++++
 iwpmd/iwpmd.1        | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 iwpmd/iwpmd.conf.5   | 20 +++++++++++++++++++
 4 files changed, 81 insertions(+)
 create mode 100644 iwpmd/CMakeLists.txt
 create mode 100644 iwpmd/iwpmd.1
 create mode 100644 iwpmd/iwpmd.conf.5

diff --git a/CMakeLists.txt b/CMakeLists.txt
index b8875b4853c0..a829cd477c52 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -249,6 +249,7 @@ add_subdirectory(librxe/)
 # Binaries
 add_subdirectory(ibacm)
 if (NOT NL_KIND EQUAL 0)
+  add_subdirectory(iwpmd)
   add_subdirectory(iwpmd/src)
 endif()
 add_subdirectory(libibcm/examples)
diff --git a/iwpmd/CMakeLists.txt b/iwpmd/CMakeLists.txt
new file mode 100644
index 000000000000..21208dd5b82a
--- /dev/null
+++ b/iwpmd/CMakeLists.txt
@@ -0,0 +1,4 @@
+rdma_man_pages(
+  iwpmd.1
+  iwpmd.conf.5
+  )
diff --git a/iwpmd/iwpmd.1 b/iwpmd/iwpmd.1
new file mode 100644
index 000000000000..a4948c509f3b
--- /dev/null
+++ b/iwpmd/iwpmd.1
@@ -0,0 +1,56 @@
+.TH "iwpmd" 1 "2016-09-16" "iwpmd" "iwpmd" iwpmd
+.SH NAME
+iwpmd \- port mapping services for iWARP.
+.SH SYNOPSIS
+.sp
+.nf
+\fIiwpmd\fR
+.fi
+.SH "DESCRIPTION"
+The iWARP Port Mapper Daemon provides a user space service (iwpmd) for the
+iWarp drivers to claim tcp ports through the standard socket interface.
+.P
+The kernel space support for the port mapper is part of the iw_cm module.
+The ib_core module includes netlink support, which is used by the port
+mapper clients to exchange messages with iwpmd. Both modules iw_cm and
+ib_core need to be loaded in order for the libiwpm service to start
+successfully.
+.SH "IWARP PORT MAPPING DETAILS"
+The iWARP Port Mapper implementation is based on the port mapper
+specification section in the Sockets Direct Protocol:
+http://www.rdmaconsortium.org/home/draft-pinkerton-iwarp-sdp-v1.0.pdf
+.P
+Existing iWARP RDMA providers use the same IP address as the native
+TCP/IP stack when creating RDMA connections.  They need a mechanism to
+claim the TCP ports used for RDMA connections to prevent TCP port
+collisions when other host applications use TCP ports.  The iWARP Port
+Mapper provides a standard mechanism to accomplish this.  Without this
+service it is possible for RDMA application to bind/listen on the same
+port which is already being used by native TCP host application.  If
+that happens the incoming TCP connection data can be passed to the
+RDMA stack with error.
+.P
+The iWARP Connection Manager (port mapper client) sends to the IWPM
+service the local IP address and TCP port it has received from the RDMA
+application, when starting a connection.  The IWPM service performs
+a socket bind from user space to get an available TCP port, called a
+mapped port, and communicates it back to the client.  In that sense,
+the IWPM service is used to map the TCP port, which the RDMA application
+uses to any port available from the host TCP port space. The mapped ports
+are used in iWARP RDMA connections to avoid collisions with native TCP
+stack which is aware that these ports are taken. When an RDMA connection
+using a mapped port is terminated, the client notifies the IWPM service,
+which then releases the TCP port.
+.P
+The message exchange between iwpmd and the iWARP Connection Manager
+(between user space and kernel space) is implemented using netlink
+sockets.
+.SH "SIGNALS"
+SIGUSR1 will force a dump of the current mappings
+to the system message log.
+.P
+SIGTERM/SIGHUP will force iwpmd to exit.
+.SH "FILES"
+/etc/iwpmd.conf
+.SH "SEE ALSO"
+rdma_cm(7)
diff --git a/iwpmd/iwpmd.conf.5 b/iwpmd/iwpmd.conf.5
new file mode 100644
index 000000000000..9dfe137d3fab
--- /dev/null
+++ b/iwpmd/iwpmd.conf.5
@@ -0,0 +1,20 @@
+.TH "iwpmd.conf" 5 "2016-09-16" "iwpmd.conf" "iwpmd.conf" iwpmd.conf
+.SH NAME
+iwpmd.conf \- iWARP port mapper config file.
+.SH SYNOPSIS
+.sp
+.nf
+\fIiwpmd.conf\fR
+.fi
+.SH "DESCRIPTION"
+The iwpmd.conf file provides configuration parameters for iwpmd.  Parameters
+are in the form: param=value, and one per line.  Parameters include:
+.P
+nl_sock_rbuf_size - The socket buffer size of the netlink socket used
+to communicate with the kernel port map client.  The default is 400MB.
+.SH "EXAMPLES"
+nl_sock_rbuf_size=419430400
+.SH "FILES"
+/etc/iwpmd.conf
+.SH "SEE ALSO"
+iwpmd(1)
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
