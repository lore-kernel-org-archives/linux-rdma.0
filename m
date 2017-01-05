From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v4] IB/umem: Release pid in error and ODP flow
Date: Thu, 5 Jan 2017 08:39:22 +0200
Message-ID: <20170105063922.GX12077@mtr-leonro.local>
References: <1483599605-24456-1-git-send-email-liguozhu@hisilicon.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l7GkBbkEatsaRqBf"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483599605-24456-1-git-send-email-liguozhu@hisilicon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kenneth Lee <liguozhu@hisilicon.com>
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, robin.murphy@arm.com, jroedel@suse.de, egtvedt@samfundet.no, vgupta@synopsys.com, dave.hansen@linux.intel.com, lstoakes@gmail.com, krzk@kernel.org, sebott@linux.vnet.ibm.com, markb@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--l7GkBbkEatsaRqBf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 05, 2017 at 03:00:05PM +0800, Kenneth Lee wrote:
> 1. Release pid before enter odp flow
> 2. Release pid when fail to allocate memory
>
> Fixes: 87773dd56d54 ("IB: ib_umem_release() should decrement mm->pinned_vm from ib_umem_get")
> Fixes: 8ada2c1c0c1d ("IB/core: Add support for on demand paging regions")
> Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
> Reviewed-by: Haggai Eran <haggaie@mellanox.com>

Thanks a lot for resending.
Reviewed-by: Leon Romanovsky <leon@kernel.org>

--l7GkBbkEatsaRqBf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlht6hkACgkQ5GN7iDZy
WKfaXxAAu/NdrhEUOUrbzhB2q3Gc6HyenJdY0yHAZa5n/1e1LE6eh01YnpiyVmWG
QeEtBH7oPuUl7zwjCkSpCbeeVbNiswHJ+pmTC0xJ1aRjCPFYgK1r3OhmoUdi0f7t
ekn45aSuxrjFa5wwnPRoHH8Ha9cPF4pJ+tbuC7oF6sVDNZePDhz4NDV6Els9PD31
2/SfWsv6Kpd5gzq8nSaFK/n12BhUXRfP2Ibt5olqt6A9eZpX1Pu5fZCd78WObHw3
TRYW8GKyJdBvuzLQC43GtTtHsjQk5k2ZP1e8Y1/y74WZA2Kkp/Uhg1qeeRwSgkG6
CXjTDGUgfK1E0zuYWfixJexWcw0IVdwFSj1Tclcwuo5h40f2wXmVS3MLdmXzh0/f
8R6jz+ohVMoNfZekZS+PkVJolYg3iKPw6+arcJXD94akfnOTT2r0wxq24plIX5vb
B8/xXXnYe0+DrklP0WR0hlBcYmq1Kl7ISIxMHmhsCohsSpz9pUTmFwPEDn8XgFtv
X7eQLkpHIYmZuz+xCfhAn4y1lrZWFvhdNZ75NiI/wqeFJ3U70rfOcVEKaeui/LSY
jqfS552q6nPsaAXpdEo49zGzyRrrCcYUDhETjnGUVd5+v6KeTITQ/nsUpVFlcaUK
eGjWxDD4d3A1kSGPcDlq592L8BQtsPDTjOUQKIWWTzCcCGGPd1w=
=om7x
-----END PGP SIGNATURE-----

--l7GkBbkEatsaRqBf--
