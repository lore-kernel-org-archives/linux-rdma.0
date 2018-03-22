From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: WARNING: ODEBUG bug in process_one_req
Date: Thu, 22 Mar 2018 15:20:31 +0200
Message-ID: <20180322132031.GC19440@mtr-leonro.local>
References: <94eb2c0bc3aa8b2432056623c735@google.com>
 <20180322124823.GB19440@mtr-leonro.local>
 <CACT4Y+Ya8iMgV=7YGgsO2XnusF9tnGcHHPF5U5oNjQz_eJ+vMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7tuoKvP21MOB3sJS"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Ya8iMgV=7YGgsO2XnusF9tnGcHHPF5U5oNjQz_eJ+vMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+3b4acab09b6463472d0a@syzkaller.appspotmail.com>, danielj@mellanox.com, dledford@redhat.com, Jason Gunthorpe <jgg@ziepe.ca>, Johannes Berg <johannes.berg@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, monis@mellanox.com, Paolo Abeni <pabeni@redhat.com>, parav@mellanox.com, roland@purestorage.com, syzkaller-bugs@googlegroups.com, yuval.shaia@oracle.com
List-Id: linux-rdma@vger.kernel.org


--7tuoKvP21MOB3sJS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 22, 2018 at 02:10:21PM +0100, Dmitry Vyukov wrote:
> This bug is actively happening several times per day, if such bug is
> closed syzbot will open another bug on the next crash.
> This bug has a reproducer, why do you think it is invalid?

I tried to reproduce it on latest rdma-next and failed, so wanted to
start from clean page and see if it is still relevant.

Does it still reproduce on latest rdma-next?

Thanks

--7tuoKvP21MOB3sJS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqzrZ8ACgkQ5GN7iDZy
WKclkBAAwPKo8/Lh9UMrvAxPlQ4Eh3biXU4AyZhsRhr3xfH6AnuGF8r4KCVZSQbB
hPYadrR94Cux0P6AeZmQ3dZvEKY3SiJTWmqlaNja1syeWB3Csr1WTMtxeiWfUkBp
jAlZJOIDMjicKkBB3ivzn2tGiCSWTsT00C73c792WBuswNLNXxSPceegTiEot4vQ
3F/nLi0JzcMexJUMuxJ5i9UexdgjNhdsTiFbqd1zsY/Qfnozox5BPqcgULHfpsb3
KBqAgi2K1ERTEZbAtqMJk2tjGPRfixc9wlZgVkCKlbTMmKJ+4ekbn5VTZ8QxZYlg
vCHiz3YuLQNGTcEKQ0HU3YY+KHtMxaSfEdasLCxTHaPBydWykxfWYKSbXKwQFrcj
HYzGuWeWo7ZPEDLIaoQU6GTyUCbv/dAqmshgaIzPsRgjkDV3HDZZt/pkV6I9F1ID
GvKJjYAcr8i37SCea/S1azqufVE2c0nlESDlWUG/2bJ4x/AmoR3NRlMrGn+uiOa1
RI3O0RAv2lIUZ/vFoltEm4O7fJyGtMj7ZtoJsdgN+JVhibg41hcj6hO2Ar7OG6/h
DQw/CPP51kHAAuq/4wxMvngoCEigkwTkSIbhlPP8XZgW8CwQ2GUpMRVEbx+w/XLQ
nRwBXYk+sOrpmMyV4lKpGFi+pC3o5E0dwEeBoojwa5lZ4rmdc0A=
=DYdL
-----END PGP SIGNATURE-----

--7tuoKvP21MOB3sJS--
