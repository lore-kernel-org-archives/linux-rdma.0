From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-core patch] srp_daemon: srp_daemon.service should be
 started after network.target
Date: Sat, 30 Dec 2017 21:59:27 +0800
Message-ID: <20171230135927.GA23643@dhcp-13-42.nay.redhat.com>
References: <20171229101006.27861-1-honli@redhat.com>
 <20171229180058.GC6513@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171229180058.GC6513-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Dec 29, 2017 at 11:00:58AM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 29, 2017 at 06:10:06PM +0800, Honggang LI wrote:
> > From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > The srp_daemon service will be started at the very beginning state
> > of systemd when boot/reboot the machine, in case srp_daemon.service
> > is not after network.target. As result, the srp_daemon.service will
> > be terminated because of SERVICE_FAILURE_RESOURCES.
> 
> How is this possible?  srp_daemon.service just runs a script that
> doesn't touch the network.

To reproduce it, you just need enable srp_daemon.serice and then reboot
the machine. Watch the serial console when you are waiting for machine
boot up. Please see attached /var/log/boot.log for details. After system
boot up, check the status of srp_daemon.serice.

============
systemctl status srp_daemon.service -l
● srp_daemon.service - Daemon that discovers and logs in to SRP target systems
   Loaded: loaded (/usr/lib/systemd/system/srp_daemon.service; enabled; vendor preset: disabled)
   Active: failed (Result: resources)
     Docs: man:srp_daemon
           file:/etc/srp_daemon.conf

Dec 30 08:45:25 localhost.localdomain systemd[1]: [/usr/lib/systemd/system/srp_daemon.service:12] Unknown lvalue 'MemoryDenyWriteExecute' in section 'Service'
Dec 30 08:45:25 localhost.localdomain systemd[1]: [/usr/lib/systemd/system/srp_daemon.service:15] Unknown lvalue 'ProtectKernelModules' in section 'Service'
Dec 30 08:45:25 localhost.localdomain systemd[1]: [/usr/lib/systemd/system/srp_daemon.service:16] Unknown lvalue 'RestrictRealtime' in section 'Service'
=============

Note, it does not make any difference after remove all unknown lvaule
from srp_daemon.serivce and srp_daemon_port@serivce. We are using an
old version of systemd, which does not support such lvaule.

> 
> I can't see any way that srp_daemon.service should have this added,
> please explain more what is going on.
> 
> I could potentially understand needing it in srp_daemon_port@.service,

No, it does not work with srp_daemon_port@.service.

$ grep -w -n network.target /usr/lib/systemd/system/srp_daemon*
/usr/lib/systemd/system/srp_daemon_port@.service:21:After=srp_daemon.service network.target

> but even that needs much more explaination about what exactly is
> causing this requirement.
> 
> You said SERVICE_FAILURE_RESOURCES which is an internal systemd error
> code. 

Yes, it is systemd-219-51.el7.x86_64 error code.

> Is this because of PrivateNetwork=yes or something similar?

How to test or verify this?

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="boot.log"
Content-Transfer-Encoding: quoted-printable

