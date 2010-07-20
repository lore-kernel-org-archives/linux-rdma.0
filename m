From: "Itay Berman" <itayb-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: some dapl assistance - [PATCH] dapl-2.0 improperly handles pkeycheck/query in host order
Date: Tue, 20 Jul 2010 10:27:28 +0300
Message-ID: <6D1AA8ED7402FF49AFAB26F0C948ACF5014BA383@exil.voltaire.com>
References: <4C344493.2030600@Voltaire.com><E3280858FA94444CA49D2BA02341C983010435A1A8@orsmsx506.amr.corp.intel.com><4C3C50CC.7000508@Voltaire.com><E3280858FA94444CA49D2BA02341C9830104493030@orsmsx506.amr.corp.intel.com><6D1AA8ED7402FF49AFAB26F0C948ACF5014B9894@exil.voltaire.com><E3280858FA94444CA49D2BA02341C983010458ECD5@orsmsx506.amr.corp.intel.com><6D1AA8ED7402FF49AFAB26F0C948ACF5014B98F3@exil.voltaire.com><E3280858FA94444CA49D2BA02341C983010458EF5E@orsmsx506.amr.corp.intel.com><6D1AA8ED7402FF49AFAB26F0C948ACF5014B9BD0@exil.voltaire.com> <E3280858FA94444CA49D2BA02341C983010D14039A@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <E3280858FA94444CA49D2BA02341C983010D14039A-osO9UTpF0URZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Works!

[root@dodly0 OMB-3.1.1]# mpiexec -ppn 1 -n 2 -env I_MPI_FABRICS dapl:da=
pl -env I_MPI_DEBUG 5 -env I_MPI_CHECK_DAPL_PROVIDER_MISMATCH none -env=
 DAPL_DBG_TYPE 0xffff -env DAPL_IB_PKEY 0x0280 -env DAPL_IB_SL 4 /tmp/o=
