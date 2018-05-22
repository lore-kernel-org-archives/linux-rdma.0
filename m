From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH for-next] IB/qib: Fix DMA api warning with debug kernel
Date: Tue, 22 May 2018 15:41:01 -0400
Message-ID: <d504eec98a3895a23d24a75725869da8767a033b.camel@redhat.com>
References: <20180519000653.10154.69033.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-DFLW46cWU6VLmPgnCmnB"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180519000653.10154.69033.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Don Dutile <ddutile@redhat.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-DFLW46cWU6VLmPgnCmnB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-05-18 at 17:07 -0700, Dennis Dalessandro wrote:
> From: Mike Marciniszyn <mike.marciniszyn@intel.com>
>=20
> The following error occurs in a debug build when running MPI PSM:
>=20
> [  307.415911] WARNING: CPU: 4 PID: 23867 at lib/dma-debug.c:1158
> check_unmap+0x4ee/0xa20
> [  307.455661] ib_qib 0000:05:00.0: DMA-API: device driver failed to chec=
k map
> error[device address=3D0x00000000df82b000] [size=3D4096 bytes] [mapped as=
 page]
> [  307.517494] Modules linked in:
> [  307.531584]  ib_isert iscsi_target_mod ib_srpt target_core_mod rpcrdma
> sunrpc ib_srp scsi_transport_srp scsi_tgt ib_iser libiscsi ib_ipoib
> scsi_transport_iscsi rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_c=
m
> ib_qib intel_powerclamp coretemp rdmavt intel_rapl iosf_mbi kvm_intel kvm
> irqbypass crc32_pclmul ghash_clmulni_intel ipmi_ssif ib_core aesni_intel =
sg
> ipmi_si lrw gf128mul dca glue_helper ipmi_devintf iTCO_wdt gpio_ich hpwdt
> iTCO_vendor_support ablk_helper hpilo acpi_power_meter cryptd ipmi_msghan=
dler
> ie31200_edac shpchp pcc_cpufreq lpc_ich pcspkr ip_tables xfs libcrc32c sd=
_mod
> crc_t10dif crct10dif_generic mgag200 i2c_algo_bit drm_kms_helper syscopya=
rea
> sysfillrect sysimgblt fb_sys_fops ttm ahci crct10dif_pclmul crct10dif_com=
mon
> drm crc32c_intel libahci tg3 libata serio_raw ptp i2c_core
> [  307.846113]  pps_core dm_mirror dm_region_hash dm_log dm_mod
> [  307.866505] CPU: 4 PID: 23867 Comm: mpitests-IMB-MP Kdump: loaded Not
> tainted 3.10.0-862.el7.x86_64.debug #1
> [  307.911178] Hardware name: HP ProLiant DL320e Gen8, BIOS J05 11/09/201=
3
> [  307.944206] Call Trace:
> [  307.956973]  [<ffffffffbd9e915b>] dump_stack+0x19/0x1b
> [  307.982201]  [<ffffffffbd2a2f58>] __warn+0xd8/0x100
> [  308.005999]  [<ffffffffbd2a2fdf>] warn_slowpath_fmt+0x5f/0x80
> [  308.034260]  [<ffffffffbd5f667e>] check_unmap+0x4ee/0xa20
> [  308.060801]  [<ffffffffbd41acaa>] ? page_add_file_rmap+0x2a/0x1d0
> [  308.090689]  [<ffffffffbd5f6c4d>] debug_dma_unmap_page+0x9d/0xb0
> [  308.120155]  [<ffffffffbd4082e0>] ? might_fault+0xa0/0xb0
> [  308.146656]  [<ffffffffc07761a5>] qib_tid_free.isra.14+0x215/0x2a0 [ib=
_qib]
> [  308.180739]  [<ffffffffc0776bf4>] qib_write+0x894/0x1280 [ib_qib]
> [  308.210733]  [<ffffffffbd540b00>] ? __inode_security_revalidate+0x70/0=
x80
> [  308.244837]  [<ffffffffbd53c2b7>] ? security_file_permission+0x27/0xb0
> [  308.266025] qib_ib0.8006: multicast join failed for
> ff12:401b:8006:0000:0000:0000:ffff:ffff, status -22
> [  308.323421]  [<ffffffffbd46f5d3>] vfs_write+0xc3/0x1f0
> [  308.347077]  [<ffffffffbd492a5c>] ? fget_light+0xfc/0x510
> [  308.372533]  [<ffffffffbd47045a>] SyS_write+0x8a/0x100
> [  308.396456]  [<ffffffffbd9ff355>] system_call_fastpath+0x1c/0x21
>=20
> The code calls a qib_map_page() which has never correctly tested for a
> mapping error.
>=20
> Fix by testing for pci_dma_mapping_error() in all cases and properly
> handling the failure in the caller.
>=20
> Additionally, streamline qib_map_page() arguments to satisfy just
> the single caller.
>=20
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Alex Estrin <alex.estrin@intel.com>
> Tested-by: Don Dutile <ddutile@redhat.com>
> Reviewed-by: Don Dutile <ddutile@redhat.com>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

Thanks, applied to for-next.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-DFLW46cWU6VLmPgnCmnB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlsEck0ACgkQuCajMw5X
L93y1A//Wr/RsrFTPh5bLfdl/ewN3yG4PpiKb1GkIxGOa/n064rGSNlHq9awbNji
Mp4GB8vb4skscFOGNYcQV/nDlMdSnOAICgwI11x9utEDyCJVC0LmLPGQxlC3SDzH
A/MVUYy6rmqMqCNLMn2ZwmDhTKgOwbI+giwkOGjyBlAaMhXCghefIJV3ikZUGZhN
+pCZStazeUKw+398/J1Ag+5Nqo+dcu3w6LW0BDk6Lk0fndJD5IcYu/N4QkYSnLtB
kbOsGNC6eWrS36sqBh/FTEHgJnA5U94q18Wb7FG2X4NlwAIf4yu8uzIZehee185a
/wvEYT9nolRoF9x1siywLesmzpIyb7nEw4/k/fP/FOFGO+/xzX0fZwTuOq+0/eC2
N99IzJj4hOuBODRTrQP1bekGfA5TBuyIrmANRbhVVfo5lkrJFUq3vH0a7u25Qrfx
o4UVnbmZt9BZg7raZPnZ5hriQ79E+7rmB+hFif8evRoiKzhSelk4wVQILISDkKos
7Dgeje71UWp0nQW+DmRkX8Uw20npO5lHKCwjKhx1SlZMqfCELU08oT8H1T5rDuO5
H2WtQQvcABBQgU1NbhiSpwmikduEJtBg2LD9BvKkjZJrHdD9RUIXAHMpR52WWSUr
eFlF5aRMnT6XB9LcyKUa9u2ivw9y8EIg+IDJctw4OGZZh3CHST4=
=8fy2
-----END PGP SIGNATURE-----

--=-DFLW46cWU6VLmPgnCmnB--
