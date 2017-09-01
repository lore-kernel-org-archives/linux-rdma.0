From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] util: Fix check_snprintf to use __rc__ for
 local
Date: Fri, 1 Sep 2017 12:35:53 +0300
Message-ID: <20170901093553.GK10539@mtr-leonro.local>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1504212659-9674-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170901045632.GJ10539@mtr-leonro.local>
 <e10f536a-bad3-55b4-f3ef-207404209c89@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="C7PTD44AewjTsiSV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e10f536a-bad3-55b4-f3ef-207404209c89-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--C7PTD44AewjTsiSV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 01, 2017 at 09:00:01AM +0200, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 01/09/2017 =E0 06:56, Leon Romanovsky a =E9crit=A0:
> > On Thu, Aug 31, 2017 at 02:50:56PM -0600, Jason Gunthorpe wrote:
> >> To avoid clashing with user variables.
> >>
> >> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >> ---
> >>  util/util.h | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/util/util.h b/util/util.h
> >> index cbf0deca2dde7b..30d32ee6b51e24 100644
> >> --- a/util/util.h
> >> +++ b/util/util.h
> >> @@ -8,8 +8,8 @@
> >>   * error */
> >>  #define check_snprintf(buf, len, fmt, ...)                           =
          \
> >>  	({                                                                  =
   \
> >> -		int rc =3D snprintf(buf, len, fmt, ##__VA_ARGS__);               \
> >> -		(rc < len && rc >=3D 0);                                         \
> >> +		int __rc__ =3D snprintf(buf, len, fmt, ##__VA_ARGS__);           \
> > It can't clash, because it is declared in the scope {..} of that define=
 and
> > it is local to check_snprintf macro.
>
> It does if any of the va-args is called rc.
> This is "valid" C although not sure what printfs does print here (probabl=
y random stack value)
> {
> =A0int i =3D printf("i =3D %d\n", i);
> }

So how does this rename solve the issue?
Now, we can clash with __rc__ variable.

Thanks

>
> Nicolas

--C7PTD44AewjTsiSV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmpKd0ACgkQ5GN7iDZy
WKcy/BAAwKOGNBjm4KOMqlZMNWr5WBuxu7nJpVe/cbCT4+LLbkyHb1aOBpB0gMQZ
DG7MQQHRVUFiC6Tile8fCNGWYYfJDshnl1rLRjP0hB8RvofHOYWwq1e7SOYkQOTI
UHifITl/Hherv0Jn2EGVG8LmCFS25LmGtSL9zktEm4Ie+1/MOq6CMA6VhGeDhGvE
pCh8GTdWO3Gr6YlNS55Y+VBAoPgSDU+6KimYhPPRFImOs75Au0nWV9taO0Db9Wqk
U7vHkKpb/66j/U72v+p5m2uYuVoruz/Cd9TdrbgtM5biaBv8lm5V/sDILmZgY1pp
RfueDTVBgXjPaJPwAL5ZeKbZeXdP0hw5Gui57o7TLdSpMiyt8UQK5vPuqk8NVIO3
L2nSeXX8NOhJW3KLU6x+SvshaQGxCYe3zamnSwUPZ4Z1p+ayfqQSbRc4yF7f45vM
lrq6Wmrv5QcbdSdE2FfXb49ve3+Bf1765737t3F+QUblbw6hNwPaBIgB6z8l+q7H
VOwD6bF/zbNZ7k4iSHPmeekkhtgzy12hy4xEq8yzJNiJGeOMMnbW2TpxgJ8964cT
l/gl5ZBc0Stt4BySboRyMNyBamAq8203N3sFUQxjYPqoQijVy6Z4ZiO011HVqAJL
nSeRiWO8xI5SFkYAN7BzAHwQPouTsqrJedGXmyQLzu5qZWMCdBQ=
=mryp
-----END PGP SIGNATURE-----

--C7PTD44AewjTsiSV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