su_long
dodly0:5bc3: dapl_init: dbg_type=3D0xffff,dbg_dest=3D0x1
dodly0:5bc3:  open_hca: device mlx4_0 not found
dodly0:5bc3:  open_hca: device mlx4_0 not found
dodly0:5bc3:  query_hca: port.link_layer =3D 0x1
dodly0:5bc3:  query_hca: (a0.0) eps 64512, sz 16384 evds 65408, sz 1310=
71 mtu 2048 - pkey 640 p_idx 1 sl 4
dodly0:5bc3:  query_hca: msg 2147483648 rdma 2147483648 iov 27 lmr 1310=
56 rmr 0 ack_time 16 mr 4294967295
dodly0:5bc3:  query_hca: port.link_layer =3D 0x1
dodly0:5bc3:  query_hca: (a0.0) eps 64512, sz 16384 evds 65408, sz 1310=
71 mtu 2048 - pkey 640 p_idx 1 sl 4
dodly0:5bc3:  query_hca: msg 2147483648 rdma 2147483648 iov 27 lmr 1310=
56 rmr 0 ack_time 16 mr 4294967295
dodly0:5bc3:  query_hca: port.link_layer =3D 0x1
dodly0:5bc3:  query_hca: (a0.0) eps 64512, sz 16384 evds 65408, sz 1310=
71 mtu 2048 - pkey 640 p_idx 1 sl 4
dodly0:5bc3:  query_hca: msg 2147483648 rdma 2147483648 iov 27 lmr 1310=
56 rmr 0 ack_time 16 mr 4294967295
dodly0:5bc3:  dapl_poll: fd=3D17 ret=3D1, evnts=3D0x1
dodly0:5bc3:  dapl_poll: fd=3D17 ret=3D0, evnts=3D0x0
dodly0:5bc3:  dapl_poll: fd=3D14 ret=3D0, evnts=3D0x0
dodly4:1e8d: dapl_init: dbg_type=3D0xffff,dbg_dest=3D0x1
[0] MPI startup(): DAPL provider ofa-v2-mthca0-1
[0] MPI startup(): dapl data transfer mode
dodly4:1e8d:  query_hca: port.link_layer =3D 0x1
dodly4:1e8d:  query_hca: (a0.0) eps 262076, sz 16351 evds 65408, sz 419=
4303 mtu 2048 - pkey 640 p_idx 1 sl 4
dodly4:1e8d:  query_hca: msg 1073741824 rdma 1073741824 iov 32 lmr 5242=
72 rmr 0 ack_time 16 mr 4294967295
dodly4:1e8d:  query_hca: port.link_layer =3D 0x1
dodly4:1e8d:  query_hca: (a0.0) eps 262076, sz 16351 evds 65408, sz 419=
4303 mtu 2048 - pkey 640 p_idx 1 sl 4
dodly4:1e8d:  query_hca: msg 1073741824 rdma 1073741824 iov 32 lmr 5242=
72 rmr 0 ack_time 16 mr 4294967295
dodly4:1e8d:  query_hca: port.link_layer =3D 0x1
dodly4:1e8d:  query_hca: (a0.0) eps 262076, sz 16351 evds 65408, sz 419=
4303 mtu 2048 - pkey 640 p_idx 1 sl 4
dodly4:1e8d:  query_hca: msg 1073741824 rdma 1073741824 iov 32 lmr 5242=
72 rmr 0 ack_time 16 mr 4294967295
dodly4:1e8d:  dapl_poll: fd=3D15 ret=3D1, evnts=3D0x1
dodly4:1e8d:  dapl_poll: fd=3D15 ret=3D0, evnts=3D0x0
dodly4:1e8d:  dapl_poll: fd=3D13 ret=3D0, evnts=3D0x0
[1] MPI startup(): DAPL provider ofa-v2-mlx4_0-1
[1] MPI startup(): dapl data transfer mode
[0] MPI startup(): static connections storm algo
dodly0:5bc3:  dapl_poll: fd=3D17 ret=3D1, evnts=3D0x1
dodly0:5bc3:  dapl_poll: fd=3D17 ret=3D0, evnts=3D0x0
dodly0:5bc3:  dapl_poll: fd=3D14 ret=3D0, evnts=3D0x0
dodly0:5bc3:  dapl_poll: fd=3D19 ret=3D0, evnts=3D0x0
dodly0:5bc3:  dapl_poll: fd=3D17 ret=3D0, evnts=3D0x0
dodly0:5bc3:  dapl_poll: fd=3D14 ret=3D0, evnts=3D0x0
dodly0:5bc3:  dapl_poll: fd=3D19 ret=3D1, evnts=3D0x4
dodly0:5bc3:  dapl_poll: fd=3D17 ret=3D0, evnts=3D0x0
dodly0:5bc3:  dapl_poll: fd=3D14 ret=3D0, evnts=3D0x0
dodly0:5bc3:  dapl_poll: fd=3D19 ret=3D0, evnts=3D0x0
dodly4:1e8d:  dapl_poll: fd=3D15 ret=3D0, evnts=3D0x0
dodly4:1e8d:  dapl_poll: fd=3D13 ret=3D1, evnts=3D0x1
dodly4:1e8d:  dapl_poll: fd=3D13 ret=3D0, evnts=3D0x0
dodly4:1e8d:  dapl_poll: fd=3D15 ret=3D1, evnts=3D0x1
dodly4:1e8d:  dapl_poll: fd=3D15 ret=3D0, evnts=3D0x0
dodly4:1e8d:  dapl_poll: fd=3D13 ret=3D0, evnts=3D0x0
dodly4:1e8d:  dapl_poll: fd=3D17 ret=3D1, evnts=3D0x1
dodly0:5bc3:  dapl_poll: fd=3D17 ret=3D0, evnts=3D0x0
dodly0:5bc3:  dapl_poll: fd=3D14 ret=3D0, evnts=3D0x0
dodly0:5bc3:  dapl_poll: fd=3D19 ret=3D1, evnts=3D0x1
[0] MPI startup(): I_MPI_CHECK_DAPL_PROVIDER_MISMATCH=3Dnone
[0] MPI startup(): I_MPI_DEBUG=3D5
dodly4:1e8d:  dapl_poll: fd=3D15 ret=3D0, evnts=3D0x0
dodly4:1e8d:  dapl_poll: fd=3D13 ret=3D0, evnts=3D0x0
dodly4:1e8d:  dapl_poll: fd=3D17 ret=3D1, evnts=3D0x1
[0] MPI startup(): I_MPI_FABRICS=3Ddapl:dapl
[0] MPI startup(): set domain to {0,1,2,3} on node dodly0
[1] MPI startup(): set domain to {0,1,2,3} on node dodly4
[0] Rank    Pid      Node name  Pin cpu
[0] 0       23491    dodly0     {0,1,2,3}
[0] 1       7821     dodly4     {0,1,2,3}
# OSU MPI Bandwidth Test v3.1.1
# Size        Bandwidth (MB/s)
4194304                 978.30
4194304                 978.45
4194304                 978.69
4194304                 978.24
dodly0:5bc3: dapl async_event: DEV ERR 12
dodly4:1e8d: dapl async_event: DEV ERR 12
dodly4:1e8d:  DTO completion ERROR: 12: op 0xff
dodly4:1e8d: DTO completion ERR: status 12, op OP_RDMA_READ, vendor_err=
 0x81 - 172.30.3.230
