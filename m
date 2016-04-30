From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Sat, 30 Apr 2016 10:28:47 +0300
Message-ID: <20160430072847.GB25593@leon.nu>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
 <5721F149.1090004@grimberg.me>
 <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
 <5722C24B.6020108@redhat.com>
 <20160429051755.GC774@leon.nu>
 <a1d504ff-716c-210a-7114-517577d2e0fa@redhat.com>
 <20160429205434.GA11286@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160429205434.GA11286-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 29, 2016 at 02:54:34PM -0600, Jason Gunthorpe wrote:
> On Fri, Apr 29, 2016 at 11:06:46AM -0400, Doug Ledford wrote:
>=20
> > > These patches are long time here in mailing list and they were review=
ed as
> > > all other patches in this mailing list.
> >=20
> > That's not true.  The RSS patches in particular tend to get no review.
> > No one appears to care about them.  V1 was posted way back last year and
> > no one had anything to say about them.  I don't know when V2 was, it's
> > no longer in my mailbox.  Then v3 has been on the list for 12 days and
> > again, no one has responded.  No review at all does not mean
> > automatically accepted.
>=20
> During the Collab summit I thought we reached a rough consensus that
> these sorts of uAPI changes to the common multi-vendor API would go
> through a more rigorous process and those who are proposing them would
> actively seek a multi-vendor sign off instead of simply dumping them
> on the list. Liran nominated himself and the OFVWG to act as a
> forum. I recommend we let that process get going and do it's work.
>=20
> Further, I also thought we reached a rough consensus that we'd shunt
> some of this stuff to the driver specific uAPI channel to reduce this
> continual churn on the common multi-vendor API for currently
> driver-specific features. Drivers can implement their unique features
> and sanely export them through the kernel without so much pain. The
> uAPI 2.0 concepts from all parties have been heavily influenced by
> this idea.
>=20
> Certainly, if patches cannot attract any review or interest from the
> community as part of the core API then I'd say that is an excellent
> sign they should be shunted to a driver specific channel.
>=20
> There is more flexability in user space to make mistakes with the
> libibverbs/etc API, and more options to provide access to these kind
> of services. For instance I really wonder if integrating into
> libibverbs is really the right home to trial a broad range of brand
> new UD offload focused features.

Jason,
It is **respin** of patches which were with us for **more than year**, it is
enough time to all participants and maintainer to say their word.

>=20
> > >> verbs 2.0 API is settled so we only have one API to apply it too,
> > >=20
> > > SELinux code adds hooks which are deep in IB/core code and doesn't
> > > play with ABI at all.
> >=20
> > They snoop ABI.  If they ABI changes, they would possibly need to be
> > changed in order to continue to be able to read the elements.
>=20
> Agree, if we go to a object based uAPI then there may be better ways
> to make use of selinux right at the uapi layer.

=46rom user perspective, it will be the same, so please name me technical
reason do not proceed with them now.

SELinux patches are contributed by open source company who is actively
supporting IB stack by code and by following IBTA specification.

As I said before and continue to say again, we will invest time and effort =
to
update all needed pieces of our code to support new ABI whenever it comes.

>=20
> Jason

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXJF6vAAoJEORje4g2clinYNMP/iLlf+Uv07D2WAyHylJ0Bhjs
zt6an27iDyQ11kpvOCxZG1oqfmGHnlswPGxHDDD26EcEHq3nIQ2qh/x2jJX3LHtc
E57yqch4075VZ3jZ8XCMFjxZpmZUNfU2TQB7PiWPTcKd3ps3oXLFUKCaWt6pCgPr
vLGfaxe4fLXFCapGjLUPHVkgqn/XRT8JX9V6ESBXX/ySNIpJ6zjvV723K7oQ+GHc
WzDW6R7bhnJ/VoDG3ZssXiNiVpWPPmkKw4FCXbJK5jbUynSVh1BGPwKLnQhZCRlm
2l5D3tozyP9sAZt93wylmmZZM92w5iey6Kb+rRFv2JTK64ILu+t2c0DlXI4ByhMG
2EceXuYpAcAZ+m8Rvf/H9FU+UNUBK0eE+4nQXN+ht1sLEn5CYqZGXA1Zo+XIVF1V
uYM5Q/1m1xeA2lJrKapxQUfhkTl4KlmTwATA2Lhp4HZAMv2uucd4YZ5zbp6d46sZ
OvZaNhTDArl78hDdnjDzugGj7BzP16fhLJHgPVRLmKcCpFV4dwRo6pzNwfKgIAXr
f/Ohkr89m6+Faz7GSXghsnSGVRpmFl8zaHH/wnlKqdu0otbEwler+2A22W1SCav2
kVXfZTHG+7zJYfGPp5qHMYrcXtqFLnHlvhjcKQO7kjMC4a51qJ1UdtoeFcScTW++
EO2CopG2hyHhrRwL3HDa
=GcmY
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
