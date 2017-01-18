From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] i40iw: Set 128B as the only supported RQ WQE
 size
Date: Wed, 18 Jan 2017 18:30:00 +0200
Message-ID: <20170118163000.GE32481@mtr-leonro.local>
References: <1482179477-100780-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3CF/MBslHFRhO8r/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1482179477-100780-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--3CF/MBslHFRhO8r/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 19, 2016 at 02:31:17PM -0600, Tatyana Nikolova wrote:
> RQ WQE size other than 128B is not supported.
> Correct RQ size calculation to use 128B only.
>
> Since this breaks ABI, add code to provide
> compatibility with V4 kernel driver, i40iw.
>
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  providers/i40iw/i40iw-abi.h    |  3 +--
>  providers/i40iw/i40iw_uk.c     | 18 +++++++++++++-----
>  providers/i40iw/i40iw_umain.c  | 15 +++++++++++----
>  providers/i40iw/i40iw_umain.h  |  1 +
>  providers/i40iw/i40iw_user.h   |  4 +++-
>  providers/i40iw/i40iw_uverbs.c | 20 +++++++++++++++-----
>  6 files changed, 44 insertions(+), 17 deletions(-)
>

Thanks,
https://github.com/linux-rdma/rdma-core/commit/1919a5d436712c58bac8480a0aae6ee2b2f92f17
I applied it again.

--3CF/MBslHFRhO8r/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh/mAgACgkQ5GN7iDZy
WKc7DhAAyyv28h+Z5jXrl6hLFeV86T8ldXehZcMTxq7d55oAPKU6FO8ANUr1KFt8
49myeK0kQYjGeeZ20ewYp5zoMsvhlt5GroL7a/5e/o7WUO71oH1dhV4KfRftEthV
b7g1y3c6w7aLFYWz2jVTIxWnV7/N6mu2orOGmZQTm3WnnnObqARUyNii+BURUUF2
biJLF3yAP9FFofl6TXExphCyRBkeDuKTlKCjqv54XWcLEJxNcwM0ZfhfebJzHchF
MnJ1QlNlEiDak0FdUXnNHN4imREGaRX8D7Tg48iaRmoISiAyguFbuIade0QFDnpD
cOHQthZEuKXep5kuUquAPcTTbpYz/ROS/DJwmzx1YdwogB78swWC7SOwxv+/l7li
jOFfbqW0NgRadNM+MVZbDLfGwC230mRMZFPsLL2CZE8vD4p+4nUfnKmsESv2So5u
k+cxumSWjCJiMFJwpuPk02kiT7Jszfj8NexUeybKzDqYoCiZfpKhhZ61lXsI4jzo
eKpv8LbydiOrEAmShDBBlIn4Cw/S4JT7GiZNoYWs/kDGkAiNz8gItB8gBc/ZmlLc
vVAxiIK8tj4Fg5KncXU5IC22AEuYe+8UuMlu1pFCkYjLbj55ZIuut42f31r8bX56
/vIwAFsGRLzLFqlA7dbIetVcyXW6VD2uqSj4fHGPGUSq+xdaRKk=
=Eehe
-----END PGP SIGNATURE-----

--3CF/MBslHFRhO8r/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
