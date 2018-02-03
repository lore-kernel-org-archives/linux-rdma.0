From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: Working NVMeoF Config From 4.12.5 Fails With 4.15.0
Date: Sat, 3 Feb 2018 00:55:19 +0000
Message-ID: <HE1PR0502MB3004A319E5CBF9FC43806136D1F80@HE1PR0502MB3004.eurprd05.prod.outlook.com>
References: <DE927C68B458BE418D582EC97927A9287FE2088B@ORSMSX113.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DE927C68B458BE418D582EC97927A9287FE2088B-8oqHQFITsIFQxe9IK+vIArfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Gruher, Joseph R
> Sent: Friday, February 02, 2018 5:36 PM
> To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Working NVMeoF Config From 4.12.5 Fails With 4.15.0
>=20
> (Apologies to the RDMA mailing list if you get this twice - I screwed up =
the NVMe
> mailing list address on the first send.  Sorry!)
>=20
> Hi folks-
>=20
> I recently upgraded my Ubuntu 16.10 kernel from 4.12.5 to 4.15.0 to try o=
ut the
> newer kernel.  I have a previous working NVMeoF initiator/target pair whe=
re I
> didn't change any of the configuration, but it no longer works with 4.15.=
0, for
> connects using certain numbers of IO queues.  The nvmetcli version is 0.5=
.  I'll
> include the target JSON at the bottom of this email.
>=20
> Target setup seems happy:
>=20
> rsa@purley02:~$ uname -a
> Linux purley02 4.15.0-041500-generic #201802011154 SMP Thu Feb 1 11:55:45
> UTC 2018 x86_64 x86_64 x86_64 GNU/Linux rsa@purley02:~$ sudo nvmetcli
> clear rsa@purley02:~$ sudo nvmetcli restore joe.json rsa@purley02:~$
> dmesg|tail -n 2 [  159.170896] nvmet: adding nsid 1 to subsystem NQN [
> 159.171682] nvmet_rdma: enabling port 1 (10.6.0.12:4420)
>=20
> Initiator can do discovery:
>=20
> rsa@purley06:~$ sudo nvme --version
> nvme version 1.4
> rsa@purley06:~$ uname -a
> Linux purley06 4.15.0-041500-generic #201802011154 SMP Thu Feb 1 11:55:45
> UTC 2018 x86_64 x86_64 x86_64 GNU/Linux rsa@purley06:~$ sudo nvme
> discover -t rdma -a 10.6.0.12 Discovery Log Number of Records 1, Generati=
on
> counter 1 =3D=3D=3D=3D=3DDiscovery Log Entry 0=3D=3D=3D=3D=3D=3D
> trtype:  rdma
> adrfam:  ipv4
> subtype: nvme subsystem
> treq:    not specified
> portid:  1
> trsvcid: 4420
> subnqn:  NQN
> traddr:  10.6.0.12
> rdma_prtype: not specified
> rdma_qptype: connected
> rdma_cms:    rdma-cm
> rdma_pkey: 0x0000
> rsa@purley06:~$ dmesg|tail -n 1
> [  226.161612] nvme nvme1: new ctrl: NQN "nqn.2014-
> 08.org.nvmexpress.discovery", addr 10.6.0.12:4420
>=20
> However initiator fails to connect:
>=20
> rsa@purley06:~$ sudo nvme connect -t rdma -a 10.6.0.12 -n NQN -i 16
>=20
> With a dump into dmesg:
>=20
> [  332.445577] nvme nvme1: creating 16 I/O queues.
> [  332.778085] nvme nvme1: Connect command failed, error wo/DNR bit: -
> 16402 [  332.791475] nvme nvme1: failed to connect queue: 4 ret=3D-18 [
> 334.342771] nvme nvme1: Reconnecting in 10 seconds...
> [  344.418493] general protection fault: 0000 [#1] SMP PTI [  344.428922]
> Modules linked in: ipmi_ssif nls_iso8859_1 intel_rapl skx_edac
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel aes_x8=
6_64
> crypto_simd glue_helper cryptd input_leds joydev intel_cstate intel_rapl_=
perf
> lpc_ich mei_me shpchp mei ioatdma ipmi_si ipmi_devintf ipmi_msghandler
> acpi_power_meter acpi_pad mac_hid nvmet_rdma nvmet nvme_rdma
> nvme_fabrics rdmavt rdma_ucm rdma_cm iw_cm ib_cm ib_uverbs mlx5_ib
> ib_core ip_tables x_tables autofs4 ast ttm hid_generic drm_kms_helper
> mlx5_core igb syscopyarea mlxfw usbhid sysfillrect dca devlink hid sysimg=
blt
> fb_sys_fops ptp ahci pps_core drm i2c_algo_bit libahci wmi uas usb_storag=
e [
> 344.555058] CPU: 2 PID: 450 Comm: kworker/u305:6 Not tainted 4.15.0-
> 041500-generic #201802011154 [  344.572597] Hardware name: Quanta Cloud
> Technology Inc. 2U4N system 20F08Axxxx/Single side, BIOS F08A2A12
> 10/02/2017 [  344.593590] Workqueue: nvme-wq
> nvme_rdma_reconnect_ctrl_work [nvme_rdma] [  344.606969] RIP:
> 0010:nvme_rdma_alloc_queue+0x3c/0x190 [nvme_rdma] [  344.619294] RSP:
> 0018:ffffb660c4fbbe08 EFLAGS: 00010202 [  344.629712] RAX:
> 0000000000000000 RBX: 498c0dc3fa1db134 RCX: ffff8f1d6e817c20 [
> 344.643940] RDX: ffffffffc068b600 RSI: ffffffffc068a3ab RDI: ffff8f21656a=
e000 [
> 344.658173] RBP: ffffb660c4fbbe28 R08: 0000000000000032 R09:
> 0000000000000000 [  344.672403] R10: 0000000000000000 R11:
> 00000000003d0900 R12: ffff8f21656ae000 [  344.686633] R13:
> 0000000000000000 R14: 0000000000000020 R15: ffff8f1d6bfffd40 [
> 344.700865] FS:  0000000000000000(0000) GS:ffff8f1d6ee80000(0000)
> knlGS:0000000000000000 [  344.717002] CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033 [  344.728458] CR2: 00007ffe5169c880 CR3:
> 000000019f80a001 CR4: 00000000007606e0 [  344.742690] DR0:
> 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 [
> 344.756920] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400 [  344.771151] PKRU: 55555554 [  344.776539] Call Trace:
> [  344.781415]  nvme_rdma_configure_admin_queue+0x22/0x2d0 [nvme_rdma]
> [  344.793928]  nvme_rdma_reconnect_ctrl_work+0x27/0xd0 [nvme_rdma] [
> 344.805906]  process_one_work+0x1ef/0x410 [  344.813912]
> worker_thread+0x32/0x410 [  344.821212]  kthread+0x121/0x140 [
> 344.827657]  ? process_one_work+0x410/0x410 [  344.835995]  ?
> kthread_create_worker_on_cpu+0x70/0x70
> [  344.846069]  ret_from_fork+0x35/0x40
> [  344.853208] Code: 89 e5 41 56 41 55 41 54 53 48 8d 1c c5 00 00 00 00 4=
9 89 fc
> 49 89 c5 49 89 d6 48 29 c3 48 c7 c2 00 b6 68 c0 48 c1 e3 04 48 03 1f <48>=
 89 7b
> 18 48 8d 7b 58 c7 43 50 00 00 00 00 e8 f0 78 44 c2 45 [  344.890872] RIP:
> nvme_rdma_alloc_queue+0x3c/0x190 [nvme_rdma] RSP: ffffb660c4fbbe08 [
> 344.906154] ---[ end trace 457e71ef6c0b301e ]---
>=20
> I discovered with fewer IO queues connect actually works:
>=20
> rsa@purley06:~$ sudo nvme connect -t rdma -a 10.6.0.12 -n NQN -i 8
> rsa@purley06:~$ dmesg|tail -n 2 [  433.432200] nvme nvme1: creating 8 I/O
> queues.
> [  433.613525] nvme nvme1: new ctrl: NQN "NQN", addr 10.6.0.12:4420
>=20
> But both servers have 40 cores, and previously I could use '-i 16' withou=
t any
> issues, so not sure why it is a problem now.  I would also note if I just=
 don't
> specify the -i on the connect command line it appears to default to a val=
ue of 40
> (one per core I suppose?) which fails in the same manner as -i 16.
>=20
> I did a quick re-test with the 1.5 nvme-cli release as well and that also=
 didn't
> offer any improvement:
>=20
I didn't read much email details.
However there was a mention and git bisect done by Logan Gunthorpe in recen=
t email in [1].
Where he mentioned possible commit that introduced the regression.
05e0cc84e00c net/mlx5: Fix get vector affinity helper function

[1] https://www.spinics.net/lists/linux-rdma/msg60298.html

You might want to try to revert that commit and attempt.
Might be same issue. Might be different, not sure.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
