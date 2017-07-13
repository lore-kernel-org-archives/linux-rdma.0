From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Add rdma service for kernel boot support
Date: Thu, 13 Jul 2017 12:20:18 -0600
Message-ID: <20170713182018.GE11069@obsidianresearch.com>
References: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
 <1499968101.2740.10.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499968101.2740.10.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 05:48:22PM +0000, Bart Van Assche wrote:
> On Thu, 2017-07-13 at 19:20 +0200, Benjamin Drung wrote:
> > Currently upstream does not provide a rdma or openibd service. Only the
> > RedHat package ships a rdma service and rdma modules configuration
> > files. The ibacm and srp_daemon services depend on the openibd service.
> > 
> > Make RedHat's rdma service available to all distros by cherry-picking
> > the basic files for the rdma service to run and trim them down to the
> > minimum. Do not pick workarounds or other quirk that might not needed
> > any more. Then replace the openibd service dependency by the rdma
> > service.
> 
> Hello Benjamin,
> 
> Shouldn't the rdma / openibd service be split into multiple services -
> one for IPoIB, one for the SRP initiator driver, one for the SRP target
> driver, one for the iSER initiator driver, one for the iSER target driver,
> one for RDS and one for NFSoRDMA? I think that would allow us to get rid
> of the rdma.conf configuration file and also that this would allow systemd
> to load those services concurrently that do not depend on each other.

I broadly agree.

For instance, Bart's work has already completely fixed srp to load
properly and race free. The missing piece is to have it also autoload
the required srp kernel module.

Benjamin, I have a different, simpler suggestion for some of the other
bits, let me post an RFC

Here is an untested attempt to move module loading into srp_daemon -
what do you think Bart?

Jason

>From 28c1e19719ed850bc8f328d187c536c97eef7fd7 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Thu, 13 Jul 2017 12:10:07 -0600
Subject: [PATCH] srp: Autoload the SRP kernel module if required

Doing this before starting the daemon ensures the daemon will work.
Since the daemon is using sysfs files there is no easy way to have the
kernel auto load it.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/srp_daemon.service.in       |  2 +-
 srp_daemon/srp_daemon_port@.service.in |  1 +
 srp_daemon/srp_kernel_module.service   | 12 ++++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)
 create mode 100644 srp_daemon/srp_kernel_module.service

diff --git a/srp_daemon/srp_daemon.service.in b/srp_daemon/srp_daemon.service.in
index 33dddd5cb46fef..cca1fce9c99283 100644
--- a/srp_daemon/srp_daemon.service.in
+++ b/srp_daemon/srp_daemon.service.in
@@ -1,6 +1,6 @@
 [Unit]
 Description=Daemon that discovers and logs in to SRP target systems
-Documentation=man:srp_daemon file:/etc/rdma/rdma.conf file:/etc/srp_daemon.conf
+Documentation=man:srp_daemon file:/etc/srp_daemon.conf
 DefaultDependencies=false
 Conflicts=emergency.target emergency.service
 Before=remote-fs-pre.target
diff --git a/srp_daemon/srp_daemon_port@.service.in b/srp_daemon/srp_daemon_port@.service.in
index 0ec966f912aec8..3c9c824fd243aa 100644
--- a/srp_daemon/srp_daemon_port@.service.in
+++ b/srp_daemon/srp_daemon_port@.service.in
@@ -3,6 +3,7 @@ Description=SRP daemon that monitors port %i
 Documentation=man:srp_daemon file:/etc/rdma/rdma.conf file:/etc/srp_daemon.conf
 DefaultDependencies=false
 Conflicts=emergency.target emergency.service
+Requires=srp_kernel_module.service
 After=srp_daemon.service dev-infiniband-umad-%i.device network.target
 BindsTo=srp_daemon.service dev-infiniband-umad-%i.device
 Before=remote-fs-pre.target
diff --git a/srp_daemon/srp_kernel_module.service b/srp_daemon/srp_kernel_module.service
new file mode 100644
index 00000000000000..b779031578dae1
--- /dev/null
+++ b/srp_daemon/srp_kernel_module.service
@@ -0,0 +1,12 @@
+[Unit]
+Description=Load the SRP daemon kernel module
+Documentation=man:srp_daemon
+After=systemd-modules-load.service
+ConditionCapability=CAP_SYS_MODULE
+ConditionPathIsDirectory=!/sys/class/infiniband_srp/
+
+[Service]
+Type=oneshot
+RemainAfterExit=yes
+ExecPre=bash -c 'mkdir -p /run/modules-load.d && echo ib_srp > /run/modules-load.d/rdma_core_srp_modules.conf'
+ExecStart=/lib/systemd/systemd-modules-load
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
