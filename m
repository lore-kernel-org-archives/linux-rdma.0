From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: [BUG?] OpenMPI with openib on SPARC64: Signal: Bus error (10)
Date: Tue, 22 Nov 2011 01:51:14 +0000 (GMT)
Message-ID: <1321926674.44951.YahooMailNeo@web24715.mail.ird.yahoo.com>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "devel-ygRj4skf0tpg9hUCZPvPmw@public.gmane.org" <devel-ygRj4skf0tpg9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello everybody!

I've Sun T5120 (SPARC64) Servers with
- Debian: 6.0.3
- linux-2.6.39.4 (from kernel.org)
- OFED-1.5.3.2
- InfiniBand: Mellanox Technologies MT25418 [ConnectX VPI PCIe 2.0 2.5G=
T/s - IB DDR / 10GigE] (rev a0)
=A0 with newest FW (2.9.1)
and the following issue:

If I try to mpirun a program like the osu_latency benchmark:
$ /usr/mpi/gcc/openmpi-1.4.3/bin/mpirun -np 2 --mca btl_base_verbose 50=
 --mca btl_openib_verbose 1 -host cluster1,cluster2 /usr/mpi/gcc/openmp=
i-1.4.3/tests/osu_benchmarks-3.1.1/osu_latency

then I get these errors:
<snip>
# OSU MPI Latency Test v3.1.1
# Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Latency (us)
[cluster1:64027] *** Process received signal ***
[cluster1:64027] Signal: Bus error (10)
[cluster1:64027] Signal code: Invalid address alignment (1)
[cluster1:64027] Failing at address: 0xaa9053
[cluster1:64027] [ 0] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_pml_=
ob1.so(+0x62f0) [0xfffff8010209e2f0]
[cluster1:64027] [ 1] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_coll=
_tuned.so(+0x2904) [0xfffff801031ce904]
[cluster1:64027] [ 2] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_coll=
_tuned.so(+0xb498) [0xfffff801031d7498]
[cluster1:64027] [ 3] /usr/mpi/gcc/openmpi-1.4.3/lib64/libmpi.so.0(MPI_=
Barrier+0xbc) [0xfffff8010005a97c]
[cluster1:64027] [ 4] /usr/mpi/gcc/openmpi-1.4.3/tests/osu_benchmarks-3=
=2E1.1/osu_latency(main+0x2b0) [0x100f34]
[cluster1:64027] [ 5] /lib64/libc.so.6(__libc_start_main+0x100) [0xffff=
f80100ac1240]
[cluster1:64027] [ 6] /usr/mpi/gcc/openmpi-1.4.3/tests/osu_benchmarks-3=
=2E1.1/osu_latency(_start+0x2c) [0x100bac]
[cluster1:64027] *** End of error message ***
[cluster2:02759] *** Process received signal ***
[cluster2:02759] Signal: Bus error (10)
[cluster2:02759] Signal code: Invalid address alignment (1)
[cluster2:02759] Failing at address: 0xaa9053
[cluster2:02759] [ 0] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_pml_=
ob1.so(+0x62f0) [0xfffff8010209e2f0]
[cluster2:02759] [ 1] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_coll=
_tuned.so(+0x2904) [0xfffff801031ce904]
[cluster2:02759] [ 2] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_coll=
_tuned.so(+0xb498) [0xfffff801031d7498]
[cluster2:02759] [ 3] /usr/mpi/gcc/openmpi-1.4.3/lib64/libmpi.so.0(MPI_=
Barrier+0xbc) [0xfffff8010005a97c]
[cluster2:02759] [ 4] /usr/mpi/gcc/openmpi-1.4.3/tests/osu_benchmarks-3=
=2E1.1/osu_latency(main+0x2b0) [0x100f34]
[cluster2:02759] [ 5] /lib64/libc.so.6(__libc_start_main+0x100) [0xffff=
f80100ac1240]
[cluster2:02759] [ 6] /usr/mpi/gcc/openmpi-1.4.3/tests/osu_benchmarks-3=
=2E1.1/osu_latency(_start+0x2c) [0x100bac]
[cluster2:02759] *** End of error message ***
---

The whole output can be found here:
http://net.razik.de/linux/T5120/openmpi-1.4.3-verbose.txt

That's my 'ompi_info --param all all' output:
http://net.razik.de/linux/T5120/openmpi-1.4.3_param_all_all.txt

Same error with OFED-1.5.4-rc4 and also the same with openmpi-1.4.4.

If I disable openib the I get the right results:
$ /usr/mpi/gcc/openmpi-1.4.3/bin/mpirun --mca btl ^openib -np 2 -host c=
luster1,cluster2 /usr/mpi/gcc/openmpi-1.4.3/tests/osu_benchmarks-3.1.1/=
osu_latency
# OSU MPI Latency Test v3.1.1
# Size=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Latency (us)
0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 143=
=2E53
1=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 140=
=2E50
<snip>
---

ibverbs seems to work:
$ ibv_srq_pingpong -n 1000000 cluster2
<snip>
8192000000 bytes in 4.15 seconds =3D 15806.63 Mbit/sec
1000000 iters in 4.15 seconds =3D 4.15 usec/iter
---

These are the installed OFED packets:
kernel-ib
ofed-scripts
libibverbs
libibverbs-devel
libibverbs-utils
libmlx4
libmlx4-devel
libibumad
libibumad-devel
libibmad
libibmad-devel
librdmacm
librdmacm-utils
librdmacm-devel
opensm-libs
ibutils
infiniband-diags
qperf
ofed-docs
mpi-selector
openmpi_gcc
mpitests_openmpi_gcc
---

I don't know which mailing list is the right one and I'm very thankful =
for any help!
If you have questions, please ask!

Best regards,
Lukas


The archives of the lists I've sent this email to:
http://lists.openfabrics.org/pipermail/ewg/2011-November/thread.html
http://www.open-mpi.org/community/lists/devel/2011/11/date.php
http://thread.gmane.org/gmane.linux.drivers.rdma/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
