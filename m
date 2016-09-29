From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
Date: Thu, 29 Sep 2016 12:26:48 -0400
Message-ID: <57ED40C8.901@redhat.com>
References: <20160923041340.GA11269@obsidianresearch.com>
 <20160929160053.GA11879@infradead.org>
 <20160929161659.GA774@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="tTI1u5tG4497WX9Pxh70tJKj6fgpWkCF3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160929161659.GA774-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tTI1u5tG4497WX9Pxh70tJKj6fgpWkCF3
Content-Type: multipart/mixed; boundary="surALNcnGeeBfslgfe1Qm742kOWQxrOfw";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Message-ID: <57ED40C8.901-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
References: <20160923041340.GA11269-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20160929160053.GA11879-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <20160929161659.GA774-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160929161659.GA774-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--surALNcnGeeBfslgfe1Qm742kOWQxrOfw
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/29/16 12:16 PM, Jason Gunthorpe wrote:
> On Thu, Sep 29, 2016 at 09:00:53AM -0700, Christoph Hellwig wrote:
>> Hi Jason,
>>
>> any chance you could simply follow the modern debian copyright file
>> format:
>=20
> I was thinking about doing that.. But choose not to for this first
> draft.
>=20
> 1) I'd have to go and unwind on a file by file basis exactly what
>    every licnese is. Right now I've just done a survey. There are many
>    copyrightable files with no license text, and many potentially
>    non-copyrightable files with no license text as well. All that
>    needs to be figured out first.
>=20
>    I would like to add at least short license headers to every file.
> 2) It seems to require listing the copyright owners for every file,
>    this is a royal pain, IMHO. Many copyrightable files do not have
>    copyright data, so it would have to be mined out of git. I have
>    a script that does that someplace..
>=20
> My thinking was to start small, document the survey results (and agree
> my interpetation is sensible), then work on achiveing full copyright
> headers, then use that to build the debian format.
>=20
> I'd appreciate help, eg patches moving toward #1 and eliminating the
> free COPYING files and unlicnesed items. I think it will take a bit to
> get there, I still have a bit wack of patches to get applied on other
> topics..

I just merged a pull request of yours, and that was the last outstanding
pull request in the github.  I still have to sort through patches on the
list that aren't in the github interface...but at least 20 or so of your
outstanding patches were taken in today.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
  Red Hat, Inc.
  100 E. Davie St
  Raleigh, NC 27601 USA


--surALNcnGeeBfslgfe1Qm742kOWQxrOfw--

--tTI1u5tG4497WX9Pxh70tJKj6fgpWkCF3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJX7UDIAAoJELgmozMOVy/d8XkP/3igb+DOlGWNreFsrGtAyy5l
qEfL+Rnn19OKnQGy8p0uJDBXnKD/AvJz9+3Q+l4EHBVnRBCKRCQP9KWJnxdhvebS
EtagI/zk6wnBkxLHj/qcq8eJ0JSv/b9CvbQNrPHOSGm7FbZOSPB8Q1kbUKh7Yr5y
kNQL7lx1S33Cc/gNY9i/sSDNYBLDrwyfe+dektrSP3wcZK4cqkHEno7n0ylRgUe5
q2lfkeYOlS0UTEYz+4UoYiQ9otqB3iiWOHh5F5RvJqbcPBDe4k71UHpncCX+zRtW
zZTyjHtHJaMvO9ZxT4JVg1r+vsoUlCBIa3q0N1A+9EBANh6IriJp47/tz44+6Vt9
2ADo9KF13X3Yuz1Sd3d6yGVpcRwzDdSxteWJNt25CGsz/BUtz5JvwUzaZ94Atzvz
87ZophCd3zpuyKySLrL6gC0Eqbyfj6jLHyxoZFHcEGbbWJVk9jexUNfsqm5y93ZU
/xaQ9jUch0YLLXgx5mB77iKa2LLCAKx7Kmqp0MaIHovsNp3cqmRGgH574NH1/97m
Z0QJrgAAZaHJyerUJ1yaKl4ZAljekuTT9wCI6tacGph1jemticE7Z31kTMHe8p5B
KJfAhMrTKW2CwDxOSuQTTVj/vfrWqmJOrUUy06IrRNICW6qLLmIMyEQqxOeQ12Lq
Yod9kcp2zjSH4+/RVLSy
=1dWC
-----END PGP SIGNATURE-----

--tTI1u5tG4497WX9Pxh70tJKj6fgpWkCF3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
