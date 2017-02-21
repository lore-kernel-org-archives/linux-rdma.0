From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iSER fails to release rdma resources (WRs) if iw_cxgb4 is
 unloaded while IO is in progress
Date: Tue, 21 Feb 2017 10:06:00 -0700
Message-ID: <CAANLjFqM=a7-9+nGK454a0Kp+iGS63b+EMavqKEhAyGp_nqkLw@mail.gmail.com>
References: <CY1PR12MB077405C1FA5279D200AD3089BC4D0@CY1PR12MB0774.namprd12.prod.outlook.com>
 <49223bb6-e2a1-eee7-cf4e-701957e6727f@mellanox.com> <CY1PR12MB07749731AC32F7BE065CC51DBC4C0@CY1PR12MB0774.namprd12.prod.outlook.com>
 <c0a53feb-8c15-54af-c443-fbc4f3d5ec0e@mellanox.com> <AM4PR0501MB27867EED1435EE19BDE2CEC7CB5E0@AM4PR0501MB2786.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR0501MB27867EED1435EE19BDE2CEC7CB5E0-dp/nxUn679hhbxXPg6FtWcDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Although not exactly similar, this patch does not help my isert D
state problem. The description sounds very much like what I'm seeing.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Mon, Feb 20, 2017 at 5:46 AM, Vladimir Neyelov
<vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Hi Raju,
> Try this patch that solve this problem, it checked with our tests.
> Thanks,
> Vladimir
>
>
> -----Original Message-----
> From: Max Gurtovoy
> Sent: Sunday, February 19, 2017 11:23 AM
> To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>; Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>; l=
inux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>; Potnuri Bharat Teja <bharat@=
chelsio.com>; Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: iSER fails to release rdma resources (WRs) if iw_cxgb4 is un=
loaded while IO is in progress
>
> Adding Vladimir that was debugging this issue.
>
> Sagi,
> there is a comment that was added in commit 3a940daf6fa1 "IB/iser:
> Protect tasks cleanup in case IB device was already released"
> that "DEVICE_REMOVAL event might have already released the device"
> but it is possible and this is the case now, that not all the tasks where=
 cleaned up. We actually destroy the low level structures but the upper lay=
