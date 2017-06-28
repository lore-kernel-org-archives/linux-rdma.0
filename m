From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Wed, 28 Jun 2017 18:40:46 +0300
Message-ID: <20170628154046.GG1248@mtr-leonro.local>
References: <DE0C511C-A4CB-4D76-8BA7-6BFF81F590B3@oracle.com>
 <20170620180348.GV17846@mtr-leonro.local>
 <C27E2410-44B7-451E-8069-DF1444048158@oracle.com>
 <20170620184046.GW17846@mtr-leonro.local>
 <B34E95B2-A7D9-4725-B7C2-3DA4DACD29B7@oracle.com>
 <16d52534-5564-8137-a8b3-6c66df6bb508@grimberg.me>
 <20170628095640.GB1248@mtr-leonro.local>
 <64eae30c-9490-b801-550d-d871473f0d29@grimberg.me>
 <20170628134528.GE1248@mtr-leonro.local>
 <275acec0-215e-8157-e6a0-4c0f48fe3d75@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4zKt6bo/V7G+vDr7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <275acec0-215e-8157-e6a0-4c0f48fe3d75-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4zKt6bo/V7G+vDr7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 28, 2017 at 05:48:33PM +0300, Sagi Grimberg wrote:
>
> > > > I hope that we are done.
> > > > https://patchwork.kernel.org/patch/9808615/
> > >
> > > You have a bogus empty line change there.
> >
> > If I remember correctly, It was needed to silence checkpatch.
>
> So it should not be a part of the patch.
>
> Also, I think that the statement is _really_ unnecessary:
>
> "* Setting it to "true" will allow to mimic with IB devices,
>  * the slow memory registration of iWARP devices."
>
> And, its simply not true. Its designed to test the rw logic for
> sg patterns that would normally not be registered. The fact
> that iWARP registers memory for rdma reads is completely orthogonal.
>
> And this statement is not true either:
>
> "* This parameter is useful for new ULP bringup
>  * and/or conversion to this R/W API."
>
> Its designed to test the code itself, not for ULP
> bringup or conversion, although it is useful for that.
>
> And, I can't say that I 100% agree with not making it
> configurable, but since you insist so much, at least
> give a proper description.

No problem, I'll send updated version.

Thanks

--4zKt6bo/V7G+vDr7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllTzf4ACgkQ5GN7iDZy
WKcdaw//eAzyG3ddAF56GzzG2xUtjJqA+mqKHHwPULJlzT4wJK+xkoNrRrTnlPOD
tU+2w4oYUOKWD5Ls1DnAV6KD3+TEFo+CeU22txUf+sGW1sQqhPMCc0IhBQhmBX3k
93o6mh2yUNCGMaJtVBPlMB/eGOnGH4qncc9TORbeogCUJicGJbqQKW9akqubZhL4
SOlVUabU3xs7GPRwCOcif4aMIT9kN6VgOKvl5fDYCGmmcuOxlFOLT1qijwYJZNi4
B8ud2E/36momzO7tD5mpVnhI45pJ6zNeUHPxWI0f9IJabWOfPpVqZbB1pk1IqkA+
XazVbtKZhie1T+BnTYTfVr5ypQODacqS0K8Hb/czbaiUUHW9y8Rs7t+D8ftkDsci
tuDz9P7LHQiovPRjdQp6ELlcFu5LFakgByruiBEh80l/k/fmALWxsIdCvtgErPkq
MA9lk1GOdIUYhVfnXOXlCAYDF5TY0/M3jdCIiAXZ+k8dwWhyQ6U9BkhXMUIdPHD0
5JzepsKWp6uID2hoQE3/dCYGFkL0dP1991jIVU1MYa27qJ8zoabZuac1NzL+J2pK
meq0s1IQMuGHjZcN4irRQtd66yGwdIVKmNP6DTMbpI24ISFgaJUvlIY814LrIo8Q
xk6q715rHZzRHifL89huzXLO+3b9pQ/khGZDuJiWk1wv3y0G3mI=
=at5N
-----END PGP SIGNATURE-----

--4zKt6bo/V7G+vDr7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
