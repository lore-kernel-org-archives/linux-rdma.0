From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: sg_map failures when tuning SRP via ib_srp module parameters
 for maximum SG entries
Date: Sun, 13 Mar 2016 18:15:07 -0400 (EDT)
Message-ID: <1558140769.21644120.1457907307800.JavaMail.zimbra@redhat.com>
References: <1195068688.21605141.1457794577569.JavaMail.zimbra@redhat.com> <56E4B677.6020809@sandisk.com> <2043305499.21615736.1457830705865.JavaMail.zimbra@redhat.com> <56E4C25E.7050000@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E4C25E.7050000-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Hartsock <hartsjc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart, Doug

You can add probably add a tested by for me for 
http://thread.gmane.org/gmane.linux.drivers.rdma/33715
I will email a response to that original thread.

Its settled and stabilized my array in that I only get the queue fulls now, which I think is going to 
be a client side overcommitment issue.

Testing logs

Array side
-----------
[root@localhost ~]# cat /etc/modprobe.d/ib_srp.conf 
options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048

[root@localhost ~]# cat /etc/modprobe.d/ib_srpt.conf 
options ib_srpt srp_max_req_size=4148

Then I tuned these

Default is 4096

[root@localhost sys]# cat ./kernel/config/target/srpt/0xfe800000000000007cfe900300726e4e/tpgt_1/attrib/srp_sq_size
4096

Set it to 16384

[root@localhost sys]# echo 16384 > ./kernel/config/target/srpt/0xfe800000000000007cfe900300726e4e/tpgt_1/attrib/srp_sq_size
[root@localhost sys]# echo 16384 > ./kernel/config/target/srpt/0xfe800000000000007cfe900300726e4f/tpgt_1/attrib/srp_sq_size

Fedora 23 (Server Edition)
Kernel 4.5.0-rc7+ on an x86_64 (ttyS1)

..
Many of these, likely way too many queued requests from the client.
..
..

[ 1814.417508] ib_srpt IB send queue full (needed 131)
[ 1814.442723] ib_srpt srpt_xfer_data[2478] queue full -- ret=-12
[ 1814.474973] ib_srpt IB send queue full (needed 131)
[ 1814.477444] ib_srpt IB send queue full (needed 1)
[ 1814.477446] ib_srpt sending cmd response failed for tag 17
[ 1814.477925] ib_srpt IB send queue full (needed 144)
[ 1814.477926] ib_srpt srpt_xfer_data[2478] queue full -- ret=-12
[ 1814.478237] ib_srpt IB send queue full (needed 160)
[ 1814.478237] ib_srpt srpt_xfer_data[2478] queue full -- ret=-12
[ 1814.478559] ib_srpt IB send queue full (needed 184)
[ 1814.478560] ib_srpt srpt_xfer_data[2478] queue full -- ret=-12
[ 1814.478871] ib_srpt IB send queue full (needed 157)
..
..
.. After the aborts this is expected to see the TMR
..
[ 1818.051125] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 111
[ 1823.595409] ABORT_TASK: Found referenced srpt task_tag: 88
[ 1823.623385] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 88
[ 1824.475646] ABORT_TASK: Found referenced srpt task_tag: 0
[ 1824.505863] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 0
[ 1824.543904] ABORT_TASK: Found referenced srpt task_tag: 58
[ 1824.573565] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 58
[ 1824.634873] ABORT_TASK: Found referenced srpt task_tag: 55

On the client
--------------
localhost login: [  593.363357] scsi host4: SRP abort called
[  599.261519] scsi host4: SRP abort called
[  599.290285] scsi host4: SRP abort called
..
..
[  625.847278] scsi host4: SRP abort called
[  626.246293] scsi host4: SRP abort called
[  722.672833] INFO: task systemd-udevd:3843 blocked for more than 120 seconds.
[  722.710870] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  722.754207] systemd-udevd   D ffff8811df412720     0  3843    802 0x00000080
[  722.794078]  ffff880086c1bb20 0000000000000086 ffff8823bcc6ae00 ffff880086c1bfd8
[  722.836676]  ffff880086c1bfd8 ffff880086c1bfd8 ffff8823bcc6ae00 ffff8811df412718
[  722.879162]  ffff8811df41271c ffff8823bcc6ae00 00000000ffffffff ffff8811df412720
[  722.921464] Call Trace:
[  722.935067]  [<ffffffff8163baa9>] schedule_preempt_disabled+0x29/0x70
[  722.972515]  [<ffffffff816397a5>] __mutex_lock_slowpath+0xc5/0x1c0
[  723.008003]  [<ffffffff81638c0f>] mutex_lock+0x1f/0x2f
[  723.037253]  [<ffffffff8121a3c6>] __blkdev_get+0x76/0x4d0
[  723.068997]  [<ffffffff8121a9f5>] blkdev_get+0x1d5/0x360
[  723.098180]  [<ffffffff8121ac2b>] blkdev_open+0x5b/0x80
[  723.127296]  [<ffffffff811dc0b7>] do_dentry_open+0x1a7/0x2e0
[  723.159133]  [<ffffffff8121abd0>] ? blkdev_get_by_dev+0x50/0x50
[  723.192497]  [<ffffffff811dc2e9>] vfs_open+0x39/0x70
[  723.220155]  [<ffffffff811eb8dd>] do_last+0x1ed/0x1270
[  723.248745]  [<ffffffff811c11be>] ? kmem_cache_alloc_trace+0x1ce/0x1f0
[  723.284548]  [<ffffffff811ee642>] path_openat+0xc2/0x490
[  723.314101]  [<ffffffff811efe0b>] do_filp_open+0x4b/0xb0
[  723.343628]  [<ffffffff811fc9a7>] ? __alloc_fd+0xa7/0x130
[  723.372032]  [<ffffffff811dd7b3>] do_sys_open+0xf3/0x1f0
[  723.402086]  [<ffffffff811dd8ce>] SyS_open+0x1e/0x20
[  723.430490]  [<ffffffff81645a49>] system_call_fastpath+0x16/0x1b
[  760.532038] scsi host4: ib_srp: failed receive status 5 for iu ffff8823bee8d680
[  760.536192] scsi host4: ib_srp: FAST_REG_MR failed status 5
[  770.772150] scsi host4: ib_srp: reconnect succeeded

