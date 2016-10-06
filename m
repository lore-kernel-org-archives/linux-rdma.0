From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Add a .travis.yml file
Date: Thu, 6 Oct 2016 20:52:55 +0300
Message-ID: <20161006175255.GS9282@leon.nu>
References: <1475105337-18002-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20161005115132.GE9282@leon.nu>
 <20161005163250.GB18636@obsidianresearch.com>
 <20161006045337.GK9282@leon.nu>
 <20161006161009.GE1224@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tqSMaTz1cCSspCQ4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161006161009.GE1224-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--tqSMaTz1cCSspCQ4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 06, 2016 at 10:10:09AM -0600, Jason Gunthorpe wrote:
> On Thu, Oct 06, 2016 at 07:53:37AM +0300, Leon Romanovsky wrote:
>
> > > I don't understand how a compiler can be too new? The next round of
> > > rolling release distros are likely to use this compiler, and those are
> > > the distros that will first pick to up rdma-core.
> >
> > I have an issue in front of my eyes where kernel fails to build with old
> > gcc version, while new gcc version works.
>
> Heh, last week I had the opposite..
>
> > My experience shows the same, however I want to minimize the test burden
> > on the users.
>
> IMHO, it is more valuable to run a build on the full distro stack than
> to try and inject old compiler variations into travis. Old system
> libraries are just as likely to fail a build as the compiler.
>
> I don't have any way to do that automatically. IMHO Travis is not able to
> handle that sort of workload.
>
> Perhaps a pre-release pass through OBS or something like it is the answer here?

Yeah,
Let's start simple and sort it later on.

>
> Jason

--tqSMaTz1cCSspCQ4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9o93AAoJEORje4g2clinowMP/3dsJNRPNAFrbj+BB6L5ClTB
zqxj5N4tcGWiKz16CnWsE5DXMnG0sBOiZCe3CBpbdMIx7Ul0FH40/UJ+KeC4BAQI
i0SO7cubH6Rk+7mwQF3gZS833vgUg3i+XDz37CNSp7cpSPfqh4olwXXHXVzUXK0I
T3hPmcCeS4fU6pOjfBkkXFLQslna+8e20aWty4A22HuMFTaVo8725zTT1ZebYvIJ
xOq/ggY6pIEHBqeLJzQncOq6OnMyapcxgn1F7/g/4twE+WON0GtayjJv2Gp7c6MD
5iqJyDollBsmMijQlXSc01XhVyZWFUHr1iuV9MrQdXf0GC1A8lFy5ZNoBSSx/Lt2
B/XOChV6gUpM/mm2jDBf0qQEY3b/+6f+HONAj+QIqfOZyrrccuplaarFmrvUTdFF
/eenAfpOn1icdysrUak/OLxc59/4K13lu79k555crcoKD0NcOhfNQAr1pIPhxybz
EG5r3mEKTTJpj4BkkmoPuI0N+uT9LrwfalX4kISrSbtUhGJBm2y25j6BcRKY/UuR
wJz4pPB1xPfEClkIR1IOu/YXWNtRJjcPvxKAbU4k9aiQKujdbFCLyZMaqUVhpkvG
166CXW48NgH655N72xnequXUEqHUvEg1s89kd3cBomCkw9N/l7lopvcM0k5d05nj
l/szmxDSHAk06akaAVUD
=PZCO
-----END PGP SIGNATURE-----

--tqSMaTz1cCSspCQ4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
