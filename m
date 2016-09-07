From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RFCv3: Consolidated userspace RDMA library repo
Date: Wed, 7 Sep 2016 09:25:08 +0300
Message-ID: <20160907062508.GA3639@leon.nu>
References: <20160907040925.GA27361@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160907040925.GA27361-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <christoph-zt5rKe7wo/JBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 06, 2016 at 10:09:25PM -0600, Jason Gunthorpe wrote:
> Hello Everyone,
>
> I've updated the repo, and I think we are now at the point to begin to
> engage the distribution packagers and collect their feedback. As Doug
> has suggested, there are many modifications that the distros have done
> that could be folded back upstream.
>
> It is available at:
>   https://github.com/jgunthorpe/rdma-plumbing

The simple git pull from v2 on master fails. Do I need to clone it
again?

Thanks

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXz7LEAAoJEORje4g2clinZ+sP/13bO7/KF7xFvHAOUxs/DHPY
JUbdUhq1eNmTdZr9QmPiyXw9Bvm0JuYZP8Fim3hKCSLqN0roxVg3RtQhJrrO1Xv8
MZHchwZZCRGOXRLntJCqjOS3qfLMyBwPnDU1MmFHh9JW2Ttt9ml9M/YD6AAYX6qa
gDc6JXKZejm1Tni1LIihdFi+A6dR1nW+4UYHnjoPf0K1a96M4bBK8Khn4b5tWMtE
NEI2ox7MECpJVziG0UkPJhQ/OXer2QRBBlyUWzfquIzsIX8l3oo66Yk7oAiuJN49
Os1KjUB/+JqRHgQB5n8MVkZTEXs5h5VWRtVFEQzLo/VjpdHFX4V1slc0DZoX7Lyn
rjif3mR+2BO0widhYBnUYorOowceZ/WeOlo7j38E8bCiCrt0Si1FMDVH/G6qiEUV
VjS8RJWsGEWgbSfDqvfMSq15NUpjGikvoCRyOCoqbA6EPEhI8NPGkFYcfPn0uGEP
ysoy09qz+ydGFZBykC2YGnDSy4RtkEORk6HejBZ626kLm7cND9D/x/Pb7pNeLLrx
HwXDTW3HM+Vbz1oPb+sXix6FY9cdbiGl6uqwgkQYVSnXBFIv2VUWNOFC235UdATM
p7bDYdkKlQtfWAkToHu7bRHKtLhetFCFgMwptePakky+RbnMOAy0KW88uL5t999Q
wzsSOL7dQpqJbA1//y8C
=HtMS
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
