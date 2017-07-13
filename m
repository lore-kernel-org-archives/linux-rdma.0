From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] bnxt_re: Fix -Wimplicit-fallthrough warnings
 in GCC 7.1
Date: Thu, 13 Jul 2017 22:08:29 +0300
Message-ID: <20170713190829.GQ1528@mtr-leonro.local>
References: <20170713133935.1206-1-leon@kernel.org>
 <20170713175122.GD11069@obsidianresearch.com>
 <1499968451.2740.14.camel@wdc.com>
 <20170713181536.GA4771@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="diC/HfBc3E/jkYPW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170713181536.GA4771-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--diC/HfBc3E/jkYPW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 13, 2017 at 12:15:36PM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 13, 2017 at 05:54:12PM +0000, Bart Van Assche wrote:
> > On Thu, 2017-07-13 at 11:51 -0600, Jason Gunthorpe wrote:
> > > Can you follow the same approach as I used in
> > >
> > > commit 47cd2efcd4cd416ead0a1a48153aa27a2e178ce5
> > > Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > Date:   Tue Jan 31 14:55:50 2017 -0700
> > >
> > >     Annotate correct switch fall throughs with SWITCH_FALLTHROUGH
> > >
> > > Or convert those cases to this approach?
> > >
> > > >  			 * LE platform be32toh will do the job.
> > > >  			 */
> > > >  			hdr->key_immd = htole32(be32toh(wr->imm_data));
> > > > +			/* FALLTHROUGH */
> > >
> > > Use the SWITCH_FALLTHROUGH; macro
> >
> > Hello Jason,
> >
> > Both Coverity and gcc 7 understand fall-through comments. Do we
> > really need a macro to annotate fall-through in switch statements?
>
> Probably not, but I added it a while ago already based on some other
> documentation..
>
> The advantage of the macro is that all compilers verify it is spelled
> correctly, while it is easy to make a mistake with comments..
>
> In any case, let us do it consistently throughtout..

No problem, it is less than 1 minute change.

The thing which bothers me, why didn't we see this warning in Travis CI?
We need to treat all compilation warnings as errors.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--diC/HfBc3E/jkYPW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllnxSwACgkQ5GN7iDZy
WKeZ0xAAnIkbQR+wyUT6sLsgt0d1sKhjJvECc59Q1fjvBwTAfeeBDGDiMSEUe+ZV
Z4G9bgMLwxn81XtXWQY+nqbDCA4cC8olPsRMyOY6PQpCJ9cfH/u452MruchTgm0i
zVbw54O1cljQ4IW2pUcfMRLuxEe13VEwF+I+QzKbo+CxF+JjwnxRxR+CaCMkCRh9
G4BR9QVvxf8cA5UDclgFMiDPCFxP9ug1HJURErADFG3WiwLqH17JphcUkiyHLOZ6
Nj8xMzGZhFw/go+dzmV18+nwoa7UF20LtGJzq0f/+4zjKihtPcJXE5w8lkhctDd4
fCxQ4exBQVAaLhiQlwFyyPXURHa704hCaGT3MljW02s6nWHIkxueiE8omk9mqmsK
gtwWlgnxzyQkfjfGGeP5eNutFzFirlDVE+cUwFqUSqgB6jmdxi/4C7AThg1zSWkG
Lk6z5eEEsKVaFylb/XIfFt12VX/UR0JTZzVJnSnM/KmQfk3wosdjAKrTlANiNRLo
aE5BbEqOxtWslu4J2qOcnXenSuJrr1myCEjk79NmNlx1B3whC5yXYkimM3BPp3C+
Qu520dkr3asjsmWuTefngGE1sY0cFLU1yPhOK80KlTc6EbqvbxoI1s645PlYZSvb
dpFJ86fScjQ1K+ByD958buhHleQHoisTU6KY8wuXm8cO2cglaLU=
=B2/L
-----END PGP SIGNATURE-----

--diC/HfBc3E/jkYPW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