[1:dodly4][../../dapl_module_poll.c:3972] Intel MPI fatal error: ofa-v2=
-mlx4_0-1 DTO operation posted for [0:dodly0] completed with error. sta=
tus=3D0x8. cookie=3D0x40000
Assertion failed in file ../../dapl_module_poll.c at line 3973: 0
internal ABORT - process 1
rank 1 in job 41  dodly0_54941   caused collective abort of all ranks
  exit status of rank 1: killed by signal 9

dapl reports p_idx 1. this is an output of an osu test that I removed t=
he configured pkey. At that time the mpi died. So it indeed ran over th=
at pkey.

To test the sl I will have to change my configuration a bit.

We will be happy to get a new build of dapl if possible.

Thanks,

Itay. =20

-----Original Message-----
=46rom: Davis, Arlin R [mailto:arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]=20
Sent: =E1 19 =E9=E5=EC=E9 2010 22:04
To: Itay Berman
Cc: linux-rdma; Or Gerlitz
Subject: RE: some dapl assistance - [PATCH] dapl-2.0 improperly handles=
 pkeycheck/query in host order

=20
Itay,

>>>OK, we got Intel MPI to run. To test the pkey usage we=20
>>>configured it to run over pkey that is not configured on the=20
>>>node. In this case the MPI should have failed, but it didn't.
>>>The dapl debug reports the given pkey (0x8001 =3D 32769).
>>>How can that be?
>>
>>If the pkey override is not valid it uses default idx of 0 and=20
>>ignores pkey value given.=20

Sorry, verbs pkey_query is network order and the consumer
variable is assumed host order. Please try the following
v2.0 patch (or use 0x0280 without patch):

---

scm, ucm: improperly handles pkey check/query in host order

Convert consumer input to network order before verbs
query pkey check.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index a69261f..73730ef 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -326,7 +326,7 @@ DAT_RETURN dapls_ib_query_hca(IN DAPL_HCA * hca_ptr=
,
=20
                /* set SL, PKEY values, defaults =3D 0 */
                hca_ptr->ib_trans.pkey_idx =3D 0;
-               hca_ptr->ib_trans.pkey =3D dapl_os_get_env_val("DAPL_IB=
_PKEY", 0);
+               hca_ptr->ib_trans.pkey =3D htons(dapl_os_get_env_val("D=
APL_IB_PKEY", 0));
                hca_ptr->ib_trans.sl =3D dapl_os_get_env_val("DAPL_IB_S=
L", 0);
=20
 		/* index provided, get pkey; pkey provided, get index */
@@ -345,10 +345,10 @@ DAT_RETURN dapls_ib_query_hca(IN DAPL_HCA * hca_p=
tr,
 				}
 			}
 			if (i =3D=3D dev_attr.max_pkeys) {
-				dapl_log(DAPL_DBG_TYPE_WARN,
-					 " Warning: new pkey(%d), query (%s)"
-					 " err or key !found, using defaults\n",
-					 hca_ptr->ib_trans.pkey, strerror(errno));
+				dapl_log(DAPL_DBG_TYPE_ERR,
+					 " ERR: new pkey(0x%x), query (%s)"
+					 " err or key !found, using default pkey_idx=3D0\n",
+					 ntohs(hca_ptr->ib_trans.pkey), strerror(errno));
 			}
 		}
 skip_ib:


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
