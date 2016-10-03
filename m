From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: correctly handle rdma_rw_init_mrs() failure
Date: Mon, 3 Oct 2016 10:44:18 -0400
Message-ID: <e9ed2f5c-bac8-b93c-0f7f-45e86e8c999d@redhat.com>
References: <20160929143217.F2C8DE0BD1@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qIF1u8fCUhlduenclcNdwNvNlE7MLNSSN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160929143217.F2C8DE0BD1-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qIF1u8fCUhlduenclcNdwNvNlE7MLNSSN
Content-Type: multipart/mixed; boundary="7HaFTVrk1Wgg99rGG4H2cQPq3sNRvKoAi";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
Message-ID: <e9ed2f5c-bac8-b93c-0f7f-45e86e8c999d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: correctly handle rdma_rw_init_mrs() failure
References: <20160929143217.F2C8DE0BD1-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
In-Reply-To: <20160929143217.F2C8DE0BD1-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>

--7HaFTVrk1Wgg99rGG4H2cQPq3sNRvKoAi
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/29/2016 10:31 AM, Steve Wise wrote:
> Function ib_create_qp() was failing to return an error when
> rdma_rw_init_mrs() fails, causing a crash further down in ib_create_qp(=
)
> when trying to dereferece the qp pointer which was actually a negative
> errno.
>=20
> The crash:
>=20
> crash> log|grep BUG
> [  136.458121] BUG: unable to handle kernel NULL pointer dereference at=
 0000000000000098
> crash> bt
> PID: 3736   TASK: ffff8808543215c0  CPU: 2   COMMAND: "kworker/u64:2"
>  #0 [ffff88084d323340] machine_kexec at ffffffff8105fbb0
>  #1 [ffff88084d3233b0] __crash_kexec at ffffffff81116758
>  #2 [ffff88084d323480] crash_kexec at ffffffff8111682d
>  #3 [ffff88084d3234b0] oops_end at ffffffff81032bd6
>  #4 [ffff88084d3234e0] no_context at ffffffff8106e431
>  #5 [ffff88084d323530] __bad_area_nosemaphore at ffffffff8106e610
>  #6 [ffff88084d323590] bad_area_nosemaphore at ffffffff8106e6f4
>  #7 [ffff88084d3235a0] __do_page_fault at ffffffff8106ebdc
>  #8 [ffff88084d323620] do_page_fault at ffffffff8106f057
>  #9 [ffff88084d323660] page_fault at ffffffff816e3148
>     [exception RIP: ib_create_qp+427]
>     RIP: ffffffffa02554fb  RSP: ffff88084d323718  RFLAGS: 00010246
>     RAX: 0000000000000004  RBX: fffffffffffffff4  RCX: 000000018020001f=

>     RDX: ffff880830997fc0  RSI: 0000000000000001  RDI: ffff88085f407200=

>     RBP: ffff88084d323778   R8: 0000000000000001   R9: ffffea0020bae210=

>     R10: ffffea0020bae218  R11: 0000000000000001  R12: ffff88084d3237c8=

>     R13: 00000000fffffff4  R14: ffff880859fa5000  R15: ffff88082eb89800=

>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> #10 [ffff88084d323780] rdma_create_qp at ffffffffa0782681 [rdma_cm]
> #11 [ffff88084d3237b0] nvmet_rdma_create_queue_ib at ffffffffa07c43f3 [=
nvmet_rdma]
> #12 [ffff88084d323860] nvmet_rdma_alloc_queue at ffffffffa07c5ba9 [nvme=
t_rdma]
> #13 [ffff88084d323900] nvmet_rdma_queue_connect at ffffffffa07c5c96 [nv=
met_rdma]
> #14 [ffff88084d323980] nvmet_rdma_cm_handler at ffffffffa07c6450 [nvmet=
_rdma]
> #15 [ffff88084d3239b0] iw_conn_req_handler at ffffffffa0787480 [rdma_cm=
]
> #16 [ffff88084d323a60] cm_conn_req_handler at ffffffffa0775f06 [iw_cm]
> #17 [ffff88084d323ab0] process_event at ffffffffa0776019 [iw_cm]
> #18 [ffff88084d323af0] cm_work_handler at ffffffffa0776170 [iw_cm]
> #19 [ffff88084d323cb0] process_one_work at ffffffff810a1483
> #20 [ffff88084d323d90] worker_thread at ffffffff810a211d
> #21 [ffff88084d323ec0] kthread at ffffffff810a6c5c
> #22 [ffff88084d323f50] ret_from_fork at ffffffff816e1ebf
>=20
> Fixes: 632bc3f65081 ("IB/core, RDMA RW API: Do not exceed QP SGE send l=
imit")
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--7HaFTVrk1Wgg99rGG4H2cQPq3sNRvKoAi--

--qIF1u8fCUhlduenclcNdwNvNlE7MLNSSN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8m7CAAoJELgmozMOVy/dEvsQAI5MgK4g8sfS29XO0W4cfeiD
L3WBQml7Zt+Yhn2Xm+Aqs+55czj1VI7m+MOnMIdH2BLS8jx0W9qk9g8ogyT/MMC1
MT+2qgWli9BMIM0IbbyTyeXBuNUvBbC/iCkDPiAV8csVq9xDq1qUOpmZvlpDEuXG
FdhBtb5DH//tc797yl27x9+f5HuLvo6bJFTcPkaNL2gMBrol9k4bplBt2xsXX90u
sm4Xzp9VdoyD4SGhtZAKsfXhJWh2O3dEjM5eTWI/2IyzHCAKVYRUFTnmFGlMFaZH
5AZPvNIlYFdtRcc1WqDVCQs6/M9BKrxub0dtrCMLIHBdkpnKzXj5aKsLWRgYowvx
ugs4HFGusdT4So1XIQ6i81WQt3xd56R6SDZX0ZCxLVdTeChJe2t616+133whuMan
ZVlltEwgRZc7FTnWNQDq0f6mfipzg+1fVydRNF1Gb5ImAmy2RmoO6wvTEbjcO2o0
PEM9nBN4vDq5zieQgift1bHy2DTvkFqj+RamAxcNrsWycEiPQwfMF4eCnSq9/D5Y
jqc+Ha2cLLl4KmE2GmneD5ySeNBv9Mgg1WGIHSNhvqZD5f7mumo7xx+++67xGCd7
i/N7YsSa+FTxSD4udKwijN2ub9e7S5f+2h7ySpH1mAdRukv+MboHYYHZegoZR3GJ
bEEO7+MRbGHtddcaIBnL
=nx0f
-----END PGP SIGNATURE-----

--qIF1u8fCUhlduenclcNdwNvNlE7MLNSSN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
