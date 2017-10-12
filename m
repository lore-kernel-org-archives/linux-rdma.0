From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] iwpmd: Return existing mapping if port reused
 on active side
Date: Thu, 12 Oct 2017 12:11:49 +0300
Message-ID: <20171012091149.GP2106@mtr-leonro.local>
References: <20171008233429.16348-1-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JPKYlvo4+BwO1+FT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171008233429.16348-1-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--JPKYlvo4+BwO1+FT
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

Thanks, applied.

--JPKYlvo4+BwO1+FT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnfMdQACgkQ5GN7iDZy
WKdGBxAAhnPng1VCLuQgrYyevdxfiScCyceTwp1QSWvgKsbduhX8hcPhcM7Z28OE
FkK6usbLs3gKAthTfuHHn+I0qcl+dEN4Ow7PUBovdXq9ZG+OnZDyB/zFubDrPpUu
f/9Y6gnQ8N90n4e55ZhWTHwg7fHu50DlvqYIL4/oTX8j0/okA+AT/JgGbYbK7DpH
IF+0ODhoKwsbYFKdP4qZ1uEDg4bPtmknyVtZlqHOMTHvJfuTbSZwhMA7LQsBCKQM
jYud2zwa0TJsfOoPBYPU8zZhDCMgoN3Q9SlPSsR2WgsAEsBNMNNlXrYpvR4EdeIW
MA7AibGv/6SXC0DHu0DwDxwC4sZFWyd8xUIrLy7XABLPpTX+dYV44MInrz6SD4wf
0UX5HkNGjSDAXiKqPgerl+Fr7Ww+RMCiwvIb/v+TSzjv4O3zvrBugEbIZZIkIPMs
qZ/OGxYXTbSS1oI7yKxRN5GRMAJOzQq7Ce3jJI3dEmsUFT+1Avd6viqV2gk1U0Oq
yTh8kNtzmm4aKImnmSuMZxTcNyhXCfu7xfBBPENPTB9KdTmMWKkeNrZCJUM+STE2
naiGz7M+DHwnvjFT67f9L+mr7HLpPQ6Pj/Xkyxyrq8AwTCvLQLlfCKIN5JjyDUsw
L8SwOEuHQelSWWIz9KqzbObuR5vjWAi1ZnihjeIvoOF44jzmBqM=
=D7Ba
-----END PGP SIGNATURE-----

--JPKYlvo4+BwO1+FT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
