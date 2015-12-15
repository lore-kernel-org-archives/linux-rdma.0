From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Tue, 15 Dec 2015 16:46:01 -0500
Message-ID: <56708A19.8030403@redhat.com>
References: <20151211182532.332343651@linux.com>
 <20151211182543.329283794@linux.com>
 <20151211235630.GG7855@phlsvsds.ph.intel.com>
 <20151212000047.GA9961@obsidianresearch.com>
 <566EEE69.5080906@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512151351050.3509@east.gentwo.org>
 <20151215195554.GA28167@obsidianresearch.com>
 <5670717F.9090701@dev.mellanox.co.il>
 <20151215212035.GD28167@obsidianresearch.com>
 <56708961.1040505@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2BxxmU6XtjU07htM16SuuuuFSTTbiplgv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56708961.1040505-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2BxxmU6XtjU07htM16SuuuuFSTTbiplgv
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/15/2015 04:42 PM, Hal Rosenstock wrote:
> On 12/15/2015 4:20 PM, Jason Gunthorpe wrote:
>>> The unicast/multicast extended counters are not always supported -
>>>> depends on setting of PerfMgt ClassPortInfo
>>>> CapabilityMask.IsExtendedWidthSupportedNoIETF (bit 10).
>=20
>> Yes.. certainly this proposed patch needs to account for that and
>> continue to use the 32 bit ones in that case.
>=20
> There are no 32 bit equivalents of those 4 "IETF" counters ([uni
> multi]cast [xmit rcv] pkts).
>=20
> When not supported, perhaps it is best not to populate these counters i=
n
> sysfs so one can discern between counter not supported and 0 value.
>=20
> I'm still working on definitive mthca answer but think the attribute is=

> not supported there. Does anyone out there have an mthca setup where
> they can try this ?

Yes.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--2BxxmU6XtjU07htM16SuuuuFSTTbiplgv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWcIoZAAoJELgmozMOVy/dySsQAJAOzM9/ATUu3OHM7LjnYgYr
jE0ZfF5GoFcguK3hLdB22fy+W3InzDlPaRgoxzY+kAzHtjTn+YH0DOfOwi2MMb2j
tcs0M8eT2Cwol8Y4akpZNxJOyX9UHUyJELB6PVwBnMm3jOAANERkIBvkGuL48k+L
H1nfFjPKP29S9d9v+cvDqC8+Tcb0A1Ba4ITj69/D4WhuBzIh24reGv/o6CMgH98q
wfW+OmLnNXxBpOUdY8FDVq4y4huq0A9oFd67I7SoqjZjvAL2j/JHdi7PAfT/VRDI
WJR+xSx+ok1pkD32e38rpwbU1tdDIv73sfQTKuOUqPRQcENXoYFGpFzO9GIMCelY
JIxEam6FoYRiqmnLHcKQeNoS333L0tZxQN1rFPAFz8U1GiWpLFKQbYIYQ3xvFtqQ
0EyqFu827iNzWNFbIt3DvvuCs6zMP8qC/8fZ0Ysrxl9rxxcXJaZWkrUeB0c/5C7p
/UCOWnpfUGhviLTUEBjHcKsekcnx/f+BUU4NEJ2AdNzmfRNN9kugJi/f2l0lXzMY
FLT27ATQBRyoQL7IoHyMIRIZjI/0FfmZGPldIy5oIFO2R39Jjy0tuDaoJv7MZfRe
GLaw7eQWeVLT5YeoULxvGPbSVT3xKjkoWbI42dfFcaJvCTNZiJ/2NjSj5/5GRTEc
P4xvM3WJFqkYwTlGrhwm
=tLCt
-----END PGP SIGNATURE-----

--2BxxmU6XtjU07htM16SuuuuFSTTbiplgv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
