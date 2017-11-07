From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Tue, 7 Nov 2017 18:28:04 +0200
Message-ID: <20171107162804.GM18825@mtr-leonro.local>
References: <20171107083022.Horde.E7wKXkvErbmdKSHiwomsj7N@gator4166.hostgator.com>
 <20171107144517.GA25631@embeddedor.com>
 <20171107145018.GJ18825@mtr-leonro.local>
 <20171107085637.Horde.qFzN3uJQkHeQUTyEgZzV4mv@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bgLLobvf7eP6VP5c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171107085637.Horde.qFzN3uJQkHeQUTyEgZzV4mv-fU+oOHjIBR1LoJgMfuPDHBfZZeVsHd8q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bgLLobvf7eP6VP5c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 07, 2017 at 08:56:37AM -0600, Gustavo A. R. Silva wrote:
>
> Quoting Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
>
> > On Tue, Nov 07, 2017 at 08:45:17AM -0600, Gustavo A. R. Silva wrote:
> > > Check on return value and goto label mbx_err are unnecessary.
> > >
> > > Addresses-Coverity-ID: 1268780
> > > Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> > > Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > ---
> > > Changes in v2:
> > >  Remove assignment from "int status = -ENOMEM" as suggested by Leon
> > > Romanovsky.
> > >
> > >  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > Please use git send-email to send patches and not reply to the conversation.
> >
>
> I'm using mutt.
> What would be the advantage of using git send-email in this case?

New mail headers, so it won't appear as Reply-To and will be presented
correctly in mutt's threaded mode.

You can do it with mutt too.

>
> > Thanks,
> > Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Thank you
> --
> Gustavo A. R. Silva
>
>
>
>
>

--bgLLobvf7eP6VP5c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloB3xQACgkQ5GN7iDZy
WKf/HQ/+LWE2OjgEi7vbj9fG4GW6Lwjrdc0CR9mscnh0kErEAAzATS2cnJ0l8/IO
7SE/wVg8N6qGGK/1y7jFywSLQCkoIsgNRltyP2d0nZ33eLqzrqn1yRrXEFhsAYIO
kVEMZ1RiBN6HIKXQlmfhZaiWzzMj4/MQ0ekdCUYyc6VyyO7MG134rs1/bfkDcNr2
JGrOsH2/aNfMAI0IyYW1VvlYMwbDAoZYcNLOkI64Kzv3RKsaFIrrGCQCJB8WOn8Y
tLB2khXEIx45WOoMpT7qQ9h1DETio5kUd5BabPvqbJDyOy8Rb/dZyltH8YcswZZ2
zshpqQn5COBOeCDPM6mOr4mSiDFPMx42ECxb53p8Fnwt+SJeUyZHMyLU3zzkCWC5
00DkM1XYnX6PXPb3MCzUi9pj9rb6nYmw3yppJRqk+mzuZnSYwYGqjEKNId27BED2
+cmyX1d/OBs5wp/ud24+5LPdpQuovYN7UAr6mclTaAd1cMu+tw2NZXwtQQL4bt+f
iNjjnnnncTa06IFsGl6ivLlqnR/dxD+BUTJlZa/huVJJG3LLEhu38H1TIaX2ASJd
rCXSxahHRh1mzRL/Ehv8c2U7vyJuEvx02QKH8DAdwQwy1eXuqhFFs1By9eZX8btg
PfO2sr/cUyoI9NrxdiXkAUR44jZfC8mz8MYYabWJj+OTGQ+I/yI=
=ERc0
-----END PGP SIGNATURE-----

--bgLLobvf7eP6VP5c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
