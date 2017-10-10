From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] iwpmd: Return existing mapping if port reused
 on active side
Date: Tue, 10 Oct 2017 20:10:17 +0300
Message-ID: <20171010171017.GF2106@mtr-leonro.local>
References: <20171008233429.16348-1-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y1L3PTX8QE8cb2T+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171008233429.16348-1-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Y1L3PTX8QE8cb2T+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 08, 2017 at 06:34:28PM -0500, Tatyana Nikolova wrote:
> From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Port-mapper returns a duplicate mapping error and no
> mapped port if an attempt is made to add a mapping for
> a new connection which re-uses the local port on active side.
> Fix this by finding the existing  mapping for the re-used
> local port and return the mapped port. Also, change ref_cnt
> in struct iwpm_port to be atomic and use it to track the
> references to a mapping.
>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  iwpmd/iwarp_pm.h        |  5 ++---
>  iwpmd/iwarp_pm_helper.c | 27 ++++-----------------------
>  iwpmd/iwarp_pm_server.c | 47 +++++++++++++++++++++--------------------------
>  3 files changed, 27 insertions(+), 52 deletions(-)
>

Any feedback from iWARP crowd?

Thanks

--Y1L3PTX8QE8cb2T+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnc/vkACgkQ5GN7iDZy
WKfmbRAAiMm9S2DLIIzBAE1pjFWrX+PT6cV/B5fvJxqbhLjgsjcUD+WhvvUNRUfk
7Yrz0LGgq6ql+CDs8nk6GjN+EnMWBlccqek+CYg6CJcvPfg072ryWuOfK3bcC9+S
gEtnPINUrSWdtOROe48CurWTu+1GyGm7T38d1xAK0mgLfFtV2VAQemmQvjqwJKx2
dt0WrLcnl4+MfnIKSlcAOVqqMMdeKbpgAPmCns1H+vFLcPuXbr9dXix/+EsLRkRY
SPL4QpcDmi2jIjC/WeL0aWoWpOcMG8eRvL1Bsd8vkjkA0peUnh++A0M7XK+6KBTV
egX0iPh4ctvFd48039AUJTwnewaoyR6SuZtzyGIe9rxhZ9pE4qDZvz1irOrDclNC
JA93u3MUqM+qCBgzZlhm4n2VT79VK2U83jCivUUh2YN/n/HgDYP3ABqdWZsr5K2v
DqndpQqdQphlNZQYsHHRjeLzoUyaKrj5etSiyN5lsVs9Q+FB3y3MiMwB9OvQrVl4
m33RFaxi6MWKJu2cYEMuwrGafK7VqwYYId+QhpR1bxmK0mztl/a1HzDMVdmgkbm3
dqZPJalxz8OzLtFeEkBo2GyWLop4YIyXhLwI8U36a3qw3mYvVx6KrSpmiSr57TPP
g1NiUlO41tlzIwrchNuiB9jFGitGsJ3dVFvEAKhEW4RN9Cdp8sw=
=+3zI
-----END PGP SIGNATURE-----

--Y1L3PTX8QE8cb2T+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
