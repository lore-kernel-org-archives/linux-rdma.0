From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 8/8] IB/hfi1: Do not warn on lid conversions for
 OPA
Date: Tue, 3 Oct 2017 09:25:54 +0300
Message-ID: <20171003062554.GC13648@mtr-leonro.local>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <20171002180453.31117.53379.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1SQmhf2mF2YjsYvc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171002180453.31117.53379.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 02, 2017 at 11:04:55AM -0700, Dennis Dalessandro wrote:
> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> On OPA devices opa_local_smp_check will receive 32Bit LIDs when the LID
> is Extended. In such cases, it is okay to lose the upper 16 bits of the
> LID as this information is obtained elsewhere. Do not issue a warning
> when calling ib_lid_cpu16() in this case by masking out the upper 16Bits.
>
> [75920.148985] ------------[ cut here ]------------
> [75920.154651] WARNING: CPU: 0 PID: 1718 at ./include/rdma/ib_verbs.h:3788 hfi1_process_mad+0x1c1f/0x1c80 [hfi1]
> [75920.166192] Modules linked in: ib_ipoib hfi1(E) rdmavt(E) rdma_ucm(E) ib_ucm(E) rdma_cm(E) ib_cm(E) iw_cm(E) ib_umad(E) ib_uverbs(E) ib_core(E) libiscsi scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_mod dax x86_pkg_temp_thermal intel_powerclamp coretemp kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel mei_me ipmi_si iTCO_wdt iTCO_vendor_support crypto_simd ipmi_devintf pcspkr mei sg i2c_i801 glue_helper lpc_ich shpchp ioatdma mfd_core wmi ipmi_msghandler cryptd acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm igb ptp ahci libahci pps_core crc32c_intel libata dca i2c_algo_bit i2c_core [last unloaded: ib_core]
> [75920.246331] CPU: 0 PID: 1718 Comm: kworker/0:1H Tainted: G        W I E   4.13.0-rc7+ #1
> [75920.255907] Hardware name: Intel Corporation S2600WT2/S2600WT2, BIOS SE5C610.86B.01.01.0008.021120151325 02/11/2015
> [75920.268158] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> [75920.274934] task: ffff88084a718000 task.stack: ffffc9000a424000
> [75920.282123] RIP: 0010:hfi1_process_mad+0x1c1f/0x1c80 [hfi1]
> [75920.288881] RSP: 0018:ffffc9000a427c38 EFLAGS: 00010206
> [75920.295265] RAX: 0000000000010001 RBX: ffff8808361420e8 RCX: ffff880837811d80
> [75920.303784] RDX: 0000000000000002 RSI: 0000000000007fff RDI: ffff880837811d80
> [75920.312302] RBP: ffffc9000a427d38 R08: 0000000000000000 R09: ffff8808361420e8
> [75920.320819] R10: ffff88083841f0e8 R11: ffffc9000a427da8 R12: 0000000000000001
> [75920.329335] R13: ffff880837810000 R14: 0000000000000000 R15: ffff88084f1a4800
> [75920.337849] FS:  0000000000000000(0000) GS:ffff88085f400000(0000) knlGS:0000000000000000
> [75920.347450] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [75920.354405] CR2: 00007f9e4b3d9000 CR3: 0000000001c09000 CR4: 00000000001406f0
> [75920.362947] Call Trace:
> [75920.366257]  ? ib_mad_recv_done+0x258/0x9b0 [ib_core]
> [75920.372457]  ? ib_mad_recv_done+0x258/0x9b0 [ib_core]
> [75920.378652]  ? __kmalloc+0x1df/0x210
> [75920.383229]  ib_mad_recv_done+0x305/0x9b0 [ib_core]
> [75920.389270]  __ib_process_cq+0x5d/0xb0 [ib_core]
> [75920.395032]  ib_cq_poll_work+0x20/0x60 [ib_core]
> [75920.400777]  process_one_work+0x149/0x360
> [75920.405836]  worker_thread+0x4d/0x3c0
> [75920.410505]  kthread+0x109/0x140
> [75920.414681]  ? rescuer_thread+0x380/0x380
> [75920.419731]  ? kthread_park+0x60/0x60
> [75920.424406]  ret_from_fork+0x25/0x30
> [75920.428972] Code: 4c 89 9d 58 ff ff ff 49 89 45 00 66 b8 00 02 49 89 45 08 e8 44 27 89 e0 4c 8b 9d 58 ff ff ff e9 d8 f6 ff ff 0f ff e9 55 e7 ff ff <0f> ff e9 3b e5 ff ff 0f ff 0f 1f 84 00 00 00 00 00 e9 4b e9 ff
> [75921.451269] ---[ end trace cf26df27c9597265 ]---
>
> Fixes: 62ede7779904 ("Add OPA extended LID support")
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/mad.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--1SQmhf2mF2YjsYvc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnTLXIACgkQ5GN7iDZy
WKcZmA/+NhYIAXltgeXP0IX2zQWKDUiIM9MtfIswBPpvP3UXmk0oMf/WFEJIYnWy
GX5pKMwK3NMuauSctS+TQIzNMi+DELhpWZ8fT5xvsP4rIh06COv06Tj4pp7Wvspr
Wqh5Iin+lVJE5yG5aXOCmGdFnpg3ztrJcQEP2QJ58i5dtQPnRdXURJLZp9edSdq7
CbAVkbci6F9vlGM1AU1euXbxNaaVEsBlit1R6YfS3OqB0tnaz+OLmdiqJmVz3jWi
hi/1bNMTrPsUr0v2fkpI+LA52e3BlN1EqssCSd6VSB6jHD8L//bGlELsbdVWIiRZ
EPBrs5+DxzE38X8dJ08wQ6CvSyfBE9pzCboJ4gx78gAz+In4+TPoyBFU/KXXbr0u
tmUs6iT/gVHt2hYKnuDSVCmoFa2qYvLEQHjDkN9sZlqAOXkhZfCOUOwB45fyYYV9
72ScapwKWFW6uZ5WqOkkvHnd30zViVSuLKCtClTgohjvzTuvmcZ3GCZbJERujEj8
2kVYEGIucvuG7IJuA+qsP1JRBerJVgEuBWsaO1o+o35XfvHkNsftB+mJFXBIUICF
eXfpQ8CHBTAyb08mTzzLyaDgewxXie5hJY9o/g5EW9I0/vwJsPtszjTCLSGkCPp5
VU54+C5wg7HA3znapN7qqRz9D1dzHROKP8TMfICILzwPdUTigkU=
=uU8Q
-----END PGP SIGNATURE-----

--1SQmhf2mF2YjsYvc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
