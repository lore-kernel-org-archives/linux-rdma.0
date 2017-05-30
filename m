From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] libibumad: clean up htonll/ntohnll handling
Date: Tue, 30 May 2017 06:52:39 +0300
Message-ID: <20170530035239.GE17751@mtr-leonro.local>
References: <20170522141722.50502-1-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8M+BMcg+0CmQ2H7L"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170522141722.50502-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8M+BMcg+0CmQ2H7L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 22, 2017 at 10:17:22AM -0400, Jarod Wilson wrote:
> Only ntohll was being checked to see if it wasn't defined, and was then
> redefining htonll as well as ntohll. This was causing some problems for
> the compile of the opa-ff package. Simple enough to rearrange this code a
> bit such that htonll and ntohll are handled entirely independent of one
> another.
>
> Reported-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  libibumad/umad.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>

Thanks, applied.

--8M+BMcg+0CmQ2H7L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlks7IcACgkQ5GN7iDZy
WKcsVA/+PpXOBUjW08GXPFoAT3PTikFVNIw9iOkVDDB4zWVYbWJlyL8OypeSHuHA
WQUauAbrtNi15SEUD61+Rv8aq+WLtOUgunAfhyZC5KRqmGob+GKQMGJfvYS9AGN6
e7axuo2uw2Nw3Gv9ENzmOrajyRHtODyS1nvn6YIsabR9cCTuobXgMdywJJE8kqU4
Z+4z2gh2Zd2mJsvpREkLhg3wJB73So6IC3XUEsrJD7wyAsuPG6zOq6PEC0XnBNop
JstMDE0fHFevzDqL997AAOHCwt/SJzsXYgVkdlYxvOo1DKEI6bPuSHlXc5vxZHC2
EWSi9fU/jPPrwk3iIAFmp/PeMUHKpRo24EpiFyqmZO/wslcx5jBIVMBawvzwmfd+
dBfYy23IRZib0uBTmUoAXkV471Kv1tUM1fh8yPLi6H0UIT8irwGomxJZvCLrvTAc
N8Mog3cftRLaWcdhMG3eVLcYJ48DhCfowH12qbJSXTqdte3HLbGtWlfRGlfAtk6b
ArlGQxIIy+nZB4afyDKqQj8rchUIcgeK7gf8Pr1NH1v8yh2a8WhW2cbA4Fx9svqJ
eY4vkbflCM/U7B9b1FYRXDuOvHuZAu4yOAC3lzsRc4Dautk2QDdEyPWzbA9Wo1c9
7yLu7CwroAP5yxMuNKRL3X0IXVCkwOGm+iqUu/dug6wfxI1nS6A=
=pvbT
-----END PGP SIGNATURE-----

--8M+BMcg+0CmQ2H7L--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
