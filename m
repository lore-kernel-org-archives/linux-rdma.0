From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v7 00/23] IB/Verbs: IB Management Helpers
Date: Wed, 29 Apr 2015 12:28:15 -0400
Message-ID: <1430324895.102408.23.camel@redhat.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YuHlLVnEU1YE/tEmMu6X"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Devesh Sharma <Devesh.Sharma@Emulex.Com>, Liran Liss <liranl@mellanox.com>, Dave Goodell <dgoodell@cisco.com>
List-Id: linux-rdma@vger.kernel.org


--=-YuHlLVnEU1YE/tEmMu6X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-04-28 at 17:10 +0200, Michael Wang wrote:
> Since v6:
>   * Thanks to Ira, Devesh for the review and testing :-)
>   * Thanks for the comments from Sean, Tom, Jason, Doug, Devesh, Ira,
>     Liran :-) Please remind me if anything missed :-P
>   * Use query_protocol() and enum protocol type in 1#
>   * Use rdma_protocol_XX() in 2#
>   * Drop cma_set_legacy_transport()
>   * Reserve rdma_ib_or_iboe() and rdma_node_get_transport()
>   * Updated github repository to v7

I've taken your patchset and threw it into a for-4.2 branch in my repo.
This will get it 0day testing.  I've also pulled it into my test cluster
and done minimal testing (bootup, finds devices, gets IP address via
dhcp).  Here are the hardware types it passed on:

mthca (yes, I still have these...only just barely, but I do)
mlx4 (IB/RoCE, in both standalone and SRIOV usage)
mlx5 (IB only, I don't have the Eth capable mlx5 hardware yet)
cxgb3
cxgb4
qib
ocrdma

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--=-YuHlLVnEU1YE/tEmMu6X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVQQafAAoJELgmozMOVy/dYKUP/jI0z7y0SI17QSECgAya9ZjK
lhYJzvp0W6HkmX+jHPIBmWKAbEOuBvS3LtixTk6v73R7utpIbL+yXpIhY6Vt3YyH
YzxP5QkhmFzIjpvMGQvIUYF2CBoRvjJTnEe8dvsbUMJRKjHufM6zXzkz1JB5tc2H
mfifaoBuDteFz32fLqMvmUa3QdBNAwVtHLnySPowJh2+8Jconfi1Ut8blNa1M9FG
kr1uZ57Omzx+yhkTFzd4DwyQZTwJVih8ThtvDKAMRGeHLsUDNCTSSW7gfBzIBp59
owx2myUUhrqoZYLYlps3gxTAclWqMX6FFmY9wZ9a1oVnBX+E/iq5AhXugt/bYtl5
GD+2U18UlF5j+MUbtLRgERBKps+lomQnCXbOctdl5AEwDZky+rkk0IdRsNZ2KNaF
oxeAuGL7Pc1rs333xhyde4eT+YonrBSsPhohUF2pLR70IwHcPjGU9p4KQofI+J1H
nOECxQvk0NqVJHJ379DobQrKxba5VRGQXv4v7XPjoweKWfV0dcpinsbdqdH/vK2/
mMkk0KlR5r+xgQG85qczunrfuHH7ccs8vo4JDWeePt0+qCWKSmQVdOPJywbYXxfv
e3X4Mlp8oUfryjE0rojX2k9u+IaCJF6hemHalK5MZG8YG3hlMCLb1r8A9QJphPrm
808aqDBKo7yxSrW/ORHJ
=oCcf
-----END PGP SIGNATURE-----

--=-YuHlLVnEU1YE/tEmMu6X--
