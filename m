From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v3 01/12] IB/core: Guarantee that a local_dma_lkey is
 available
Date: Fri, 14 Aug 2015 20:54:55 -0400
Message-ID: <55CE8DDF.4020403@redhat.com>
References: <20150804222130.GB21509@obsidianresearch.com>
 <20150804233520.GA22313@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q8Pobh5g9qNbkJCIuSuPsSjip20kSxjvn"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150804233520.GA22313@phlsvsds.ph.intel.com>
Sender: target-devel-owner@vger.kernel.org
To: "ira.weiny" <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Haggai Eran <haggaie@mellanox.com>, linux-rdma@vger.kernel.org, Amir Vadai <amirv@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, rds-devel@oss.oracle.com, target-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q8Pobh5g9qNbkJCIuSuPsSjip20kSxjvn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/04/2015 07:35 PM, ira.weiny wrote:
> On Tue, Aug 04, 2015 at 04:21:30PM -0600, Jason Gunthorpe wrote:
>> Every single ULP requires a local_dma_lkey to do anything with
>> a QP, so let us ensure one exists for every PD created.
>>
>> If the driver can supply a global local_dma_lkey then use that, otherw=
ise
>> ask the driver to create a local use all physical memory MR associated=

>> with the new PD.
>>
>> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> Reviewed-by: Sagi Grimberg <sagig@dev.mellanox.co.il>
>> Acked-by: Christoph Hellwig <hch@infradead.org>
>> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
>=20
> I hit this bug as well.
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Tested-by: Ira Weiny <ira.weiny@intel.com>

I've pulled the v2 of this patch and replaced it with this one.  Thanks.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--q8Pobh5g9qNbkJCIuSuPsSjip20kSxjvn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzo3fAAoJELgmozMOVy/dL04P/2X8fz3aoXATk8Foq/1qemYu
qAT6yGt0JR6KpIKhyT0H7XMZ2Ps13tgxTJdauFd8jQfzCYZTqUxbL6CLiFM3eL4t
cF7qjwCM+thfzR/GE4b7Tu/PvyeThPdwWppKjdKTGSJ6wk8B/dWbRA1/+j+CGMXa
hhTTil7QtA1YGU/rsOgnkysyuqpu77rnaRkn+Fa5vCDP6QrKoINAcQW2lOnejObS
D4Bp9Co91IvrVHgrizsUoFaMljYAbdmzK/E0gKgJcAmXBysyJGQjqacA3Rl5Dp5M
ZqEdL0Uh7lSdZcYpNd9IIU0w2E0+rM0P+cUYRgLnyF4UstYM9iRYs+xlbD6FOnAd
QDmUT7X9Wb2MOKiEaocRbhtBbbHqkirqBYla8jEcMHUC0vHHfRsLb+xQ0Ws4xGGq
MMw44VH8EXrH8Qfi4QVnbFKchTFn2tRaAK9KRuIVqvkBXnUI2ERIB++e6rLYmS8q
x96tSIQFyZBQb64AGV6Ek6KvkU7W6u4EFJLxdfgEm+EuPZhoTP9e4HYhuiPfzqQL
i/wd9UB947QPee765xwKKHqR2reIH1N+gNqP2IAruXw3kQWBS8cOWhBA4R5KQeUn
x4rT/iVEMvSmW8yZRqzXX3s8qEiydPLY5TV0usPSzt6U9GKRdg5BowABg6gjs+Ti
fldqvo4p/0sBlHL1rayf
=VZfw
-----END PGP SIGNATURE-----

--q8Pobh5g9qNbkJCIuSuPsSjip20kSxjvn--
