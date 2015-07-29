From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Wed, 29 Jul 2015 12:39:43 -0400
Message-ID: <55B901CF.6020801@redhat.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55B0F06E.8000603@sandisk.com> <20150723183044.GA1868@obsidianresearch.com>
 <55B13583.5010208@sandisk.com> <20150723184725.GB30303@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WPaXpmmSRSWlAPEgvHQTIvaCol9sG3BrV"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150723184725.GB30303@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Amir Vadai <amirv@mellanox.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WPaXpmmSRSWlAPEgvHQTIvaCol9sG3BrV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/23/2015 02:47 PM, Jason Gunthorpe wrote:
> On Thu, Jul 23, 2015 at 11:42:11AM -0700, Bart Van Assche wrote:
>>> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband=
/ulp/srp/ib_srp.c
>>> index fb9fed0fac28..a1e3818d0791 100644
>>> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
>>> @@ -69,7 +69,7 @@ static unsigned int cmd_sg_entries;
>>>  static unsigned int indirect_sg_entries;
>>>  static bool allow_ext_sg;
>>>  static bool prefer_fr;
>>> -static bool register_always;
>>> +static bool register_always =3D true;
>>
>> If we want security by default then I propose not only to change the d=
efault
>> value of register_always from false into true but also to change the d=
efault
>> value of prefer_fr from false into true such that fast registration be=
comes
>> the default instead of FMR.
>=20
> Yes, I was frowning at that stuff too.. We are trying to get rid of
> FMR, so nothing should prefer it over FRWR...
>=20
> Sagi, perhaps that belongs in your MR unification series?
>=20
>>> +	if (register_always)
>>> +		mr_flags |=3D IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
>>
>> Hmm ... did you perhaps intend if (!register_always) instead ?
>=20
> I did, thank you. For your testing convenience, the updated version is
> on github now:
>=20
> https://github.com/jgunthorpe/linux/commits/remove-ib_get_dma_mr

Hi Jason,

If you think this is nearing a stable enough state for 4.3, please go
ahead and repost.  I'm trying to pull together all of the 4.3 material
and I already have the mlx5 fix you referenced.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--WPaXpmmSRSWlAPEgvHQTIvaCol9sG3BrV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVuQHPAAoJELgmozMOVy/dMRQP/Rpot4WfUFeVX7ZbKPO0/a/2
fVp6lxuHw6nRyEY/hR4700pku5GXDAye3Xbf1sUDPozIHaezEMTmrgh6RizPp9Iy
lpER2dEGO/uRn0NIt8m87ILa0/9f0bmUT8O14bkaWwhFK7B4hYVjPkb44wMh0mpY
eDBxLsHXJvSZljRLQ9VPJleNbt5ZyFiGMJwb1U+Wva7V8AWNBKnmINImxI/OzV6w
6E6BYThYNCehW9JWp5InlVm1hTY0z7HWjv2MecjV6iSO5wYmeG/gZmsFjhNgoRhe
GhvrTyjxuUAQF2g+jYNFJsvH5DnFtYTR/q/jkPuYQ2VKyH5IOC10QGSaZaP6BMDE
Y8HSWDzdq4ACsLnNr0sUASofckNixoo0Rh65DXt0aLu9ccTuLCYvSTaLsMsajtu+
gH6u7M9EqHZkv2vhPboCxiGkNz4KLhgZmCeMlNHit67nnX9FWC1PDbiG3x8S/fe9
wXcTUOAOTEObxk75sliMvGpatpVxt9eOJAncNeAmPgF5Eey7WJ4CXxx71ZoDOzt1
ognLD3bT6ZUPZzMMc7t7jloTGJbSBJ9uYkIsCyXzN6kiKZERECjhk8lrGaXSZ/Gw
6/OBmyQcwAGcztq4HgJGOnyfxwE4sLE+BaVIFMggkOePn4k0U98IaCaY84ifIg8a
6nDM+z2Kkf5XMSuU/nAL
=FZSn
-----END PGP SIGNATURE-----

--WPaXpmmSRSWlAPEgvHQTIvaCol9sG3BrV--
