From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Issue with MLX5 IB driver
Date: Wed, 31 May 2017 19:18:19 +0300
Message-ID: <20170531161819.GK5406@mtr-leonro.local>
References: <ae8a8bbf-edb5-1909-824c-f98384f506b0@synopsys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n83H03bbH672hrlY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ae8a8bbf-edb5-1909-824c-f98384f506b0-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--n83H03bbH672hrlY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 31, 2017 at 04:59:45PM +0100, Joao Pinto wrote:
> Dear Matan and Leon,
>
> I am trying to bring-up a Connect-X 5 Ex Endpoint, using a setup composed by a
> 32-bit CPU and 512MB of RAM (PCIe Prototyping Platform). The MLX5 Ethernet
> driver initializes well, but after MLX5 IB driver initiates, it consumes all the
> available memory in my board (400MB). Does this driver needs more than 400MB to
> work?

I think that you are hitting the side effect of these commits
7d0cc6edcc70 ("IB/mlx5: Add MR cache for large UMR regions") and
81713d3788d2 ("IB/mlx5: Add implicit MR support")

Do you have CONFIG_INFINIBAND_ON_DEMAND_PAGING on? Can you disable it
for the test?

Thanks

>
> Kernel used:
>
> Latest 4.12.
>
> Kernel log:
>
> mlx5_core 0000:01:00.0: enabling device (0000 -> 0002)
> mlx5_core 0000:01:00.0: Warning: couldn't set 64-bit PCI DMA mask
> mlx5_core 0000:01:00.0: Warning: couldn't set 64-bit consistent PCI DMA mask
> mlx5_core 0000:01:00.0: firmware version: 16.19.21102
> mlx5_core 0000:01:00.0: mlx5_cmd_init:1765:(pid 1): descriptor at dma 0x9a25a000
> mlx5_core 0000:01:00.0: dump_command:726:(pid 5): dump command ENABLE_HCA(0x104)
> INPUT
> mlx5_core 0000:01:00.0: cmd_work_handler:829:(pid 5): writing 0x1 to command
> doorbell
> mlx5_core 0000:01:00.0: dump_command:726:(pid 5): dump command ENABLE_HCA(0x104)
> OUTPUT
> mlx5_core 0000:01:00.0: mlx5_cmd_comp_handler:1418:(pid 5): command completed.
> ret 0x0, delivery status no errors(0x0)
> mlx5_core 0000:01:00.0: wait_func:893:(pid 1): err 0, delivery status no errors(0)
> (...)
> mlx5_ib: Mellanox Connect-IB Infiniband driver v2.2-1 (Feb 2014)
> (...)
> mlx5_core 0000:01:00.0: dump_command:726:(pid 40): dump command
> QUERY_HCA_VPORT_CONTEXT(0x762) INPUT
> mlx5_core 0000:01:00.0: cmd_work_handler:829:(pid 40): writing 0x1 to command
> doorbell
> mlx5_core 0000:01:00.0: mlx5_eq_int:394:(pid 5): eqn 16, eqe type
> MLX5_EVENT_TYPE_CMD
> (...)
> mlx5_core 0000:01:00.0: mlx5_eq_int:460:(pid 0): page request for func 0x0,
> npages 4096
> mlx5_core 0000:01:00.0: dump_command:726:(pid 40): dump command
> CREATE_MKEY(0x200) INPUT
> mlx5_core 0000:01:00.0: cmd_exec:1558:(pid 61): err 0, status 0
> mlx5_core 0000:01:00.0: cmd_exec:1558:(pid 61): err 0, status 0
> mlx5_core 0000:01:00.0: cmd_exec:1558:(pid 61): err 0, status 0
> (...)
> kworker/u2:3 invoked oom-killer: gfp_mask=0x14200c2(GFP_HIGHUSER),
> nodemask=(null),  order=0, oom_score_adj=0
> CPU: 0 PID: 61 Comm: kworker/u2:3 Not tainted 4.12.0-MLNX20170524 #46
> Workqueue: mlx5_page_allocator pages_work_handler
>
> Stack Trace:
>   arc_unwind_core.constprop.2+0xb4/0x100
>   dump_header.isra.6+0x82/0x1a8
>   out_of_memory+0x2fc/0x368
>   __alloc_pages_nodemask+0x22ee/0x24e4
>   give_pages+0x1fc/0x664
>   pages_work_handler+0x2a/0x88
>   process_one_work+0x1c8/0x390
>   worker_thread+0x120/0x540
>   kthread+0x116/0x13c
>   ret_from_fork+0x18/0x1c
> Mem-Info:
> active_anon:2083 inactive_anon:7261 isolated_anon:0
>  active_file:0 inactive_file:0 isolated_file:0
>  unevictable:0 dirty:0 writeback:0 unstable:0
>  slab_reclaimable:94 slab_unreclaimable:709
>  mapped:0 shmem:9344 pagetables:0 bounce:0
>  free:311 free_pcp:57 free_cma:0
> Node 0 active_anon:16664kB inactive_anon:58088kB active_file:0kB
> inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB
> mapped:0kB dirty:0kB writeback:0kB shmem:74752kB writeback_tmp:0kB unstable:0kB
> all_unreclaimable? yes
> Normal free:2488kB min:2552kB low:3184kB high:3816kB active_anon:16664kB
> inactive_anon:58088kB active_file:0kB inactive_file:0kB unevictable:0kB
> writepending:0kB present:442368kB managed:407104kB mlocked:0kB
> slab_reclaimable:752kB slab_unreclaimable:5672kB kernel_stack:424kB
> pagetables:0kB bounce:0kB free_pcp:456kB local_pcp:456kB free_cma:0kB
> lowmem_reserve[]: 0 0
> Normal: 1*8kB (U) 1*16kB (U) 1*32kB (U) 0*64kB 1*128kB (U) 1*256kB (U) 0*512kB
> 0*1024kB 1*2048kB (U) 0*4096kB 0*8192kB = 2488kB
> 9344 total pagecache pages
> 55296 pages RAM
> 0 pages HighMem/MovableOnly
> 4408 pages reserved
> [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
> Kernel panic - not syncing: Out of memory and no killable processes...
>
> ---[ end Kernel panic - not syncing: Out of memory and no killable processes...
>
>
> Thank you and best regards,
>
> Joao Pinto
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--n83H03bbH672hrlY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlku7MsACgkQ5GN7iDZy
WKd/ChAAgiXXyHLei8sWCVpONbNNFQyFhz8VjZo6eFj9BIWHn2yZsLfTDlwpDAw+
zdAIqGrHWm13AZgs4uTXCRcUNq9K/oAEG/ABV+o9FoP2SNHnPK3OqM24CiuJ3FAX
gjXGcg8DiEt6xDzjzoF//63pb0Yp31V7wF7a6ZaaGRDkjcLg60btwDaWQadcARW1
mpF9ET856Fb68K5ZDNS+gLRK/0Bdwlu955H9lAj8VeubClWv002muvVcnjt1+rQR
8ADIzmrB+/FKCqskjCx0iJcgQtpqm9r6Nkev98MK/Zl28BWBerQSf6auSHPqHMDu
7kbG8pLy2GPwzUqY81bczUfUGHAcED6JZo8sX3AJ2KNQ/3liPUjnMZxp8mrY5mNw
YeS8pLqnZhtrmnNn8A7J7459R4TovG1uvqbIowuWDw/jIuyDW9ZlI6M1WLRNqhT+
Iys1xHxX9flRVSYptS3puXzb9SQhbh8n3/BR/iwRUfcm+BeionHM/+Ui3yiqUG/a
+FUMiezifPCpV3YqISLaYPea8Gi9eD8hxiy5gowXkdGI3DHRAXFMXdQ2qp1R0G3a
/gj22XCTKWtMr9gBxTLXBK+RosqWCMcX+3fGZMNaEAGbbNCTf3wMaSZ13/+Fv00G
+9cGvdLsbJalHaMf4TeRFSIUhika40OTP39xhGALgLr9BEHt3HM=
=nHdW
-----END PGP SIGNATURE-----

--n83H03bbH672hrlY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
