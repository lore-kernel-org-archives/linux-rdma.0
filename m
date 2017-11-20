From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: =?UTF-8?Q?Re:_Problem_of_changing_the_inline_mode_or_turning_on_the?=
 =?UTF-8?Q?_encapsulation_support_of_Mellanox_NIC=e2=80=99s_eswitch?=
Date: Mon, 20 Nov 2017 09:28:53 +0200
Message-ID: <83fb4706-2a4c-9e25-b5b6-92e433a7c746@mellanox.com>
References: <HK2PR01MB0834534F555D6F532694DE5AF5220@HK2PR01MB0834.apcprd01.prod.exchangelabs.com>
 <20171120072351.GA18825@mtr-leonro.local>
 <HK2PR01MB083483A928DBF1EC8643BEA3F5220@HK2PR01MB0834.apcprd01.prod.exchangelabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HK2PR01MB083483A928DBF1EC8643BEA3F5220-j5d1BCxnhFliu6CZMbmO22kgRNbfFy2WiWZaQy0nMoadU/p4gVGmPFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Junxue ZHANG <jzhangcs-t+iU6Fs6CelnrVKH7T7RYw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Byron Yi <yibairen1994-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 20/11/2017 09:26, Junxue ZHANG wrote:
> + Bairen
> 
> Thanks
> 
> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org] 
> Sent: Monday, November 20, 2017 3:24 PM
> To: Junxue ZHANG <jzhangcs-t+iU6Fs6CelnrVKH7T7RYw@public.gmane.org>; Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: Problem of changing the inline mode or turning on the encapsulation support of Mellanox NIC’s eswitch
> 
> On Mon, Nov 20, 2017 at 03:29:00AM +0000, Junxue ZHANG wrote:
>> Hi all,
>>
>> I encountered a problem when I tried to change the inline mode or turn on the encapsulation support of Mellanox NIC’s eswitch. I wonder if anyone could help me with this. Thanks.
>>
>> I want to use VXLan with OVS and try to offload the rules in hardware. I don’t know whether it is necessary to turn on the encapsulation support. It would also be of great help if anyone could tell me the correct way to accomplish that. Thanks.
>>
> 
> + Saeed and Or
> 
> 
> The failure in drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
> 990         err = esw_inline_mode_from_devlink(mode, &mlx5_mode);
> 991         if (err)
> 992                 goto out;
> 993
> 994         for (vport = 1; vport < esw->enabled_vports; vport++) {
> 995                 err = mlx5_modify_nic_vport_min_inline(dev, vport, mlx5_mode);
> 996                 if (err) {
> 997                         esw_warn(dev, "Failed to set min inline on vport %d\n",
> 998                                  vport);
> 999                         goto revert_inline_mode;
> 1000                 }
> 1001         }
> 
> Thanks
> 
>>
>> Problem:
>> —————————
>> I can successfully turned on the switchdev mode of my Mellanox NIC. But when I tried to change the inline-mode or turn on the encapsulation support, it failed.
>>
>> I can create VFs successfully and use those VFs with switch with link inline mode and encapsulation support off.
>>
>> How to reproduce:
>> —————————
>> Before each of the following steps, I first turn the switchdev mode off and turn on the legacy mode.
>>
>> 1. Change the inline mode:
>>
>> $ devlink dev eswitch set pci/0000:81:00.0 mode switchdev inline-mode 
>> network devlink answers: Invalid argument
>>
>> Output of Syslog:
>> Nov 20 00:05:04 ip-192-168-2-203 kernel: [ 2968.592023] 
>> mlx5_0:wait_for_async_commands:735:(pid 2332): done with all pending 
>> requests Nov 20 00:05:04 ip-192-168-2-203 systemd-udevd[2335]: Could 
>> not generate persistent MAC address for eth0: No such file or 
>> directory Nov 20 00:05:04 ip-192-168-2-203 systemd-udevd[2340]: Could 
>> not generate persistent MAC address for eth1: No such file or 
>> directory Nov 20 00:05:04 ip-192-168-2-203 kernel: [ 2968.707239] 
>> (0000:81:00.0): E-Switch: SRIOV enabled: active vports(3) Nov 20 
>> 00:05:04 ip-192-168-2-203 kernel: [ 2968.707712] mlx5_core 
>> 0000:81:00.0: mlx5_cmd_check:710:(pid 2332): 
>> MODIFY_NIC_VPORT_CONTEXT(0x755) op_mod(0x0) failed, status bad 
>> parameter(0x3), syndrome (0x40ea03) Nov 20 00:05:04 ip-192-168-2-203 
>> kernel: [ 2968.707790] (0000:81:00.0): E-Switch: Failed to set min 
>> inline on vport 1
>>
>> 2. Turn on the encapsulation:
>>
>> $ devlink dev eswitch set pci/0000:81:00.0 mode switchdev encap enable 
>> devlink answers: Operation not supported
>>
>> Output of Syslog:
>>
>> Nov 20 00:06:16 ip-192-168-2-203 kernel: [ 3040.121748] 
>> (0000:81:00.0): E-Switch: disable SRIOV: active vports(3) mode(1) Nov 
>> 20 00:06:16 ip-192-168-2-203 kernel: [ 3040.161942] (0000:81:00.0): 
>> E-Switch: E-Switch enable SRIOV: nvfs(2) mode (2) Nov 20 00:06:18 
>> ip-192-168-2-203 kernel: [ 3042.847377] 
>> mlx5_0:wait_for_async_commands:735:(pid 2371): done with all pending 
>> requests Nov 20 00:06:19 ip-192-168-2-203 systemd-udevd[2374]: Could 
>> not generate persistent MAC address for eth0: No such file or 
>> directory Nov 20 00:06:19 ip-192-168-2-203 systemd-udevd[2379]: Could 
>> not generate persistent MAC address for eth1: No such file or 
>> directory Nov 20 00:06:19 ip-192-168-2-203 kernel: [ 3042.961906] 
>> (0000:81:00.0): E-Switch: SRIOV enabled: active vports(3)
>>
>> 3. Query the status
>>
>> $ devlink dev eswitch show pci/0000:81:00.0
>> pci/0000:81:00.0: mode switchdev inline-mode link encap disable
>>
>>
>> NIC hardware model:
>> —————————
>> ConnectX®-4 EN network interface card, 40GbE dual-port QSFP28, PCIe3.0 
>> x8, tall bracket, ROHS R6
>>

