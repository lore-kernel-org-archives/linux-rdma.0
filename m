From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] util: Fix check_snprintf to use __rc__ for
 local
Date: Fri, 1 Sep 2017 17:13:55 +0300
Message-ID: <20170901141355.GL10539@mtr-leonro.local>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1504212659-9674-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170901045632.GJ10539@mtr-leonro.local>
 <e10f536a-bad3-55b4-f3ef-207404209c89@suse.de>
 <20170901093553.GK10539@mtr-leonro.local>
 <dfa51066-0d39-5d31-c7e6-b2af1a6089a5@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RVlUGXxwBj5SDcM9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <dfa51066-0d39-5d31-c7e6-b2af1a6089a5-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--RVlUGXxwBj5SDcM9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 01, 2017 at 11:46:02AM +0200, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 01/09/2017 =E0 11:35, Leon Romanovsky a =E9crit=A0:
> > On Fri, Sep 01, 2017 at 09:00:01AM +0200, Nicolas Morey-Chaisemartin wr=
ote:
> >>
> >> Le 01/09/2017 =E0 06:56, Leon Romanovsky a =E9crit=A0:
> >>> On Thu, Aug 31, 2017 at 02:50:56PM -0600, Jason Gunthorpe wrote:
> >>>> To avoid clashing with user variables.
> >>>>
> >>>> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >>>> ---
> >>>>  util/util.h | 4 ++--
> >>>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/util/util.h b/util/util.h
> >>>> index cbf0deca2dde7b..30d32ee6b51e24 100644
> >>>> --- a/util/util.h
> >>>> +++ b/util/util.h
> >>>> @@ -8,8 +8,8 @@
> >>>>   * error */
> >>>>  #define check_snprintf(buf, len, fmt, ...)                         =
            \
> >>>>  	({                                                                =
     \
> >>>> -		int rc =3D snprintf(buf, len, fmt, ##__VA_ARGS__);               \
> >>>> -		(rc < len && rc >=3D 0);                                         \
> >>>> +		int __rc__ =3D snprintf(buf, len, fmt, ##__VA_ARGS__);           \
> >>> It can't clash, because it is declared in the scope {..} of that defi=
ne and
> >>> it is local to check_snprintf macro.
> >> It does if any of the va-args is called rc.
> >> This is "valid" C although not sure what printfs does print here (prob=
ably random stack value)
> >> {
> >> =A0int i =3D printf("i =3D %d\n", i);
> >> }
> > So how does this rename solve the issue?
> > Now, we can clash with __rc__ variable.
> >
> > Thanks
>
> There is no safe way to handle that. It can be detected with -Wshadow tho=
ugh.
> But rc is quite a common name (39 definitions in the code base), __rc__ m=
uch less (unused... yet)

Or commit message should reflect that it is not fix, but attempt to
reduce name collision, or the patch should provide real fix. For
example, create inline function and convert all 5 callers to use it
without ##__VA_ARGS__.

>
>
> If you want some real fun, try writing macros with local variables that c=
an be called recursively ;)
>
> Nicolas
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--RVlUGXxwBj5SDcM9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmpav8ACgkQ5GN7iDZy
WKcKqg//VR/iHSaMlrIvnY5V2p9SYV5ErrBMxLnsTYlh7TvLUIwA9o6Jo++VVQBA
GZz/Oyv4C1jvNFGk0+XNv6mQ8jaH9nVHfH552tbWnWRZ1zstwSFjLW+4ieZPwPRL
39dANY2LeHwqsBJw61BZ2lQCd0336nr9COHetqAaA55EGXBi88orM5oLrH0/bMRT
yMwLvAtshnJz5RvYqAtvMyCgyHZrbWQiQt5qwmA1WcLDCtgTHLLAtkNtJE/a2SJZ
oDW9zQjpFwpGaGtx2jJ2KR6CCRhdczEQEr2M8d5X9AzYiqUFi5kuBfz+37Wr8vVT
zvPJIOPR6MQ2MYD0JmC/4AVu3rzBou95lyb5Glzpud8ZhoXi6jqlnYJgwXtfVHZA
t6D9sZhgis8NEReOJOd4cvv3+oqWh4fNjcZ3fyb+app4I2JrUMkhNAgELfKmKfM7
onnNlHglO5dO9c/jlzoyCRqRKoZ2TrjB3aqSLa8DRs6cl4xtdXsS5FkOSBLuHdZh
OVErv4WcTXq7Ocpvsfd4Yo8WN5gHUp2yEa0zXRTYYMnbTgLeKsL1sJNCitli7F9Y
H3H47s/sh53A4mvZzOlPQYh7L7SdIa80WsH+BErueuHX4OD1w/XDSP4Fui6mDFq6
HAy2s8RIsRA55sTSyoq3+2lgf7xkV/VPfUeRf0ZohlG5eGA+vcs=
=6Fti
-----END PGP SIGNATURE-----

--RVlUGXxwBj5SDcM9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