er (iscsi) still has some tasks that should be cleaned.
> Also we need to think about the case of the absence of the iscsid and thi=
s makes the situation more difficult.
>
> Vladimir,
> please add your patch for Raju to check and let's start thinking of pushi=
ng this fix to main code.
>
> Max.
>
>
> On 2/2/2017 7:09 AM, Raju  Rangoju wrote:
>> Hi Max,
>>
>> I have tried the patch, but no luck. Issue is still seen.
>>
>> -Raju
>>
>> -----Original Message-----
>> From: Max Gurtovoy [mailto:maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
>> Sent: 01 February 2017 20:48
>> To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>; Sagi Grimberg
>> <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>; Potnuri Bharat Teja
>> <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
>> Subject: Re: iSER fails to release rdma resources (WRs) if iw_cxgb4 is
>> unloaded while IO is in progress
>>
>> hi Raju,
>> please apply the attached patch I want to push soon (still haven't find =
the chance to test it).
>> I'm not sure it will solve your problem but let's try it.
>>
>> thanks,
>> Max.
>>
>> On 2/1/2017 11:08 AM, Raju  Rangoju wrote:
>>>
>>> Hello Sagi,
>>>
>>> I intermittently see an issue with iser when unloading the iw_cxgb4 mod=
ule while traffic is running. Apparently the rdma resources are not getting=
 released when the iser receives RDMA_CM_EVENT_DEVICE_REMOVAL event while t=
he IO in progress. iser_cma_handler() upon receiving the DEVICE_REMOVAL eve=
nt, destroys the device by calling iser_cleanup_handler(). iser_free_ib_con=
n_res() destroys the qp and calls iser_free_fastreg_pool() to free the Memo=
ry Regions in the fastreg_pool list, and then it calls ib_dealloc_pd.
>>>
>>> Issue:
>>>
>>> iSCSI uses its .xmit_task and .cleanup_task callbacks to get/put MRs fr=
om iser fr_pool(fastreg_pool) during the normal IO, at this point if the DE=
VICE_REMOVAL event is received, iser_cma_handler()->iser_cleanup_handler() =
it simply releases the available MRs in the fr_pool list (some MRs may have=
 been moved to running task list) and eventually calls ib_dealloc_pd, which=
 ends up hitting kernel panic as some registered MRs are not freed up.
>>>
>>> iser_free_fastreg_pool() complains about the registered regions; "pool =
still has %d regions registered"
>>>
>>> Trace:
>>>
>>> iser: iser_free_fastreg_pool: pool still has 1 regions registered
>>> iser: iser_device_try_release: device ffff880508660080 refcount 0
>>> iw_cxgb4:c4iw_destroy_cq ib_cq ffff8803f3addc00
>>> iw_cxgb4:c4iw_wait_for_reply add wr_waitp ffffc9000dd83a28
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 7 PID: 14790 at drivers/infiniband/core/verbs.c:305
>>> ib_dealloc_pd+0x87/0xd0 [ib_core] Modules linked in: rdma_ucm ib_uverbs=
 iw_cxgb4(OE-) autofs4 target_core_iblock target_core_file target_core_pscs=
i target_core_mod bnx2fc fcoe libfcoe 8021q libfc garp stp llc scsi_transpo=
rt_fc cpufreq_ondemand be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libc=
xgbi iw_cxgb3 cxgb3 mdio libcxgb ib_iser rdma_cm ib_cm iw_cm ib_core config=
fs ipv6 crc_ccitt iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi uinp=
ut ppdev iTCO_wdt iTCO_vendor_support serio_raw pcspkr parport_pc parport t=
pm_infineon sg i2c_i801 i2c_core lpc_ich mfd_core e1000e acpi_cpufreq i7cor=
e_edac edac_core ioatdma dca ext4(E) mbcache(E) jbd2(E) sd_mod(E) pata_acpi=
(E) ata_generic(E) ata_piix(E) floppy(E) cxgb4(OE) ptp(E) pps_core(E) dm_mi=
rror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
>>> CPU: 7 PID: 14790 Comm: rmmod Tainted: G           OE   4.10.0-rc4+ #22
>>> Hardware name: Supermicro X8ST3/X8ST3, BIOS 2.0        07/29/10
>>> Call Trace:
>>> dump_stack+0x51/0x78
>>> __warn+0xfd/0x120
>>> warn_slowpath_null+0x1d/0x20
>>> ib_dealloc_pd+0x87/0xd0 [ib_core]
>>> ? ib_unregister_event_handler+0x6d/0x80 [ib_core] ?
>>> mutex_lock+0x16/0x40
>>> iser_device_try_release+0x81/0x120 [ib_iser] ?
>>> iser_free_rx_descriptors+0xd3/0xf0 [ib_iser]
>>> iser_free_ib_conn_res+0x75/0xb0 [ib_iser]
>>> iser_cleanup_handler+0x41/0x70 [ib_iser]
>>> iser_cma_handler+0x1c9/0x220 [ib_iser]
>>> cma_remove_id_dev+0x8f/0xa0 [rdma_cm]
>>> cma_process_remove+0x127/0x170 [rdma_cm] ? kobject_cleanup+0x82/0x1b0
>>> ? kobject_release+0xd/0x10
>>> cma_remove_one+0x6f/0x90 [rdma_cm]
>>> ib_unregister_device+0xe7/0x190 [ib_core]
>>> c4iw_unregister_device+0x79/0x90 [iw_cxgb4] c4iw_remove+0x45/0x6c
>>> [iw_cxgb4]
>>> c4iw_exit_module+0x31/0x75 [iw_cxgb4]
>>> SyS_delete_module+0x183/0x1d0
>>> ? syscall_trace_enter+0x154/0x1f0
>>> ? SyS_munmap+0x6e/0x90
>>> do_syscall_64+0x6c/0x160
>>> entry_SYSCALL64_slow_path+0x25/0x25
>>> RIP: 0033:0x37d22e8ee7
>>> RSP: 002b:00007ffedd1877b8 EFLAGS: 00000206 ORIG_RAX:
>>> 00000000000000b0
>>> RAX: ffffffffffffffda RBX: 00007ffedd1877c0 RCX: 00000037d22e8ee7
>>> RDX: 00007ffedd1877af RSI: 0000000000000880 RDI: 00007ffedd1877c0
>>> RBP: 00007ffedd187810 R08: 00007f0120b48700 R09: 0000000000000100
>>> R10: 0000000000000011 R11: 0000000000000206 R12: 0000000000000880
>>> R13: 00007ffedd188735 R14: 0000000000000000 R15: 0000000000000001
>>> ---[ end trace 9bdbdddd5759d7e6 ]---
>>>
>>>
>>> Steps to reproduce:
>>> 1. Bring up the iser target setup
>>> 2. Bring up the iser initiator setup
>>> 3. From DUT(initiator) login to all the Targets and start IOzone traffi=
c on all the mounted luns.
>>> 4. Now unload iw_cxgb4 module on the iser initiator setup.
>>>
>>>
>>> This is a generic issue, seen with other vendors also.
>>>
>>> Could you give me a few pointers on how to debug it further to address =
this issue?
>>> I am happy to provide any details further.
>>>
>>> Thank you for any help you can provide, -Raju
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
>>> info at  http://vger.kernel.org/majordomo-info.html
>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
