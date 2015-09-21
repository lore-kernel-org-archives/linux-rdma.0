From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch] IB/hfi1: checking for NULL instead of IS_ERR
Date: Mon, 21 Sep 2015 11:42:28 -0400
Message-ID: <56002564.6000100@redhat.com>
References: <20150916062220.GC21542@mwanda> <55FC32ED.1000404@redhat.com>
 <20150919030153.GA30373@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qgiEDosIXATkFhLC66sqiBqxoWJSrO2Jn"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150919030153.GA30373@kroah.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qgiEDosIXATkFhLC66sqiBqxoWJSrO2Jn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/18/2015 11:01 PM, Greg Kroah-Hartman wrote:
> On Fri, Sep 18, 2015 at 11:51:09AM -0400, Doug Ledford wrote:
>> On 09/16/2015 02:22 AM, Dan Carpenter wrote:
>>> __get_txreq() returns an ERR_PTR() but this checks for NULL so it wou=
ld
>>> oops on failure.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> Thanks, applied.
>=20
> Applied to what?  Should I just ignore these types of patches and not
> take them in my tree and you will send them on later on?  I don't
> remember what we agreed to do, sorry.

My understanding was that I would handle everything in the staging/rdma
area.  To that end, I tried to make it explicit so that people would
know that via the following things:

=46rom MAINTAINERS:

INFINIBAND SUBSYSTEM
M:      Doug Ledford <dledford@redhat.com>
M:      Sean Hefty <sean.hefty@intel.com>
M:      Hal Rosenstock <hal.rosenstock@gmail.com>
L:      linux-rdma@vger.kernel.org
W:      http://www.openfabrics.org/
Q:      http://patchwork.kernel.org/project/linux-rdma/list/
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.g=
it
S:      Supported
F:      Documentation/infiniband/
F:      drivers/infiniband/
F:      drivers/staging/rdma/
F:      include/uapi/linux/if_infiniband.h
F:      include/uapi/rdma/
F:      include/rdma/


And from drivers/staging/rdma/Kconfig:

menuconfig STAGING_RDMA
        bool "RDMA staging drivers"
	depends on INFINIBAND
	depends on PCI || BROKEN
	depends on HAS_IOMEM
	depends on NET
	depends on INET
        default n
        ---help---
          This option allows you to select a number of RDMA drivers that
	  fall into one of two categories: deprecated drivers being held
	  here before finally being removed or new drivers that still need
	  some work before being moved to the normal RDMA driver area.

          If you wish to work on these drivers, to help improve them, or
          to report problems you have with them, please use the
	  linux-rdma@vger.kernel.org mailing list.

          If in doubt, say N here.

I was hoping those two items would be sufficient to keep people from
flooding devel@ and yourself personally with fixups for these items and
instead they would send them through linux-rdma@.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--qgiEDosIXATkFhLC66sqiBqxoWJSrO2Jn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWACVkAAoJELgmozMOVy/dWZgQAJD7ROh/5AxO9Zgv2vjbb6h2
7NqbB0ZvomgvJjTpJMWPtisgy24Z/8Z+0Uqf4+L/bHlG23c8/w/T8f6sd8BtlPDL
HVLqgZ6ha/23wIhkNHDLgz26wqDMKuIbmG2zOygFC/2dJWmX3wTRilwVwkB9de4r
2TSM8s7Vq4GaiZRAVNGWZXwPv/Wb7fgCIGQ3GuminuLtVTV2aUtrRZR+6KKdFUeC
FUbYZIy6TQRihSlInCdvfJ1E4hyXsK4vD0TNClWd6SVCpLsGnGZAeZmh950AGYuk
wirKPzOlYH3RpKaKpTMInd9F2ufF7HaTzSVsL6ubIhuwkEkYHXT0TEGPohPnDdLC
DNHOEKdoiS2Yj2SBuGguMFeFq6TeEBjVNHlSg/Vz0Zaw1UMn72z3wW3i7/JrYi0D
p4I+XFAmGSkn2kCbmfSLokSMBlwIoy1etVkIw1WsEm5Pna1NSzdXN+OLcvznGQxI
YLTSYSrIrr6i6SnF9MCMhehWyMIYNNtp1Lbq5A0e0rhS1sRrWXOnKJI2JUMoXNZW
BjP6KaCBZrmJGLqb+YXKeK/eIHavvEc9UJXQkkb4tKgAco301bJ/6rvUQ/Zdyfi/
enZGH+e6u278kTlyrNmI8sJv0Ugl3gbZSrNIyvs8uCoO1wYHDYkbZdpvx6gXhTKr
yonUjeaQdooh6HESgyHc
=4S05
-----END PGP SIGNATURE-----

--qgiEDosIXATkFhLC66sqiBqxoWJSrO2Jn--
