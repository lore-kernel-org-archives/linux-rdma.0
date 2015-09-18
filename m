From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/hfi1: fix sdma_descq_cnt parameter parsing
Date: Fri, 18 Sep 2015 11:50:33 -0400
Message-ID: <55FC32C9.5040101@redhat.com>
References: <20150915141927.16196.22394.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2844892140882423320=="
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20150915141927.16196.22394.stgit@phlsvslse11.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, David Binderman <dcb314@hotmail.com>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============2844892140882423320==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UQw49h50MKNECKLG4adNgBr4T2rQFuwk8"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UQw49h50MKNECKLG4adNgBr4T2rQFuwk8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/15/2015 10:19 AM, Mike Marciniszyn wrote:
> The boolean tests should have been or-ed.
>=20
> Reported-by: David Binderman <dcb314@hotmail.com>
> Reviewed-by: Jubin John <jubin.john@intel.com>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>

Thanks, applied.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--UQw49h50MKNECKLG4adNgBr4T2rQFuwk8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV/DLJAAoJELgmozMOVy/dg0oP/R8G0dYMJ5zSKA7RdA6QIhdk
KcxpJSEbKcLFEAJLbeUtFu0ixvaKxLrRoMCHQUw6snIIkh6bAfLg0l4Sq8OVIhvL
swpAzN9Ljt5uwO8UmZ3TCoTZt6U/Z6P2MDljBgFtv6jfU/1kJ3lGUiq86+Xd0sac
X+wfRDl7rJGLIUWs7AhMfZN1vlVvr0PritUD5dV9A9V51ndEYvjzjfm9kEOPJ+Gz
+0gtE7aYTet04GhJ1gXPDidzHnbiaJ1ETri8dySToILHfUNQbkcbgOM0vSiA+u+n
b8KlXEeS0UWIXK0fMZE1Q2ANAzGTMhQkm2P46w213boWnLgDeTmlygmikh3sNnWA
zkWd0Zwlv05Cce6Na8MPB43Cca0Q6V6lYDyWCqcifKYpGVYAM5KV8r/Pp2ZCoNVb
3HZU4rLks44H5h/b5lfj07THGgs6v7JFhn+cMjubXfs8GE27zIbNVcFwqL92GgQU
R7ZKES9Ak1OTwYONVttP1aOr7zZsUotWL7syuPxfzOK5zpTfnPRtalzKSrtbXIDX
mD01IJhc/F0Vy70weccTY950Ml7YKD4hwYQJTqLJxfUYfnRgJMUmJ9Xej+32RB4x
YWNPwWJaE6ZxjB+VKaD5H1EKFN89DD3Db3BcvvnWmyPhg4KXflxcCLSxKhgA9im4
jnUZ7lfmj9SMFy/imjCW
=ZESm
-----END PGP SIGNATURE-----

--UQw49h50MKNECKLG4adNgBr4T2rQFuwk8--

--===============2844892140882423320==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

--===============2844892140882423320==--
