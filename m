From: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 11/20] ib_srp: Make srp_disconnect_target() wait for IB
 completions
Date: Fri, 24 Aug 2012 12:42:37 +0200
Message-ID: <20120824104237.GB4227@gmail.com>
References: <5023DA39.7020000@acm.org>
 <5023DCFF.4020709@acm.org>
 <5036536B.1000003@profitbricks.com>
 <50365DC3.1050807@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50365DC3.1050807-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

I'll try to explain, as Sebastian is on vacation.

On 23.08.2012 16:43, Bart Van Assche wrote:
> On 08/23/12 15:59, Sebastian Riemer wrote:
> > we've triggered the WARN_ON() in srp_wait_last_send_wqe() by connecting
> > to a disabled SCST SRP target.
> > 
> > I would remove that one.
> > 
> > [ ... ]
> >
> >> +	while (!target->last_send_wqe && time_before(jiffies, deadline)) {
> >> +		srp_send_completion(target->send_cq, target);
> >> +		msleep(20);
> >> +	}
> >> +
> >> +	WARN_ON(!target->last_send_wqe);
> > 
> > <-- here it is - remove it
> 
> But why was that WARN_ON() statement hit ? srp_wait_last_send_wqe() is
> invoked after the QP has been transitioned into the error state. It is
> the responsibility of the HCA to generate an error completion for any
> work queued on a QP that is in the error state. If that WARN_ON()
> statement has been hit that means that it took more than the RC timeout
> before the HCA finished processing earlier queued work and generated an
> error completion. That's not really something I had expected.

That occurs usually when releasing multiple targets at the same time.
A typical situation is unloading kernel module ib_srp.ko immediately,
which leads to tearing down every Infiniband connection.
But it doesn't occur always, which makes it hard for us to test.

Example of kernel trace:

WARNING: at drivers/infiniband/ulp/srp/ib_srp.c:529
srp_disconnect_target+0x317/0x320 [ib_srp]()
Hardware name: H8DGU
Modules linked in:
rdma_ucm rdma_cm iw_cm ib_addr ib_ipoib ib_uverbs ib_umad ib_srp
scsi_transport_srp scsi_tgt ib_cm ib_sa loop ib_mthca psmouse ib_mad
amd64_edac_mod edac_core i2c_piix4 evdev serio_raw edac_mce_amd
ib_core tpm_tis tpm tpm_bios processor button thermal_sys sg
hid_cherry sd_mod crc_t10dif usb_storage ahci libahci libata scsi_mod
[last unloaded: scsi_wait_scan]
Pid: 101, comm: kworker/1:1 Tainted: G W 3.2.8-pserver #1
Call Trace:
[<ffffffff81048dbb>] ? warn_slowpath_common+0x7b/0xc0
[<ffffffffa00a9b07>] ? srp_disconnect_target+0x317/0x320 [ib_srp]
[<ffffffff8106a640>] ? wake_up_bit+0x40/0x40
[<ffffffffa00ab0bf>] ? srp_remove_work+0x13f/0x1c0 [ib_srp]
[<ffffffffa00aaf80>] ? srp_free_req_data+0xd0/0xd0 [ib_srp]
[<ffffffff81063383>] ? process_one_work+0x113/0x470
[<ffffffff81065c73>] ? worker_thread+0x163/0x3e0
[<ffffffff81065b10>] ? manage_workers+0x200/0x200
[<ffffffff81065b10>] ? manage_workers+0x200/0x200
[<ffffffff8106a126>] ? kthread+0x96/0xa0
[<ffffffff8165f674>] ? kernel_thread_helper+0x4/0x10
[<ffffffff8106a090>] ? kthread_worker_fn+0x180/0x180
[<ffffffff8165f670>] ? gs_change+0x13/0x13

Regards,
Dongsu

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
