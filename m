From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Sat, 16 Apr 2016 00:23:28 +0300
Message-ID: <20160415212328.GF10689@leon.nu>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160415040126.GB10689@leon.nu>
 <20160415161754.GA21549@rhel>
 <20160415173035.GC10689@leon.nu>
 <20160415173401.GA10868@infradead.org>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/QKKmeG/X/bPShih"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160415173401.GA10868@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--/QKKmeG/X/bPShih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 15, 2016 at 10:34:01AM -0700, Christoph Hellwig wrote:
> On Fri, Apr 15, 2016 at 08:30:35PM +0300, Leon Romanovsky wrote:
> > Great, did you show it to other RDMA stakeholders except Intel?
> > I saw nothing posted on ML or proposed for initial discussion, which
> > will be held in the next week or two.
>=20
> I fear it's kfabrics, which is an entirely crackpot idea and a total
> non-starter, but for some reason Intel and their buddies keep wasting
> time on it.

It is a different thing, during OFA16 conference we were **strongly
advised** to move from old read/write interface in RDMA stack to
something else.

The agreement was that a couple of weeks after the conference,
Liran will organize open web meeting to discuss what we want from
this interface.

It is important to make it open, so all participants will be able to
express their willingness.

Intel as usual decided to do it in their way and the result is presented
on this mailing list.

Thanks.

--/QKKmeG/X/bPShih
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXEVvQAAoJEORje4g2clinFWoP/RDfTOaq37s2J2mgxt98UHv/
sx2rQazne8arMbcJegKVBOApKd7CwkGv+/7LBZsh3O47Fp2tNvJZW5E1CPKsaOtz
G0rLuor+5g/98qoASM6qEIuotYGJUUKv77l7xhmeT2auslF3rA8cXGk9ZEdkY5Zr
6Kqo03ObzlCt/LAiqsr57iOj5P1I1kcnysCxtNLxI1pTik4BVEBBOUhgavrDjI3M
9wGCG2Pi2jS5H5pa9/BhUPkkSE8chdY3IxK4yI/GZBGOnxRmmYlmaADhCfgssJLN
xcBOr3SdypzUlRV+y1p+5hqt45JoUZqUwLX3SsBksGVzdcZedutPkVO48/AKiWKo
eFRmTR04uWqG7bWa6fvyCCbhfEcDTTwSQ1vfNJ9ndGnhPjdKb/u5n6WOTTrW+wZh
B1xkTJv1Rwf9XfAXjuIbQY6I2DC+l20gBNVUyoqL7SfWIGCIAE7ZuUxEHYlRIwRf
Mhhjag40Pp/J4q25qDuxzNR3x5leJUr1YZtnMfHWnVJI82QemrKMG4Fmufq/hHVv
Sigr48HmYZjmF6oeIYWi6QReH9X1qkmAay/TP4aUtEerVQ8T5hWo+H1hQAfz6XKl
BkRz4WSdrG2cD66ft552sRm2v2lyEUzWlLh9MkR1YMgM67FFd3xELbLKySkpC8bq
XtK7IUXu6iDIQ3ORMOjO
=CX8n
-----END PGP SIGNATURE-----

--/QKKmeG/X/bPShih--
