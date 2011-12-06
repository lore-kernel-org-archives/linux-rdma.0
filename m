From: Eugene Loh <eugene.loh-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [OMPI devel] [BUG?] OpenMPI with openib on SPARC64: Signal: Bus
 error (10)
Date: Tue, 06 Dec 2011 00:36:41 -0500
Message-ID: <4EDDA9E9.1040207@oracle.com>
References: <1321926674.44951.YahooMailNeo@web24715.mail.ird.yahoo.com>
Reply-To: eugene.loh-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321926674.44951.YahooMailNeo-Igr0H0yBZInyX4RqAA4FmIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>, Open MPI Developers <devel-ygRj4skf0tpg9hUCZPvPmw@public.gmane.org>
Cc: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/21/11 20:51, Lukas Razik wrote:
> Hello everybody!
>
> I've Sun T5120 (SPARC64) Servers with
> - Debian: 6.0.3
> - linux-2.6.39.4 (from kernel.org)
> - OFED-1.5.3.2
> - InfiniBand: Mellanox Technologies MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE] (rev a0)
>    with newest FW (2.9.1)
> and the following issue:
>
> If I try to mpirun a program like the osu_latency benchmark:
> $ /usr/mpi/gcc/openmpi-1.4.3/bin/mpirun -np 2 --mca btl_base_verbose 50 --mca btl_openib_verbose 1 -host cluster1,cluster2 /usr/mpi/gcc/openmpi-1.4.3/tests/osu_benchmarks-3.1.1/osu_latency
>
> then I get these errors:
> <snip>
> # OSU MPI Latency Test v3.1.1
> # Size            Latency (us)
> [cluster1:64027] *** Process received signal ***
> [cluster1:64027] Signal: Bus error (10)
> [cluster1:64027] Signal code: Invalid address alignment (1)
> [cluster1:64027] Failing at address: 0xaa9053
> [cluster1:64027] [ 0] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_pml_ob1.so(+0x62f0) [0xfffff8010209e2f0]
> [cluster1:64027] [ 1] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_coll_tuned.so(+0x2904) [0xfffff801031ce904]
> [cluster1:64027] [ 2] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_coll_tuned.so(+0xb498) [0xfffff801031d7498]
> [cluster1:64027] [ 3] /usr/mpi/gcc/openmpi-1.4.3/lib64/libmpi.so.0(MPI_Barrier+0xbc) [0xfffff8010005a97c]
> [cluster1:64027] [ 4] /usr/mpi/gcc/openmpi-1.4.3/tests/osu_benchmarks-3.1.1/osu_latency(main+0x2b0) [0x100f34]
> [cluster1:64027] [ 5] /lib64/libc.so.6(__libc_start_main+0x100) [0xfffff80100ac1240]
> [cluster1:64027] [ 6] /usr/mpi/gcc/openmpi-1.4.3/tests/osu_benchmarks-3.1.1/osu_latency(_start+0x2c) [0x100bac]
> [cluster1:64027] *** End of error message ***
> [cluster2:02759] *** Process received signal ***
> [cluster2:02759] Signal: Bus error (10)
> [cluster2:02759] Signal code: Invalid address alignment (1)
> [cluster2:02759] Failing at address: 0xaa9053
> [cluster2:02759] [ 0] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_pml_ob1.so(+0x62f0) [0xfffff8010209e2f0]
> [cluster2:02759] [ 1] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_coll_tuned.so(+0x2904) [0xfffff801031ce904]
> [cluster2:02759] [ 2] /usr/mpi/gcc/openmpi-1.4.3/lib64/openmpi/mca_coll_tuned.so(+0xb498) [0xfffff801031d7498]
> [cluster2:02759] [ 3] /usr/mpi/gcc/openmpi-1.4.3/lib64/libmpi.so.0(MPI_Barrier+0xbc) [0xfffff8010005a97c]
> [cluster2:02759] [ 4] /usr/mpi/gcc/openmpi-1.4.3/tests/osu_benchmarks-3.1.1/osu_latency(main+0x2b0) [0x100f34]
> [cluster2:02759] [ 5] /lib64/libc.so.6(__libc_start_main+0x100) [0xfffff80100ac1240]
> [cluster2:02759] [ 6] /usr/mpi/gcc/openmpi-1.4.3/tests/osu_benchmarks-3.1.1/osu_latency(_start+0x2c) [0x100bac]
> [cluster2:02759] *** End of error message ***
There do indeed seem to be a set of problems here addressing non-aligned 
words.

*IF* you were to use Oracle Solaris Studio compilers, you could use 
-xmemalign=8i as Terry suggested and it appears that eliminates these 
errors, albeit potentially with a loss of performance.

Your e-mail thread identified a problem with misalignment in

551         hdr->hdr_match.hdr_ctx = sendreq->req_send.req_base.req_comm->c_contextid;

It appears one can get past this problem by configuring OMPI with --enable-openib-control-hdr-padding.  This turns on OMPI_OPENIB_PAD_HDR and gives you padding/alignment in ompi/mca/btl/openib/btl_openib_frag.h here:

struct mca_btl_openib_control_header_t {
     uint8_t  type;
#if OMPI_OPENIB_PAD_HDR
     uint8_t  padding[15];
#endif
};
typedef struct mca_btl_openib_control_header_t mca_btl_openib_control_header_t;

struct mca_btl_openib_eager_rdma_header_t {
     mca_btl_openib_control_header_t control;
     uint8_t padding[3];
     uint32_t rkey;
     ompi_ptr_t rdma_start;
};
typedef struct mca_btl_openib_eager_rdma_header_t mca_btl_openib_eager_rdma_header_t;

But then perhaps the padding in mca_btl_openib_eager_rdma_header_t needs to be adjusted.  I don't yet know.

This helps (more tests pass), but in many cases it just delays problems until a later point.

All of this is I suppose to say:
1)  Yes, there is a problem with misaligned words in the openib BTL.
2)  We are interested in and looking at the problem.
3)  No promises of outcome.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
