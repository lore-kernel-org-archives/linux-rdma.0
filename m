From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Tue, 20 Jun 2017 11:08:36 -0600
Message-ID: <CAANLjFrpHzapvqgBajUu7QpgNNPvNjThMZrsXGcKt58E+6siMA@mail.gmail.com>
References: <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me>
 <20170515143632.GH3616@mtr-leonro.local> <20170515145952.GA7871@infradead.org>
 <20170515170506.GK3616@mtr-leonro.local> <779753075.36035391.1495025796237.JavaMail.zimbra@kalray.eu>
 <20170518133439.GD3616@mtr-leonro.local> <CAANLjFrCLpX3nb3q7LpFPpLJKciU+1Hvmt_hxyTovQJM2-zQmg@mail.gmail.com>
 <6073e553-e8c2-6d14-ba5d-c2bd5aff15eb@grimberg.me> <20170620074639.GP17846@mtr-leonro.local>
 <1c706958-992e-b104-6bae-4a6616c0a9f9@grimberg.me> <20170620083309.GQ17846@mtr-leonro.local>
 <bd0b986f-9bed-3dfa-7454-0661559a527b@grimberg.me> <614481c7-22dd-d93b-e97e-52f868727ec3@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <614481c7-22dd-d93b-e97e-52f868727ec3-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 20, 2017 at 6:02 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>
