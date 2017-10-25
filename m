From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Wed, 25 Oct 2017 22:06:08 +0300
Message-ID: <20171025190608.GX16127@mtr-leonro.local>
References: <20171024123957.32207.70888.stgit@phlsvslse11.ph.intel.com>
 <20171024144152.GH16127@mtr-leonro.local>
 <14063C7AD467DE4B82DEDB5C278E8663875E153D@FMSMSX108.amr.corp.intel.com>
 <20171024151958.GI16127@mtr-leonro.local>
 <14063C7AD467DE4B82DEDB5C278E8663875E15AD@FMSMSX108.amr.corp.intel.com>
 <1508957840.3325.54.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oAjj1ZwgLg4oRN9q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508957840.3325.54.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--oAjj1ZwgLg4oRN9q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 25, 2017 at 02:57:20PM -0400, Doug Ledford wrote:
> On Tue, 2017-10-24 at 15:42 +0000, Ruhl, Michael J wrote:
> > > > have the same issue.  Specific index validation is needed, and
> > > > should probably
> > >
> > > be
> > > > addressed with a different patch.
> > >
> > > .doit exists for RDMA_NL_LS and for other .dumpit exists, so no
> > > actual
> > > check is needed.
> > >
> > > if you want to be on the safe side, please extend is_nl_valid().
> > > IMHO,
> > > it will keep code cleaner, the checks in one localized place and
> > > execution
> > > is not mixed with the validity checks.
> >
> > Leon,
> >
> > I do not disagree with you on this.  My patch is to fix the Oops, and
> > make
> > sure it can't happen with the current code.
> >
> > Extending is_nl_valid() to be more complete seems to be out of scope
> > for
> > the current issue of making the Oops go away.
> >
> > I can probably work on is_nl_valid(), but I will need much more time
> > to make sure
> > that it is correct, and don't feel that I can get it done with in the
> > appropriate
> > time frame (i.e. sometime this week).
>
> I agree with Michael that tweaking this code to be optimal versus
> plainly failsafe is a patch for another day.  I've taken this one.
> Thanks Michael.

Too bad, you actually suggested very good solution, it is unclear who
will now implement it.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--oAjj1ZwgLg4oRN9q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnw4KAACgkQ5GN7iDZy
WKdseA/8C60RBSm18Of8Q7+DLWJixHqP1cvTHFjwXrWZbfMtZPXPL1BOTVGg/sj3
8VAdQWTllQUfmZSFEEfVPp9g52VA03RNPe2gdHTlDgFgszZmfaxPSq4rWoZzR0ae
aH0zm6zdOu5CZFkZ6cX1v31zc8s0YYI0ONKWUrWUn+NDEM6u6blqkDir9b8i/Qf+
GJihC/qH2YEDFA9fWelwNhtwljGoHme7ut+8dbckJCibZbBbpcK8YxuDh3XZ4SXJ
B1tjNGpmYbQhp/OS+VBChnv4fhP6lG6BuzrpP5xLvRTP+OGzAW5ljqbKErMvea4S
KKfrwdE+xM5+XAx6FNvsoHQSuRk5kUQZ2UcynTBF3Wk4A6yGTaqQBRXG4mlcDx6F
ejN6p6dR03ItawPlvABrj0Mj+zxLMg0w5buu+U26LVbORZlTe2MOz55NF8fPV1ig
UHJZF0zAUx8bduiXQ9/zoPwY+jet8AFF8mhhiIZFp/IL1qQnNRgeXqa1e9XzOdhZ
aTuOvfhnjKahcdPbG6QLNG6RqUs8uVZCCoI2zck6wtWscfP9/RBnGlnn8m3UCcls
Xxe/taYKHzHeg951eMU6Hx/hh39td4rezopBHmxg+JRqm0ChUnawxgWz9e7Hob+B
MzCfrUSGuN1hns6vqW/iq8ZcqX/IV9dPJKqCHV/QJOSCgcLzp6Q=
=+doZ
-----END PGP SIGNATURE-----

--oAjj1ZwgLg4oRN9q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
