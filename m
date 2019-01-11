From: Joey Pabalinas <joeypabalinas@gmail.com>
Subject: Re: [PATCH v4] coding-style: Clarify the expectations around bool
Date: Fri, 11 Jan 2019 07:29:40 -1000
Message-ID: <20190111172940.zufmrhvukqo5hkat@gmail.com>
References: <20190110234805.GN6890@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zp7lkj5ihh2r6cwq"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190110234805.GN6890@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Joe Perches <joe@perches.com>, Gal Pressman <galpress@amazon.com>, Bart Van Assche <bvanassche@acm.org>, Stephen Warren <swarren@wwwdotorg.org>, Tariq Toukan <tariqt@mellanox.com>, "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Stephen Warren <swarren@nvidia.com>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Joey Pabalinas <joeypabalinas@gmail.com>
List-Id: linux-rdma@vger.kernel.org


--zp7lkj5ihh2r6cwq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2019 at 11:48:13PM +0000, Jason Gunthorpe wrote:
> There has been some confusion since checkpatch started warning about bool
> use in structures, and people have been avoiding using it.
>=20
> Many people feel there is still a legitimate place for bool in structures,
> so provide some guidance on bool usage derived from the entire thread that
> spawned the checkpatch warning.

Hey Jason,

I very much agree that the bool expectations could be much clearer, and this
patch is a nice step in that direction! Just a couple small nitpicks:

> +Do not use bool if cache line layout or size of the value matters, its s=
ize
> +and alignment varies based on the compiled architecture. Structures that=
 are
> +optimized for alignment and size should not use bool.

+Do not use bool if cache line layout or size of the value matters, as its =
size
                                                                    ^
                                                                    |
Adding an "as" makes the sentence flow a bit cleaner: --------------

> +into a single bitwise 'flags' argument and 'flags' can often a more read=
able
> +alternative if the call-sites have naked true/false constants.

+into a single bitwise 'flags' argument and 'flags' can often be a more rea=
dable
                                                              ^
                                                              |
Missing a "be" here: -----------------------------------------

Ack from me after those two corrections.

Reviewed-by: Joey Pabalinas <joeypabalinas@gmail.com>

--=20
Cheers,
Joey Pabalinas

--zp7lkj5ihh2r6cwq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEENpTlWU2hUK/KMvHp2rGdfm9DtVIFAlw40oMACgkQ2rGdfm9D
tVIt6w//YCX55pUgnakyxl8AEZJg8IeJW725Pj9QA04LY0CaNZ/uRhxvw4IaOTUq
svXR3RxqEd+B/GMo5WIokxdlPtovU3tbccda3VX14LXKW7J9KMSR5cMdoq7pxCKX
SuvmDdgU9lF2AiSBF7+46DohL7ENd67wPFswwCcVBfPfNVX7RucfmnXMGZwhiTFF
fgNjRxsCS4DOVj7Ps9rblhIk3PmSKglTiTu83H9mx3h5AmF5Rd3Rsf9dy2mSYevp
0NWojWI6+6y2nV4gA9KIo5lW2RutlClpLAmxUMhiQWlQLka2ZUbUI6AlCDwmNnqz
iyW0QtLNvnSvfgTcbG6gmaHGn5YKCGRB+FZuWLV7igwJLfr7f2lzZgtU2BXZaGnl
ys6+Ul2x+I0E/ZfqpBcfu0G3lSpTiMLmCRNBSzkEbZjqn/n05cvuHVGUEEELWBq7
foyg/g5rkjhqEPoSJqaVIn1ngRyMRvAcRdOgOCmn6sidSs21QsZprh4nBGqcio2y
dt0DSaDSvZZoFaJJwIFT2XHOGUy2X30/CCMb67JrNLav6u4fIYPk1bSUL4YEgjoY
1n5tfDv/Fpif1JMscsQvryM4XegLkjTAq/fRx4QmB1PWuqVktlTDZnuGNEo3o0kD
MdBnYUPp51nMlL60JsVoZF+36VOU2QvrLuLxTN8uKxh1YOtR0ck=
=p1Hy
-----END PGP SIGNATURE-----

--zp7lkj5ihh2r6cwq--
