From: "Francisco Manuel Cardoso" <francisco.cardoso-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: RE: NFS over RDMA in SLinux
Date: Sat, 7 Mar 2015 09:03:07 -0000
Message-ID: <004001d058b5$87830560$96891020$@gmail.com>
References: <000501d0577e$35db88a0$a19299e0$@gmail.com> <54FA604A.4050807@dev.mellanox.co.il>
Reply-To: <francisco.cardoso-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54FA604A.4050807-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-gb
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Sagi,

This is about NFSoRDMA, NFS on IPoIPB no issues.

The main issue is that simulation on the HPC cluster starts running
"fine"and after a while, I get loads of errors that the NFS server is not
responding;

Server Side getting messages such as ;

svcrdma: Error -107 posting RDMA_READ
------------[ cut here ]------------
WARNING: at net/sunrpc/xprtrdma/svc_rdma_transport.c:1158
__svc_rdma_free+0x20a/0x230 [svcrdma]() (Tainted: P        W
---------------   )
Hardware name: ProLiant SL4540 Gen8 
Modules linked in: xprtrdma svcrdma nfsd lockd nfs_acl auth_rpcgss sunrpc
autofs4 8021q garp stp llc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
rdma_cm ib_cm iw_cm xfs exportfs iTCO_wdt iTCO_vendor_support ipmi_devintf
power_meter acpi_ipmi ipmi_si ipmi_msghandler hpwdt hpilo igb i2c_algo_bit
i2c_core ptp pps_core serio_raw sg lpc_ich mfd_core ioatdma dca shpchp ext4
jbd2 mbcache sd_mod crc_t10dif hpvsa(P)(U) hpsa mlx4_ib ib_sa ib_mad ib_core
ib_addr ipv6 mlx4_core dm_mirror dm_region_hash dm_log dm_mod [last
unloaded: scsi_wait_scan]
Pid: 51, comm: events/0 Tainted: P        W  ---------------
2.6.32-504.8.1.el6.x86_64 #1
Call Trace:
 [<ffffffff81074df7>] ? warn_slowpath_common+0x87/0xc0
 [<ffffffff81074e4a>] ? warn_slowpath_null+0x1a/0x20
 [<ffffffffa073d25a>] ? __svc_rdma_free+0x20a/0x230 [svcrdma]
 [<ffffffffa073d050>] ? __svc_rdma_free+0x0/0x230 [svcrdma]
 [<ffffffff81097fe0>] ? worker_thread+0x170/0x2a0
 [<ffffffff8109eb00>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81097e70>] ? worker_thread+0x0/0x2a0
 [<ffffffff8109e66e>] ? kthread+0x9e/0xc0
 [<ffffffff8100c20a>] ? child_rip+0xa/0x20
 [<ffffffff8109e5d0>] ? kthread+0x0/0xc0
 [<ffffffff8100c200>] ? child_rip+0x0/0x20
---[ end trace 3ee821ba0f96711f ]---

And;

svcrdma: Error fast registering memory for xprt ffff880c6ae13800
svcrdma: Error fast registering memory for xprt ffff8802e87a3000
svcrdma: Error fast registering memory for xprt ffff880bfa496c00
svcrdma: Error fast registering memory for xprt ffff8808ec717000
svcrdma: Error fast registering memory for xprt ffff880b82577c00
svcrdma: Error fast registering memory for xprt ffff880bfa496c00

I've searched high and low for solutions and went to Red Hat KB, discovered
all the articles regarding high workloads and the workarounds for like for
example the " svcrdma: Error fast registering memory for xprt
ffff8802e87a3000" messages that should be fixed after RH Kernel Errata on
RHEL 6.1.
And the "sunrpc.rdma_memreg_strategy = 6" value change.

If anyone can provide some help or insight would be really great.

Cause I've seen from looking around that usually RDMA with High CPU Loads is
"troublesome".

Regards,

Francisco

-----Original Message-----
From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org] 
Sent: 07 March 2015 02:20
To: francisco.cardoso-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Chuck Lever
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: NFS over RDMA in SLinux

On 3/5/2015 9:54 PM, Francisco Manuel Cardoso wrote:
> Hello,
>
>
>
> Sorry newcomer to the group at the moment, brief question i hope 
> someone can at least point me.
>
> Are there any considerations regarding NFS over RDMA on Linux SL6 ?
>
> Question I've been setting up/using an HPC cluster and NFS over IPoIB 
> it's cool as soon as start dishing out things onto with the RDMA things go
crazy.
>
> The tipical setup is each machine is able to handle max 40 processes, 
> using all of those to mpi, I seem to be having some performance 
> issues, if I scale down to 39 I get much better performance still it
crashes.
>
> Anyone got any pointers ?

I'm not sure if you're asking about NFS over IPoIB or NFSoRDMA?

CC'ing Chuck which is probably the best help you can get...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
