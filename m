From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] staging: amso1100: fix format string for 64-bit phys_addr
Date: Thu, 4 Feb 2016 07:15:05 -0500
Message-ID: <56B340C9.2060303@redhat.com>
References: <2307631.X1DYNXxKPZ@wuerfel>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2881327648499234347=="
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <2307631.X1DYNXxKPZ@wuerfel>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Arnd Bergmann <arnd@arndb.de>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============2881327648499234347==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TfXDq459stieGfTPL357f35kb5KxC2AAm"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TfXDq459stieGfTPL357f35kb5KxC2AAm
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/01/2016 11:34 AM, Arnd Bergmann wrote:
> The amso1100 driver prints a phys_addr_t by casting it to a pointer,
> which causes a warning when phys_addr_t is 64-bit and pointers
> are 32-bit:
>=20
> drivers/staging/rdma/amso1100/c2.c: In function 'c2_rx_error':
> drivers/staging/rdma/amso1100/c2.c:430:4: warning: cast to pointer from=
 integer of different size [-Wint-to-pointer-cast]
>=20
> This changes the format string to print the address as a 64-bit
> number all the time to avoids the warnings. Ideally we would use
> the %pap format string for phys_addr_t, but that doesn't work
> here easily as it requires passing a pointer to the address.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Found on ARM randconfig testing. This must have been there forever but =
is
> rather hard to trigger even with randconfig builds.
>=20
> diff --git a/drivers/staging/rdma/amso1100/c2.c b/drivers/staging/rdma/=
amso1100/c2.c
> index b46ebd1ae15a..170a42a60552 100644
> --- a/drivers/staging/rdma/amso1100/c2.c
> +++ b/drivers/staging/rdma/amso1100/c2.c
> @@ -426,8 +426,8 @@ static void c2_rx_error(struct c2_port *c2_port, st=
ruct c2_element *elem)
>  		pr_debug("    index : %Zu\n",
>  			elem - c2_port->rx_ring.start);
>  		pr_debug("    len   : %u\n", rx_desc->len);
> -		pr_debug("  rxp_hdr : %p [PA %p]\n", rxp_hdr,
> -			(void *) __pa((unsigned long) rxp_hdr));
> +		pr_debug("  rxp_hdr : %p [PA %016llx\n", rxp_hdr,
> +			(u64)__pa((unsigned long) rxp_hdr));
>  		pr_debug("    flags : 0x%x\n", rxp_hdr->flags);
>  		pr_debug("    status: 0x%x\n", rxp_hdr->status);
>  		pr_debug("    len   : %u\n", rxp_hdr->len);
>=20

I've sent off a deletion of this file to Linus already, sorry.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--TfXDq459stieGfTPL357f35kb5KxC2AAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWs0DJAAoJELgmozMOVy/dpCcQAKamySMMWSqDpl4Zfwg+Df+w
tlBG50/qkg22qdawiIwMkAJ+ksTNQudNfmY45Na3Jcb+eJXyJJhjJ+LhzaC7qkGT
u41cc16bE0LoImjdU4Hzb0x4MixDNIQ22wb1rZf78EluSSUViTMRC9sgi4ZNmmdM
qTuSXJkXk2OcZ6FSyy/sX9nZSQmvg6p2HVxFcoSdwEJMsHWittEdhFvl8uSjKneO
xZ0amNQQNNB1Tx2I3DNpjSnDgTILEbUtAeum64I40SWjavJTRPtpPDkTmeS78yfc
ut2IUjxoj+6bE2HATUiiU8PHKSFaOhUm0tOHKhHS7XJ6G22mEOszJa4k9IU0IH4D
ob+BqfE4cDeZ9FABrVWB3qYNJLKLu61SrRYdJa9yAUihJEQYetTwKKz9YhMMIVmT
YsqKpxejKfTbTDIhDobStXM5LDWq/D7Md9i4bM58gCOcWA6eFJ4ypXP+ivCjneHH
HfO3mdiPy7v8tZwdW7qTvRkWm/GGq2JkjYsQh/iCmeRBp1uk/WM7QQuEMWAr18Ad
kbjoDalEyGLukHjZCRn3e158ZJ3NzksoOnuITOWGq11QYCl79hcrykt4r4GI/5Mq
pAPdkgWahd/C9IC54SyICoqDDrzNgaI4Cq3J2UTvAXMFJpb2n4OHL8/XlOUgTO94
YK2teFCkfhSWST8dHQLw
=wE+3
-----END PGP SIGNATURE-----

--TfXDq459stieGfTPL357f35kb5KxC2AAm--

--===============2881327648499234347==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

--===============2881327648499234347==--
