From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: srp-ha backport
Date: Wed, 5 Dec 2012 22:10:42 +0400
Message-ID: <CACaajQsRWCVXkjsHSBMmyEbTW4tN-O1YH1eQB61UC1DX1QumSg@mail.gmail.com>
References: <5054492E.1090403@acm.org> <loom.20121120T050107-224@post.gmane.org>
 <50AB84C1.5090105@acm.org> <CACaajQtEu_z+GEUBuiDz6D1dHYsb-YSFMJfkWeya1FNvfhbQHg@mail.gmail.com>
 <50ACE5B0.3060607@acm.org> <CACaajQsUR92Hg-nx_VQN1eHdnghDtsRv1xZJFaJKT=a4nWWf8Q@mail.gmail.com>
 <CACaajQswh5foLKTGMhbZnj5JRpFax7nhdHxL7c1wTwbpMe=b8A@mail.gmail.com>
 <50AD1EE6.6090206@acm.org> <CACaajQs3pPpB9Bz1OxRduk63+uu+ahBYYZsYv_VgroWCsr+vzQ@mail.gmail.com>
 <50ADD617.80500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50ADD617.80500-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm try to use stable 3.0.53 from kernel.org but have lock issues. If
i use you ib_srp-backport from github this does not solve problem. Now
(witout backported ib_srp) i have this dmesg output when multipath -ll
locks.
Is that possible to determine when the problem ?

[  729.936560] SysRq : Show Blocked State
[  729.936669]   task                        PC stack   pid father
[  729.936704] multipathd      D 0000000000000083     0  8152      1
0x00000000
[  729.936709]  ffff880115b97a68 0000000000000282 0000000100000000
ffff880115b979e8
[  729.936713]  ffff880115b96010 ffff880115b97a30 ffff880115b94400
ffff880115b94400
[  729.936718]  ffff880115b94400 ffff880115b97fd8 ffff880115b97fd8
ffff880115b94400
[  729.936722] Call Trace:
[  729.936760]  [<ffffffffa017b2ad>]
scsi_block_when_processing_errors+0xcd/0xf0 [scsi_mod]
[  729.936776]  [<ffffffffa04b7cf8>] sd_open+0xb8/0x1f0 [sd_mod]
[  729.936797]  [<ffffffff80160bb8>] __blkdev_get+0x388/0x460
[  729.936803]  [<ffffffff8016113a>] blkdev_get+0x5a/0x1f0
[  729.936808]  [<ffffffff80161303>] blkdev_get_by_dev+0x33/0x70
[  729.936819]  [<ffffffffa00ffe43>] open_dev+0x33/0xb0 [dm_mod]
[  729.936835]  [<ffffffffa01000f1>] __table_get_device+0x231/0x2c0
[dm_mod]
[  729.936849]  [<ffffffffa03719d7>] parse_path+0xe7/0x380
[dm_multipath]
[  729.936859]  [<ffffffffa0371de1>] parse_priority_group+0x171/0x220
[dm_multipath]
[  729.936868]  [<ffffffffa03720c2>] multipath_ctr+0x232/0x32c
[dm_multipath]
[  729.936879]  [<ffffffffa0100a63>] dm_table_add_target+0x193/0x260
[dm_mod]
[  729.936895]  [<ffffffffa0102cb9>] table_load+0xc9/0x2c0 [dm_mod]
[  729.936914]  [<ffffffffa0103f8d>] ctl_ioctl+0x1ed/0x270 [dm_mod]
[  729.936934]  [<ffffffffa010401e>] dm_ctl_ioctl+0xe/0x20 [dm_mod]
[  729.936950]  [<ffffffff8013b613>] do_vfs_ioctl+0x93/0x3f0
[  729.936955]  [<ffffffff8013ba11>] sys_ioctl+0xa1/0xb0
[  729.936962]  [<ffffffff80402233>] system_call_fastpath+0x16/0x1b
[  729.936970]  [<00007f73a8679fa7>] 0x7f73a8679fa6
[  729.936981] scsi_eh_2       D 0000000000000000     0 30416      2
0x00000000
[  729.936985]  ffff880120ff3b70 0000000000000246 0000000000000026
ffff880120ff3af0
[  729.936989]  ffff880120ff2010 ffff880120ff3b38 ffff88011f616480
ffff88011f616480
[  729.936993]  ffff88011f616480 ffff880120ff3fd8 ffff880120ff3fd8
ffff88011f616480
[  729.936997] Call Trace:
[  729.937004]  [<ffffffff803f804d>] schedule_timeout+0x21d/0x2c0
[  729.937010]  [<ffffffff803f6f35>] wait_for_common+0xe5/0x210
[  729.937018]  [<ffffffffa037b75c>] srp_disconnect_target+0x18c/0x210
[ib_srp]
[  729.937029]  [<ffffffffa037cbe0>] srp_reconnect_target+0x110/0x3a0
[ib_srp]
[  729.937042]  [<ffffffffa037cea9>] srp_reset_host+0x39/0x50 [ib_srp]
[  729.937059]  [<ffffffffa017898d>] scsi_try_host_reset+0x4d/0x120
[scsi_mod]
[  729.937077]  [<ffffffffa017a604>] scsi_eh_host_reset+0x44/0x170
[scsi_mod]
[  729.937096]  [<ffffffffa017ab81>] scsi_eh_ready_devs+0x91/0x130
[scsi_mod]
[  729.937115]  [<ffffffffa017aefd>] scsi_unjam_host+0xfd/0x200
[scsi_mod]
[  729.937134]  [<ffffffffa017b188>] scsi_error_handler+0x188/0x1e0
[scsi_mod]
[  729.937147]  [<ffffffff80067ae6>] kthread+0x96/0xa0
[  729.937153]  [<ffffffff80402bd4>] kernel_thread_helper+0x4/0x10
[  729.937156] scsi_eh_3       D 0000000000000000     0 30421      2
0x00000000
[  729.937161]  ffff88010d0d3b70 0000000000000246 0000000000000000
ffff88010d0d3af0
[  729.937165]  ffff88010d0d2010 ffff88010d0d3b38 ffff88011166a180
ffff88011166a180

