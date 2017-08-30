From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] mlx5: Convert explicitly to signed char
Date: Wed, 30 Aug 2017 20:44:02 +0300
Message-ID: <20170830174402.GC10539@mtr-leonro.local>
References: <1504102764-21638-1-git-send-email-yishaih@mellanox.com>
 <1504102764-21638-3-git-send-email-yishaih@mellanox.com>
 <20170830164952.GA9310@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170830164952.GA9310-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 30, 2017 at 10:49:52AM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 30, 2017 at 05:19:24PM +0300, Yishai Hadas wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The 0x80 value is a canonical way to mark as not-used in intrinsics
> > function calls.
>
> This commit message is not good, try:
>
> _mm_shuffle_epi8 requires 0x80 to set the output byte to zero, but
> _mm_set_epi8() accepts char. If gcc is compiling in a configuration
> with a signed char then it can produce a -Werror=overflow warning.
>
> And this fix is wrong, since it just moves the warning to
> configurations that have an unsigned char. (eg -funsigned-char)

I have gut feeling that with such option "-funsigned-char" half of the
world will break.

>
> It is really broken that the _mm_set_epi uses a char as input :|
>
> I think you need to do this instead:
>
> #include <limits.h>
> #if CHAR_MIN < 0
> #define SHUFFLE_IGNORE  -128
> #else
> #define SHUFFLE_IGNORE  0x80
> #endif
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmm+WIACgkQ5GN7iDZy
WKc5Xg//Tf6zPyXAjYgpnyK/DtDBSSDirHUVYYCOBkw8PB/pso+HXWhwJ3ON6zAK
HrzqBa2gvGVfu+EJVZQX4ikKFbPmmX8bQYoDBoNPsf08bGkG/30fibPK8cId0+Nc
IlrK77NwzDfJtS4uZUkriufvnwjNcXXfBkTug/q/+M7AbhOI5K9sJa4NEB4VNuni
YLHMMxdMFCKjpSJMCUwya9dOXGVTCcn9pBRNwB9MnVuIweD64773VMv7Pg6KcCMq
gvqilyor7qIVL9iYYwuWigCVa+3I7XXl9n+hQ7U3dZBcmPdKxwp1nf15dilqID/r
rbCenOfT+iQETPtnqXL0bzzkGUvZn7hpUCV4P0cs8LFFVOfyC9iUP9J+Lssr8ZoJ
7PdYe6cuInlRm5JSLQdFtZgzpMiXHugTc9b+HY/2l+/QnayT9ajetWUWsUGx/Vro
WaeTGl8SwMBKgDb731F0JV8fOvJd2AjdEEnM3wkHF2bp7DoyFG2Vtu7MwC1lgqWR
jja5VAEbo5NQ8XNYx33X3MKpIqtvU0rmzkFWHbl2t0h4uczUFkmeNz87OsxTlW3D
MB4sh8ukFvbW6faK1+EPBNmjArrvPK34Q1Xo2A5iX6hZav5rIu9gmrS6mQ2CHkvf
+z1ELhaZEeJkYbdyX2tb+Ng5EXKx27MsfqPVqGVtL8csKtrBqEs=
=8UIJ
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