>>>> Can you share the check that correlates to the vendor+hw syndrome?
>>>
>>>
>>> mkey.free == 1
>>
>>
>> Hmm, the way I understand it is that the HW is trying to access
>> (locally via send) a MR which was already invalidated.
>>
>> Thinking of this further, this can happen in a case where the target
>> already completed the transaction, sent SEND_WITH_INVALIDATE but the
>> original send ack was lost somewhere causing the device to retransmit
>> from the MR (which was already invalidated). This is highly unlikely
>> though.
>>
>> Shouldn't this be protected somehow by the device?
>> Can someone explain why the above cannot happen? Jason? Liran? Anyone?
>>
>> Say host register MR (a) and send (1) from that MR to a target,
>> send (1) ack got lost, and the target issues SEND_WITH_INVALIDATE
>> on MR (a) and the host HCA process it, then host HCA timeout on send (1)
>> so it retries, but ehh, its already invalidated.
>
>
> Well, this entire flow is broken, why should the host send the MR rkey
> to the target if it is not using it for remote access, the target
> should never have a chance to remote invalidate something it did not
> access.
>
> I think we have a bug in iSER code, as we should not send the key
> for remote invalidation if we do inline data send...
>
> Robert, can you try the following:
> --
> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c
> b/drivers/infiniband/ulp/iser/iser_initiator.c
> index 12ed62ce9ff7..2a07692007bd 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -137,8 +137,10 @@ iser_prepare_write_cmd(struct iscsi_task *task,
>
>         if (unsol_sz < edtl) {
>                 hdr->flags     |= ISER_WSV;
> -               hdr->write_stag = cpu_to_be32(mem_reg->rkey);
> -               hdr->write_va   = cpu_to_be64(mem_reg->sge.addr + unsol_sz);
> +               if (buf_out->data_len > imm_sz) {
> +                       hdr->write_stag = cpu_to_be32(mem_reg->rkey);
> +                       hdr->write_va = cpu_to_be64(mem_reg->sge.addr +
> unsol_sz);
> +               }
>
>                 iser_dbg("Cmd itt:%d, WRITE tags, RKEY:%#.4X "
>                          "VA:%#llX + unsol:%d\n",
> --
>
> Although, I still don't think its enough. We need to delay the
> local invalidate till we received a send completion (guarantees
> that ack was received)...
>
> If this indeed the case, _all_ ULP initiator drivers share it because we
> never condition on a send completion in order to complete an I/O, and
> in the case of lost ack on send, looks like we need to... It *will* hurt
> performance.
>
> What do other folks think?
>
> CC'ing Bart, Chuck, Christoph.
>
> Guys, for summary, I think we might have a broken behavior in the
> initiator mode drivers. We never condition send completions (for
> requests) before we complete an I/O. The issue is that the ack for those
> sends might get lost, which means that the HCA will retry them (dropped
> by the peer HCA) but if we happen to complete the I/O before, either we
> can unmap the request area, or for inline data, we invalidate it (so the
> HCA will try to access a MR which was invalidated).
>
> Signalling all send completions and also finishing I/Os only after we
> got them will add latency, and that sucks...

Testing this patch I didn't see these new messages even when rebooting
the targets multiple times. It also resolved some performance problems
I was seeing (I think our switches are having bugs with IPv6 and
routing) and I was receiving expected performance. At one point in the
test, one target (4.9.33) showed:
[Tue Jun 20 10:11:20 2017] iSCSI Login timeout on Network Portal [::]:3260
[Tue Jun 20 10:11:39 2017] iSCSI Login timeout on Network Portal [::]:3260
[Tue Jun 20 10:11:58 2017] isert: isert_print_wc: login send failure:
transport retry counter exceeded (12) vend_err 81

After this and a reboot of the target, the initiator would drop the
connection after 1.5-2 minutes then faster and faster until it was
every 5 seconds. It is almost like it set up the connection then lose
the first ping, or the ping wasn't set-up right. I tried rebooting the
target multiple times.

I tried to logout the "bad" session and got a back trace.

[Tue Jun 20 10:30:08 2017] ------------[ cut here ]------------
[Tue Jun 20 10:30:08 2017] WARNING: CPU: 20 PID: 783 at
fs/sysfs/group.c:237 sysfs_remove_group+0x82/0x90
[Tue Jun 20 10:30:08 2017] Modules linked in: ib_iser rdma_ucm ib_ucm
ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib mlx4_ib ib_core 8021q
garp mrp sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm iTCO_wdt iTCO_vendor_support mei_me irqbypass
crct10dif_pclmul mei crc32_pclmul ioatdma ghash_clmulni_intel lpc_ich
i2c_i801 pcbc mfd_core aesni_intel crypto_simd glue_helper cryptd
joydevsg pcspkr shpchp wmi ipmi_si ipmi_devintf ipmi_msghandler
acpi_power_meter ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 acpi_pad
nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter nfsd
auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c raid1
dm_service_time sd_mod mlx4_en be2iscsi bnx2i cnic uio qla4xxx
iscsi_boot_sysfs ast drm_kms_helper mlx5_core syscopyarea sysfillrect
sysimgblt fb_sys_fops ttm
[Tue Jun 20 10:30:08 2017]  drm mlx4_core igb ahci libahci ptp libata
pps_core dca i2c_algo_bit dm_multipath dm_mirror dm_region_hash dm_log
dm_mod dax
[Tue Jun 20 10:30:08 2017] CPU: 20 PID: 783 Comm: kworker/u64:2 Not
tainted 4.12.0-rc6+ #5
[Tue Jun 20 10:30:08 2017] Hardware name: Supermicro
SYS-6028TP-HTFR/X10DRT-PIBF, BIOS 1.1 08/03/2015
[Tue Jun 20 10:30:08 2017] Workqueue: scsi_wq_12 __iscsi_unbind_session
[Tue Jun 20 10:30:08 2017] task: ffff887f5c45cb00 task.stack: ffffc90032ef4000
[Tue Jun 20 10:30:08 2017] RIP: 0010:sysfs_remove_group+0x82/0x90
[Tue Jun 20 10:30:08 2017] RSP: 0018:ffffc90032ef7d18 EFLAGS: 00010246
[Tue Jun 20 10:30:08 2017] RAX: 0000000000000038 RBX: 0000000000000000
RCX: 0000000000000000
[Tue Jun 20 10:30:08 2017] RDX: 0000000000000000 RSI: ffff883f7fd0e068
RDI: ffff883f7fd0e068
[Tue Jun 20 10:30:08 2017] RBP: ffffc90032ef7d30 R08: 0000000000000000
R09: 0000000000000676
[Tue Jun 20 10:30:08 2017] R10: 00000000000003ff R11: 0000000000000001
R12: ffffffff81da8a40
[Tue Jun 20 10:30:08 2017] R13: ffff887f52ec0838 R14: ffff887f52ec08d8
R15: ffff883f4c611000
[Tue Jun 20 10:30:08 2017] FS:  0000000000000000(0000)
GS:ffff883f7fd00000(0000) knlGS:0000000000000000
[Tue Jun 20 10:30:08 2017] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Tue Jun 20 10:30:08 2017] CR2: 000055eef886b398 CR3: 0000000001c09000
CR4: 00000000001406e0
[Tue Jun 20 10:30:08 2017] Call Trace:
[Tue Jun 20 10:30:08 2017]  dpm_sysfs_remove+0x57/0x60
[Tue Jun 20 10:30:08 2017]  device_del+0x107/0x330
[Tue Jun 20 10:30:08 2017]  scsi_target_reap_ref_release+0x2d/0x40
[Tue Jun 20 10:30:08 2017]  scsi_target_reap+0x2e/0x40
[Tue Jun 20 10:30:08 2017]  scsi_remove_target+0x197/0x1b0
[Tue Jun 20 10:30:08 2017]  __iscsi_unbind_session+0xbe/0x170
[Tue Jun 20 10:30:08 2017]  process_one_work+0x149/0x360
[Tue Jun 20 10:30:08 2017]  worker_thread+0x4d/0x3c0
[Tue Jun 20 10:30:08 2017]  kthread+0x109/0x140
[Tue Jun 20 10:30:08 2017]  ? rescuer_thread+0x380/0x380
[Tue Jun 20 10:30:08 2017]  ? kthread_park+0x60/0x60
[Tue Jun 20 10:30:08 2017]  ret_from_fork+0x25/0x30
[Tue Jun 20 10:30:08 2017] Code: d5 c0 ff ff 5b 41 5c 41 5d 5d c3 48
89 df e8 66 bd ff ff eb c6 49 8b 55 00 49 8b 34 24 48 c7 c7 d0 3ca7 81
31 c0 e8 3c 01 ee ff <0f> ff eb d5 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00 00 55 48
[Tue Jun 20 10:30:08 2017] ---[ end trace 6161f21139b6a1ea ]---

Logging back into that target didn't help stabilize the connection. I
rebooted both initiator and targets to clear things up and after the
initiator went down, the target showed the timeout message again. It
seems something got out of whack and never recovered and "poisoned"
the other node in the process.

I'll test Max's patch now and report back.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