[  729.937169]  ffff88011166a180 ffff88010d0d3fd8 ffff88010d0d3fd8
ffff88011166a180
[  729.937173] Call Trace:
[  729.937178]  [<ffffffff803f804d>] schedule_timeout+0x21d/0x2c0
[  729.937183]  [<ffffffff803f6f35>] wait_for_common+0xe5/0x210
[  729.937190]  [<ffffffffa037b75c>] srp_disconnect_target+0x18c/0x210 =
[ib_srp]
[  729.937201]  [<ffffffffa037cbe0>] srp_reconnect_target+0x110/0x3a0 [=
ib_srp]
[  729.937213]  [<ffffffffa037cea9>] srp_reset_host+0x39/0x50 [ib_srp]
[  729.937230]  [<ffffffffa017898d>] scsi_try_host_reset+0x4d/0x120 [sc=
si_mod]
[  729.937248]  [<ffffffffa017a604>] scsi_eh_host_reset+0x44/0x170 [scs=
i_mod]
[  729.937267]  [<ffffffffa017ab81>] scsi_eh_ready_devs+0x91/0x130 [scs=
i_mod]
[  729.937286]  [<ffffffffa017aefd>] scsi_unjam_host+0xfd/0x200 [scsi_m=
od]
[  729.937306]  [<ffffffffa017b188>] scsi_error_handler+0x188/0x1e0 [sc=
si_mod]
[  729.937317]  [<ffffffff80067ae6>] kthread+0x96/0xa0
[  729.937322]  [<ffffffff80402bd4>] kernel_thread_helper+0x4/0x10
[  729.937333] multipath       D 0000000000000001     0  5230   5056 0x=
00000004
[  729.937337]  ffff880128467c18 0000000000000246 0000000000000001
ffff880128467b98
[  729.937341]  ffff880128466010 ffff880128467be0 ffff8800a297a5c0
ffff8800a297a5c0
[  729.937345]  ffff8800a297a5c0 ffff880128467fd8 ffff880128467fd8
ffff8800a297a5c0
[  729.937349] Call Trace:
[  729.937354]  [<ffffffff803f7c1c>] io_schedule+0x9c/0xf0
[  729.937361]  [<ffffffff8016ff7f>] wait_for_all_aios+0xff/0x180
[  729.937366]  [<ffffffff80170396>] exit_aio+0x46/0xb0
[  729.937372]  [<ffffffff80042edd>] mmput+0x1d/0x100
[  729.937378]  [<ffffffff8004768c>] exit_mm+0x12c/0x170
[  729.937384]  [<ffffffff80048aca>] do_exit+0x18a/0x440
[  729.937389]  [<ffffffff8004911f>] do_group_exit+0x3f/0xe0
[  729.937395]  [<ffffffff8005b4f3>] get_signal_to_deliver+0x2a3/0x530
[  729.937403]  [<ffffffff80006d81>] do_signal+0x71/0x1b0
[  729.937408]  [<ffffffff80006f48>] do_notify_resume+0x88/0xa0
[  729.937413]  [<ffffffff804024c3>] int_signal+0x12/0x17
[  729.937421]  [<00007fb5b9e5e6a4>] 0x7fb5b9e5e6a3
[  729.937426] Sched Debug Version: v0.10, 3.0.53 #1



2012/11/22 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
> Hello Vasily,
>
> Replacing the kernel on the initiator system is sufficient. You don't=
 have
> to replace the kernel on the target system for this test. Regarding w=
hich
> InfiniBand stack to use at the initiator side in combination with ker=
nel
> 3.6: unless there is something I do not yet know about, it is fine to=
 use
> the InfiniBand stack included in that kernel and it is not necessary =
to
> install OFED for this test.
>
> Bart.
>
>
> On 11/21/12 20:52, Vasiliy Tolstov wrote:
>>
>> Does i need that on storage host side or on onitiator side? My stora=
ge
>> under debian squeeze with ofed from openfabrics.
>>
>> 21.11.2012 22:35 =D0=BF=D0=BE=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=
=82=D0=B5=D0=BB=D1=8C "Bart Van Assche" <bvanassche-HInyCGIudOg@public.gmane.org
>> <mailto:bvanassche-HInyCGIudOg@public.gmane.org>> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=
=BB:
>>
>>
>>     On 11/21/12 18:41, Vasiliy Tolstov wrote:
>>
>>         Another test has very bad results:
>>         initiator multipath -ll running than storage go to down neve=
r
>>         returns
>>         (deadlock), but other multipath -ll returns immediate with
>>         output (i'm
>>         reboot sas01)
>>
>>
>>     It could be helpful to have a look at the call stacks generated =
by
>>     "echo w >/proc/sysrq-trigger". If this output reveals that devic=
e
>>     removal triggers hanging I/O then that might indicate that one o=
r
>>     more SCSI device removal patches have not yet been backported to
>>     SLES 11 SP2. Have you already tried whether the same test succee=
ds
>>     with kernel 3.6.7 ? Several SCSI device removal fixes have been
>>     integrated in kernel 3.6.
>>
>>     Bart.
>>
>



--=20
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