[=1B[32m  OK  =1B[0m] Started Show Plymouth Boot Screen.=0D
[=1B[32m  OK  =1B[0m] Reached target Paths.=0D
[=1B[32m  OK  =1B[0m] Reached target Basic System.=0D
=1B%G[=1B[32m  OK  =1B[0m] Found device MB0500GCEHF 7.=0D
         Starting File System Check on /dev/...7-f857-41d3-b7ad-5b9618f6f39=
e...=0D
[=1B[32m  OK  =1B[0m] Started dracut initqueue hook.=0D
[=1B[32m  OK  =1B[0m] Reached target Remote File Systems (Pre).=0D
[=1B[32m  OK  =1B[0m] Reached target Remote File Systems.=0D
[=1B[32m  OK  =1B[0m] Started File System Check on /dev/d...7b7-f857-41d3-b=
7ad-5b9618f6f39e.=0D
         Mounting /sysroot...=0D
[=1B[32m  OK  =1B[0m] Mounted /sysroot.=0D
[=1B[32m  OK  =1B[0m] Reached target Initrd Root File System.=0D
         Starting Reload Configuration from the Real Root...=0D
[=1B[32m  OK  =1B[0m] Started Reload Configuration from the Real Root.=0D
[=1B[32m  OK  =1B[0m] Reached target Initrd File Systems.=0D
[=1B[32m  OK  =1B[0m] Reached target Initrd Default Target.=0D
         Starting dracut pre-pivot and cleanup hook...=0D
[=1B[32m  OK  =1B[0m] Started dracut pre-pivot and cleanup hook.=0D
         Starting Cleaning Up and Shutting Down Daemons...=0D
[=1B[32m  OK  =1B[0m] Stopped target Timers.=0D
         Starting Plymouth switch root service...=0D
[=1B[32m  OK  =1B[0m] Stopped Cleaning Up and Shutting Down Daemons.=0D
[=1B[32m  OK  =1B[0m] Stopped dracut pre-pivot and cleanup hook.=0D
         Stopping dracut pre-pivot and cleanup hook...=0D
[=1B[32m  OK  =1B[0m] Stopped target Remote File Systems.=0D
[=1B[32m  OK  =1B[0m] Stopped target Remote File Systems (Pre).=0D
[=1B[32m  OK  =1B[0m] Stopped dracut initqueue hook.=0D
         Stopping dracut initqueue hook...=0D
[=1B[32m  OK  =1B[0m] Stopped target Initrd Default Target.=0D
[=1B[32m  OK  =1B[0m] Stopped target Basic System.=0D
[=1B[32m  OK  =1B[0m] Stopped target Paths.=0D
[=1B[32m  OK  =1B[0m] Stopped target Slices.=0D
[=1B[32m  OK  =1B[0m] Stopped target System Initialization.=0D
         Stopping udev Kernel Device Manager...=0D
[=1B[32m  OK  =1B[0m] Stopped target Local File Systems.=0D
[=1B[32m  OK  =1B[0m] Stopped udev Coldplug all Devices.=0D
         Stopping udev Coldplug all Devices...=0D
[=1B[32m  OK  =1B[0m] Stopped Apply Kernel Variables.=0D
         Stopping Apply Kernel Variables...=0D
[=1B[32m  OK  =1B[0m] Stopped target Swap.=0D
[=1B[32m  OK  =1B[0m] Stopped target Sockets.=0D
[=1B[32m  OK  =1B[0m] Stopped udev Kernel Device Manager.=0D
[=1B[32m  OK  =1B[0m] Stopped Create Static Device Nodes in /dev.=0D
         Stopping Create Static Device Nodes in /dev...=0D
[=1B[32m  OK  =1B[0m] Stopped Create list of required sta...ce nodes for th=
e current kernel.=0D
         Stopping Create list of required st... nodes for the current kerne=
l...=0D
[=1B[32m  OK  =1B[0m] Stopped dracut pre-udev hook.=0D
         Stopping dracut pre-udev hook...=0D
[=1B[32m  OK  =1B[0m] Stopped dracut cmdline hook.=0D
         Stopping dracut cmdline hook...=0D
[=1B[32m  OK  =1B[0m] Closed udev Control Socket.=0D
[=1B[32m  OK  =1B[0m] Closed udev Kernel Socket.=0D
         Starting Cleanup udevd DB...=0D
[=1B[32m  OK  =1B[0m] Started Cleanup udevd DB.=0D
[=1B[32m  OK  =1B[0m] Reached target Switch Root.=0D
[=1B[32m  OK  =1B[0m] Started Plymouth switch root service.=0D
         Starting Switch Root...=0D
=0D
Welcome to =1B[0;31mRed Hat Enterprise Linux Server 7.5 Beta (Maipo)=1B[0m!=
=0D
=0D
[=1B[32m  OK  =1B[0m] Stopped Switch Root.=0D
[=1B[32m  OK  =1B[0m] Stopped Journal Service.=0D
         Starting Journal Service...=0D
[=1B[32m  OK  =1B[0m] Listening on udev Control Socket.=0D
[=1B[32m  OK  =1B[0m] Listening on udev Kernel Socket.=0D
         Mounting POSIX Message Queue File System...=0D
[=1B[1;31mFAILED=1B[0m] Failed to start Daemon that discove...d logs in to =
SRP target systems.=0D
See 'systemctl status srp_daemon.service' for details.=0D
         Starting Daemon that discovers and logs in to SRP target systems..=
=2E=0D
[=1B[32m  OK  =1B[0m] Created slice system-selinux\x2dpol...grate\x2dlocal\=
x2dchanges.slice.=0D
[=1B[32m  OK  =1B[0m] Listening on /dev/initctl Compatibility Named Pipe.=0D
[=1B[32m  OK  =1B[0m] Stopped File System Check on Root Device.=0D
         Stopping File System Check on Root Device...=0D
[=1B[32m  OK  =1B[0m] Set up automount Arbitrary Executab...ats File System=
 Automount Point.=0D
[=1B[32m  OK  =1B[0m] Created slice User and Session Slice.=0D
         Mounting Huge Pages File System...=0D
[=1B[32m  OK  =1B[0m] Reached target Slices.=0D
[=1B[32m  OK  =1B[0m] Listening on Delayed Shutdown Socket.=0D
[=1B[32m  OK  =1B[0m] Created slice system-serial\x2dgetty.slice.=0D
[=1B[32m  OK  =1B[0m] Reached target Local Encrypted Volumes.=0D
         Mounting Debug File System...=0D
[=1B[32m  OK  =1B[0m] Stopped target Switch Root.=0D
[=1B[32m  OK  =1B[0m] Stopped target Initrd File Systems.=0D
         Starting Create list of required st... nodes for the current kerne=
l...=0D
[=1B[32m  OK  =1B[0m] Stopped target Initrd Root File System.=0D
[=1B[32m  OK  =1B[0m] Created slice system-getty.slice.=0D
         Starting Initialize the iWARP/InfiniBand/RDMA stack in the kernel.=
=2E.=0D
         Starting Apply Kernel Variables...=0D
         Starting Remount Root and Kernel File Systems...=0D
[=1B[32m  OK  =1B[0m] Created slice system-systemd\x2dfsck.slice.=0D
[=1B[32m  OK  =1B[0m] Mounted Debug File System.=0D
[=1B[32m  OK  =1B[0m] Mounted POSIX Message Queue File System.=0D
[=1B[32m  OK  =1B[0m] Mounted Huge Pages File System.=0D
[=1B[32m  OK  =1B[0m] Started Journal Service.=0D
[=1B[32m  OK  =1B[0m] Started Create list of required sta...ce nodes for th=
e current kernel.=0D
[=1B[32m  OK  =1B[0m] Started Remount Root and Kernel File Systems.=0D
         Starting Load/Save Random Seed...=0D
         Starting Configure read-only root support...=0D
         Starting udev Coldplug all Devices...=0D
         Starting Create Static Device Nodes in /dev...=0D
         Starting Flush Journal to Persistent Storage...=0D
[=1B[32m  OK  =1B[0m] Started Apply Kernel Variables.=0D
[=1B[32m  OK  =1B[0m] Started udev Coldplug all Devices.=0D
[=1B[32m  OK  =1B[0m] Started Load/Save Random Seed.=0D
[=1B[32m  OK  =1B[0m] Started Flush Journal to Persistent Storage.=0D
[=1B[32m  OK  =1B[0m] Started Create Static Device Nodes in /dev.=0D
[=1B[32m  OK  =1B[0m] Reached target Local File Systems (Pre).=0D
         Starting udev Kernel Device Manager...=0D
[=1B[32m  OK  =1B[0m] Started Configure read-only root support.=0D
[=1B[32m  OK  =1B[0m] Started udev Kernel Device Manager.=0D
[=1B[32m  OK  =1B[0m] Found device /dev/ttyS1.=0D
=1B%G=1B%G[=1B[32m  OK  =1B[0m] Found device MB0500GCEHF 3.=0D
[=1B[32m  OK  =1B[0m] Found device MB0500GCEHF 2.=0D
[=1B[32m  OK  =1B[0m] Found device MB0500GCEHF 6.=0D
[=1B[32m  OK  =1B[0m] Found device MB0500GCEHF 5.=0D
         Mounting /mnt/rdma-xfs...=0D
         Activating swap /dev/disk/by-uuid/a...6-f0ce-4513-99fa-72bbdb9f530=
9...=0D
         Mounting /boot...=0D
         Starting File System Check on /dev/...6-129a-4cb2-9040-a0484cbc876=
5...=0D
[=1B[32m  OK  =1B[0m] Activated swap /dev/disk/by-uuid/add068f6-f0ce-4513-9=
9fa-72bbdb9f5309.=0D
[=1B[32m  OK  =1B[0m] Reached target Swap.=0D
[   17.739449] systemd-fsck[561]: /dev/sda3: clean, 11/1638400 files, 14689=
3/6553600 blocks=0D
[=1B[32m  OK  =1B[0m] Mounted /boot.=0D
[=1B[32m  OK  =1B[0m] Started File System Check on /dev/d...386-129a-4cb2-9=
040-a0484cbc8765.=0D
         Mounting /mnt/rdma-ext4...=0D
[=1B[32m  OK  =1B[0m] Mounted /mnt/rdma-xfs.=0D
[=1B[32m  OK  =1B[0m] Mounted /mnt/rdma-ext4.=0D
[=1B[32m  OK  =1B[0m] Reached target Local File Systems.=0D
         Starting Preprocess NFS configuration...=0D
         Starting Tell Plymouth To Write Out Runtime Data...=0D
         Starting Import network configuration from initramfs...=0D
         Starting RDMA Node Description Daemon...=0D
[=1B[32m  OK  =1B[0m] Created slice system-rdma\x2dload\x2dmodules.slice.=0D
         Starting Load RDMA modules from /etc/rdma/modules/roce.conf...=0D
         Starting Load RDMA modules from /etc/rdma/modules/infiniband.conf.=
=2E.=0D
         Starting Load RDMA modules from /etc/rdma/modules/rdma.conf...=0D
[=1B[32m  OK  =1B[0m] Started Preprocess NFS configuration.=0D
[=1B[32m  OK  =1B[0m] Started Load RDMA modules from /etc/rdma/modules/roce=
=2Econf.=0D
[=1B[32m  OK  =1B[0m] Started Import network configuration from initramfs.=
=0D
         Starting Create Volatile Files and Directories...=0D
[=1B[32m  OK  =1B[0m] Started Tell Plymouth To Write Out Runtime Data.=0D
[=1B[32m  OK  =1B[0m] Started RDMA Node Description Daemon.=0D
[=1B[32m  OK  =1B[0m] Started Create Volatile Files and Directories.=0D
         Starting Security Auditing Service...=0D
         Mounting RPC Pipe File System...=0D
[=1B[32m  OK  =1B[0m] Started Load RDMA modules from /etc/rdma/modules/infi=
niband.conf.=0D
[=1B[32m  OK  =1B[0m] Mounted RPC Pipe File System.=0D
[=1B[32m  OK  =1B[0m] Reached target rpc_pipefs.target.=0D
[=1B[32m  OK  =1B[0m] Started Load RDMA modules from /etc/rdma/modules/rdma=
=2Econf.=0D
[=1B[32m  OK  =1B[0m] Reached target RDMA Hardware.=0D
[=1B[32m  OK  =1B[0m] Reached target Network (Pre).=0D
[=1B[32m  OK  =1B[0m] Started Initialize the iWARP/InfiniBand/RDMA stack in=
 the kernel.=0D
         Starting Starts the OpenSM InfiniBand fabric Subnet Manager...=0D
[=1B[32m  OK  =1B[0m] Started Starts the OpenSM InfiniBand fabric Subnet Ma=
nager.=0D
[=1B[32m  OK  =1B[0m] Started Security Auditing Service.=0D
         Starting Update UTMP about System Boot/Shutdown...=0D
[=1B[32m  OK  =1B[0m] Started Update UTMP about System Boot/Shutdown.=0D
[=1B[32m  OK  =1B[0m] Reached target System Initialization.=0D
[=1B[32m  OK  =1B[0m] Reached target Paths.=0D
[=1B[32m  OK  =1B[0m] Listening on D-Bus System Message Bus Socket.=0D
[=1B[32m  OK  =1B[0m] Reached target Timers.=0D
[=1B[32m  OK  =1B[0m] Listening on Open-iSCSI iscsid Socket.=0D
[=1B[32m  OK  =1B[0m] Listening on RPCbind Server Activation Socket.=0D
         Starting RPC bind service...=0D
[=1B[32m  OK  =1B[0m] Listening on Open-iSCSI iscsiuio Socket.=0D
[=1B[32m  OK  =1B[0m] Reached target Sockets.=0D
[=1B[32m  OK  =1B[0m] Reached target Basic System.=0D
         Starting GSSAPI Proxy Daemon...=0D
[=1B[32m  OK  =1B[0m] Started D-Bus System Message Bus.=0D
         Starting D-Bus System Message Bus...=0D
         Starting Network Manager...=0D
         Starting Dump dmesg to /var/log/dmesg...=0D
[=1B[32m  OK  =1B[0m] Started irqbalance daemon.=0D
         Starting irqbalance daemon...=0D
         Starting Login Service...=0D
         Starting Authorization Manager...=0D
         Starting Load CPU microcode update...=0D
         Starting NTP client/server...=0D
[=1B[32m  OK  =1B[0m] Started RPC bind service.=0D
[=1B[32m  OK  =1B[0m] Started GSSAPI Proxy Daemon.=0D
[=1B[32m  OK  =1B[0m] Started Load CPU microcode update.=0D
[=1B[32m  OK  =1B[0m] Reached target NFS client services.=0D
[=1B[32m  OK  =1B[0m] Started Login Service.=0D
[=1B[32m  OK  =1B[0m] Started Dump dmesg to /var/log/dmesg.=0D
[=1B[32m  OK  =1B[0m] Started NTP client/server.=0D
         Starting Wait for chrony to synchronize system clock...=0D
[=1B[32m  OK  =1B[0m] Started Authorization Manager.=0D
         Starting Hostname Service...=0D
[=1B[32m  OK  =1B[0m] Started Hostname Service.=0D
[=1B[32m  OK  =1B[0m] Started Network Manager.=0D
[=1B[32m  OK  =1B[0m] Reached target Network.=0D
         Starting Enable periodic update of entitlement certificates....=0D
         Starting Login and scanning of iSCSI devices...=0D
         Starting OpenSSH server daemon...=0D
         Starting Dynamic System Tuning Daemon...=0D
         Starting Logout off all iSCSI sessions on shutdown...=0D
         Starting Postfix Mail Transport Agent...=0D
[=1B[32m  OK  =1B[0m] Reached target Network is Online.=0D
         Starting System Logging Service...=0D
         Starting Notify NFS peers of a restart...=0D
[=1B[32m  OK  =1B[0m] Started Enable periodic update of entitlement certifi=
cates..=0D
[=1B[32m  OK  =1B[0m] Started Logout off all iSCSI sessions on shutdown.=0D
         Starting Network Manager Script Dispatcher Service...=0D
[=1B[32m  OK  =1B[0m] Started Notify NFS peers of a restart.=0D
[=1B[32m  OK  =1B[0m] Started System Logging Service.=0D
         Starting Open-iSCSI...=0D
[=1B[32m  OK  =1B[0m] Started Open-iSCSI.=0D
[=1B[32m  OK  =1B[0m] Started OpenSSH server daemon.=0D
[=1B[32m  OK  =1B[0m] Started Network Manager Script Dispatcher Service.=0D
[=1B[0m=1B[31m*     =1B[0m] (1 of 4) A start job is running for...ze system=
 clock (12s / no limit)=0D=1B[K[=1B[32m  OK  =1B[0m] Started Dynamic System=
 Tuning Daemon.=0D
[=1B[32m  OK  =1B[0m] Started Postfix Mail Transport Agent.=0D
[=1B[32m  OK  =1B[0m] Reached target Remote File Systems (Pre).=0D
[=1B[32m  OK  =1B[0m] Reached target Remote File Systems.=0D
         Starting Permit User Sessions...=0D
         Starting Crash recovery kernel arming...=0D
         Starting Availability of block devices...=0D
[=1B[32m  OK  =1B[0m] Started Availability of block devices.=0D
[=1B[32m  OK  =1B[0m] Started Permit User Sessions.=0D
         Starting Terminate Plymouth Boot Screen...=0D
         Starting Wait for Plymouth Boot Screen to Quit...=0D
[=1B[32m  OK  =1B[0m] Started Job spooling tools.=0D
         Starting Job spooling tools...=0D

--BOKacYhQ+x31HxR3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
