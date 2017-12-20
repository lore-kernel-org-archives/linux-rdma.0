From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dumping queue state
Date: Wed, 20 Dec 2017 21:58:37 +0200
Message-ID: <20171220195837.GB2942@mtr-leonro.local>
References: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com>
 <20171220163655.GW2942@mtr-leonro.local>
 <010e01d379b4$0ae59a90$20b0cfb0$@opengridcomputing.com>
 <20171220171146.GX2942@mtr-leonro.local>
 <019d01d379b9$e42cd390$ac867ab0$@opengridcomputing.com>
 <20171220180549.GY2942@mtr-leonro.local>
 <023501d379c9$2aafd470$800f7d50$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r7tUYVWcdYzDJoZW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <023501d379c9$2aafd470$800f7d50$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--r7tUYVWcdYzDJoZW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 01:31:43PM -0600, Steve Wise wrote:
> >
> > I'm not using CM and take this information from ib_query_qp
>
> By the way, it will be very useful to dump cm_ids, or at least include the
> ip address/port numbers for each connected qp...
>

Will do, we need it for RoCE too.

>
>

--r7tUYVWcdYzDJoZW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo6wO0ACgkQ5GN7iDZy
WKefyRAAgBwmF6oITyHraYBkTavJJcDrD60mZKlmA9553YBYyQyOkJ4lf7iX7sOC
NVXFSSuDu1NWrlK4cF7PV5ZnT60Hy5AyC2CR3sUIOVw4bMhMdyS6KANUpccBklp3
8D5MT2ZXOFzYddFPXh1NGQQ0c4VQJFe7rqlmMbK+wvoxEd3hp0G263+YHTMTZsi8
Hj5MRAs3dLgYQXPANTUcc0BCsBUnI5WpwsTkdZUx0uyd4EHj8oHDdAITCzc+DGNO
emS+9t77LB7pr2VPGuCdqD9lxD77Ln3UNfiZ212NRNuMaZC+mJ1fFb0mAwHFzxCF
q2B+Ix00ZVt2P5eY4+/0muEKs0NwuohxgjZFIoweTdE0WBoSD6oNW1j3Yn5Wa1jy
fsfaRFN9F1f1C3o7eePnsKT3/BbEijlQC5GJxJHPSTN1jBwAmqujcFfVI1Mm7MJ5
CVwNpPQccWEkkM4JxhRHWUzfy5wI7SxjCITmFqKlt9HliIZoLK9oBNWa0C/LtY3e
i4l1ON4R400gs43kkMjXFrYtBeqsbXblKtUKEFFgBLo+9dDKSHHNmeeFs8Cnfiv6
EbQNu+LQ7c3YLn96SRzwghhbDEe2mpirVGzAwBiexDowgrIw2S6zEzs0qHWLys/0
AC7H5mSgVgYW0L8NbV8Fx5ZoF3fQf6aK30TD/X3LLxnia7s47qU=
=NQJ8
-----END PGP SIGNATURE-----

--r7tUYVWcdYzDJoZW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
