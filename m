From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Tue, 02 Jun 2015 10:53:08 -0400
Message-ID: <1433256788.114391.226.camel@redhat.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	 <1433098827.114391.179.camel@redhat.com>
	 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
	 <1433157904.114391.188.camel@redhat.com>
	 <20150601164322.GA14391@obsidianresearch.com>
	 <1433255724.114391.225.camel@redhat.com> <556DC167.5070205@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-cKuCqZwh29VPq5QsILiq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <556DC167.5070205-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-cKuCqZwh29VPq5QsILiq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-06-02 at 17:44 +0300, Or Gerlitz wrote:
> On 6/2/2015 5:35 PM, Doug Ledford wrote:
> > On Mon, 2015-06-01 at 10:43 -0600, Jason Gunthorpe wrote:
> >> On Mon, Jun 01, 2015 at 07:25:04AM -0400, Doug Ledford wrote:
> >>
> >>> attempted abstraction of ibverbs.  Passing in the wc struct allows th=
e
> >>> driver to internally allocate a wc struct with extra private elements
> >>> and pass that back to the user, when the user passes it back to
> >>> ibv_get_timestamp the elements are there in the private portion of th=
e
> >>> struct.
> >> wc structures are allocated by the caller, there is no option for the
> >> driver to create private elements.
> > Well, they *are* using an extended work completion structure.  Unlike
> > what I mentioned, where they create a larger one themselves, you have t=
o
> > allocate a struct ibv_wc_ex instead of a struct ibv_wc and then you hav=
e
> > to call poll_cq_ex, which expects a struct ibv_wc_ex.
> >
> > So, just so everyone is clear on this point: the current user space
> > implementation of this feature creates an unversioned, newly named
> > ibv_wc_ex struct that is ibv_wc with a 64bit timestamp tacked on at the
> > end (not 64bit aligned either).  If we ever wanted to have a different
> > extension to our ibv_wc struct, there is no good way to do that.  If, a=
t
> > some point, we had multiple extension and the user was able to select
> > which they wanted to utilize, this structure extension is not flexible
> > enough to deal with that.  At a minimum, if we are going to have a one
> > shot extension to the wc struct like this, I would prefer to see it
> > called struct ibv_wc_timestamp and there be a ibv_poll_cq_timestamp.  A=
t
> > least that way people would not use the generic _ex and assume this is
> > the one and only _ex that we will ever need for work completions.
> >
> > Jason, when the XRC and flow steering extensions were added to
> > libibverbs, you complained loudly that they were not added in the agree=
d
> > upon format and cited a previous on list discussion.  Do you have a lin=
k
> > to that discussion?
>=20
> Doug,
>=20
> Do we agree that this part of the discussion (and also the below point)=
=20
> are related to the libibverbs API to applications and not to the kernel=
=20
> -> user API to support time-stamping?

Yes.

> Or.
>=20
> >
> >> AFAIK, Christoph's use case is essentially the only meaningful use
> >> case for this feature, generalizing too much may destroy the
> >> performance that is valuable here.
> > There is actually room in a 64byte cacheline for two 64bit timestamps
> > and another 2 bytes of padding or something else.
> >
> >
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-cKuCqZwh29VPq5QsILiq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVbcNUAAoJELgmozMOVy/dDc8P/08j0+OUnU9CwJQzRSDrE7Ma
u4LT8s6T9ql99z7llDBsG3Rbb0/0w/GPNYf8h5OJ8Z06tSioWICJ8rhpq4bE/44+
h8as4TlNy6kI6XNOjcUnfEof2iXc5yOdQTRRVK/dTLiOfyrUiZqwSGCFU6DHjTHQ
J3iv9v7JApxiYXi4HpO59KTHYmkevGgwCwR8I0L2TpXHRu5yTlYpFsPsCIT6pSV7
C1kb5lci8f2asfntBMYr7FGF0UfitIUe+7hPwCon7Ss1mDBrjRAUi2mNpP7btDWq
CP8khA1B86Gh8EETkhkgEwFSKm+NfrQeif2OVI3hymJ2zPTTACcT1WKfvYIJ1vq+
iFW2rVZnLWD6pAeOHOVd0oC/te7AwH6vpblGn8SQW7BSsmE3zhS0CknvpYtpg/sc
AOiLXSn77eh63DvQNjA/i1eFvgUouhotYJ+BBX2sdGKnmp692mRFZ8dztJ2jfthr
jeS74hz2uLCQUybhL8lUfxM3eIIHVyLLKyUGRu9OsfdJIXCXsojFK9FaP1SUqtvI
aqrnRZ6xKasp7M/o3r5Mej+j1mIuS2LInpq6YlZ1GDFzFYctHCfaX1i4SrhsdtwW
BYib442DbbY3qA/GLTPT2ud/lOwX2Z3WqOPzqpZn9wWNT8lO/ey2RgFayrc1Ufnq
argfjHDshE2NtvCDuGur
=4sVb
-----END PGP SIGNATURE-----

--=-cKuCqZwh29VPq5QsILiq--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
