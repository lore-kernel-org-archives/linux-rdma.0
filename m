From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Fix C++ compilation break
Date: Mon, 9 Oct 2017 22:33:40 +0300
Message-ID: <20171009193340.GE1252@mtr-leonro.local>
References: <20171009081717.21478-1-leon@kernel.org>
 <20171009154104.GA3824@obsidianresearch.com>
 <20171009190519.GD1252@mtr-leonro.local>
 <20171009191101.GC15336@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171009191101.GC15336-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 09, 2017 at 01:11:01PM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 09, 2017 at 10:05:19PM +0300, Leon Romanovsky wrote:
>
> > It means that your glibc is new enough.
> > On some systems, the stdint.h contains the following ifdef to protect UINTPTR_MAX
> > "#if !defined __cplusplus || defined __STDC_LIMIT_MACROS"
>
> Ah, that old thing. __STDC_LIMIT_MACROS is removed from the latest
> standards, and IIRC, including cstdint isn't even enough to reliably
> get the macros under the old standards.
>
> The commit comment should describe the problem in these terms..
>
> So this is the best fix:
>
> > > #ifdef __cplusplus
> > > #include <limits>
> > > #define __VERBS_ABI_IS_EXTENDED ((void *)std::numeric_limits<uintptr_t>::max())
> > > #else
> > > #define __VERBS_ABI_IS_EXTENDED ((void *)UINTPTR_MAX)
> > > #endif
>
> Because numeric_limits is never subject to __STDC_LIMIT_MACROS

Thanks, I'll test it on that system and resend.

>
> Jason

--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnbzxQACgkQ5GN7iDZy
WKcI8Q/9H1COFRSKzPBPFvofSGEsi9ccF9f98gidT+fCJZT6OExcU+W1sPp2Jm2m
Qen6cN9EsRq6oTjSaSyRCghhXzXm7hKiIdol8hfizDFEip0Rm/9FH6QIZnLEzYst
iBIdaNO3OewP9FwCZugb0SwuR5lX8gM3JC8by8yJLI8dpP5RkcWfE0Fx7/vsNVuR
DExjwUMmzaMKjqlm1ABa7fWusvKeW10Y6yLNSRzrVEfZookqRVDqktQBeK+P3fsL
Kfi5Ti5so/JLeYks1o741pbZG89KgO1ZK5P8TCn46JCidDqDriocoTTaqRsMUeCG
voyRKFUy7hr09U7iK7bTJlH2xJsKjhQyQqT2tufQe6PMCHGTUa0HDbOdMgBLnKZN
Htmzxnqei6/g9HFX6/jC+PBAonBpi+tmbVZFpIQEFHZiKhEneBJR5jUFStp4kKoD
TetHXX+qO0ygg5F3Ag0cK/pE6gblxm0RWtz6czSKif3YgRPkoTwsi2x1+I1wFYES
nTAJW/Z5407MXGwPSTkhJMK7sf3nSASWdHThu7DKp8tzB8OuGSEEEFqNo04Bu1mF
CrydoMGI+PXuUqEPN82K54RwvlXqSdWTHyLqKfzirskr2De/5JBRKTXTVZvqYg42
APbZ/scB5IPDajaQSabhzytndX6/F2gkv6APcS+qOdX2p+H3cno=
=+CqC
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
