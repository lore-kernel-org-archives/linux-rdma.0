From: Doug Ledford <dledford@redhat.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 06 Feb 2019 15:14:33 -0500
Message-ID: <671e7ebc8e125d1ebd71de9943868183e27f052b.camel@redhat.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
         <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
         <20190206175233.GN21860@bombadil.infradead.org>
         <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
         <20190206183503.GO21860@bombadil.infradead.org>
         <20190206185233.GE12227@ziepe.ca>
         <CAPcyv4j4gDNHu836N4RfgQsE+eZU9Wt0N9Y09KQ43zV+4mK-eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-iM5a0EW7HkLiEIH1y20B"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4j4gDNHu836N4RfgQsE+eZU9Wt0N9Y09KQ43zV+4mK-eg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org


--=-iM5a0EW7HkLiEIH1y20B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-02-06 at 11:45 -0800, Dan Williams wrote:
> On Wed, Feb 6, 2019 at 10:52 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > On Wed, Feb 06, 2019 at 10:35:04AM -0800, Matthew Wilcox wrote:
> >=20
> > > > Admittedly, I'm coming in late to this conversation, but did I miss=
 the
> > > > portion where that alternative was ruled out?
> > >=20
> > > That's my preferred option too, but the preponderance of opinion lean=
s
> > > towards "We can't give people a way to make files un-truncatable".
> >=20
> > I haven't heard an explanation why blocking ftruncate is worse than
> > giving people a way to break RDMA using process by calling ftruncate??
> >=20
> > Isn't it exactly the same argument the other way?
>=20
>=20
> If the
> RDMA application doesn't want it to happen, arrange for it by
> permissions or other coordination to prevent truncation,

I just argued the *exact* same thing, except from the other side: if you
want a guaranteed ability to truncate, then arrange the perms so the
RDMA or DAX capable things can't use the file.

>  but once the
> two conflicting / valid requests have arrived at the filesystem try to
> move the result forward to the user requested state not block and fail
> indefinitely.

Except this is wrong.  We already have ETXTBSY, and arguably it is much
easier for ETXTBSY to simply kill all of the running processes with
extreme prejudice.  But we don't do that.  We block indefinitely.  So,
no, there is no expectation that things will "move forward to the user
requested state".  Not when pages are in use by the kernel, and very
arguably pages being used for direct I/O are absolutely in use by the
kernel, then truncate blocks.

There is a major case of dissonant cognitive behavior here if the
syscall supports ETXTBSY, even though the ability to kill apps using the
text pages is trivial, but thinks supporting EBUSY is out of the
question.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-iM5a0EW7HkLiEIH1y20B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlxbQCkACgkQuCajMw5X
L90c/A/+ORaYm+JkAbD9YzCrqjaXuhjfRvV3aIYRdbQQBw6u5vGkXkwa6ewT3pnQ
AVpOAQbs9+tagP1vO3wpEP7cczuX8X+U61Apq7Hsx7mYw2LbiSzao0V5vRwdtpVW
VJvZqWEEpangAVaFedNY/pvYpZeL9jCeJ2WGynJEqcrIAOETnXCt7EQA0+m3kQkT
olCDbfcgQnpmzz3VhSe5ePVdMsAnEZp7182n11kBC9n1+MiRd+OEw6+jZ1b2Xor7
Ouf4A+8ZGCC/PWggLNGLeqXZYCjGLjXLrygnygCjUvbuQLF174Zs6Dchpk4QOIVL
+97WuqChjAoef4zhF3fp3LGa+XIXMtrzESG/G6hikUptNYHn4xvwnirxqoIBaK24
gEyksTqPkwYMEwz4t7ZF7+Ged3AeXAMl1mUYkbPIyuKHI0v5bncjkjtxsPCfvFel
rVuCXxuAUIG6p3T1RZhBCfeWnQeVrAIPp5vRDlheUc6JWxTDUn5XPJbsSVbCG8/K
wjIAadfJlGiYxvYdPRkAoNuFyMugRKQ2UiXD1bahPVoDYy9USkGlMO5+KxhUcP6k
pfat3AOPOA7aspZGgBYdVFMk0xAeL+qyarXPG/OcHPX/aGA4PdB5baxCpb//fuKe
6YJuhcW3xLXHDk/y6J+PQ060h4RY9bIDK5oozPIx84BYEEaWVzA=
=li/D
-----END PGP SIGNATURE-----

--=-iM5a0EW7HkLiEIH1y20B--
