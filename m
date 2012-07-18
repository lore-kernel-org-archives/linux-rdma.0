From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: mlx4_ib_create_qp failed - OOM with call trace
Date: Wed, 18 Jul 2012 15:50:11 +0200
Message-ID: <5006BF13.50405@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

we've got a very busy storage system with approx. 1000 LVs, one SRP LUN
per LV and two paths per LUN. It had an OOM while QP creation but there
should be enough memory available. Multiple disk-less servers are
connected to it running VMs.

We are running kernel 3.2.15 (OFA kernel stuff from in-tree) with
upstream SCST svn r4163 on the storage server.

$free -m
total used free shared buffers cached
Mem: 16041 15876 164 0 14360 37
-/+ buffers/cache: 1479 14562
Swap: 3833 22 3811

The following output was produced. Could you assist please to find the
root cause?

[5416523.203047] ib_srpt: Received SRP_LOGIN_REQ with i_port_id
0x0:0x2c903004ecf8b, t_port_id 0x2c903004ecf82:0x2c903004ecf82 and
it_iu_len 260 on port 1 (guid=3D0xfe80000000000000:0x2c903004ecf83)
[5416523.204736] kworker/0:4: page allocation failure: order:4, mode:0x=
40d0
[5416523.204738] Pid: 17674, comm: kworker/0:4 Not tainted 3.2.15+ #5
[5416523.204740] Call Trace:
[5416523.204745] [<ffffffff810d3d6b>] warn_alloc_failed+0xeb/0x130
[5416523.204747] [<ffffffff810d6720>] ? drain_pages+0xa0/0xa0
[5416523.204749] [<ffffffff810d6731>] ? drain_local_pages+0x11/0x20
[5416523.204751] [<ffffffff810d6ec2>] __alloc_pages_nodemask+0x5f2/0x82=
0
[5416523.204754] [<ffffffff8110c4b1>] alloc_pages_current+0xa1/0x110
[5416523.204756] [<ffffffff810d3829>] __get_free_pages+0x9/0x40
[5416523.204759] [<ffffffff81113a3a>] kmalloc_order_trace+0x3a/0xb0
[5416523.204761] [<ffffffff8111502e>] __kmalloc+0xee/0x140
[5416523.204764] [<ffffffff81445954>] ? mlx4_buf_write_mtt+0xb4/0xd0
[5416523.204768] [<ffffffff8153cd62>] create_qp_common.clone.17+0x6c2/0=
x990
[5416523.204770] [<ffffffff81115130>] ? kmem_cache_alloc_trace+0xb0/0x1=
10
[5416523.204772] [<ffffffff8153d141>] mlx4_ib_create_qp+0x111/0x230
[5416523.204775] [<ffffffff814f6b7c>] ib_create_qp+0x3c/0x1e0
[5416523.204778] [<ffffffffa00596a6>] srpt_cm_handler+0x576/0x1034 [ib_=
srpt]
[5416523.204780] [<ffffffff814f8bbd>] ? ib_get_client_data+0x4d/0x70
[5416523.204783] [<ffffffff81508fe2>] cm_process_work+0x22/0x130
[5416523.204785] [<ffffffff8150991e>] cm_req_handler+0x67e/0xa50
[5416523.204787] [<ffffffff8150a600>] ? cm_rep_handler+0x590/0x590
[5416523.204789] [<ffffffff8150a70d>] cm_work_handler+0x10d/0x1010
[5416523.204791] [<ffffffff8150a600>] ? cm_rep_handler+0x590/0x590
[5416523.204794] [<ffffffff81073c83>] process_one_work+0x123/0x430
[5416523.204796] [<ffffffff81074c42>] worker_thread+0x162/0x340
[5416523.204798] [<ffffffff81074ae0>] ? manage_workers.clone.21+0x240/0=
x240
[5416523.204801] [<ffffffff81079ab6>] kthread+0x96/0xa0
[5416523.204805] [<ffffffff81646434>] kernel_thread_helper+0x4/0x10
[5416523.204807] [<ffffffff81079a20>] ? kthread_worker_fn+0x190/0x190
[5416523.204809] [<ffffffff81646430>] ? gs_change+0x13/0x13
[5416523.204810] Mem-Info:
[5416523.204811] Node 0 DMA per-cpu:
[5416523.204812] CPU 0: hi: 0, btch: 1 usd: 0
[5416523.204814] CPU 1: hi: 0, btch: 1 usd: 0
[5416523.204815] CPU 2: hi: 0, btch: 1 usd: 0
[5416523.204816] CPU 3: hi: 0, btch: 1 usd: 0
[5416523.204817] CPU 4: hi: 0, btch: 1 usd: 0
[5416523.204818] CPU 5: hi: 0, btch: 1 usd: 0
[5416523.204819] CPU 6: hi: 0, btch: 1 usd: 0
[5416523.204820] CPU 7: hi: 0, btch: 1 usd: 0
[5416523.204821] CPU 8: hi: 0, btch: 1 usd: 0
[5416523.204822] CPU 9: hi: 0, btch: 1 usd: 0
[5416523.204824] CPU 10: hi: 0, btch: 1 usd: 0
[5416523.204825] CPU 11: hi: 0, btch: 1 usd: 0
[5416523.204826] Node 0 DMA32 per-cpu:
[5416523.204827] CPU 0: hi: 186, btch: 31 usd: 0
[5416523.204828] CPU 1: hi: 186, btch: 31 usd: 0
[5416523.204829] CPU 2: hi: 186, btch: 31 usd: 0
[5416523.204830] CPU 3: hi: 186, btch: 31 usd: 0
[5416523.204831] CPU 4: hi: 186, btch: 31 usd: 0
[5416523.204833] CPU 5: hi: 186, btch: 31 usd: 98
[5416523.204834] CPU 6: hi: 186, btch: 31 usd: 0
[5416523.204835] CPU 7: hi: 186, btch: 31 usd: 0
[5416523.204836] CPU 8: hi: 186, btch: 31 usd: 0
[5416523.204837] CPU 9: hi: 186, btch: 31 usd: 0
[5416523.204838] CPU 10: hi: 186, btch: 31 usd: 0
[5416523.204839] CPU 11: hi: 186, btch: 31 usd: 0
[5416523.204840] Node 0 Normal per-cpu:
[5416523.204841] CPU 0: hi: 186, btch: 31 usd: 0
[5416523.204842] CPU 1: hi: 186, btch: 31 usd: 0
[5416523.204844] CPU 2: hi: 186, btch: 31 usd: 0
[5416523.204845] CPU 3: hi: 186, btch: 31 usd: 0
[5416523.204846] CPU 4: hi: 186, btch: 31 usd: 0
[5416523.204847] CPU 5: hi: 186, btch: 31 usd: 180
[5416523.204848] CPU 6: hi: 186, btch: 31 usd: 0
[5416523.204849] CPU 7: hi: 186, btch: 31 usd: 0
[5416523.204850] CPU 8: hi: 186, btch: 31 usd: 0
[5416523.204851] CPU 9: hi: 186, btch: 31 usd: 0
[5416523.204853] CPU 10: hi: 186, btch: 31 usd: 0
[5416523.204854] CPU 11: hi: 186, btch: 31 usd: 0
[5416523.204856] active_anon:1159 inactive_anon:4454 isolated_anon:0
[5416523.204857] active_file:1834929 inactive_file:1858278 isolated_fil=
e:0
[5416523.204858] unevictable:0 dirty:3419 writeback:1 unstable:0
[5416523.204858] free:41486 slab_reclaimable:140009 slab_unreclaimable:=
71445
[5416523.204859] mapped:1094 shmem:1646 pagetables:412 bounce:0
[5416523.204860] Node 0 DMA free:15900kB min:64kB low:80kB high:96kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15644kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:=
0
all_unreclaimable? yes
[5416523.204866] lowmem_reserve[]: 0 3495 16095 16095
[5416523.204868] Node 0 DMA32 free:77448kB min:14664kB low:18328kB
high:21996kB active_anon:0kB inactive_anon:104kB active_file:1491480kB
inactive_file:1526412kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:3579648kB mlocked:0kB dirty:1176kB
writeback:0kB mapped:180kB shmem:0kB slab_reclaimable:301820kB
slab_unreclaimable:97804kB kernel_stack:20768kB pagetables:308kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[5416523.204875] lowmem_reserve[]: 0 0 12600 12600
[5416523.204877] Node 0 Normal free:72596kB min:52852kB low:66064kB
high:79276kB active_anon:4636kB inactive_anon:17712kB
active_file:5848236kB inactive_file:5906316kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:12902400kB mlocked:0kB
dirty:12500kB writeback:4kB mapped:4196kB shmem:6584kB
slab_reclaimable:258216kB slab_unreclaimable:187976kB
kernel_stack:15456kB pagetables:1340kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:36 all_unreclaimable? no
[5416523.204883] lowmem_reserve[]: 0 0 0 0
[5416523.204885] Node 0 DMA: 1*4kB 1*8kB 1*16kB 0*32kB 2*64kB 1*128kB
1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB =3D 15900kB
[5416523.204890] Node 0 DMA32: 1923*4kB 2433*8kB 3088*16kB 16*32kB
3*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB =3D 78164kB
[5416523.204895] Node 0 Normal: 14590*4kB 1263*8kB 56*16kB 1*32kB 1*64k=
B
0*128kB 1*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB =3D 73296kB
[5416523.204900] 3698022 total pagecache pages
[5416523.204901] 3249 pages in swap cache
[5416523.204903] Swap cache stats: add 2384957, delete 2381708, find
8582137/8898669
[5416523.204904] Free swap =3D 3902556kB
[5416523.204904] Total swap =3D 3926012kB
[5416523.238116] 4194288 pages RAM
[5416523.238117] 87642 pages reserved
[5416523.238118] 3673827 pages shared
[5416523.238119] 363584 pages non-shared
[5416523.238323] ib_srpt: ***ERROR***: failed to create_qp ret=3D -12
[5416523.238381] ib_srpt: ***ERROR***: rejected SRP_LOGIN_REQ because
creating a new RDMA channel failed.
[5416523.238393] ib_srpt: Rejecting login with reason 0x10001

Cheers,
Sebastian

--=20
Sebastian Riemer
Linux Kernel Developer

ProfitBricks GmbH =95 Greifswalder Str. 207 =95 10405 Berlin, Germany
www.profitbricks.com =95 sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
