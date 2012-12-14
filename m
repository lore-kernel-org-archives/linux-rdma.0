From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: umad_send with service level higher than 0 does not work
Date: Fri, 14 Dec 2012 08:47:31 -0500
Message-ID: <50CB2DF3.7020409@dev.mellanox.co.il>
References: <0D9917EC-D7A3-4786-BE38-60F6990BA3E1@m.titech.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0D9917EC-D7A3-4786-BE38-60F6990BA3E1@m.titech.ac.jp>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Domke <domke.j.aa@m.titech.ac.jp>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/14/2012 7:18 AM, Jens Domke wrote:
> Hello,
>=20
> I'm trying to find a bug in our configuration, which causes the the I=
B fabric or at least the port where the OpenSM is running to crash. I h=
ope someone on this list has more experience and can help, or give me a=
 hint.
>=20
> The configuration:
>   a) HCAs: Mellanox Technologies MT25418 [ConnectX VPI PCIe 2.0 2.5GT=
/s - IB DDR / 10GigE]; or Voltaire (ibv_devinfo shows board_id: VLT0130=
010001, fw_ver: 2.3.000)
>   b) OFED 3.5 rc2
>   c) OpenSM with DFSSSP routing algorithm running on a compute node (=
additinal OpenSM on a switch with lower priority)

Not related to this problem but it is problematic to mix SM flavors lik=
e
this in a subnet.

>   d) OpenMPI runs are executed with "--mca btl_openib_ib_path_record_=
service_level 1"

I'm not familiar with what DFSSSP does to figure out SLs exactly but
there should be no need to set this. The proper SL for querying the SA
for PathRecords, etc. is always in PortInfo.SMSL. In the case of DFSSSP
(and other QoS based routing algorithms), it calculates that and the SM
pushes this into each port. That should be used. It's possible that SL1
is not a valid SL for port <-> SA querying using DFSSSP.

>   e) kernel 2.6.32-220.13.1.el6.x86_64
>=20
> As far as I understand the whole system:
>   1. the OMPI processes are sending MAD requests (SubnAdmGet:PathReco=
rd) to the OpenSM
>   2. the SA receives the request on QP1

There is the SL in the query itself. This should be the SMSL that the S=
M
set for that port.

>   3. SA asks the routing algorithm (like LASH, DFSSSP or Torus_2QoS) =
about a special service level for the slid/dlid path

This is a (potentially) different SL (for MPI<->MPI port communication)
than the one the query used and is the one returned inside the
PathRecord attribute/data.

>   4. SA sends the PathRecord back to the OMPI process via umad_send i=
n libvendor/osm_vendor_ibumad.c

By the response reversibility rule, I think this is returned on the SL
of the original query but haven't verified this in the code base yet.

> The osm_vendor_send() function builds the MAD packet with the followi=
ng attributes:
>         /* GS classes */
>         umad_set_addr_net(p_vw->umad, p_mad_addr->dest_lid,
>                           p_mad_addr->addr_type.gsi.remote_qp,
>                           p_mad_addr->addr_type.gsi.service_level,
>                           IB_QP1_WELL_KNOWN_Q_KEY);
> So, the SL is the same like the one which was used by the OMPI proces=
s. The Q_Key matches the Q_key on the OMPI process, and remote_qp and d=
est_lid is correct, too.
> Afterwards umad_send(=85) is used to send the reply with the PathReco=
rd, and this send does not work (except for SL=3D0).

By not working, what do you mean ? Do you mean it's not received at the
requester with no message in the OpenSM log or not received at the
OpenSM or something else ? It could be due to the wrong SL being used i=
n
the original request (forcing it to SL 1). That could cause it not to b=
e
received at the SM or the response not to make it back to the requester
from the SA if the SL used is not "reversible".

> If I look into the MAD before it is send, then it looks like this:
> Breakpoint 2, umad_send (fd=3D9, agentid=3D2, umad=3D0x7fffe8012530, =
length=3D120, timeout_ms=3D0, retries=3D3)
>     at src/umad.c:791
> 791             if (umaddebug > 1)
> (gdb) p *mad
> $1 =3D {agent_id =3D 2, status =3D 0, timeout_ms =3D 0, retries =3D 3=
, length =3D 0, addr =3D {qpn =3D 1325427712, qkey =3D 384,=20
>     lid =3D 4096, sl =3D 6 '\006', path_bits =3D 0 '\000', grh_presen=
t =3D 0 '\000', gid_index =3D 0 '\000',=20
>     hop_limit =3D 0 '\000', traffic_class =3D 0 '\000', gid =3D '\000=
' <repeats 15 times>, flow_label =3D 0,=20
>     pkey_index =3D 0, reserved =3D "\000\000\000\000\000"}, data =3D =
0x7fffe8012530 "\002"}

Is this the PathRecord query on the OpenMPI side or the response on the
OpenSM side ? SL is 6 rather than 1 here.

