From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: BUG: bad page map under Xen
Date: Mon, 21 Oct 2013 13:57:40 +0200
Message-ID: <20131021115740.GN20913@ics.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: xen-devel@lists.xen.org
Cc: roland@kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I'm trying to get SR-IOV working under Xen (4.2). It almost works except
memory bug. This is easily reproducible just in Dom0. =


I have Connect-X3 card with the latest firmware. OFED 2.0-3 drivers. I tried
3.2 kernel from Debian, 3.10 kernel from Debian and vanila 3.11.5 kernel. A=
ll
are the same. =


As soon as I issue ibv_devinfo command, it produces the following messages
into dmesg. Problem is that with ib_rdma_bw command, I get more of those
messages and moreover, oom killer gets confused and kills almost all
processes.

[23502.645455] mlx4_core 0000:06:00.0: mlx4_ib: Port 1 logical link is up
[23550.181907] <mlx4_ib> check_flow_steering_support: Device managed flow s=
teering is unavailable for IB port in multifunction env.
[23550.183822] swap_free: Unused swap offset entry 00000001
[23550.183868] BUG: Bad page map in process ibv_devinfo  pte:00000200 pmd:1=
b7df4067
[23550.183939] addr:00007f7ef5e18000 vm_flags:400844fa anon_vma:          (=
null) mapping:ffff8801b83c0480 index:380fe0882
[23550.184022] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x0/0x2d [ib_uverbs]
[23550.195382] Pid: 13813, comm: ibv_devinfo Tainted: G           O 3.2.0-0=
.bpo.4-amd64 #1 Debian 3.2.41-2+deb7u2~bpo60+1+zs4
[23550.195461] Call Trace:
[23550.195508]  [<ffffffff810d9009>] ? print_bad_pte+0x1f5/0x20d
[23550.195553]  [<ffffffff810db083>] ? unmap_vmas+0x5fe/0x814
[23550.195601]  [<ffffffff810c68dd>] ? __add_page_to_lru_list+0x53/0x53
[23550.195647]  [<ffffffff810df2de>] ? unmap_region+0x9f/0x102
[23550.195694]  [<ffffffff8100d722>] ? __switch_to+0x23b/0x2b1
[23550.195741]  [<ffffffff8103d870>] ? pick_next_task_fair+0xfc/0x10c
[23550.195788]  [<ffffffff810463a2>] ? finish_task_switch+0x53/0xc7
[23550.195832]  [<ffffffff810e01f7>] ? do_munmap+0x281/0x2eb
[23550.195875]  [<ffffffff810e02a0>] ? sys_munmap+0x3f/0x55
[23550.195921]  [<ffffffff8136e51c>] ? system_call_fastpath+0x16/0x1b
[23550.195965] Disabling lock debugging due to kernel taint
[23550.196412] <mlx4_ib> check_flow_steering_support: Device managed flow s=
teering is unavailable for IB port in multifunction env.
[23550.198303] swap_free: Unused swap offset entry 00000001
[23550.198348] BUG: Bad page map in process ibv_devinfo  pte:00000200 pmd:1=
b7df4067
[23550.198424] addr:00007f7ef5e18000 vm_flags:400844fa anon_vma:          (=
null) mapping:ffff8801b83c09a0 index:380fe0082
[23550.198508] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x0/0x2d [ib_uverbs]
[23550.198558] Pid: 13813, comm: ibv_devinfo Tainted: G    B      O 3.2.0-0=
.bpo.4-amd64 #1 Debian 3.2.41-2+deb7u2~bpo60+1+zs4
[23550.198637] Call Trace:
[23550.198680]  [<ffffffff810d9009>] ? print_bad_pte+0x1f5/0x20d
[23550.198730]  [<ffffffff810db083>] ? unmap_vmas+0x5fe/0x814
[23550.198775]  [<ffffffff810c68dd>] ? __add_page_to_lru_list+0x53/0x53
[23550.198820]  [<ffffffff810df2de>] ? unmap_region+0x9f/0x102
[23550.198865]  [<ffffffff8100d6b0>] ? __switch_to+0x1c9/0x2b1
[23550.198913]  [<ffffffff8103d870>] ? pick_next_task_fair+0xfc/0x10c
[23550.198959]  [<ffffffff810463a2>] ? finish_task_switch+0x53/0xc7
[23550.199005]  [<ffffffff810e01f7>] ? do_munmap+0x281/0x2eb
[23550.199052]  [<ffffffff810e02a0>] ? sys_munmap+0x3f/0x55
[23550.199096]  [<ffffffff8136e51c>] ? system_call_fastpath+0x16/0x1b
[23550.199766] <mlx4_ib> check_flow_steering_support: Device managed flow s=
teering is unavailable for IB port in multifunction env.
[23550.201661] swap_free: Unused swap offset entry 00000001
[23550.201706] BUG: Bad page map in process ibv_devinfo  pte:00000200 pmd:1=
b7df4067
[23550.201776] addr:00007f7ef5e18000 vm_flags:400844fa anon_vma:          (=
null) mapping:ffff8801b83c0ec0 index:380fdf882
[23550.201861] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x0/0x2d [ib_uverbs]
[23550.201908] Pid: 13813, comm: ibv_devinfo Tainted: G    B      O 3.2.0-0=
.bpo.4-amd64 #1 Debian 3.2.41-2+deb7u2~bpo60+1+zs4
[23550.201990] Call Trace:
[23550.202032]  [<ffffffff810d9009>] ? print_bad_pte+0x1f5/0x20d
[23550.202081]  [<ffffffff810db083>] ? unmap_vmas+0x5fe/0x814
[23550.202125]  [<ffffffff810df2de>] ? unmap_region+0x9f/0x102
[23550.202169]  [<ffffffff8100d6b0>] ? __switch_to+0x1c9/0x2b1
[23550.202217]  [<ffffffff8103d870>] ? pick_next_task_fair+0xfc/0x10c
[23550.202267]  [<ffffffff810463a2>] ? finish_task_switch+0x53/0xc7
[23550.202312]  [<ffffffff810e01f7>] ? do_munmap+0x281/0x2eb
[23550.202355]  [<ffffffff810e02a0>] ? sys_munmap+0x3f/0x55
[23550.202398]  [<ffffffff8136e51c>] ? system_call_fastpath+0x16/0x1b
[23550.202925] <mlx4_ib> check_flow_steering_support: Device managed flow s=
teering is unavailable for IB port in multifunction env.
[23550.213336] swap_free: Unused swap offset entry 00000001
[23550.213377] BUG: Bad page map in process ibv_devinfo  pte:00000200 pmd:1=
b7df4067
[23550.213448] addr:00007f7ef5e18000 vm_flags:400844fa anon_vma:          (=
null) mapping:ffff8801b6bd8ec0 index:380fdf082
[23550.213527] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x0/0x2d [ib_uverbs]
[23550.213573] Pid: 13813, comm: ibv_devinfo Tainted: G    B      O 3.2.0-0=
.bpo.4-amd64 #1 Debian 3.2.41-2+deb7u2~bpo60+1+zs4
[23550.213651] Call Trace:
[23550.213775]  [<ffffffff810d9009>] ? print_bad_pte+0x1f5/0x20d
[23550.213820]  [<ffffffff810db083>] ? unmap_vmas+0x5fe/0x814
[23550.213863]  [<ffffffff810df2de>] ? unmap_region+0x9f/0x102
[23550.213907]  [<ffffffff8100d6b0>] ? __switch_to+0x1c9/0x2b1
[23550.213951]  [<ffffffff8103d870>] ? pick_next_task_fair+0xfc/0x10c
[23550.213996]  [<ffffffff810463a2>] ? finish_task_switch+0x53/0xc7
[23550.214041]  [<ffffffff810e01f7>] ? do_munmap+0x281/0x2eb
[23550.214084]  [<ffffffff810e02a0>] ? sys_munmap+0x3f/0x55
[23550.214127]  [<ffffffff8136e51c>] ? system_call_fastpath+0x16/0x1b
[23550.214461] <mlx4_ib> check_flow_steering_support: Device managed flow s=
teering is unavailable for IB port in multifunction env.
[23550.215924] swap_free: Unused swap offset entry 00000001
[23550.215974] BUG: Bad page map in process ibv_devinfo  pte:00000200 pmd:1=
b7df4067
[23550.216049] addr:00007f7ef5e18000 vm_flags:400844fa anon_vma:          (=
null) mapping:ffff8801b8f381f0 index:380fff085
[23550.216133] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x0/0x2d [ib_uverbs]
[23550.216184] Pid: 13813, comm: ibv_devinfo Tainted: G    B      O 3.2.0-0=
.bpo.4-amd64 #1 Debian 3.2.41-2+deb7u2~bpo60+1+zs4
[23550.216267] Call Trace:
[23550.216306]  [<ffffffff810d9009>] ? print_bad_pte+0x1f5/0x20d
[23550.216351]  [<ffffffff810db083>] ? unmap_vmas+0x5fe/0x814
[23550.216395]  [<ffffffff810df2de>] ? unmap_region+0x9f/0x102
[23550.216443]  [<ffffffff8100d6b0>] ? __switch_to+0x1c9/0x2b1
[23550.216487]  [<ffffffff8103d870>] ? pick_next_task_fair+0xfc/0x10c
[23550.216532]  [<ffffffff810463a2>] ? finish_task_switch+0x53/0xc7
[23550.216581]  [<ffffffff810e01f7>] ? do_munmap+0x281/0x2eb
[23550.216628]  [<ffffffff810e02a0>] ? sys_munmap+0x3f/0x55
[23550.216677]  [<ffffffff8136e51c>] ? system_call_fastpath+0x16/0x1b
[23550.216728] swap_free: Unused swap offset entry 00000001
[23550.216777] BUG: Bad page map in process ibv_devinfo  pte:00000200 pmd:1=
b7df4067
[23550.216846] addr:00007f7ef5e16000 vm_flags:400844fa anon_vma:          (=
null) mapping:ffff8801b8f381f0 index:380fff485
[23550.216925] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x0/0x2d [ib_uverbs]
[23550.216980] Pid: 13813, comm: ibv_devinfo Tainted: G    B      O 3.2.0-0=
.bpo.4-amd64 #1 Debian 3.2.41-2+deb7u2~bpo60+1+zs4
[23550.217077] Call Trace:
[23550.217124]  [<ffffffff810d9009>] ? print_bad_pte+0x1f5/0x20d
[23550.217169]  [<ffffffff810db083>] ? unmap_vmas+0x5fe/0x814
[23550.217212]  [<ffffffff810df2de>] ? unmap_region+0x9f/0x102
[23550.217256]  [<ffffffff8100d6b0>] ? __switch_to+0x1c9/0x2b1
[23550.217300]  [<ffffffff8103d870>] ? pick_next_task_fair+0xfc/0x10c
[23550.217349]  [<ffffffff810e01f7>] ? do_munmap+0x281/0x2eb
[23550.217396]  [<ffffffff810e02a0>] ? sys_munmap+0x3f/0x55
[23550.217443]  [<ffffffff8136e51c>] ? system_call_fastpath+0x16/0x1b

this happens only if running under Xen. Native kernel in the same version i=
s OK.

Is it a known bug or is something wrong with BIOS/firmware?

-- =

Luk=E1=B9 Hejtm=E1nek
