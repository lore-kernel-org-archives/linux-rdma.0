From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: warning from IB core RoCE cache, please send the pending fix
Date: Sun, 19 Jun 2016 15:40:14 +0300
Message-ID: <be3f3905-75dc-9c6f-8771-c59c773d503d@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I get this trace while playing with my mlx5 setup, few times per hour.

I understand there's a fix underway from Talat, can you please submit it up?

Or.

[ 2908.589209] ------------[ cut here ]------------
[ 2908.589241] WARNING: CPU: 5 PID: 5081 at 
drivers/infiniband/core/cache.c:700 
ib_cache_gid_set_default_gid+0x12b/0x2a7 [ib_core]
[ 2908.589266] Modules linked in: openvswitch nf_conntrack_ipv4 
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c crc32c_generic 
mlx5_ib ib_core mlx5_core(O) nfsv4 nfs ipt_REJECT nf_reject_ipv4 
xt_tcpudp tun ebtable_nat ebtable_filter ebtable_broute bridge stp llc 
ebtables ip6table_raw ip6table_mangle ip6table_filter ip6_tables 
iptable_raw iptable_security iptable_mangle iptable_filter kvm_intel kvm 
irqbypass crc32c_intel shpchp ioatdma joydev button pcspkr nfsd 
auth_rpcgss oid_registry nfs_acl lockd sch_fq_codel grace sunrpc 
ip_tables x_tables ext4 crc16 jbd2 mlx4_en sd_mod sr_mod ata_generic 
uhci_hcd ata_piix libata igb hwmon mlx4_core scsi_mod devlink ehci_pci 
ptp ehci_hcd pps_core dca ipv6 autofs4 [last unloaded: mlx5_core]
[ 2908.589586] CPU: 5 PID: 5081 Comm: kworker/5:0 Tainted: G           
O    4.7.0-rc2+ #637
[ 2908.589605] Hardware name: Supermicro X8DTU/X8DTU, BIOS 2.1c       
08/03/2012
[ 2908.589630] Workqueue: infiniband netdevice_event_work_handler [ib_core]
[ 2908.589648]  0000000000000000 ffff88057c24b8d8 ffffffff81263eaf 
00000000000013d9
[ 2908.589702]  0000000000000000 0000000000000000 ffffffffa0617dd7 
ffff88057c24b928
[ 2908.589756]  ffffffff81055f78 0000000000000008 0000000900000000 
ffff88057c24b9b8
[ 2908.589810] Call Trace:
[ 2908.589835]  [<ffffffff81263eaf>] dump_stack+0x6b/0xa0
[ 2908.589865]  [<ffffffff81055f78>] __warn+0xe1/0xff
[ 2908.589892]  [<ffffffff81055fb3>] warn_slowpath_null+0x1d/0x1f
[ 2908.589927]  [<ffffffffa0602847>] 
ib_cache_gid_set_default_gid+0x12b/0x2a7 [ib_core]
[ 2908.589981]  [<ffffffffa0604930>] add_netdev_ips+0x1a7/0x1c4 [ib_core]
[ 2908.590017]  [<ffffffffa0604789>] ? is_eth_port_of_netdev+0x159/0x159 
[ib_core]
[ 2908.590069]  [<ffffffffa0604779>] ? is_eth_port_of_netdev+0x149/0x159 
[ib_core]
[ 2908.590121]  [<ffffffffa0604656>] ? is_eth_port_of_netdev+0x26/0x159 
[ib_core]
[ 2908.590169]  [<ffffffff8150e5fd>] ? _raw_read_unlock+0x2b/0x36
[ 2908.590204]  [<ffffffffa05ff3d9>] ib_enum_roce_netdev+0xb1/0xec [ib_core]
[ 2908.590241]  [<ffffffffa0604789>] ? is_eth_port_of_netdev+0x159/0x159 
[ib_core]
[ 2908.590293]  [<ffffffffa0604789>] ? is_eth_port_of_netdev+0x159/0x159 
[ib_core]
[ 2908.590345]  [<ffffffffa0604630>] ? del_netdev_default_ips+0x1d/0x1d 
[ib_core]
[ 2908.590397]  [<ffffffffa0604789>] ? is_eth_port_of_netdev+0x159/0x159 
[ib_core]
[ 2908.590449]  [<ffffffffa0604630>] ? del_netdev_default_ips+0x1d/0x1d 
[ib_core]
[ 2908.590500]  [<ffffffffa05ff6ab>] ib_enum_all_roce_netdevs+0x4b/0x80 
[ib_core]
[ 2908.590548]  [<ffffffff81081eda>] ? finish_task_switch+0x130/0x213
[ 2908.590584]  [<ffffffffa0603711>] 
netdevice_event_work_handler+0x27/0x66 [ib_core]
[ 2908.590630]  [<ffffffff810726aa>] process_one_work+0x3c1/0x68d
[ 2908.590659]  [<ffffffff8107252c>] ? process_one_work+0x243/0x68d
[ 2908.590688]  [<ffffffff81509be6>] ? __schedule+0x9b6/0xa0b
[ 2908.590716]  [<ffffffff810729dc>] ? worker_thread+0x66/0x53f
[ 2908.590744]  [<ffffffff810729dc>] ? worker_thread+0x66/0x53f
[ 2908.590773]  [<ffffffff8150e816>] ? _raw_spin_unlock_irq+0x30/0x3d
[ 2908.590802]  [<ffffffff81072d4c>] worker_thread+0x3d6/0x53f
[ 2908.590831]  [<ffffffff81509be6>] ? __schedule+0x9b6/0xa0b
[ 2908.590861]  [<ffffffff8109383b>] ? complete+0x21/0x4e
[ 2908.590888]  [<ffffffff8150e862>] ? _raw_spin_unlock_irqrestore+0x3f/0x4d
[ 2908.590919]  [<ffffffff81072976>] ? process_one_work+0x68d/0x68d
[ 2908.590948]  [<ffffffff81072976>] ? process_one_work+0x68d/0x68d
[ 2908.590976]  [<ffffffff81509da3>] ? schedule+0xa4/0xb9
[ 2908.591004]  [<ffffffff81072976>] ? process_one_work+0x68d/0x68d
[ 2908.591033]  [<ffffffff81076aef>] kthread+0xeb/0xf3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
