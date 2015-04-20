From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the target-updates tree with the
 infiniband tree
Date: Mon, 20 Apr 2015 14:29:41 +1000
Message-ID: <20150420142941.766b4015@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.VlFmj.=a6.JCjz/vpipwQw"; protocol="application/pgp-signature"
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

--Sig_/.VlFmj.=a6.JCjz/vpipwQw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

Today's linux-next merge of the target-updates tree got a conflict in
drivers/infiniband/ulp/srpt/ib_srpt.c between commit 9f5d32af09b9
("ib_srpt: convert printk's to pr_* functions") from the infiniband
tree and commit 9ac8928e6a3e ("target: simplify the target template
registration API") from the target-updates tree.

I fixed it up (the latter removed some of the code updated by the
former) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/.VlFmj.=a6.JCjz/vpipwQw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVNIC6AAoJEMDTa8Ir7ZwVQ/kP/R0kLVtpcrDb7ZaBUNwcM4RO
haXCPUVv/lCPhNSFOjnZfe4Mw8eL2qVke1QPnowWBYhcDdTVYk4chNnH4X58t4Wq
ozsC2wSAluY+yas+U8XYvDA2JdAR39Zgo9hKZOl4e4d/H10DbyNiVnYwweLHen6U
xwzN51MmEPSZvoWhF79jQUu354qoNY2jz1t1RtfrdeY/YRRqyAWsTLKg8ExmOCPS
MABUJ+D16AqGMRVXKyfChB6g8SMLxoWXRxgHIX1x6jMEokYhvYxLZqSWK5UUMO0D
M57aYRy/XtTFIOrmvpTNsXLZ0QmoapVGdm16ynL7vc8diQIYLjpwf+mqPvz6x0Pu
aC+hAst2Pkzx806KI61jJzOsu8+FS6Lfd4rxBuvcVyyH7WXTkysamn/tsomiI78p
hVggwRCVr3BztfTpcQWynxyizGYOIWqLi3MUw+Czh1tNjJL2iyWq8PUYdS8KYZdI
gWa3zu2hzffOtwwStIMZwvU0F0QHYxhpvjpR3mzB/ruhv30hnOfhfHIfhtuJKgJ2
POo7KeW7R7wGct/zPeu29CYCTxYAyKPPo+x/42hFp+f+dN9/N1QcezODBVtw/COj
Sc8xzrcvxDmvN1P0GqLwkU3Q6AH1NRvn05h1jHm1PMemGFjEctXT7xLXlBrGOZ3l
vmDWUCq5VsriH22TPgkd
=ZG2k
-----END PGP SIGNATURE-----

--Sig_/.VlFmj.=a6.JCjz/vpipwQw--