[  836.572018] scsi host4: SRP abort called
[  842.125673] scsi host4: SRP abort called
[  843.005018] scsi host4: SRP abort called
[  843.070957] scsi host4: SRP abort called
[  843.159205] scsi host4: SRP abort called
[  843.369763] INFO: task systemd-udevd:3846 blocked for more than 120 seconds.
[  843.406044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  843.450570] systemd-udevd   D ffff8811df4113a0     0  3846    802 0x00000080
[  843.490878]  ffff880b4ce3bb20 0000000000000086 ffff8811c03e5080 ffff880b4ce3bfd8
[  843.533065]  ffff880b4ce3bfd8 ffff880b4ce3bfd8 ffff8811c03e5080 ffff8811df411398
[  843.575303]  ffff8811df41139c ffff8811c03e5080 00000000ffffffff ffff8811df4113a0
[  843.616197] Call Trace:
[  843.629627]  [<ffffffff8163baa9>] schedule_preempt_disabled+0x29/0x70
[  843.663667]  [<ffffffff816397a5>] __mutex_lock_slowpath+0xc5/0x1c0
[  843.696872]  [<ffffffff81638c0f>] mutex_lock+0x1f/0x2f
[  843.725684]  [<ffffffff8121a3c6>] __blkdev_get+0x76/0x4d0
[  843.755051]  [<ffffffff8121a9f5>] blkdev_get+0x1d5/0x360
[  843.784317]  [<ffffffff8121ac2b>] blkdev_open+0x5b/0x80
[  843.813211]  [<ffffffff811dc0b7>] do_dentry_open+0x1a7/0x2e0
[  843.845213]  [<ffffffff8121abd0>] ? blkdev_get_by_dev+0x50/0x50
[  843.878693]  [<ffffffff811dc2e9>] vfs_open+0x39/0x70
[  843.906081]  [<ffffffff811eb8dd>] do_last+0x1ed/0x1270
[  843.935605]  [<ffffffff811c11be>] ? kmem_cache_alloc_trace+0x1ce/0x1f0
[  843.972008]  [<ffffffff811ee642>] path_openat+0xc2/0x490
[  844.000212] scsi host4: SRP abort called
[  844.024556]  [<ffffffff811efe0b>] do_filp_open+0x4b/0xb0
[  844.053528]  [<ffffffff811fc9a7>] ? __alloc_fd+0xa7/0x130
[  844.065679] scsi host4: SRP abort called
[  844.105880]  [<ffffffff811dd7b3>] do_sys_open+0xf3/0x1f0
[  844.135357]  [<ffffffff811dd8ce>] SyS_open+0x1e/0x20
[  844.135403] scsi host4: SRP abort called
[  844.183447]  [<ffffffff81645a49>] system_call_fastpath+0x16/0x1b
[  844.202725] scsi host4: SRP abort called
[  844.999434] scsi host4: SRP abort called
[  845.085156] scsi host4: SRP abort called

Going to retest client with upstream now.

Thanks

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "James Hartsock" <hartsjc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sent: Saturday, March 12, 2016 8:29:02 PM
Subject: Re: sg_map failures when tuning SRP via ib_srp module parameters for maximum SG entries

On 03/12/16 16:58, Laurence Oberman wrote:
> Within srpt on the array I have options ib_srpt srp_max_req_size=4148
> On the client I also only have options ib_srpt srp_max_req_size=4148
>
> I have not tuned srp_sq_size as I was only aware of
>
> parm:           srp_max_req_size:Maximum size of SRP request messages in bytes. (int)
> parm:           srpt_srq_size:Shared receive queue (SRQ) size. (int)
> parm:           srpt_service_guid:Using this value for ioc_guid, id_ext, and cm_listen_id instead of using the node_guid of the first HCA.
>
> Please explain what that does.

Hello Laurence,

The srp_sq_size parameter controls the send queue size per RDMA channel. 
The default value of this parameter is 4096. I think this is the 
parameter that has to be increased to avoid hitting "IB send queue full" 
errors.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
