From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH rdma-core 2/5] srp_daemon: Use the recommended style in the man page
Date: Mon, 15 May 2017 15:47:24 -0700
Message-ID: <20170515224733.29586-3-bart.vanassche@sandisk.com>
References: <20170515224733.29586-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515224733.29586-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From https://liw.fi/manpages/, about the SYNOPSIS section:

Font usage is important here, and carries information. All the
parts that are in bold are things that the user is expected to
write verbatim. Italic indicates values the user is expected to
fill in. Normal font is used for syntax meta-characters: for
the brackets that indicate optionality, and the ellipsis that
indicates repetition.

Additionally, change the identifiers that refer to arguments to
lower case.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 srp_daemon/srp_daemon.1.in | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/srp_daemon/srp_daemon.1.in b/srp_daemon/srp_daemon.1.in
index 008d53a2..02e1f2df 100644
--- a/srp_daemon/srp_daemon.1.in
+++ b/srp_daemon/srp_daemon.1.in
@@ -5,18 +5,30 @@
 srp_daemon \- Discovers SRP targets in an InfiniBand Fabric
 
 .SH SYNOPSIS
-.B srp_daemon [-vVcaeon] [-d \fIumad-device\fR | -i \fIinfiniband-device\fR [-p \fIport-num\fR]] [-t \fItimeout(ms)\fR] [-r \fIretries\fR] [-R \fIRescan-time\fR] [-f \fIrules-File\fR]
+.B srp_daemon\fR [\fB-vVcaeon\fR] [\fB-d \fIumad-device\fR | \fB-i \fIinfiniband-device\fR [\fB-p \fIport-num\fR]] [\fB-t \fItimeout(ms)\fR] [\fB-r \fIretries\fR] [\fB-R \fIrescan-time\fR] [\fB-f \fIrules-file\fR]
 
 
 .SH DESCRIPTION
 .PP
 Discovers and connects to InfiniBand SCSI RDMA Protocol (SRP) targets in an IB fabric.
 
-Each srp_daemon instance operates on one local port. Upon boot it performs a full rescan of the fabric then waits for an srp_daemon event. An srp_daemon event can be a join of a new machine to the fabric, a change in the capabilities of a machine, an SA change, or an expiration of a predefined timeout.
+Each srp_daemon instance operates on one local port. Upon boot it performs a
+full rescan of the fabric and then waits for an srp_daemon event. An
+srp_daemon event can be a join of a new machine to the fabric, a change in the
+capabilities of a machine, an SA change, or an expiration of a predefined
+timeout.
 
-When a new machine joins the fabric, srp_daemon checks if it is a target. When there is a change of capabilities, srp_daemon checks if the machine has turned into a target. When there is an SA change or a timeout expiration, srp_daemon performs a full rescan of the fabric.
+When a new machine joins the fabric, srp_daemon checks if it is an SRP
+target. When there is a change of capabilities, srp_daemon checks if the
+machine has turned into an SRP target. When there is an SA change or a timeout
+expiration, srp_daemon performs a full rescan of the fabric.
 
-For each target srp_daemon finds, it checks if it should connect to this target according to its rules (default rules file is @CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf) and if it is already connected to the local port. If it should connect to this target and if it is not connected yet, srp_daemon can either print the target details or connect to it.
+For each target srp_daemon finds, it checks if it should connect to this
+target according to its rules (the default rules file is
+@CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf) and if it is already
+connected to the local port. If it should connect to this target and if it is
+not connected yet, srp_daemon can either print the target details or connect
+to it.
 
 .SH OPTIONS
 
@@ -42,24 +54,25 @@ Generate output suitable for piping directly to a
 /sys/class/infiniband_srp/srp\-<device>\-<port>/add_target file. 
 .TP
 \fB\-a\fR
-Prints all the targets in the fabric, not only targets that are not connected through the local port. (The same as ibsrpdm.)
+Prints all the targets in the fabric, not only targets that are not connected
+through the local port. This is the same behavior as that of ibsrpdm.
 .TP
 \fB\-e\fR
 Execute the connection command, i.e., make the connection to the target.
 .TP
 \fB\-o\fR
-Perform only one rescan and exit. (The same as ibsrpdm.)
+Perform only one rescan and exit just like ibsrpdm.
 .TP
-\fB\-R\fR \fIRescan-time\fR
-Force a complete rescan every \fIRescan-time\fR seconds. If -R is not specified, no timeout rescans will be performed.
+\fB\-R\fR \fIrescan-time\fR
+Force a complete rescan every \fIrescan-time\fR seconds. If -R is not specified, no timeout rescans will be performed.
 .TP
-\fB\-T\fR \fIretry-Timeout\fR
-Retries to connect to existing target after \fIretry-Timeout\fR seconds. If -R is not specified, uses 5 Seconds timeout. if retry-Timeout is 0, will not try to reconnect. The reason srp_daemon retries to connect to the target is because there may be a rare scnerio in which srp_daemon will try to connect to add a target when the target is about to be removed, but is not removed yet.
+\fB\-T\fR \fIretry-timeout\fR
+Retries to connect to existing target after \fIretry-timeout\fR seconds. If -R is not specified, uses 5 Seconds timeout. if retry-timeout is 0, will not try to reconnect. The reason srp_daemon retries to connect to the target is because there may be a rare scnerio in which srp_daemon will try to connect to add a target when the target is about to be removed, but is not removed yet.
 .TP
-\fB\-f\fR \fIrules-File\fR
-Decide to which targets to connect according to the rules in \fIrules-File\fR. 
+\fB\-f\fR \fIrules-file\fR
+Decide to which targets to connect according to the rules in \fIrules-file\fR.
 If \fB\-f\fR is not specified, uses the default rules file @CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf.
-Each line in the \fIrules-File\fR is a rule which can be either an allow connection or a disallow connection according to 
+Each line in the \fIrules-file\fR is a rule which can be either an allow connection or a disallow connection according to
 the first character in the line (a or d accordingly). The rest of the line is values for id_ext, ioc_guid, dgid, 
 service_id. Please take a look at the example section for an example of the file. srp_daemon decide whether to allow or disallow each target according  to first rule that match the target. If no rule matches the target, the target is allowed and will be connected. In an allow rule it is possible to set attributes for the connection to the target. Supported attributes are max_cmd_per_lun and max_sect.
 .TP
@@ -74,7 +87,7 @@ New format - use also initiator_ext in the connection command.
 
 .SH FILES
 @CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf -
-Default rules configuration file that indicates to which targets to connect. Can be overridden using the \fB\-f\fR \fIrules-File\fR option. 
+Default rules configuration file that indicates to which targets to connect. Can be overridden using the \fB\-f\fR \fIrules-file\fR option.
 Each line in this file is a rule which can be either an allow connection or a disallow connection according to 
 the first character in the line (a or d accordingly). The rest of the line is values for id_ext, ioc_guid, dgid, 
 service_id. Please take a look at the example section for an example of the file. srp_daemon decide whether to allow or disallow each target according  to first rule that match the target. If no rule matches the target, the target is allowed and will be connected. In an allow rule it is possible to set attributes for the connection to the target. Supported attributes are max_cmd_per_lun and max_sect.
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
