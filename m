From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Fri, 13 Jan 2017 17:15:07 +0200
Message-ID: <20170113151507.GR20392@mtr-leonro.local>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-2-leon@kernel.org>
 <1484246776.123135.19.camel@redhat.com>
 <20170112193508.GO20392@mtr-leonro.local>
 <1484258308.123135.41.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4dIe/AmYstFUGHTF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484258308.123135.41.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4dIe/AmYstFUGHTF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2017 at 04:58:28PM -0500, Doug Ledford wrote:
> On Thu, 2017-01-12 at 21:35 +0200, Leon Romanovsky wrote:
> >=A0
> > First of all, thank you for fixing wording, for me it is the hardest
> > part of every commit.
>
> No worries.
>
> > Second, I have a different view from you on the issue. User
> > configured
> > some value, which is not correct for IPoIB. In ideal world (without
> > legacy),
> > we were supposed to return error to him with proper message,
>
> If you set an impossible MTU on an ethernet adapter, you get a return
> of EINVAL. =A0But it doesn't mess with the kernel log at all, it's *just*
> EINVAL to the calling program.
>
> >  but in our
> > case (legacy applications) we can't (we tried and it broke some
> > legacy
> > ifcongfig, if I remember well).
>
> ifconfig is what I used to test what Ethernet does, so it should be
> well and truly used to EINVAL as a return.

I'll recheck with Feras next week which legacy tool
didn't work and will post it.

>
> >  So it leaves us with one available
> > option is to warn user about improper value.
>
> Even if you want to alert the user, there is no need to warn. =A0Warn is
> reserved for something that is a serious error or condition, this is an
> EINVAL of something that is, at best, a performance issue. =A0Unless path
> MTU support is broken, failing to set a larger MTU will not ever hinder
> actual operation. =A0So we should never be dumping out KERN_WARN messages
> into the kernel log that will ping up on any root login session as well
> as clutter the kernel dmesg output.
>
> > User should know that he supplied wrong parameter.
>
> User can still find out, they just won't get proactive pings on all
> root sessions, instead they will have to look in the dmesg output
> because they are trying to figure out why their command didn't work.
>
> > >
> > >
> > > --
> > > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > =A0 =A0 GPG KeyID: B826A3330E572FDD
> > > =A0 =A0
> > > Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57
> > > 2FDD
> >
> >
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD



--4dIe/AmYstFUGHTF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh47vsACgkQ5GN7iDZy
WKcRGA/+OoOsEIeP6/y74NS9HOBoprD95IaKFpmmdosjLamWIhodUyKRBjBGC95e
E1TPv8bBJA4JePIk5uKmVhuLZD0+GfmaFHcB1kK46mswyP/212gj44nNbyPPYo4L
HgsjlGBNH8vrlct2df87ozc3jPg/tuvvVemLYerzikDxe5M5eov+ffAeBOhphVX2
8jWK1c95TCIIHR/dGaB8Qm0rjxUTKIRnCAdeSghjLGyfQmkZQxhWY7B0bqb0VJTT
fc1dgR0Ou+TljtCdlZlSNGkYpY/hFYTmjUu+sChklHCNt+VtUDRW2sOB1VsodOkP
YuOY2jElj2i9aU3cSkFVq/V9wlb433BW4B1FKKS11QhQEoR/h7M+HBD6F7eWN7rh
m9OTeYb8N+OZUWAtsrh2nUum8GRyzIDI1dLYHut906xVPh1OxBQ4Xa8Yq8tlshf2
Y5MyBKTQkAl3eOJVA53wj70EWgE6cuFpGxc8o/EvoCIPz/vyVyp8WbpLqfNsO12X
van67Jc4GRh4wE+uZrrSNMTZy4dUL9BYqWiOLqKxac7xjzE9Pa+XLHiG0f1cTQ8l
+7YpoqWCdCN5hgSBNdYsvqln+uG8zw9W06ZrW02JTMxbaoBmKTAv4BkQZdQ2DKMJ
2xodLDPEUY27bF8i1a8nfVjA+193AqHvLzssNNjmjjW48jKthko=
=4/S6
-----END PGP SIGNATURE-----

--4dIe/AmYstFUGHTF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
