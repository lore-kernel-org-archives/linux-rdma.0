From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 190141] New: v4.9: Running SRP on top of SoftRoCE driver
 triggers OOM
Date: Mon, 12 Dec 2016 12:44:06 +0000
Message-ID: <bug-190141-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=190141

            Bug ID: 190141
           Summary: v4.9: Running SRP on top of SoftRoCE driver triggers
                    OOM
           Product: Drivers
           Version: 2.5
    Kernel Version: v4.9
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: bvanassche-HInyCGIudOg@public.gmane.org
        Regression: No

Test description:
* Clone https://github.com/bvanassche/srp-test.
* Enable ib_srp, ib_srpt and rdma_rxe in the kernel config.
* Build and install kernel v4.9, e.g. in a virtual machine.
* Boot kernel v4.9 and run the following commands:
  modprobe rdma_rxe
  echo eth0 > /sys/module/rdma_rxe/parameters/add
  cd srp-test
  ./run-tests

Result on the console:
gmain invoked oom-killer: gfp_mask=0x24201ca(GFP_HIGHUSER_MOVABLE|__GFP_COLD),
nodemask=0, order=0, oom_score_adj=0
Call Trace:
 [<ffffffff812a4943>] dump_stack+0x86/0xc3
 [<ffffffff811ac69f>] dump_header+0x76/0x24a
 [<ffffffff8112a6ce>] oom_kill_process+0x1fe/0x3e0
 [<ffffffff8112ab81>] out_of_memory+0x101/0x530
 [<ffffffff8112ff4b>] __alloc_pages_slowpath+0xafb/0xb40
 [<ffffffff8113021e>] __alloc_pages_nodemask+0x28e/0x2d0
 [<ffffffff8117c81c>] alloc_pages_current+0x9c/0x1e0
 [<ffffffff81124ee7>] __page_cache_alloc+0x137/0x160
 [<ffffffff811284c3>] filemap_fault+0x323/0x5f0
 [<ffffffffa0168551>] ext4_filemap_fault+0x31/0x50 [ext4]
 [<ffffffff811557ad>] __do_fault+0x6d/0x150
 [<ffffffff8115a0e5>] handle_mm_fault+0x1075/0x14b0
 [<ffffffff8104d29b>] __do_page_fault+0x20b/0x460
 [<ffffffff8104d542>] do_page_fault+0x22/0x30
 [<ffffffff81048b44>] do_async_page_fault+0x14/0x70
 [<ffffffff8165a5d8>] async_page_fault+0x28/0x30
Mem-Info:
active_anon:6056 inactive_anon:1337 isolated_anon:0
 active_file:42 inactive_file:46 isolated_file:0
 unevictable:2637 dirty:50 writeback:0 unstable:0
 slab_reclaimable:3546 slab_unreclaimable:51680
 mapped:2019 shmem:1419 pagetables:888 bounce:0
 free:21709 free_pcp:90 free_cma:0
Node 0 active_anon:24224kB inactive_anon:5348kB active_file:168kB
inactive_file:184kB unevictable:10548kB isolated(anon):0kB isolated(file):0kB
mapped:8076kB dirty:200kB writeback:0kB shmem:0kB shmem_thp: 0kB
shmem_pmdmapped: 0kB anon_thp: 5676kB writeback_tmp:0kB unstable:0kB
pages_scanned:0 all_unreclaimable? no
Node 0 DMA free:15908kB min:264kB low:328kB high:392kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
writepending:0kB present:15992kB managed:15908kB mlocked:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB
bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
lowmem_reserve[]: 0 2952 3911 3911
Node 0 DMA32 free:54640kB min:50812kB low:63512kB high:76212kB
active_anon:14684kB inactive_anon:92kB active_file:56kB inactive_file:116kB
unevictable:1880kB writepending:88kB present:3129200kB managed:1716180kB
mlocked:1880kB slab_reclaimable:5696kB slab_unreclaimable:127384kB
kernel_stack:6320kB pagetables:1904kB bounce:0kB free_pcp:240kB local_pcp:116kB
free_cma:0kB
Node 0 Normal free:16288kB min:16504kB low:20628kB high:24752kB
active_anon:9540kB inactive_anon:5256kB active_file:112kB inactive_file:68kB
unevictable:8668kB writepending:112kB present:1048576kB managed:208592kB
mlocked:8668kB slab_reclaimable:8488kB slab_unreclaimable:79336kB
kernel_stack:2048kB pagetables:1648kB bounce:0kB free_pcp:120kB local_pcp:0kB
free_cma:0kB
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 1*32kB (U) 2*64kB (U) 1*128kB (U) 1*256kB
(U) 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15908kB
Node 0 DMA32: 1398*4kB (M) 769*8kB (UME) 531*16kB (UME) 425*32kB (UME) 125*64kB
(UME) 18*128kB (UE) 5*256kB (UE) 6*512kB (UE) 4*1024kB (E) 1*2048kB (E)
0*4096kB = 54640kB
Node 0 Normal: 1046*4kB (UMH) 457*8kB (UMH) 246*16kB (UMEH) 129*32kB (UMEH)
6*64kB (UMH) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 16288kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0
hugepages_size=1048576kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0
hugepages_size=2048kB
3346 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
1048442 pages RAM

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
