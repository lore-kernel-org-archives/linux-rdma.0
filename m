From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Thu, 5 May 2016 15:32:32 -0400
Message-ID: <5334ab9c-428a-547f-b80a-e0bee3f85449@redhat.com>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
 <72645a3b-5945-419a-d7af-1c065080e415@redhat.com>
 <20160505192024.GA17249@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IngB5soDV21EmU1aMk98LMPmA7EaGlbuf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160505192024.GA17249-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IngB5soDV21EmU1aMk98LMPmA7EaGlbuf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/05/2016 03:20 PM, Jason Gunthorpe wrote:
> On Thu, May 05, 2016 at 02:57:01PM -0400, Doug Ledford wrote:
> =20
>> and the eeprom is written with the new data.  If you need to do specia=
l
>> things, like Mellanox, in terms of recovering burned data like GIDs
>> or
>=20
> The 'eeprom' and device firmware are very different things. hfi1 has
> both, and uses request_firmware too.
>=20
> I've never heard of a driver using ethtool eeprom to deal with nv
> firmware like mlx has.

There's no reason it couldn't.  Since you can pass offset and length
parameters and write things in multiple chunks, you can actually set up
access to eeprom, nv ram, and firmware all through the one interface
simply by defining the start/stop points of each to be at specific, well
known locations for your device.  Then your routine could write to the
correct device based upon the location.

And in truth, whether you are talking about firmware, some sort of
eeprom, or nv ram, it's all the same basic principle: read from or write
to this non-volatile memory of arbitrary size (ok, depending on the
device, firmware might be different...it might not be non-volatile, or
there might be a non-volatile version for boot and a running copy that
can be downloaded by the kernel where the running copy and the boot time
non-volatile copy are not necessarily the same).  Only the the nitty
gritty of the access varies based upon the device in question.  Aside
from making sure to get the right device, user space couldn't care less
about the distinction of the hardware type used to implement it.

> AFAIK there is no kernel convention for that
> stuff. It is more common for storage than network drivers.

You're right, it is more common for storage devices (raid hardware in
particular). And a lot of that hardware doesn't have a good means for
doing this.  Different vendors have rolled their own solutions (Dell for
instance uses their own kernel driver to allow updated the firmware on
all of the devices they ship, including raid storage controllers,
onboard Ethernet and PXE booters, etc).  But since we have a netdevice
on everything, I see no reason not to use the eeprom routines already
present.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--IngB5soDV21EmU1aMk98LMPmA7EaGlbuf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXK5/QAAoJELgmozMOVy/dahwQAL1P7LrCgz4NaMthZ0OxHfug
Zm6vP11GkvmQ/1An17yFmXEzIrwNXt3y79NrhtiPz9uoLhME9lqYCMVzelmYLYFX
V2BEg+l8sVpz5F9bBYuDxyUz1Cw8F1y694QF5BQs/veOCe8xWQcPLZ/4dYgWclXp
sPpVmum9OczlU1IpJqNEBSsBRb7yWJ01RCRWx+3iJUUbAgylNRmN50eMoMZUN702
YomH8i8FgEsNZ82hRVCKS1S3OmyG6wZCQNGV49OEUSP1wkO5p+PUJpCnKwLdMzVp
Dyh0IsBDE3CH9SAgT1lYcbucewArRaoNIUcP+4/q1Ctp/Nhmez8sSr26Nyi+2E65
fHDjTzXKvaocXE7En9Hqr0JQpmmkYD6ppCpnk13YFDYB8/g2gx5unq8ykaCTJG4m
XEeoWtFr8x0XsrGX63iBUgNYf1aySe3YUBAOk/RPLc8tP4W1kjNOqSvVegDwue4t
oMCh/eKRAVqaDJwaCk/ZeeG7504xLmosc374gYMI1yALwuONKh6r9UndPc9qkvvi
bo94+hr4wRA2PetLGVjlG3iDQn3atkgWOLxGKoKulEUOSYuYjiw9bvgkYizZSvcl
jAo57QGV/ssyG0oRxiFnJt2ylFAUcWpeidTbbbCiwkViNKwEmWQE4rmr2icT4dcM
bO2QWQk5Tfo/bAQ4Dg+k
=UWL8
-----END PGP SIGNATURE-----

--IngB5soDV21EmU1aMk98LMPmA7EaGlbuf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
