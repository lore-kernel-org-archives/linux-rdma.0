From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Thu, 6 Dec 2018 08:45:09 +0200
Message-ID: <20181206064509.GM15544@mtr-leonro.mtl.com>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Re2uCLPLNzqOLVJA"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181206041951.22413-1-david@gibson.dropbear.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: David Gibson <david@gibson.dropbear.id.au>
Cc: davem@davemloft.net, saeedm@mellanox.com, ogerlitz@mellanox.com, tariqt@mellanox.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, alex.williamson@redhat.com, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, sbest@redhat.com, paulus@samba.org, benh@kernel.crashing.org
List-Id: linux-rdma@vger.kernel.org


--Re2uCLPLNzqOLVJA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 06, 2018 at 03:19:51PM +1100, David Gibson wrote:
> Mellanox ConnectX-5 IB cards (MT27800) seem to cause a call trace when
> unbound from their regular driver and attached to vfio-pci in order to pass
> them through to a guest.
>
> This goes away if the disable_idle_d3 option is used, so it looks like a
> problem with the hardware handling D3 state.  To fix that more permanently,
> use a device quirk to disable D3 state for these devices.
>
> We do this by renaming the existing quirk_no_ata_d3() more generally and
> attaching it to the ConnectX-[45] devices (0x15b3:0x1013).
>
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  drivers/pci/quirks.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>

Hi David,

Thank for your patch,

I would like to reproduce the calltrace before moving forward,
but have trouble to reproduce the original issue.

I'm working with vfio-pci and CX-4/5 cards on daily basis,
tried manually enter into D3 state now, and it worked for me.

Can you please post your full calltrace, and "lspci -s PCI_ID -vv"
output?

Thanks

--Re2uCLPLNzqOLVJA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcCMV1AAoJEORje4g2clinjAQP/1QohDmpz3Nx1/0h9KEad/Gv
xb/XKSpynLFHroGdEEAHUaDgLOfsp5WoJxVs5sj8/EI7ZB7+jT89DAByeXkFQI5J
8LBm+eEZboNTLa2lOcl5yBSVNWb3POGFmsuTAf2q4F+fijds+lyATk3kKYpDc7wC
4zJ22LiEr4rryTOuxZyFi5YTaNso3WhHs0XB8bAFoJar9ypY+aSPq48C+wU+08da
AbD3yThzPT++z61FgK5tmyaG2xN8uZmHzeRpSaX7vEDMgPznJk4qnIaA0FtCnjRu
SYOg8XLPksqmrdU/N/vV5FM2uk77s8yoNtOEkdCg19rkG04c2pzqdX/aZtW4epKX
h1mKWK2x21U2+l/gd5atRuFuJfP3k7P6LEsfzWprmFsyC6fwrt2H8ojN+10fuEiP
1KURSsGdMYCrKrDklpsAeu5JHRc5UEOKyQsWPQZ+wmZtpI4zJTW9Av9YfYd/RZ6d
PefEN2j6gmDpC7ffZqV0oenEuEgGAPGFiBRRTeOqgggfLMT1Rn9FZHX4zAGLZMpR
jciOwJNwN9rPTkLyEyCQItjhqQjty3gvDMlYpuMpNsYIXcyl/gkjMWuke4TaHHZP
M6g+P6qfUvDEDTlMO+wU6hcKRmqLFr+LsjQhtfHza9j1gGIcYO6FFTvPN0o0tGcq
mItAd9DzgosnlmUT2DHQ
=Hvye
-----END PGP SIGNATURE-----

--Re2uCLPLNzqOLVJA--
