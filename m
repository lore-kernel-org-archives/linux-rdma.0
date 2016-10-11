From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Pull uninitialized_var into util/compiler.h
Date: Tue, 11 Oct 2016 22:46:33 +0300
Message-ID: <20161011194633.GP9282@leon.nu>
References: <1475879772-29458-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475879772-29458-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161009054601.GB9282@leon.nu>
 <20161009230150.GB12551@obsidianresearch.com>
 <20161010040930.GF9282@leon.nu>
 <20161011180517.GA17866@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9rkt7tfZQigMla7f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161011180517.GA17866-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--9rkt7tfZQigMla7f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 11, 2016 at 12:05:17PM -0600, Jason Gunthorpe wrote:
> On Mon, Oct 10, 2016 at 07:09:30AM +0300, Leon Romanovsky wrote:
>
> > > I think people would complain about the extra stores. gcc 6 will
> > > eliminate them, but older compilers will not.
> >
> > This unintialized_var(x) adds extra store too (... x = x ...).
>
> I have confirmed that the unintialized_var macro does not impact code
> generation on the old gccs while the =0 approach does.

Ohh, thanks.

But I'm still left under impression of this article [1] that using such
macro is a bad thing and we are "punishing" all users of modern compilers.

[1] https://lwn.net/Articles/529954/

>
> So no extra store.
>
> Jason

--9rkt7tfZQigMla7f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/UGZAAoJEORje4g2clinME4P/jVCkdWH77jcRSe6LtD7eOo9
rmTonvCKKKhqzPJ8Qq0nr1EyBrhnclscdkyxW0xeLZMD0MpXTQLC3EFdbywVptfZ
zU/mt0OoOg1rs8czeValDIpZ4lIpQPzegsOnN0DwKd4vRlxXsiAzKNNS5f6yrM8B
FAlDSl9/gmXhQiNelXl6Sr0fUHKvSt5ErX+gUXekDFT6TFBiU18fG8fcS4++Hg2i
M2EDKpqnVOHz+CENAOfm7n1QN0ufZPrpZ5oH8tgo0HC9QScAkWt7qxcRPKAdYqkP
LIqQ9p2r72xFodjQgxOTJxb8ExNDOwYom3+0a+dCiuN0Kq6NaNHIQXJB4pIGiurD
SA662KyNT4uAqotZbGN5/YHAP8gClfsbLmUYXSCLg1B/F8sksiaiO6bt/SRUVnr7
7r3JSfY6G8Q13AdnoEf56+mkyqNgbUEB0/r9RJzFxDPjz1PFLFUcUrqLiEze0AwR
W045Yvuo4FP8nKkP1cVj3ymC3Vb7mWxdPrQE3TOVD/IDWq1xSHb0di9OCEIK7wJA
9mX9qnMggLdw3jWEZTo+8uYLowg7U0hLmCl/LWxWn/06Xb7dG5PI73qdxEx32zSt
AnLf56zrBHu+6HRZ4Gg10EuVCxQROFT4SzNSWnsKba2G2YLLayJPotuPXFPv8tu/
CErQPgEHT3pgMrKo/IDV
=NTKb
-----END PGP SIGNATURE-----

--9rkt7tfZQigMla7f--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
