From: Sagi Grimberg <sagi@grimberg.me>
Subject: cx4 sriov problem in stable 4.14.47
Date: Wed, 20 Jun 2018 13:40:16 +0300
Message-ID: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@mellanox.com>
Cc: Stable <stable@vger.kernel.org>, Roy Shterman <roys@lightbitslabs.com>
List-Id: linux-rdma@vger.kernel.org

Hey folks,

Seems that CX4 (Ethernet) sriov ports probe with link down in the latest
stable 4.14 kernel. I upgrated firmware but with no luck :(

Has anyone seen this issue as well?

Kernel: stable 4.14.47
Firmware: 12.22.1002
psid: MT_2140110033

sysfs port state is DOWN and phys port state is Disabled.

I tried to add as much debug as I could to dump for the experts:
--
[ 3243.373948] mlx5_core 0000:03:00.0: 
mlx5_core_sriov_configure:210:(pid 1616): requested num_vfs 1
[ 3243.374321] mlx5_core 0000:03:00.0: mlx5_device_enable_sriov:115:(pid 
1616): successfully enabled VF* 0
[ 3243.482126] pci 0000:03:00.1: [15b3:1014] type 00 class 0x020000
[ 3243.482490] pci 0000:03:00.1: Max Payload Size set to 256 (was 128, 
max 512)
[ 3243.482510] pci 0000:03:00.1: enabling Extended Tags
[ 3243.487075] mlx5_core 0000:03:00.1: enabling device (0000 -> 0002)
[ 3243.487220] mlx5_core 0000:03:00.1: firmware version: 12.22.1002
[ 3243.570233] mlx5_core 0000:03:00.1: handle_hca_cap:517:(pid 5010): 
Current Pkey table size 128 Setting new size 128
[ 3244.302809] mlx5_core 0000:03:00.1: alloc_comp_eqs:776:(pid 5010): 
allocated completion EQN 20
[ 3244.303052] mlx5_core 0000:03:00.1: alloc_comp_eqs:776:(pid 5010): 
allocated completion EQN 21
[ 3244.303296] mlx5_core 0000:03:00.1: alloc_comp_eqs:776:(pid 5010): 
allocated completion EQN 22
[ 3244.303590] mlx5_core 0000:03:00.1: alloc_comp_eqs:776:(pid 5010): 
allocated completion EQN 23
[ 3244.303825] mlx5_core 0000:03:00.1: alloc_comp_eqs:776:(pid 5010): 
allocated completion EQN 24
[ 3244.304049] mlx5_core 0000:03:00.1: alloc_comp_eqs:776:(pid 5010): 
allocated completion EQN 25
[ 3244.304276] mlx5_core 0000:03:00.1: alloc_comp_eqs:776:(pid 5010): 
allocated completion EQN 26
[ 3244.304499] mlx5_core 0000:03:00.1: alloc_comp_eqs:776:(pid 5010): 
allocated completion EQN 27
[ 3244.307241] mlx5_core 0000:03:00.1: 
mlx5_nic_vport_update_local_lb:939:(pid 5010): disable local_lb
[ 3244.307613] mlx5_core 0000:03:00.1: MLX5E: StrdRq(0) RqSz(1024) 
StrdSz(1) RxCqeCmprss(0)
[ 3244.308008] mlx5_core 0000:03:00.1: Assigned random MAC address 
42:7b:57:5a:f2:06
[ 3244.460140] mlx5_core 0000:03:00.1 ens1f1: renamed from eth0
[ 3244.627854] mlx5_core 0000:03:00.1 ens1f1: Link down
[ 3244.629033] IPv6: ADDRCONF(NETDEV_UP): ens1f1: link is not ready
[ 3244.629480] IPv6: ADDRCONF(NETDEV_UP): ens1f1: link is not ready
[ 3244.639340] pkey = 0xffff
[ 3244.644081] pkey = 0xffff
[ 3244.645809] pkey = 0xffff
[ 3244.646510] pkey = 0x0
[ 3244.646557] pkey = 0x0
[ 3244.646600] pkey = 0x0
[ 3244.646649] pkey = 0x0
[ 3244.646692] pkey = 0x0
[ 3244.646751] pkey = 0x0
[ 3244.646793] pkey = 0x0
[ 3244.646835] pkey = 0x0
[ 3244.646882] pkey = 0x0
[ 3244.646933] pkey = 0x0
[ 3244.646986] pkey = 0x0
[ 3244.647044] pkey = 0x0
[ 3244.647086] pkey = 0x0
[ 3244.647136] pkey = 0x0
[ 3244.647182] pkey = 0x0
[ 3244.647240] pkey = 0x0
[ 3244.647283] pkey = 0x0
[ 3244.647333] pkey = 0x0
[ 3244.647384] pkey = 0x0
[ 3244.647434] pkey = 0x0
[ 3244.647497] pkey = 0x0
[ 3244.647554] pkey = 0x0
[ 3244.647598] pkey = 0x0
[ 3244.647652] pkey = 0x0
[ 3244.647695] pkey = 0x0
[ 3244.647737] pkey = 0x0
[ 3244.647786] pkey = 0x0
[ 3244.647839] pkey = 0x0
[ 3244.647884] pkey = 0x0
[ 3244.647934] pkey = 0x0
[ 3244.647986] pkey = 0x0
[ 3244.648049] pkey = 0x0
[ 3244.648092] pkey = 0x0
[ 3244.648134] pkey = 0x0
[ 3244.648184] pkey = 0x0
[ 3244.648241] pkey = 0x0
[ 3244.648286] pkey = 0x0
[ 3244.648334] pkey = 0x0
[ 3244.648385] pkey = 0x0
[ 3244.648435] pkey = 0x0
[ 3244.648495] pkey = 0x0
[ 3244.648539] pkey = 0x0
[ 3244.648584] pkey = 0x0
[ 3244.648634] pkey = 0x0
[ 3244.648685] pkey = 0x0
[ 3244.648748] pkey = 0x0
[ 3244.648792] pkey = 0x0
[ 3244.648836] pkey = 0x0
[ 3244.648885] pkey = 0x0
[ 3244.648935] pkey = 0x0
[ 3244.648998] pkey = 0x0
[ 3244.649042] pkey = 0x0
[ 3244.649086] pkey = 0x0
[ 3244.649138] pkey = 0x0
[ 3244.649185] pkey = 0x0
[ 3244.649235] pkey = 0x0
[ 3244.649285] pkey = 0x0
[ 3244.649344] pkey = 0x0
[ 3244.649388] pkey = 0x0
[ 3244.649435] pkey = 0x0
[ 3244.649484] pkey = 0x0
[ 3244.649549] pkey = 0x0
[ 3244.649593] pkey = 0x0
[ 3244.649638] pkey = 0x0
[ 3244.649686] pkey = 0x0
[ 3244.649741] pkey = 0x0
[ 3244.649785] pkey = 0x0
[ 3244.649836] pkey = 0x0
[ 3244.649886] pkey = 0x0
[ 3244.649936] pkey = 0x0
[ 3244.649988] pkey = 0x0
[ 3244.651604] pkey = 0x0
[ 3244.651652] pkey = 0x0
[ 3244.651697] pkey = 0x0
[ 3244.651744] pkey = 0x0
[ 3244.651788] pkey = 0x0
[ 3244.651839] pkey = 0x0
[ 3244.651889] pkey = 0x0
[ 3244.651939] pkey = 0x0
[ 3244.651989] pkey = 0x0
[ 3244.652048] pkey = 0x0
[ 3244.652090] pkey = 0x0
[ 3244.652140] pkey = 0x0
[ 3244.652195] pkey = 0x0
[ 3244.652241] pkey = 0x0
[ 3244.652300] pkey = 0x0
[ 3244.652343] pkey = 0x0
[ 3244.652403] pkey = 0x0
[ 3244.652450] pkey = 0x0
[ 3244.652493] pkey = 0x0
[ 3244.652540] pkey = 0x0
[ 3244.652593] pkey = 0x0
[ 3244.652640] pkey = 0x0
[ 3244.652697] pkey = 0x0
[ 3244.652755] pkey = 0x0
[ 3244.652800] pkey = 0x0
[ 3244.652848] pkey = 0x0
[ 3244.652892] pkey = 0x0
[ 3244.652950] pkey = 0x0
[ 3244.652993] pkey = 0x0
[ 3244.653041] pkey = 0x0
[ 3244.653091] pkey = 0x0
[ 3244.653141] pkey = 0x0
[ 3244.653191] pkey = 0x0
[ 3244.653241] pkey = 0x0
[ 3244.653294] pkey = 0x0
[ 3244.653341] pkey = 0x0
[ 3244.653391] pkey = 0x0
[ 3244.653531] pkey = 0x0
[ 3244.653593] pkey = 0x0
[ 3244.653935] pkey = 0x0
[ 3244.653996] pkey = 0x0
[ 3244.654253] pkey = 0x0
[ 3244.654974] pkey = 0x0
[ 3244.655038] pkey = 0x0
[ 3244.655097] pkey = 0x0
[ 3244.655143] pkey = 0x0
[ 3244.655194] pkey = 0x0
[ 3244.655253] pkey = 0x0
[ 3244.655308] pkey = 0x0
[ 3244.655350] pkey = 0x0
[ 3244.655393] pkey = 0x0
[ 3244.655448] pkey = 0x0
[ 3244.655494] pkey = 0x0
[ 3244.655544] pkey = 0x0
[ 3244.655595] pkey = 0x0
[ 3244.655648] pkey = 0x0
