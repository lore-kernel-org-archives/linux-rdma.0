From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Fri, 29 Apr 2016 19:38:28 +0300
Message-ID: <20160429163828.GD774@leon.nu>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
 <5721F149.1090004@grimberg.me>
 <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
 <5722C24B.6020108@redhat.com>
 <20160429051755.GC774@leon.nu>
 <a1d504ff-716c-210a-7114-517577d2e0fa@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a1d504ff-716c-210a-7114-517577d2e0fa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 29, 2016 at 11:06:46AM -0400, Doug Ledford wrote:
> On 04/29/2016 01:17 AM, Leon Romanovsky wrote:
> > On Thu, Apr 28, 2016 at 10:09:15PM -0400, Doug Ledford wrote:
> >> On 04/28/2016 10:01 AM, Or Gerlitz wrote:
> >>> On Thu, Apr 28, 2016 at 2:56 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wr=
ote:
> >>>> On Thu, Apr 28, 2016 at 02:17:29PM +0300, Sagi Grimberg wrote:
> >>>
> >>>>> FWIW, I'd love to see ib_rxe upstream asap. In fact, I even have
> >>>>> some patches to contribute for it.
> >>>>
> >>>> We are planning on submitting it in very near future.
> >>>
> >>> So.. lets get this going, Linus made a comment [1] that we might not
> >>> go up even till rc7, which means there very little time left, Moni?
> >>>
> >>> On a related note, is there ANY patch merged for 4.7? Doug, are we
> >>> again going to have have it in
> >>> all-patches-merged-on-the-same-night-10-days-after-the-merge-window-o=
pened
> >>> manner?
> >>
> >> I have topic branches started.  The generic RDMA READ/WRITE API is
> >> almost ready to go once Christoph answers the last few things.  That's
> >> really the only one in queue right now that's big in terms of core
> >> changes, most of the rest of the stuff is all driver or ULP specific.
> >> The RSS patches haven't got much review yet.
> >=20
> > Doug,
> > These patches are long time here in mailing list and they were reviewed=
 as
> > all other patches in this mailing list.
>=20
> That's not true.  The RSS patches in particular tend to get no review.
> No one appears to care about them.  V1 was posted way back last year and
> no one had anything to say about them.  I don't know when V2 was, it's
> no longer in my mailbox.  Then v3 has been on the list for 12 days and
> again, no one has responded.  No review at all does not mean
> automatically accepted.

I'm a little bit confused here, do I need to stop reviewing other code?
So it won't be counted as "interesting".

For example, there is no many interest in hns, NES and i40iw code, what
do we do here? Maybe we should stop to accept it too?

>=20
> My slowness on the patches is that you are doing this in an obviously
> device specific way.  The only device that will support RSS this way is
> mlx5 devices.  But, I'm wondering if there isn't a more generic way to
> do this that can be done in the core or in the driver during WQE
> processing.  Maybe we can scale performance by having a more
> multithreaded process approach without resorting to firmware specific
> effects.  If that were the case, that would be my preferred way to go.
> Until I have the spare time to investigate if this approach is possible,
> it leaves these patches in limbo land.

What did you stop from express your point before?

>=20
> >> The SELinux patches are in RFC stage, and IMO should be shelved until
> >> verbs 2.0 API is settled so we only have one API to apply it too,
> >=20
> > SELinux code adds hooks which are deep in IB/core code and doesn't
> > play with ABI at all.
>=20
> They snoop ABI.  If they ABI changes, they would possibly need to be
> changed in order to continue to be able to read the elements.

Why is it different from other IB/core code? Once it will be needed, it wil=
l be
updated together with other code.

>=20
>  This is unrelated to ABI change initiative which
> > anyhow will be required to support existing IBTA specification.
> >=20
> >> --=20
> >> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>               GPG KeyID: 0E572FDD
> >>
> >>
> >=20
> >=20
>=20
>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXI44EAAoJEORje4g2clinNUQP/3u+yzkukpGMyg5j39MVRXEm
V3L8jk2vDp+leN52mheqbO+03aVM+xdeOVOLsUZvTLuhoFwJ5PTgu+Xm5oepyYK5
TUtPRfgjb83WxxhJAZVGlaTlaSqsmkg9rWd7Po40hZJiLAUOyTiQSVoZ/NdPvXma
8rt/I8tk4FcDELkQhJ6DaYFB/wi7memEzEvp/Ag4FX80stuv9eIFyXMbLBB5pzSq
n9q7k33NnOxuIRkICjeu2zgS971RYGig+YSr2Rmgz3fpm4Y+gXZLK0b9pH1e5H7T
eRoVydFCgAKj3eJeElHv/UIQl5wOaAYvIfPPssMaPNtk6PrmZxifDscMVZgB98Li
9oT0SiTs+5eY29du57BFToctE2Sff+0chpABfnpeE0QYquyLSpXBBwk0NhCVIamW
ZdstHlOd9JFrgRJ9eaXu5WV2qtwtYkICPcpd9SKo0pbjjssyNQ+BfWX4lXgSRwKb
3bBOApw6Ub5AUnCF3TbsrLcUbJn0CRu91LPufo6SIUi7UENKVUlMJATA9ZBEDZKh
8SAQV0PIGkK0FHFjFteNh8CThon47ZAOGJKln+t0HsWDwT2hShBdUpYKwuGFPw1+
UO0TI3CF64tOl0CCcGAHSF2twfqG2g25dEBxH0sz9W/LwDk8AkdBFaTxsBVJeSy0
qV6cwcLBR+nNjWTRUszO
=ToOE
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
