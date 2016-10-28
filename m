From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 185551] New: rxe_rdma: RTNL: assertion failed at
 net/core/ethtool.c (550)
Date: Fri, 28 Oct 2016 23:46:14 +0000
Message-ID: <bug-185551-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=185551

            Bug ID: 185551
           Summary: rxe_rdma: RTNL: assertion failed at net/core/ethtool.c
                    (550)
           Product: Drivers
           Version: 2.5
    Kernel Version: 4.8.5-1.el7.elrepo.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: v.badalyan-mR0gyJWGnJgvJsYlp49lxw@public.gmane.org
        Regression: No

#rxe_cfg start
#rxe_cfg add eno1.4004
#rxe_cfg 

[root@intel2-i5 ~]# rxe_cfg
  Name       Link  Driver  Speed  NMTU  IPv4_addr  RDEV  RMTU
  DevNet     yes   bridge
  eno1       yes   e1000e
  eno1.4003  yes   802.1Q
  eno1.4004  yes   802.1Q                          rxe0  4096  (5)
  enp2s1     yes   r8169
  ovirtmgmt  yes   bridge


[  174.931213] rxe: loaded
[  174.950852] RTNL: assertion failed at net/core/ethtool.c (550)
[  174.950882] CPU: 2 PID: 3158 Comm: sh Not tainted 4.8.5-1.el7.elrepo.x86_64
#1
[  174.950883] Hardware name:                  /DH67CL, BIOS
BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[  174.950884]  0000000000000286 000000007b249d8e ffff8802fbfe3a98
ffffffff81353eef
[  174.950886]  ffff88030c174000 ffff8802fbfe3b18 ffff8802fbfe3af8
ffffffff816109f7
[  174.950888]  ffffea000befc600 00000000024080c0 0000000000000001
ffffffff82164820
[  174.950889] Call Trace:
[  174.950894]  [<ffffffff81353eef>] dump_stack+0x63/0x84
[  174.950897]  [<ffffffff816109f7>] __ethtool_get_link_ksettings+0x1b7/0x1c0
[  174.950900]  [<ffffffffa0041485>] vlan_ethtool_get_link_ksettings+0x15/0x20
[8021q]
[  174.950904]  [<ffffffffa09225b0>] rxe_query_port+0xb0/0x190 [rdma_rxe]
[  174.950906]  [<ffffffff8136023e>] ? vsnprintf+0x34e/0x4d0
[  174.950908]  [<ffffffffa09226bd>] rxe_port_immutable+0x2d/0x70 [rdma_rxe]
[  174.950919]  [<ffffffffa088426c>] ib_register_device+0x27c/0x500 [ib_core]
[  174.950921]  [<ffffffff811f4cee>] ? __kmalloc+0x1ee/0x200
[  174.950923]  [<ffffffff8137307d>] ? list_del+0xd/0x30
[  174.950925]  [<ffffffffa09236a1>] rxe_register_device+0x2a1/0x300 [rdma_rxe]
[  174.950927]  [<ffffffffa091b674>] rxe_add+0x544/0x5c0 [rdma_rxe]
[  174.950929]  [<ffffffffa09281a3>] rxe_net_add+0x43/0xa0 [rdma_rxe]
[  174.950931]  [<ffffffffa0928685>] rxe_param_set_add+0x65/0x148 [rdma_rxe]
[  174.950934]  [<ffffffff810a0678>] param_attr_store+0x68/0xd0
[  174.950935]  [<ffffffff8109fa0d>] module_attr_store+0x1d/0x30
[  174.950937]  [<ffffffff8129cbba>] sysfs_kf_write+0x3a/0x50
[  174.950937]  [<ffffffff8129c6e0>] kernfs_fop_write+0x120/0x1b0
[  174.950939]  [<ffffffff8121b737>] __vfs_write+0x37/0x140
[  174.950941]  [<ffffffff810cebdf>] ? percpu_down_read+0x1f/0x50
[  174.950942]  [<ffffffff8121be52>] vfs_write+0xb2/0x1b0
[  174.950944]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0
[  174.950945]  [<ffffffff8121d2a5>] SyS_write+0x55/0xc0
[  174.950947]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
[  174.950948]  [<ffffffff8173abe1>] entry_SYSCALL64_slow_path+0x25/0x25
[  174.950967] RTNL: assertion failed at net/core/ethtool.c (550)
[  174.950985] CPU: 2 PID: 3158 Comm: sh Not tainted 4.8.5-1.el7.elrepo.x86_64
#1
[  174.950985] Hardware name:                  /DH67CL, BIOS
BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[  174.950986]  0000000000000286 000000007b249d8e ffff8802fbfe39d8
ffffffff81353eef
[  174.950987]  ffff88030c174000 ffff8802fbfe3a58 ffff8802fbfe3a38
ffffffff816109f7
[  174.950988]  ffff8802fbfe3a58 ffff8802fbfe3a48 ffff8802fbfe3a30
ffff8802fbfe3a98
[  174.950990] Call Trace:
[  174.950991]  [<ffffffff81353eef>] dump_stack+0x63/0x84
[  174.950993]  [<ffffffff816109f7>] __ethtool_get_link_ksettings+0x1b7/0x1c0
[  174.950998]  [<ffffffffa08885d0>] ? _add_netdev_ips+0x2f0/0x380 [ib_core]
[  174.950999]  [<ffffffffa0041485>] vlan_ethtool_get_link_ksettings+0x15/0x20
[8021q]
[  174.951001]  [<ffffffffa09225b0>] rxe_query_port+0xb0/0x190 [rdma_rxe]
[  174.951003]  [<ffffffff8160ef61>] ? netdev_run_todo+0x61/0x320
[  174.951007]  [<ffffffffa0883dca>] ib_query_port+0xca/0x170 [ib_core]
[  174.951008]  [<ffffffff811f462b>] ? kmem_cache_alloc_trace+0x14b/0x1b0
[  174.951012]  [<ffffffffa08863e7>] ib_cache_update+0xc7/0x350 [ib_core]
[  174.951016]  [<ffffffffa0884677>] ? ib_enum_roce_netdev+0xe7/0x100 [ib_core]
[  174.951020]  [<ffffffffa08870a1>] ib_cache_setup_one+0x271/0x400 [ib_core]
[  174.951024]  [<ffffffffa08842ce>] ib_register_device+0x2de/0x500 [ib_core]
[  174.951025]  [<ffffffff811f4cee>] ? __kmalloc+0x1ee/0x200
[  174.951026]  [<ffffffff8137307d>] ? list_del+0xd/0x30
[  174.951029]  [<ffffffffa09236a1>] rxe_register_device+0x2a1/0x300 [rdma_rxe]
[  174.951030]  [<ffffffffa091b674>] rxe_add+0x544/0x5c0 [rdma_rxe]
[  174.951032]  [<ffffffffa09281a3>] rxe_net_add+0x43/0xa0 [rdma_rxe]
[  174.951034]  [<ffffffffa0928685>] rxe_param_set_add+0x65/0x148 [rdma_rxe]
[  174.951036]  [<ffffffff810a0678>] param_attr_store+0x68/0xd0
[  174.951037]  [<ffffffff8109fa0d>] module_attr_store+0x1d/0x30
[  174.951038]  [<ffffffff8129cbba>] sysfs_kf_write+0x3a/0x50
[  174.951039]  [<ffffffff8129c6e0>] kernfs_fop_write+0x120/0x1b0
[  174.951041]  [<ffffffff8121b737>] __vfs_write+0x37/0x140
[  174.951042]  [<ffffffff810cebdf>] ? percpu_down_read+0x1f/0x50
[  174.951043]  [<ffffffff8121be52>] vfs_write+0xb2/0x1b0
[  174.951044]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0
[  174.951045]  [<ffffffff8121d2a5>] SyS_write+0x55/0xc0
[  174.951047]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
[  174.951048]  [<ffffffff8173abe1>] entry_SYSCALL64_slow_path+0x25/0x25
[  174.951084] RTNL: assertion failed at net/core/ethtool.c (550)
[  174.951102] CPU: 2 PID: 3158 Comm: sh Not tainted 4.8.5-1.el7.elrepo.x86_64
#1
[  174.951102] Hardware name:                  /DH67CL, BIOS
BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[  174.951103]  0000000000000286 000000007b249d8e ffff8802fbfe39d8
ffffffff81353eef
[  174.951104]  ffff88030c174000 ffff8802fbfe3a58 ffff8802fbfe3a38
ffffffff816109f7
[  174.951105]  ffffffff81299ec6 0000000000000000 ffff8802fbfe3a10
ffffffff81299f20
[  174.951107] Call Trace:
[  174.951109]  [<ffffffff81353eef>] dump_stack+0x63/0x84
[  174.951110]  [<ffffffff816109f7>] __ethtool_get_link_ksettings+0x1b7/0x1c0
[  174.951112]  [<ffffffff81299ec6>] ? kernfs_leftmost_descendant+0x36/0x50
[  174.951113]  [<ffffffff81299f20>] ? kernfs_next_descendant_post+0x40/0x50
[  174.951115]  [<ffffffffa0041485>] vlan_ethtool_get_link_ksettings+0x15/0x20
[8021q]
[  174.951117]  [<ffffffffa09225b0>] rxe_query_port+0xb0/0x190 [rdma_rxe]
[  174.951118]  [<ffffffff8129b191>] ? kernfs_create_dir_ns+0x51/0x80
[  174.951119]  [<ffffffff8129d5a0>] ? sysfs_create_dir_ns+0x40/0x90
[  174.951123]  [<ffffffffa0883dca>] ib_query_port+0xca/0x170 [ib_core]
[  174.951125]  [<ffffffff811afb92>] ? kfree_const+0x22/0x30
[  174.951129]  [<ffffffffa0882d4e>] add_port+0x3e/0x480 [ib_core]
[  174.951133]  [<ffffffffa088326c>] ib_device_register_sysfs+0xdc/0x140
[ib_core]
[  174.951136]  [<ffffffffa0884360>] ib_register_device+0x370/0x500 [ib_core]
[  174.951137]  [<ffffffff811f4cee>] ? __kmalloc+0x1ee/0x200
[  174.951139]  [<ffffffff8137307d>] ? list_del+0xd/0x30
[  174.951141]  [<ffffffffa09236a1>] rxe_register_device+0x2a1/0x300 [rdma_rxe]
[  174.951142]  [<ffffffffa091b674>] rxe_add+0x544/0x5c0 [rdma_rxe]
[  174.951144]  [<ffffffffa09281a3>] rxe_net_add+0x43/0xa0 [rdma_rxe]
[  174.951146]  [<ffffffffa0928685>] rxe_param_set_add+0x65/0x148 [rdma_rxe]
[  174.951148]  [<ffffffff810a0678>] param_attr_store+0x68/0xd0
[  174.951149]  [<ffffffff8109fa0d>] module_attr_store+0x1d/0x30
[  174.951150]  [<ffffffff8129cbba>] sysfs_kf_write+0x3a/0x50
[  174.951151]  [<ffffffff8129c6e0>] kernfs_fop_write+0x120/0x1b0
[  174.951153]  [<ffffffff8121b737>] __vfs_write+0x37/0x140
[  174.951154]  [<ffffffff810cebdf>] ? percpu_down_read+0x1f/0x50
[  174.951155]  [<ffffffff8121be52>] vfs_write+0xb2/0x1b0
[  174.951156]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0
[  174.951157]  [<ffffffff8121d2a5>] SyS_write+0x55/0xc0
[  174.951159]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
[  174.951160]  [<ffffffff8173abe1>] entry_SYSCALL64_slow_path+0x25/0x25
[  174.954198] rxe: set rxe0 active
[  174.954199] rxe: added rxe0 to eno1.4004
[  174.954384] RTNL: assertion failed at net/core/ethtool.c (550)
[  174.954408] CPU: 3 PID: 90 Comm: kworker/3:1 Not tainted
4.8.5-1.el7.elrepo.x86_64 #1
[  174.954409] Hardware name:                  /DH67CL, BIOS
BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[  174.954423] Workqueue: infiniband ib_cache_task [ib_core]
[  174.954425]  0000000000000286 00000000c968401e ffff88030dabfc58
ffffffff81353eef
[  174.954427]  ffff88030c174000 ffff88030dabfcd8 ffff88030dabfcb8
ffffffff816109f7
[  174.954428]  ffff8803110c0800 ffff880311663240 0000000000000000
ffff88030dabfd80
[  174.954430] Call Trace:
[  174.954434]  [<ffffffff81353eef>] dump_stack+0x63/0x84
[  174.954437]  [<ffffffff816109f7>] __ethtool_get_link_ksettings+0x1b7/0x1c0
[  174.954439]  [<ffffffff810bf41e>] ? load_balance+0x19e/0x9b0
[  174.954441]  [<ffffffffa0041485>] vlan_ethtool_get_link_ksettings+0x15/0x20
[8021q]
[  174.954445]  [<ffffffffa09225b0>] rxe_query_port+0xb0/0x190 [rdma_rxe]
[  174.954448]  [<ffffffff810b5f2e>] ? account_entity_dequeue+0xae/0xd0
[  174.954449]  [<ffffffff810b942a>] ? dequeue_entity+0x19a/0x5d0
[  174.954453]  [<ffffffffa0883dca>] ib_query_port+0xca/0x170 [ib_core]
[  174.954455]  [<ffffffff811f462b>] ? kmem_cache_alloc_trace+0x14b/0x1b0
[  174.954459]  [<ffffffffa08863e7>] ib_cache_update+0xc7/0x350 [ib_core]
[  174.954463]  [<ffffffffa088668a>] ib_cache_task+0x1a/0x30 [ib_core]
[  174.954465]  [<ffffffff8109ad82>] process_one_work+0x152/0x400
[  174.954467]  [<ffffffff8109b675>] worker_thread+0x125/0x4b0
[  174.954468]  [<ffffffff8109b550>] ? rescuer_thread+0x380/0x380
[  174.954470]  [<ffffffff810a1168>] kthread+0xd8/0xf0
[  174.954472]  [<ffffffff8173ad3f>] ret_from_fork+0x1f/0x40
[  174.954473]  [<ffffffff810a1090>] ? kthread_park+0x60/0x60
[  174.996381] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  174.997259] RTNL: assertion failed at net/core/ethtool.c (550)
[  174.997284] CPU: 1 PID: 3212 Comm: modprobe Not tainted
4.8.5-1.el7.elrepo.x86_64 #1
[  174.997285] Hardware name:                  /DH67CL, BIOS
BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[  174.997286]  0000000000000286 0000000092f5ac1c ffff8802ed3af9f8
ffffffff81353eef
[  174.997288]  ffff88030c174000 ffff8802ed3afa78 ffff8802ed3afa58
ffffffff816109f7
[  174.997289]  ffff880313000d00 ffff8802ed3afad8 ffffffff811f41cf
ffff88031fa9c6c0
[  174.997291] Call Trace:
[  174.997296]  [<ffffffff81353eef>] dump_stack+0x63/0x84
[  174.997299]  [<ffffffff816109f7>] __ethtool_get_link_ksettings+0x1b7/0x1c0
[  174.997301]  [<ffffffff811f41cf>] ? ___slab_alloc+0x34f/0x4c0
[  174.997303]  [<ffffffffa0041485>] vlan_ethtool_get_link_ksettings+0x15/0x20
[8021q]
[  174.997307]  [<ffffffffa09225b0>] rxe_query_port+0xb0/0x190 [rdma_rxe]
[  174.997316]  [<ffffffffa0883dca>] ib_query_port+0xca/0x170 [ib_core]
[  174.997318]  [<ffffffffa092283a>] ? post_one_recv.isra.14+0xaa/0x110
[rdma_rxe]
[  174.997320]  [<ffffffffa09d6670>] srpt_refresh_port+0x80/0x1a0 [ib_srpt]
[  174.997322]  [<ffffffffa09229d2>] ? rxe_post_srq_recv+0x72/0xa0 [rdma_rxe]
[  174.997324]  [<ffffffffa09d9196>] srpt_add_one+0x276/0x440 [ib_srpt]
[  174.997326]  [<ffffffffa09d6150>] ?
srpt_tpg_attrib_srp_max_rdma_size_show+0x30/0x30 [ib_srpt]
[  174.997330]  [<ffffffffa0883c3f>] ib_register_client+0x5f/0xc0 [ib_core]
[  174.997331]  [<ffffffffa08ec000>] ? 0xffffffffa08ec000
[  174.997333]  [<ffffffffa08ec07c>] srpt_init_module+0x7c/0x1000 [ib_srpt]
[  174.997334]  [<ffffffffa08ec000>] ? 0xffffffffa08ec000
[  174.997336]  [<ffffffff81002190>] do_one_initcall+0x50/0x190
[  174.997337]  [<ffffffff811f462b>] ? kmem_cache_alloc_trace+0x14b/0x1b0
[  174.997338]  [<ffffffff8118cb8c>] do_init_module+0x60/0x1f1
[  174.997340]  [<ffffffff8110ea81>] load_module+0x1f31/0x2700
[  174.997342]  [<ffffffff8110b980>] ? __symbol_put+0x60/0x60
[  174.997344]  [<ffffffff812fc18d>] ? ima_post_read_file+0x3d/0x80
[  174.997346]  [<ffffffff812ca41b>] ? security_kernel_post_read_file+0x6b/0x80
[  174.997347]  [<ffffffff8110f476>] SYSC_finit_module+0xa6/0xf0
[  174.997349]  [<ffffffff8110f4de>] SyS_finit_module+0xe/0x10
[  174.997350]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
[  174.997352]  [<ffffffff8173abe1>] entry_SYSCALL64_slow_path+0x25/0x25
[  175.001504] iscsi: registered transport (iser)
[  175.040113] RPC: Registered rdma transport module.
[  175.040114] RPC: Registered rdma backchannel transport module.
[  175.064344] RTNL: assertion failed at net/core/ethtool.c (550)
[  175.064369] CPU: 0 PID: 3187 Comm: ibv_devinfo Not tainted
4.8.5-1.el7.elrepo.x86_64 #1
[  175.064370] Hardware name:                  /DH67CL, BIOS
BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[  175.064371]  0000000000000286 00000000e5af710d ffff8802fbf97b98
ffffffff81353eef
[  175.064373]  ffff88030c174000 ffff8802fbf97c18 ffff8802fbf97bf8
ffffffff816109f7
[  175.064375]  ffffffff81235e1b ffff8802f2f3acc0 ffff8802f2f7af00
ffff8802fbf97c5c
[  175.064376] Call Trace:
[  175.064381]  [<ffffffff81353eef>] dump_stack+0x63/0x84
[  175.064384]  [<ffffffff816109f7>] __ethtool_get_link_ksettings+0x1b7/0x1c0
[  175.064387]  [<ffffffff81235e1b>] ? __d_alloc+0x12b/0x1d0
[  175.064390]  [<ffffffffa0041485>] vlan_ethtool_get_link_ksettings+0x15/0x20
[8021q]
[  175.064393]  [<ffffffffa09225b0>] rxe_query_port+0xb0/0x190 [rdma_rxe]
[  175.064396]  [<ffffffff810eaebd>] ? call_rcu_sched+0x1d/0x20
[  175.064397]  [<ffffffff81232f5c>] ? dentry_free+0x3c/0x90
[  175.064399]  [<ffffffff81234150>] ? __dentry_kill+0x100/0x150
[  175.064409]  [<ffffffffa0883dca>] ib_query_port+0xca/0x170 [ib_core]
[  175.064410]  [<ffffffff810eaebd>] ? call_rcu_sched+0x1d/0x20
[  175.064411]  [<ffffffff8121e2f4>] ? put_filp+0x44/0x50
[  175.064413]  [<ffffffffa08c7e5f>] ib_uverbs_query_port+0x5f/0x150
[ib_uverbs]
[  175.064415]  [<ffffffffa08c43dc>] ib_uverbs_write+0x18c/0x3f0 [ib_uverbs]
[  175.064416]  [<ffffffff8122cc15>] ? do_filp_open+0xa5/0x100
[  175.064418]  [<ffffffff8121b737>] __vfs_write+0x37/0x140
[  175.064419]  [<ffffffff8121be52>] vfs_write+0xb2/0x1b0
[  175.064421]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0
[  175.064423]  [<ffffffff8121d2a5>] SyS_write+0x55/0xc0
[  175.064424]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
[  175.064426]  [<ffffffff8173abe1>] entry_SYSCALL64_slow_path+0x25/0x25
[  175.103154] RTNL: assertion failed at net/core/ethtool.c (550)
[  175.103181] CPU: 1 PID: 3289 Comm: ibv_devinfo Not tainted
4.8.5-1.el7.elrepo.x86_64 #1
[  175.103182] Hardware name:                  /DH67CL, BIOS
BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[  175.103183]  0000000000000286 0000000057c77a87 ffff8802fbf97b98
ffffffff81353eef
[  175.103185]  ffff88030c174000 ffff8802fbf97c18 ffff8802fbf97bf8
ffffffff816109f7
[  175.103186]  ffffffff81235e1b ffff8802f2f3acc0 ffff8802f2f19f00
ffff8802fbf97c5c
[  175.103188] Call Trace:
[  175.103193]  [<ffffffff81353eef>] dump_stack+0x63/0x84
[  175.103196]  [<ffffffff816109f7>] __ethtool_get_link_ksettings+0x1b7/0x1c0
[  175.103199]  [<ffffffff81235e1b>] ? __d_alloc+0x12b/0x1d0
[  175.103202]  [<ffffffffa0041485>] vlan_ethtool_get_link_ksettings+0x15/0x20
[8021q]
[  175.103206]  [<ffffffffa09225b0>] rxe_query_port+0xb0/0x190 [rdma_rxe]
[  175.103209]  [<ffffffff810eaebd>] ? call_rcu_sched+0x1d/0x20
[  175.103210]  [<ffffffff81232f5c>] ? dentry_free+0x3c/0x90
[  175.103211]  [<ffffffff81234150>] ? __dentry_kill+0x100/0x150
[  175.103222]  [<ffffffffa0883dca>] ib_query_port+0xca/0x170 [ib_core]
[  175.103223]  [<ffffffff810eaebd>] ? call_rcu_sched+0x1d/0x20
[  175.103224]  [<ffffffff8121e2f4>] ? put_filp+0x44/0x50
[  175.103226]  [<ffffffffa08c7e5f>] ib_uverbs_query_port+0x5f/0x150
[ib_uverbs]
[  175.103228]  [<ffffffffa08c43dc>] ib_uverbs_write+0x18c/0x3f0 [ib_uverbs]
[  175.103230]  [<ffffffff8121b737>] __vfs_write+0x37/0x140
[  175.103231]  [<ffffffff8121be52>] vfs_write+0xb2/0x1b0
[  175.103233]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0
[  175.103235]  [<ffffffff8121d2a5>] SyS_write+0x55/0xc0
[  175.103236]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
[  175.103238]  [<ffffffff8173abe1>] entry_SYSCALL64_slow_path+0x25/0x25
[  204.011985] RTNL: assertion failed at net/core/ethtool.c (550)
[  204.012012] CPU: 0 PID: 3354 Comm: ibv_devinfo Not tainted
4.8.5-1.el7.elrepo.x86_64 #1
[  204.012012] Hardware name:                  /DH67CL, BIOS
BLH6710H.86A.0160.2012.1204.1156 12/04/2012
[  204.012013]  0000000000000286 0000000069598e2b ffff8802ed337b98
ffffffff81353eef
[  204.012015]  ffff88030c174000 ffff8802ed337c18 ffff8802ed337bf8
ffffffff816109f7
[  204.012017]  ffffffff81235e1b ffff8802f2f3acc0 ffff8802f2fdf0c0
ffff8802ed337c5c
[  204.012018] Call Trace:
[  204.012023]  [<ffffffff81353eef>] dump_stack+0x63/0x84
[  204.012026]  [<ffffffff816109f7>] __ethtool_get_link_ksettings+0x1b7/0x1c0
[  204.012029]  [<ffffffff81235e1b>] ? __d_alloc+0x12b/0x1d0
[  204.012032]  [<ffffffffa0041485>] vlan_ethtool_get_link_ksettings+0x15/0x20
[8021q]
[  204.012036]  [<ffffffffa09225b0>] rxe_query_port+0xb0/0x190 [rdma_rxe]
[  204.012039]  [<ffffffff810eaebd>] ? call_rcu_sched+0x1d/0x20
[  204.012040]  [<ffffffff81232f5c>] ? dentry_free+0x3c/0x90
[  204.012041]  [<ffffffff81234150>] ? __dentry_kill+0x100/0x150
[  204.012052]  [<ffffffffa0883dca>] ib_query_port+0xca/0x170 [ib_core]
[  204.012053]  [<ffffffff810eaebd>] ? call_rcu_sched+0x1d/0x20
[  204.012054]  [<ffffffff8121e2f4>] ? put_filp+0x44/0x50
[  204.012057]  [<ffffffffa08c7e5f>] ib_uverbs_query_port+0x5f/0x150
[ib_uverbs]
[  204.012058]  [<ffffffffa08c43dc>] ib_uverbs_write+0x18c/0x3f0 [ib_uverbs]
[  204.012060]  [<ffffffff8122cc15>] ? do_filp_open+0xa5/0x100
[  204.012061]  [<ffffffff8121b737>] __vfs_write+0x37/0x140
[  204.012063]  [<ffffffff8121be52>] vfs_write+0xb2/0x1b0
[  204.012065]  [<ffffffff8100365d>] ? syscall_trace_enter+0x1dd/0x2c0
[  204.012066]  [<ffffffff8121d2a5>] SyS_write+0x55/0xc0
[  204.012067]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
[  204.012069]  [<ffffffff8173abe1>] entry_SYSCALL64_slow_path+0x25/0x25

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
