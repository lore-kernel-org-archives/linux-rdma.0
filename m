From: "Itay Berman" <itayb-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: some dapl assistance
Date: Thu, 15 Jul 2010 20:18:37 +0300
Message-ID: <6D1AA8ED7402FF49AFAB26F0C948ACF5014B98F3@exil.voltaire.com>
References: <4C344493.2030600@Voltaire.com><E3280858FA94444CA49D2BA02341C983010435A1A8@orsmsx506.amr.corp.intel.com><4C3C50CC.7000508@Voltaire.com><E3280858FA94444CA49D2BA02341C9830104493030@orsmsx506.amr.corp.intel.com><6D1AA8ED7402FF49AFAB26F0C948ACF5014B9894@exil.voltaire.com> <E3280858FA94444CA49D2BA02341C983010458ECD5@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <E3280858FA94444CA49D2BA02341C983010458ECD5-osO9UTpF0URZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No:
No. Same warning:

[root@dodly0 compat-dapl-1.2.18]# mpiexec -ppn 1 -n 2 -env I_MPI_FABRIC=
S dapl:dapl -env I_MPI_DEBUG 2 -env I_MPI_CHECK_DAPL_PROVIDER_MISMADAPL=
_DBG_TYPE 0xffff -env DAPL_IB_PKEY 0x8002 /tmp/osu
dodly4:625b: dapl_init: dbg_type=3D0xffff,dbg_dest=3D0x1
dodly0:2c17: dapl_init: dbg_type=3D0xffff,dbg_dest=3D0x1
dodly0:2c17:  open_hca: device mlx4_0 not found
dodly0:2c17:  open_hca: device mlx4_0 not found
dodly4:625b:  Warning: new pkey(32770), query (Success) err or key !fou=
nd, using defaults
dodly4:625b:  query_hca: port.link_layer =3D 0x1
dodly4:625b:  query_hca: (a0.0) eps 262076, sz 16351 evds 65408, sz 419=
4303 mtu 2048 - pkey 32770 p_idx 0 sl 0
dodly4:625b:  query_hca: msg 1073741824 rdma 1073741824 iov 32 lmr 5242=
72 rmr 0 ack_time 16 mr 4294967295
dodly0:2c17:  Warning: new pkey(32770), query (Success) err or key !fou=
nd, using defaults
dodly0:2c17:  query_hca: port.link_layer =3D 0x1
dodly0:2c17:  query_hca: (a0.0) eps 64512, sz 16384 evds 65408, sz 1310=
71 mtu 2048 - pkey 32770 p_idx 0 sl 0
dodly0:2c17:  query_hca: msg 2147483648 rdma 2147483648 iov 27 lmr 1310=
56 rmr 0 ack_time 16 mr 4294967295
dodly0:2c17:  Warning: new pkey(32770), query (Success) err or key !fou=
nd, using defaults
dodly0:2c17:  query_hca: port.link_layer =3D 0x1
dodly0:2c17:  query_hca: (a0.0) eps 64512, sz 16384 evds 65408, sz 1310=
71 mtu 2048 - pkey 32770 p_idx 0 sl 0
dodly0:2c17:  query_hca: msg 2147483648 rdma 2147483648 iov 27 lmr 1310=
56 rmr 0 ack_time 16 mr 4294967295
dodly4:625b:  Warning: new pkey(32770), query (Success) err or key !fou=
nd, using defaults
dodly4:625b:  query_hca: port.link_layer =3D 0x1
dodly4:625b:  query_hca: (a0.0) eps 262076, sz 16351 evds 65408, sz 419=
4303 mtu 2048 - pkey 32770 p_idx 0 sl 0
dodly4:625b:  query_hca: msg 1073741824 rdma 1073741824 iov 32 lmr 5242=
72 rmr 0 ack_time 16 mr 4294967295
dodly0:2c17:  Warning: new pkey(32770), query (Success) err or key !fou=
nd, using defaults
dodly0:2c17:  query_hca: port.link_layer =3D 0x1
dodly0:2c17:  query_hca: (a0.0) eps 64512, sz 16384 evds 65408, sz 1310=
71 mtu 2048 - pkey 32770 p_idx 0 sl 0
dodly0:2c17:  query_hca: msg 2147483648 rdma 2147483648 iov 27 lmr 1310=
56 rmr 0 ack_time 16 mr 4294967295
dodly0:2c17:  dapl_poll: fd=3D17 ret=3D1, evnts=3D0x1
[0] MPI startup(): DAPL provider ofa-v2-mthca0-1
dodly0:2c17:  dapl_poll: fd=3D17 ret=3D0, evnts=3D0x0
[0] MPI startup(): dapl data transfer mode
dodly0:2c17:  dapl_poll: fd=3D14 ret=3D0, evnts=3D0x0
dodly4:625b:  Warning: new pkey(32770), query (Success) err or key !fou=
nd, using defaults
dodly4:625b:  query_hca: port.link_layer =3D 0x1
dodly4:625b:  query_hca: (a0.0) eps 262076, sz 16351 evds 65408, sz 419=
4303 mtu 2048 - pkey 32770 p_idx 0 sl 0
dodly4:625b:  query_hca: msg 1073741824 rdma 1073741824 iov 32 lmr 5242=
72 rmr 0 ack_time 16 mr 4294967295

[root@dodly0 compat-dapl-1.2.18]# cat /sys/class/infiniband/mthca0/port=
s/1/pkeys/1
0x8002

-----Original Message-----
=46rom: Davis, Arlin R [mailto:arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]=20
Sent: =E4 15 =E9=E5=EC=E9 2010 18:56
To: Itay Berman; Or Gerlitz
Cc: linux-rdma
Subject: RE: some dapl assistance


>OK, we got Intel MPI to run. To test the pkey usage we=20
>configured it to run over pkey that is not configured on the=20
>node. In this case the MPI should have failed, but it didn't.
>The dapl debug reports the given pkey (0x8001 =3D 32769).
>How can that be?
>

Itay,

If the pkey override is not valid it uses default idx of 0 and ignores =
pkey value given.=20

Notice the Warning message:

odly0:3b37:  Warning: new pkey(32769), query (Success) err or key !foun=
d, using defaults=20
odly0:3b37:  query_hca: (a0.0) eps 64512, sz 16384 evds 65408, sz 13107=
1 mtu 2048 - pkey 32769 p_idx 0 sl 0

When you override with a correct value of 8002 does it move to p_idx=3D=
1 and work?

-arlin



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
