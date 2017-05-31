From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Issue with MLX5 IB driver
Date: Wed, 31 May 2017 16:39:38 +0000
Message-ID: <6C3B5F73-C44A-49E6-B55E-3FF65EABCA4E@mellanox.com>
References: <ae8a8bbf-edb5-1909-824c-f98384f506b0@synopsys.com>,<20170531161819.GK5406@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170531161819.GK5406-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> On May 31, 2017, at 7:18 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
>> On Wed, May 31, 2017 at 04:59:45PM +0100, Joao Pinto wrote:
>> Dear Matan and Leon,
>>=20
>> I am trying to bring-up a Connect-X 5 Ex Endpoint, using a setup compose=
d by a
>> 32-bit CPU and 512MB of RAM (PCIe Prototyping Platform). The MLX5 Ethern=
et
>> driver initializes well, but after MLX5 IB driver initiates, it consumes=
 all the
>> available memory in my board (400MB). Does this driver needs more than 4=
00MB to
>> work?
>=20
> I think that you are hitting the side effect of these commits
> 7d0cc6edcc70 ("IB/mlx5: Add MR cache for large UMR regions") and
> 81713d3788d2 ("IB/mlx5: Add implicit MR support")
>=20
> Do you have CONFIG_INFINIBAND_ON_DEMAND_PAGING on? Can you disable it
> for the test?
>=20
> Thanks
Hi Joao,

As Leon mentioned, the previous commits enlarged the driver memory consumpt=
ion.
In your case, what I would suggest in order to work in low memory environme=
nt is to set the profile selector (prof_sel) module parameter of mlx5_core =
to 0 (instead default 2) and this will work in low memory environment. This=
 will have some side effects on performance, but thats the trade of..=20


>=20
>>=20
>> Kernel used:
>>=20
>> Latest 4.12.he=20
>>=20
>> Kernel log:
>>=20
>> mlx5_core 0000:01:00.0: enabling device (0000 -> 0002)
>> mlx5_core 0000:01:00.0: Warning: couldn't set 64-bit PCI DMA mask
>> mlx5_core 0000:01:00.0: Warning: couldn't set 64-bit consistent PCI DMA =
mask
>> mlx5_core 0000:01:00.0: firmware version: 16.19.21102
>> mlx5_core 0000:01:00.0: mlx5_cmd_init:1765:(pid 1): descriptor at dma 0x=
9a25a000
>> mlx5_core 0000:01:00.0: dump_command:726:(pid 5): dump command ENABLE_HC=
A(0x104)
>> INPUT
>> mlx5_core 0000:01:00.0: cmd_work_handler:829:(pid 5): writing 0x1 to com=
mand
>> doorbell
>> mlx5_core 0000:01:00.0: dump_command:726:(pid 5): dump command ENABLE_HC=
A(0x104)
>> OUTPUT
>> mlx5_core 0000:01:00.0: mlx5_cmd_comp_handler:1418:(pid 5): command comp=
leted.
>> ret 0x0, delivery status no errors(0x0)
>> mlx5_core 0000:01:00.0: wait_func:893:(pid 1): err 0, delivery status no=
 errors(0)
>> (...)
>> mlx5_ib: Mellanox Connect-IB Infiniband driver v2.2-1 (Feb 2014)
>> (...)
>> mlx5_core 0000:01:00.0: dump_command:726:(pid 40): dump command
>> QUERY_HCA_VPORT_CONTEXT(0x762) INPUT
>> mlx5_core 0000:01:00.0: cmd_work_handler:829:(pid 40): writing 0x1 to co=
mmand
>> doorbell
>> mlx5_core 0000:01:00.0: mlx5_eq_int:394:(pid 5): eqn 16, eqe type
>> MLX5_EVENT_TYPE_CMD
>> (...)
>> mlx5_core 0000:01:00.0: mlx5_eq_int:460:(pid 0): page request for func 0=
x0,
>> npages 4096
>> mlx5_core 0000:01:00.0: dump_command:726:(pid 40): dump command
>> CREATE_MKEY(0x200) INPUT
>> mlx5_core 0000:01:00.0: cmd_exec:1558:(pid 61): err 0, status 0
>> mlx5_core 0000:01:00.0: cmd_exec:1558:(pid 61): err 0, status 0
>> mlx5_core 0000:01:00.0: cmd_exec:1558:(pid 61): err 0, status 0
>> (...)
>> kworker/u2:3 invoked oom-killer: gfp_mask=3D0x14200c2(GFP_HIGHUSER),
>> nodemask=3D(null),  order=3D0, oom_score_adj=3D0
>> CPU: 0 PID: 61 Comm: kworker/u2:3 Not tainted 4.12.0-MLNX20170524 #46
>> Workqueue: mlx5_page_allocator pages_work_handler
>>=20
>> Stack Trace:
>>  arc_unwind_core.constprop.2+0xb4/0x100
>>  dump_header.isra.6+0x82/0x1a8
>>  out_of_memory+0x2fc/0x368
>>  __alloc_pages_nodemask+0x22ee/0x24e4
>>  give_pages+0x1fc/0x664
>>  pages_work_handler+0x2a/0x88
>>  process_one_work+0x1c8/0x390
>>  worker_thread+0x120/0x540
>>  kthread+0x116/0x13c
>>  ret_from_fork+0x18/0x1c
>> Mem-Info:
>> active_anon:2083 inactive_anon:7261 isolated_anon:0
>> active_file:0 inactive_file:0 isolated_file:0
>> unevictable:0 dirty:0 writeback:0 unstable:0
>> slab_reclaimable:94 slab_unreclaimable:709
>> mapped:0 shmem:9344 pagetables:0 bounce:0
>> free:311 free_pcp:57 free_cma:0
>> Node 0 active_anon:16664kB inactive_anon:58088kB active_file:0kB
>> inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB
>> mapped:0kB dirty:0kB writeback:0kB shmem:74752kB writeback_tmp:0kB unsta=
ble:0kB
>> all_unreclaimable? yes
>> Normal free:2488kB min:2552kB low:3184kB high:3816kB active_anon:16664kB
>> inactive_anon:58088kB active_file:0kB inactive_file:0kB unevictable:0kB
>> writepending:0kB present:442368kB managed:407104kB mlocked:0kB
>> slab_reclaimable:752kB slab_unreclaimable:5672kB kernel_stack:424kB
>> pagetables:0kB bounce:0kB free_pcp:456kB local_pcp:456kB free_cma:0kB
>> lowmem_reserve[]: 0 0
>> Normal: 1*8kB (U) 1*16kB (U) 1*32kB (U) 0*64kB 1*128kB (U) 1*256kB (U) 0=
*512kB
>> 0*1024kB 1*2048kB (U) 0*4096kB 0*8192kB =3D 2488kB
>> 9344 total pagecache pages
>> 55296 pages RAM
>> 0 pages HighMem/MovableOnly
>> 4408 pages reserved
>> [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score=
_adj name
>> Kernel panic - not syncing: Out of memory and no killable processes...
>>=20
>> ---[ end Kernel panic - not syncing: Out of memory and no killable proce=
sses...
>>=20
>>=20
>> Thank you and best regards,
>>=20
>> Joao Pinto
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
