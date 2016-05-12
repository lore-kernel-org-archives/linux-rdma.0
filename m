From: Doug Ledford <dledford@redhat.com>
Subject: Re: generic RDMA READ/WRITE API V8
Date: Thu, 12 May 2016 14:04:57 -0400
Message-ID: <281ac56b-e5d2-ca7f-4e4e-e55ac62a894c@redhat.com>
References: <1462291273-22403-1-git-send-email-hch@lst.de>
 <9b8601d1aae1$15f13d70$41d3b850$@opengridcomputing.com>
 <57321A82.5090309@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a2PSNuqXdpp8FMDsONbfgtAx5SQLGILJ2"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <57321A82.5090309@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Steve Wise <swise@opengridcomputing.com>
Cc: sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, 'Christoph Hellwig' <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a2PSNuqXdpp8FMDsONbfgtAx5SQLGILJ2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/10/2016 01:29 PM, Bart Van Assche wrote:
> On 05/10/2016 10:26 AM, Steve Wise wrote:
>>>
>>> This series contains patches that implement a first version of a gene=
ric
>>> API to handle RDMA READ/WRITE operations as commonly used on the targ=
et
>>> (or server) side for storage protocols.
>>>
>>> This has been developed for the upcoming NVMe over Fabrics target, an=
d
>>> extensively te=D1=95ted as part of that, although this upstream versi=
on has
>>> additional updates over the one we're currently using.
>>>
>>> It hides details such as the use of MRs for iWarp devices, and will
>>> allow
>>> looking at other HCA specifics easily in the future.
>>>
>>> This series contains also conversion the SRP and iSER targets to the =
new
>>> API.
>>>
>>> I think it's basically ready to merge now.
>>>
>>> I also have a git tree available at:
>>>
>>>     git://git.infradead.org/users/hch/rdma.git rdma-rw-api
>>>
>>> gitweb:
>>>
>>>     http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/r=
dma-rw-
>>>
>>> api
>>>
>>
>> Hey Doug,
>>
>> Is this on your to-do list for 4.7?  I think it is ready to
>> merge.  But I don't see it in your k.o/for-4.7 branch yet.
>=20
> BTW, the SRP patches I'm working on will need the ib_map_mr_sg() change=
s
> from this patch series.
>=20
> Bart.

Yep, it's going in.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--a2PSNuqXdpp8FMDsONbfgtAx5SQLGILJ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNMXJAAoJELgmozMOVy/dyoAP/18uyJNZJ6S+2lMZLqvlw/v3
oCCUY2XMNStnbfy1JAnURxtMPzNs6OFH0pz4hS/gULLF7DlKo4XjHGrk0spjKn5P
p0Rhk6ARr6Eap47DdaKJQIG/q8JMji3so+JkkeCw2BQXKvEnAwZg91lJOMg91hkK
T/v0bev9q8MytQRMYEnKP/VreuNTKkESxK07JYc8Wp0wTnm8Gfj0NyNfu6/tyEYm
TGbwhS6D97uTrYP4Gs57KmUcn6FIdhjKO0oI6W2lKA+VlCaoONaTlPqMrtS+LUXd
l1uMpZQSno3VNkPY8LBBmnEbug0LU4diYJkBHFYEpxtHdqdg5fzOCcRlm4u5Ulmy
Vz434O4kRo5YNn4uBl6VJVj41cg2Sku596XpE3J6A6wR0WGrJ9yh0SxVDp3IGXoJ
69lvwelqOsKRQmS/zG2iG1SnaUWJHLrOmG8WP58a3ZLlmVJrHx/yXuYrZtzzVg21
VcEJgJX3e/awJs5e9ekT3ujU3wQdk513GKsF+hwHblTdaFdVx6PpV0/BnDOqHbkn
naDf2ueoWUh7HVOrf7TLJ4LCicI/j8WIqhYOXfh6U0cypV5DAVZBWDNGYLo3D8Ch
w3P2RCGDjDn+eHOsrJSetAxqlHC6ItxqBJ2oXYhy/NJMF0t/i0+y2phTa84+44Q7
W1YUutQiLATJL90uZxUk
=+QDJ
-----END PGP SIGNATURE-----

--a2PSNuqXdpp8FMDsONbfgtAx5SQLGILJ2--
