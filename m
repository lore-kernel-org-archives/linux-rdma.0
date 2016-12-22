From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
Date: Thu, 22 Dec 2016 22:23:16 +0200
Message-ID: <20161222202316.GA14178@mtr-leonro.local>
References: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
 <9f5e0225-c53e-43e7-13b5-ae715f74b198@redhat.com>
 <20161222171833.GD18935@mtr-leonro.local>
 <c8463d5a-f2ac-7474-93dd-42a2e263834d@redhat.com>
 <20161222190555.GE18935@mtr-leonro.local>
 <2a4a2187-1ac8-e341-4ed9-257384ff2199@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2a4a2187-1ac8-e341-4ed9-257384ff2199-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 22, 2016 at 02:19:50PM -0500, Doug Ledford wrote:
> On 12/22/2016 2:05 PM, Leon Romanovsky wrote:
> > On Thu, Dec 22, 2016 at 01:33:43PM -0500, Doug Ledford wrote:
> >> On 12/22/2016 12:18 PM, Leon Romanovsky wrote:
> >>> On Thu, Dec 22, 2016 at 11:41:24AM -0500, Doug Ledford wrote:
> >>>> On 12/22/2016 8:54 AM, Andrew Boyer wrote:
> >>>>> This patch series addresses two issues found during heavy traffic
> >>>>> testing as well as a recently-reported Smatch issue.
> >>>>>
> >>>>> Andrew Boyer (3):
> >>>>>   IB/rxe: Use BTH_PSN_MASK when ACKing duplicate sends
> >>>>>   IB/rxe: Drop future atomic/read packets rather than retrying
> >>>>>   IB/rxe: Don't check for null ptr in send()
> >>>>>
> >>>>>  drivers/infiniband/sw/rxe/rxe_comp.c | 2 +-
> >>>>>  drivers/infiniband/sw/rxe/rxe_net.c  | 3 +--
> >>>>>  drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
> >>>>>  3 files changed, 4 insertions(+), 4 deletions(-)
> >>>>>
> >>>>
> >>>> Thanks, series applied.
> >>>
> >>> Hi Doug,
> >>>
> >>> Thank you for such fast response, but can you please give enough time to
> >>> other reviewers/relevant maintainers to take a look on them before
> >>> applying?
> >>
> >> If the patches look like they need review, I wait for review.  These did
> >> not meet that criteria IMO.
> >
> > Two of three are trivial, and another one is worth to take an extra time
> > to review.
>
> Which one did you think was not trivial?

Personaly for me, it was second patch from the series.

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhcNjQACgkQ5GN7iDZy
WKcguA//ZZ1rXGvuSBiDJQI8I5S9FKTz7KEdPuNV8IllqlG/T65YR7W5hJI9KMEb
vDS6U6or0ROe+oXC9ELTGzt2GhqjJQzBRjXiemdxJGuEeOb8mNNE5cmYM4Yelxbu
GMohTqq3fTw7JKZ4PxQ6c8ifpW30o/W//hNSI5DHQkQpxY5ccjYOxt2tBa8l/K7b
2NQbmQj05ub86QyJL8SAm1Ju8ynz33HCDQoyfvr8oyNqJ0PNuoOESycDPuKcJSVn
qHfx1qlahRcAtsGSAAohI+nVtockIvqoAePxyswyQltaunyRZtcwazefDWc3xesY
e1rIpvRD+cvBaOFH4qOtjd1NiIJvusVv2WUiwbdp3Aj+sPcA3ioYXhwqR7dUvAW9
BtsDrxE2zYU1wdjOoOz/6l/GszAAsRoqUAkn6PjHCCI0ZwCvHc6tb9sieZX6eS7Q
UyHDvXJL5vTZg0AVFIHGj4gABG8EFLRW35WNwPv3qT+dOhshJ66HWuhLrlQdUcnP
9PgJV3z3SlUBTdXsaF0z8KZd8QH+7/xtZLZf3eRXYU8htl9QulCYQA76/HVuaxLm
petMay+hpWAVwGv/PAi7aKgtJU1tXIZ+HmPAELt+rJF5ESj2I9+ip+lUkh7ciEbh
dmkpjrGbQjw2asM37adBxGfKc6f6XIQBikdjT8nOx0qVhuLxD60=
=vjgv
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
