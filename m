From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
Date: Thu, 22 Dec 2016 21:05:55 +0200
Message-ID: <20161222190555.GE18935@mtr-leonro.local>
References: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
 <9f5e0225-c53e-43e7-13b5-ae715f74b198@redhat.com>
 <20161222171833.GD18935@mtr-leonro.local>
 <c8463d5a-f2ac-7474-93dd-42a2e263834d@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9UV9rz0O2dU/yYYn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c8463d5a-f2ac-7474-93dd-42a2e263834d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--9UV9rz0O2dU/yYYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 22, 2016 at 01:33:43PM -0500, Doug Ledford wrote:
> On 12/22/2016 12:18 PM, Leon Romanovsky wrote:
> > On Thu, Dec 22, 2016 at 11:41:24AM -0500, Doug Ledford wrote:
> >> On 12/22/2016 8:54 AM, Andrew Boyer wrote:
> >>> This patch series addresses two issues found during heavy traffic
> >>> testing as well as a recently-reported Smatch issue.
> >>>
> >>> Andrew Boyer (3):
> >>>   IB/rxe: Use BTH_PSN_MASK when ACKing duplicate sends
> >>>   IB/rxe: Drop future atomic/read packets rather than retrying
> >>>   IB/rxe: Don't check for null ptr in send()
> >>>
> >>>  drivers/infiniband/sw/rxe/rxe_comp.c | 2 +-
> >>>  drivers/infiniband/sw/rxe/rxe_net.c  | 3 +--
> >>>  drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
> >>>  3 files changed, 4 insertions(+), 4 deletions(-)
> >>>
> >>
> >> Thanks, series applied.
> >
> > Hi Doug,
> >
> > Thank you for such fast response, but can you please give enough time to
> > other reviewers/relevant maintainers to take a look on them before
> > applying?
>
> If the patches look like they need review, I wait for review.  These did
> not meet that criteria IMO.

Two of three are trivial, and another one is worth to take an extra time
to review.

Thanks

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--9UV9rz0O2dU/yYYn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhcJBMACgkQ5GN7iDZy
WKf+xxAAq+4A27iZahHoRCwnSHyWOK+03KcrrMQpBpYS/T8iiuZB2t7Di9u2dygk
/DcxMDgCqoLhl7zjNJ5TkpYHikvjsIXXF8ZRh+mILPf0LH3Cgvl58btQnkK9fNet
wQrH6ro14U0SBFiJwhPJ27dWN6Wi0fJCJYuSs6aOYVYptw6pyxUYkIt2q23uKEy7
+RLeMzDNdcLjBAovIB2casL3EGl/9c37pR2kUNXCtNAmvRHUBc3W6XiZDnzzATqP
gVaMAw1fWpu4po8Sdniu8Z9MCz2/HiIv5zGiP6pHo0D4lPp7ejeeZ0oL2wSPL+Hn
OusCrQ5Vz06pfOpE3hK8XaqMCZVAzXWt+IniVPt9lShggRcGBOyeeHEbHWkSH440
mDNCVZZxGHLeJemlkrI+zIWaFIeVg79Qah9Wu3uHiRlIaugaWFWjjvdwh59GPg+A
lJ4q4GSUx2wUH/KXgH+WirYvHERxhMLt0Z2TJg/DDH8/7hcxj2tjaVYZLog3BJ+L
6ynhJUuTKJCIN9iAvtwO3Q0nztpJPo4RNXwAzbB6Jv8SxDFAwwMhnJKIzWKF4ilQ
dDFQGYccmqNYivdkLA6FHuiOB497AIMCAXTrRTFReKNd4D+J7HV1SeQYxCVqF+97
VtUkRavilVOFGOqc5yyqjWVLUx7nY4e/Xue7JFfi5IX4zD2u8Q4=
=MrFp
-----END PGP SIGNATURE-----

--9UV9rz0O2dU/yYYn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
