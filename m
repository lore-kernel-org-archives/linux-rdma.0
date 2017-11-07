From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next] IB/core: Only maintain real QPs in the
 security lists
Date: Tue, 7 Nov 2017 20:40:17 +0200
Message-ID: <20171107184016.GO18825@mtr-leonro.local>
References: <20171107163326.23881-1-leon@kernel.org>
 <20171107164632.GA7063@ziepe.ca>
 <065e66ff-e901-bd5c-674d-173eab720989@mellanox.com>
 <20171107165539.GB7063@ziepe.ca>
 <87a902ae-351b-43c4-4a42-b362c981a767@mellanox.com>
 <20171107173215.GD7063@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2O+9B+xSKalj/wdD"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107173215.GD7063@ziepe.ca>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Daniel Jurgens <danielj@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--2O+9B+xSKalj/wdD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 07, 2017 at 10:32:15AM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 07, 2017 at 11:15:12AM -0600, Daniel Jurgens wrote:
>
> > This flow is through ib_modify_qp, it's not user space specific. If
> > it really pains you that much it can be changed an inclusive compare
> > instead of exclusive.
>
> There was already a RFC on re-purpsing those constants and exposing
> them to user space.

It pains me, the flows of create_qp/modify_qp are completely
unmaintainable mess and I would like to see more explicit checks, so
refactoring will be easy. We will reach that step much sooner than I expected.

Thanks

BTW, I spent last day to annotate all different paths of create_qp for
the resource tracking information.

>
> Jason

--2O+9B+xSKalj/wdD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloB/hAACgkQ5GN7iDZy
WKf/dhAAls+p2o5ORMJZIJ6SZ6puq4krQpiVStSmHZ8bGrua7DwvGX+eCirlrhEE
tgMEFNpyMa/LAn6mzSPDmdTzknpfxcWdn7krl/4/1ywKC5dFzvJbtEStYo4gTbec
3BpV04deDfVyRm1AtoT5x15D5XA5S0Ronvo3kiD7xxP9Cipdp599q1iC2L6O1pai
yyx1pZ0bLEqKV/3ffPKt5V5d+18lRel5d9MW8XAS4Tcwus5AX8qbYa0XoW/yzkQL
gzs1rq1341PDnoJiL/xbKVZWkoVcKnKLQiZ566MaOIBkF2LSHlsVNjrJ91twTywC
+5e5TXTj7M+BK93qB1WTHJoPuwAvrIQnAy0jMDcTCzXtXbJHQ96hgeKL2P5WAt4h
c8f9jvtOMB+Nnwn4eum4af9YnfT4653vQjlgYwk60MYEUILsX44zFc0yeyez6Bko
pdxN9fVpBjV+xAVhAH1yxkM2UhlYrgMTnrZfUSo9joUApHPME5O560wyP2WzWxGi
RILoII98Pir1HagOMS2UgXDG/q7tSuY0r/JpB2HRZwRR2BYlWDpq/OYmNh7QJFia
nRZd8nuaQtqnfvCQsON6ZoWfNdWWGfqZ7dvgRykFlYMGB6nCb0IWx67tw97WS0Sz
MrnhnDUsqkUp9o221Zx7B4s2S3AVN+v+NCkfHdOP7ae+0QjZuhE=
=LGRH
-----END PGP SIGNATURE-----

--2O+9B+xSKalj/wdD--
