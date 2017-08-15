From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cm: Don't allocate ib_cm workqueue with
 WQ_MEM_RECLAIM
Date: Tue, 15 Aug 2017 21:06:53 +0300
Message-ID: <20170815180653.GZ24282@mtr-leonro.local>
References: <1502813574-6040-1-git-send-email-sagi@grimberg.me>
 <1502813574-6040-2-git-send-email-sagi@grimberg.me>
 <009901d315ec$263eee80$72bccb80$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="np3HfElajyDBpWGr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <009901d315ec$263eee80$72bccb80$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--np3HfElajyDBpWGr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 15, 2017 at 12:30:12PM -0500, Steve Wise wrote:
> > create_workqueue always creates the worqeueu with WQ_MEM_RECLAIM
>
> Typo "worqeueu" -> "workqueue"
>
> > and silences a flush dependancy warn for WQ_LEGACY. Instead, we
> > want to keep the warn in case the allocator tries to flush the
> > cm workqueue because its very likely that cm work execution will
> > yield memory allocations (for example cm connection requests) .

And extra space before the last dot.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


> >
> > Reported-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>
> The change looks good.
>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--np3HfElajyDBpWGr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmTOD0ACgkQ5GN7iDZy
WKfQvg//aOSJTjiusvP8q8o/K0AbKFcfOZV9E/If00FLVkezJkrL47Evn67Ghirx
HRpNOtMRaDNblPMJ4a5kHzcudKzlQ4RliKBRoSkU60blBxa/HS1xyluQI4mcda5Q
9+gjM4/l30SlEwKGzMB58x20J+8MdCTGbLID+emYKvaoE601DwcbF3axAWN0yu+A
nHp/Hxais3g3q4JrjXOF3iH73rg3RTYQKKtiYFCZTYdOv0h/3uAZ5xTqdb9x1DqF
1XCPbmJyYKx83yjIsKWBkF0LgI699DKXd0uOLuXXvTE3Om5lYUmascjAhEEfgsXn
oVPZxUCK0QHEy4ukN6N1lYVM0m1cRIm/x2m8zeJsW4imG2odRBbISWN7Oi0uLsQA
M+UqxUvKCyONm0nPkRWr2F1EJkiAPJyWBLJC5TBZkRoIFCeqcSyXB36R+4Uf2M7r
zFt8PYnWyGVJlgOsqR1qTADgy9V1xs15IgUGee8QQmZAfQI74AYVpEZbK0HxXKbH
68fo4HQ1wlVv+vS+Ikki2Uy2pKdyLKoz/gOqZ51tIIln/uEw6xBnfo1LyUAaqKeb
1g4mIYwZMRnP5aYagH+nH8IyvEerkZnVCZ3nC8E605hGJ+GfoErUdNb8FpxxGwK4
+5pkT7aIDiaLCu4OA83yAGY4Edd6BnPy6FoYRxOvs2QlMyTrocU=
=cGp3
-----END PGP SIGNATURE-----

--np3HfElajyDBpWGr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