> The kernel writes the following messages after a short time into the =
log:
> Dec 14 01:23:46 rc001 kernel: INFO: task opensm:2499 blocked for more=
 than 120 seconds.
> Dec 14 01:23:46 rc001 kernel: "echo 0 > /proc/sys/kernel/hung_task_ti=
meout_secs" disables this message.
> Dec 14 01:23:46 rc001 kernel: opensm        D 0000000000000000     0 =
 2499   2498 0x00000000
> Dec 14 01:23:46 rc001 kernel: ffff880424bebc38 0000000000000082 00000=
00000000000 0000000000000000
> Dec 14 01:23:46 rc001 kernel: 0000000000000000 ffff8804ffffffff ffff8=
8042287eec0 0000000031bc502d
> Dec 14 01:23:46 rc001 kernel: ffff880427fca678 ffff880424bebfd8 00000=
0000000f4e8 ffff880427fca678
> Dec 14 01:23:46 rc001 kernel: Call Trace:
> Dec 14 01:23:46 rc001 kernel: [<ffffffff814eddc5>] schedule_timeout+0=
x215/0x2e0
> Dec 14 01:23:46 rc001 kernel: [<ffffffff8109698f>] ? up+0x2f/0x50
> Dec 14 01:23:46 rc001 kernel: [<ffffffffa00fb8d2>] ? __mlx4_cmd+0x202=
/0x300 [mlx4_core]
> Dec 14 01:23:46 rc001 kernel: [<ffffffff814eda43>] wait_for_common+0x=
123/0x180
> Dec 14 01:23:46 rc001 kernel: [<ffffffff8105e940>] ? default_wake_fun=
ction+0x0/0x20
> Dec 14 01:23:46 rc001 kernel: [<ffffffff814edb5d>] wait_for_completio=
n+0x1d/0x20
> Dec 14 01:23:46 rc001 kernel: [<ffffffffa0e1913a>] ib_unregister_mad_=
agent+0x33a/0x500 [ib_mad]
> Dec 14 01:23:46 rc001 kernel: [<ffffffffa0d9f923>] ib_umad_unreg_agen=
t+0xb3/0xe0 [ib_umad]
> Dec 14 01:23:46 rc001 kernel: [<ffffffffa0d9fa37>] ib_umad_ioctl+0x67=
/0x70 [ib_umad]
> Dec 14 01:23:46 rc001 kernel: [<ffffffff81189582>] vfs_ioctl+0x22/0xa=
0
> Dec 14 01:23:46 rc001 kernel: [<ffffffff81141190>] ? unmap_region+0x1=
10/0x130
> Dec 14 01:23:46 rc001 kernel: [<ffffffff81189724>] do_vfs_ioctl+0x84/=
0x580
> Dec 14 01:23:46 rc001 kernel: [<ffffffff8113f33e>] ? remove_vma+0x6e/=
0x90
> Dec 14 01:23:46 rc001 kernel: [<ffffffff81141828>] ? do_munmap+0x308/=
0x3a0
> Dec 14 01:23:46 rc001 kernel: [<ffffffff81189ca1>] sys_ioctl+0x81/0xa=
0
> Dec 14 01:23:46 rc001 kernel: [<ffffffff8100b0f2>] system_call_fastpa=
th+0x16/0x1b
> (Even "modprobe mlx4_core enable_qos=3DY debug_level=3D1" does not ma=
ke any difference and I get the same output like the one above)

This looks like the problem reported on the list where there are
outstanding work completions and some MAD client is trying to exit. The
root cause for that has yet to be determined AFAIK.

> The output of OpenMPI or OpenSM's log file don't show any useful info=
rmation for this problem, even with higher debug levels.

So nothing interesting logged relative to the PathRecord queries ?

> The OpenSM does not really respond to ctrl+c and becomes a zombi proc=
ess afterwards, so that the only option is to reboot the node.

Right, after the above error, I wouldn't expect OpenSM to be able to
exit cleanly.

> So, right now I'm stuck, and have no idea if there is an error in the=
 kernel driver, the HCA firmware or something completely different. Or =
if umad_send basically does not support SL>0.
> A workaround for the moment is to set the SL in the umad_set_addr_net=
(...) call to 0.

So SL 0 works between all nodes and SA for querying/responses. Wonder i=
f
that's how SMSL is set by DFSSSP.

-- Hal

> Please let me know if you need more information, or if I can test som=
ething to give you more inside.
>=20
> Thank you in advance,
> Jens
>=20
> --------------------------------
> Dipl.-Math. Jens Domke
> Researcher - Tokyo Institute of Technology
> Satoshi MATSUOKA Laboratory
> Global Scientific Information and Computing Center
> 2-12-1-E2-7 Ookayama, Meguro-ku,=20
> Tokyo, 152-8550, JAPAN
> Tel/Fax: +81-3-5734-3876
> E-Mail: domke.j.aa@m.titech.ac.jp
> --------------------------------
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
