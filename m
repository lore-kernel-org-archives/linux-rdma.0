From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFS over RDMA in SLinux
Date: Sat, 7 Mar 2015 11:12:59 -0500
Message-ID: <845DB266-3DC2-4A56-8808-4D9727C9B5AB@oracle.com>
References: <000501d0577e$35db88a0$a19299e0$@gmail.com> <54FA604A.4050807@dev.mellanox.co.il> <004001d058b5$87830560$96891020$@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004001d058b5$87830560$96891020$@gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: francisco.cardoso-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Mar 7, 2015, at 4:03 AM, Francisco Manuel Cardoso <francisco.cardoso=
@gmail.com> wrote:

> Hello Sagi,
>=20
> This is about NFSoRDMA, NFS on IPoIPB no issues.
>=20
> The main issue is that simulation on the HPC cluster starts running
> "fine"and after a while, I get loads of errors that the NFS server is=
 not
> responding;
>=20
> Server Side getting messages such as ;
>=20
> svcrdma: Error -107 posting RDMA_READ
> ------------[ cut here ]------------
> WARNING: at net/sunrpc/xprtrdma/svc_rdma_transport.c:1158
> __svc_rdma_free+0x20a/0x230 [svcrdma]() (Tainted: P        W
> ---------------   )
> Hardware name: ProLiant SL4540 Gen8=20
> Modules linked in: xprtrdma svcrdma nfsd lockd nfs_acl auth_rpcgss su=
nrpc
> autofs4 8021q garp stp llc ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad
> rdma_cm ib_cm iw_cm xfs exportfs iTCO_wdt iTCO_vendor_support ipmi_de=
vintf
> power_meter acpi_ipmi ipmi_si ipmi_msghandler hpwdt hpilo igb i2c_alg=
o_bit
> i2c_core ptp pps_core serio_raw sg lpc_ich mfd_core ioatdma dca shpch=
p ext4
> jbd2 mbcache sd_mod crc_t10dif hpvsa(P)(U) hpsa mlx4_ib ib_sa ib_mad =
ib_core
> ib_addr ipv6 mlx4_core dm_mirror dm_region_hash dm_log dm_mod [last
> unloaded: scsi_wait_scan]
> Pid: 51, comm: events/0 Tainted: P        W  ---------------
> 2.6.32-504.8.1.el6.x86_64 #1
> Call Trace:
> [<ffffffff81074df7>] ? warn_slowpath_common+0x87/0xc0
> [<ffffffff81074e4a>] ? warn_slowpath_null+0x1a/0x20
> [<ffffffffa073d25a>] ? __svc_rdma_free+0x20a/0x230 [svcrdma]
> [<ffffffffa073d050>] ? __svc_rdma_free+0x0/0x230 [svcrdma]
> [<ffffffff81097fe0>] ? worker_thread+0x170/0x2a0
> [<ffffffff8109eb00>] ? autoremove_wake_function+0x0/0x40
> [<ffffffff81097e70>] ? worker_thread+0x0/0x2a0
> [<ffffffff8109e66e>] ? kthread+0x9e/0xc0
> [<ffffffff8100c20a>] ? child_rip+0xa/0x20
> [<ffffffff8109e5d0>] ? kthread+0x0/0xc0
> [<ffffffff8100c200>] ? child_rip+0x0/0x20
> ---[ end trace 3ee821ba0f96711f ]---
>=20
> And;
>=20
> svcrdma: Error fast registering memory for xprt ffff880c6ae13800
> svcrdma: Error fast registering memory for xprt ffff8802e87a3000
> svcrdma: Error fast registering memory for xprt ffff880bfa496c00
> svcrdma: Error fast registering memory for xprt ffff8808ec717000
> svcrdma: Error fast registering memory for xprt ffff880b82577c00
> svcrdma: Error fast registering memory for xprt ffff880bfa496c00
>=20
> I've searched high and low for solutions and went to Red Hat KB, disc=
overed
> all the articles regarding high workloads and the workarounds for lik=
e for
> example the " svcrdma: Error fast registering memory for xprt
> ffff8802e87a3000" messages that should be fixed after RH Kernel Errat=
a on
> RHEL 6.1.
> And the "sunrpc.rdma_memreg_strategy =3D 6" value change.
>=20
> If anyone can provide some help or insight would be really great.

I was volunteered, but I don=92t have much insight.

=46or issues with NFS, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org is the place to ask fo=
r
advice and help.

=46or issues with RHEL and its derivatives (I=92m assuming SL6 is Scien=
tific
Linux and not SuSE SLES), the best course of action is to work with the
distributors, since their kernels do not match any mainline tree.

In this case RHEL 6 kernel code base is very old by today=92s standards=
,
and it pre-dates my direct involvement with NFS/RDMA.

I=92ve never touched the RHEL 6 NFS/RDMA server implementation. My gues=
s
based on my experience with the current mainline server is that it is
not production-ready. You should check the release notes to be sure it
is fully-supported.

If the RH KBs do not help, please contact RH and use their support to
address the issue. Red Hat is the authority on that code.

My advice is if you are sticking with stock RHEL 6 kernels, you should
use NFS on IPoIB.

> Cause I've seen from looking around that usually RDMA with High CPU L=
oads is
> "troublesome".
>=20
> Regards,
>=20
> Francisco
>=20
> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]=20
> Sent: 07 March 2015 02:20
> To: francisco.cardoso-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org; Chuck Lever
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: NFS over RDMA in SLinux
>=20
> On 3/5/2015 9:54 PM, Francisco Manuel Cardoso wrote:
>> Hello,
>>=20
>>=20
>>=20
>> Sorry newcomer to the group at the moment, brief question i hope=20
>> someone can at least point me.
>>=20
>> Are there any considerations regarding NFS over RDMA on Linux SL6 ?
>>=20
>> Question I've been setting up/using an HPC cluster and NFS over IPoI=
B=20
>> it's cool as soon as start dishing out things onto with the RDMA thi=
ngs go
> crazy.
>>=20
>> The tipical setup is each machine is able to handle max 40 processes=
,=20
>> using all of those to mpi, I seem to be having some performance=20
>> issues, if I scale down to 39 I get much better performance still it
> crashes.
>>=20
>> Anyone got any pointers ?
>=20
> I'm not sure if you're asking about NFS over IPoIB or NFSoRDMA?
>=20
> CC'ing Chuck which is probably the best help you can get...
>=20

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