We don't support encap/decap with ConnectX-4.
You should use ConnectX-4 LX or ConnectX-5.
Note that on ConnectX-5 you don't need to turn inline support as it isn't needed.

>>
>> NIC firmware:
>> —————————
>> $ mstflint -d 81:00.1 q
>>
>> Image type:            FS3
>> FW Version:            12.21.1000
>> FW Release Date:       29.10.2017
>> Product Version:       rel-12_21_1000
>> Rom Info:              type=PXE version=3.5.305 devid=4115 cpu=AMD64
>> Description:           UID                GuidsNumber Base GUID:             
>> ec0d9a0300373802        4 Base MAC:              0000ec0d9a373802        
>> 4 Image VSD:             N/A Device VSD:            N/A
>> PSID:                  MT_2130110027
>> Security Attributes:   N/A
>>
>> Linux distribution:
>> —————————
>> $ cat /etc/*-release
>>
>> PRETTY_NAME="Debian GNU/Linux 9 (stretch)"
>> NAME="Debian GNU/Linux"
>> VERSION_ID="9"
>> VERSION="9 (stretch)"
>> ID=debian
>> HOME_URL="https://emea01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.debian.org%2F&data=02%7C01%7Cmarkb%40mellanox.com%7Cc0875a82b80b4adbe85b08d52fe7fcef%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636467595842031971&sdata=omVFnV%2BIjJaYJ5zx%2BuSSjIQOHtynMuod6zFSuMB%2FpjY%3D&reserved=0"
>> SUPPORT_URL="https://emea01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.debian.org%2Fsupport&data=02%7C01%7Cmarkb%40mellanox.com%7Cc0875a82b80b4adbe85b08d52fe7fcef%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636467595842031971&sdata=MUkGR8tCG8qrVC4TIvsoBZvSVFg4CSJF89e9u1s7WI8%3D&reserved=0"
>> BUG_REPORT_URL="https://emea01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugs.debian.org%2F&data=02%7C01%7Cmarkb%40mellanox.com%7Cc0875a82b80b4adbe85b08d52fe7fcef%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636467595842031971&sdata=xOtp4QasDS5BZFwl%2BqyebXZ9w6cgpP4B5bM7PsAuOG0%3D&reserved=0"
>>
>> Linux kernel:
>> —————————
>> $ uname -r
>>
>> 4.14.0-rc7-amd64
>>
>> NIC driver:
>> —————————
>> $ ethtool -i ens6f0
>>
>> driver: mlx5_core
>> version: 5.0-0
>> firmware-version: 12.21.1000 (MT_2130110027)
>> expansion-rom-version:
>> bus-info: 0000:81:00.0
>> supports-statistics: yes
>> supports-test: yes
>> supports-eeprom-access: no
>> supports-register-dump: no
>> supports-priv-flags: yes
>>
>> Best,
>>
>> Junxue
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" 
>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo 
>> info at  https://emea01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fvger.kernel.org%2Fmajordomo-info.html&data=02%7C01%7Cmarkb%40mellanox.com%7Cc0875a82b80b4adbe85b08d52fe7fcef%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636467595842031971&sdata=2IO9bkNKf8jDtMB5E2n%2FiAPS55oS7g%2BeTWsi%2F8IHadQ%3D&reserved=0
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��ٚ�{ay�
ʇڙ�,j��f���h���z�
�w���
���j:+v���w�j�m��������zZ+�����ݢj"��!�i
> 

Mark.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
