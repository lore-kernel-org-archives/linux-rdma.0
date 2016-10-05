From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
Date: Wed, 5 Oct 2016 15:49:39 +0300
Message-ID: <20161005124939.GF9282@leon.nu>
References: <20160923041340.GA11269@obsidianresearch.com>
 <20160923080655.GM4088@leon.nu>
 <20160923152412.GB11269@obsidianresearch.com>
 <20160923171003.GR4088@leon.nu>
 <20160923173421.GB13920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160923173421.GB13920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 23, 2016 at 11:34:21AM -0600, Jason Gunthorpe wrote:
> On Fri, Sep 23, 2016 at 08:10:03PM +0300, Leon Romanovsky wrote:
>
> > I sure that this question will sound dumb for you, but can we unify all
> > code under OFA's licenses (dual-license)? I don't feel comfortable with
> > this multi-license situation.
>
> It is an excellent question.
>
> To do this we would need the OFA to talk to each of the member
> companies and get them to sign some kind of legal change of copyright
> document. Assuming all of the member companies agree, and all the
> member companies are the exhaustive copyright owners then the code can
> be placed under a single uniform license.
>
> As I understand it all OFA members were required to agree to use a
> specific licensing scheme, including specific license text when they
> signed the OFA membership agreement. What we are seeing here is that
> the corporate legal side agreed to something but the developers made
> small errors along the way, and those errors were later copied by
> other developers and spread widely. So the OFA has a basis for
> requests of this nature.
>
> For instance, a legal statement from Mellanox that all code they
> contributed is available under the GPLv2 or *either* MIT or FreeBSD
> license varient would allow immediately placing all Mellanox
> copyrighted code under the single Default License. I expect this is
> what Mellanox intended to do anyhow, the fact that ibverbs and all
> their providers had an error in the COPYING file is simply
> an unfortunate mistake.
>
> These sorts of license issues are typical in historical code bases. I
> would say we are in pretty good shape, from what I can tell absolutely
> everything is unambiguously licensed under at least the GPLv2, or a
> compatible license.
>
> Almost everything is alternatively licensed under some kind of BSD
> license. The notable exception is ipathverbs and rxe. It is also
> unfortunate we have so many BSD variants.
>
> Further, almost all C code is licensed under the dual GPLv2/OpenIB.org
> (MIT) license. The kernel is similar, almost all C code is using the
> MIT variant. Hence my desire to make that the license for new code in
> the tree.
>
> I would say this is a pretty good result.
>
> My ultimate suggestion is that we push the non-default copyright into
> the impacted files, eg add short licenses headers to the man pages,
> etc, and then delete the extraneous COPYING files once every single
> file has a correct license statement. From that point we can look at
> switching individual files based on the above Legal process to the
> Default License, or just leave them as is - a historical quirk.

It looks like a lot of work to do and it can be handled by anyone.
Can OPA handle this?

>
> Jason

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9PbjAAoJEORje4g2clinm68QALD/gX1JprYmqNR7ujiIMWwt
vuc9Su2Dm7OI6ya5MzHONBXiLTfyNXyq8+ZW/2YeqiC2QQqB/3XEBFGBekS0gYTw
1pM6RrBM5UYaTskUHRqDcHx75KEDU9G0CcCPgU3basawSHVmKyV2Jq0OIIdXDa6E
a0ZpB4fEflccE3nrYbxIfd8byvlZ1w1giHgxMjzjZkATHb/6PwNhmlIW4C7ReNji
Qlyp0uD/duCilRJpums+VJcqcukg6rISMR1cSUk7wparX99vwT1YZA6m/el92FE6
QL/zh1JBYYr3kimx5FO/82SzQpsQb3JRGfGRm2pdk0OI2tG16oHEvBAqPwzP4lGt
evtu72VU/SIOzn/vT2QfRvLIMpswIhx2I32rOGDq39TA9FL4gJO7X1oru7bcxPNK
CKlXP3w4ojup0Qu7WiA73tHu2xrLGZ5y7z0N/0sQToZZdt3mE6/YgBaEfkLVX/uo
KtwM30jbs1X2s7jKLSsvWfX283eXoiuxocO/bEzJWXiC4Dnqu0ehFTToRFgoio7R
gF1e/jSpDQnaBRMzqlnOrKD96IRhhX4mZwIJcr6L3YTsBXpHVJU8TKg0hpJqDkLW
wiGzmVWMsqblbSai40m0jJmwjYGexyGGf2uFB7XibwtuUXhfTWlgTv9+6ROHvb1y
twTLEYSXLum7U1TbyWwd
=Myzp
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
