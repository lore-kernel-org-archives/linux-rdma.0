From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/4] debian/copyright: Add copyright information
Date: Sun, 1 Jan 2017 09:54:33 +0200
Message-ID: <20170101075433.GR26885@mtr-leonro.local>
References: <20161229134908.13185-1-leon@kernel.org>
 <20161229134908.13185-4-leon@kernel.org>
 <20161229152537.GB30742@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XAEV7zm15O60d1Zf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161229152537.GB30742-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XAEV7zm15O60d1Zf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 29, 2016 at 08:25:37AM -0700, Jason Gunthorpe wrote:
> On Thu, Dec 29, 2016 at 03:49:07PM +0200, Leon Romanovsky wrote:
> > From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > This patch adds debian/copyright file and list all
> > different licences and copyrights, according to
> > debian policy.
>
> > +Files: *
> > +License: GPL-2+ or BSD
>
> We don't have anything that includes the 'any later version' clause in
> the copyright header required to be GPLv2+ - so everything should be simply
> 'GPL-2'

Right

>
> > +Files: debian/*
> > +Copyright: 2016 Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > +License: GPL-2+
>
> You can add me here too

Sure with great pleasure.


>
> > +Files: buildlib/cbuild
> > +Copyright: 2015, 2016, Obsidian Research Corp. See COPYING.
> > +License: GPL-2+ or BSD
> > +
> > +Files: buildlib/fixup-include/*
> > +Copyright: 2016, Mellanox Technologies Ltd.
> > +License: GPL-2+ or BSD
>
> Many of these copyright attributions are a bit wonky :\ I personally
> think this format of Debian's is too difficult.
>
> > +Files: ccan/*
> > +Copyright: unspecified
> > +License: CC0 and BSD-MIT
> > +
> > +Files: ibacm/*
> > +Copyright: 2013-2015, Mellanox Technologies LTD.
> > +  2009-2014, Intel Corporation.
> > +License:  GPL-2 or OpenIB.org BSD (FreeBSD variant)
>
> There is no text stanza for 'OpenIB.org BSD'

Changed to be BSD

>
> > +Files: providers/ipathverbs/*
> > +Copyright: 2006-2009, QLogic Corp.
> > +  2005
> > +License: GPL-2+ or BSD
>
> ipath has a special license. Please review COPYING.md and make sure
> all the special cases called out are covered properly.

Thanks, I fixed it to be PathScale-BSD

>
> > +License: GPL-2+ or BSD
>
> I think this should just be 'BSD', same with all the 'or' stanzas.

I'm not a lawyer and in the rdma-core.spec it is "or".

Do you know which spec is correct one?
https://github.com/linux-rdma/rdma-core/blob/master/redhat/rdma-core.spec
https://github.com/linux-rdma/rdma-core/blob/master/rdma-core.spec

Meanwhile, I updated pull request with new version.

>
> I didn't see the intel bsd license in here (see
> providers/hfi1verbs/hfiverbs.c, it is slightly different again)
>
> It would be good to update COPYING.md to refer people to this new file
> as it is better than the short summary.
>
> Jason

--XAEV7zm15O60d1Zf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhotbkACgkQ5GN7iDZy
WKdSCQ//RtrbumZoCaboGPysnSVlhIdlqFTJHzubkQ7RYDW4YPfatvlrnvsMNUsd
67vqupe66j+G31DlvsJt3EbcrAcVQu9TM2G6Ffa+4uLHHkhHd0TygYC1pvQVkSRd
IoMg7qUBUu9P/xQS0XJBcgvpVXWly2Znb22f5YF6oUnm+P2LQNwY3W9WVAXcREbq
DpY88vDbm/JspRID6fE7OMsKctaKgNq38/F5fLSl1ccN8occSax6hPPk19+febjt
3FZUXSrGw3fPin8ptDwiK7DYO3pDAH974IyRsmM3qgDUoK3/x9QHf3zuxuuBlTyn
Tkix4FjqUs63NeZRW3TscBUoYYi16d3PA7xuKGX7xLj6zSlGTVa6sSbllheMCMPU
fdWyF0KRG1DYuRg6zFIWk0cqYgeK440q7JKXyYxYvRgVOmuMrneKp6FSmL4HgDPC
2efP7jxwbQyGP+9eJrjqmPiYja+fFxa12CVfR71mBZWmIk7fbLXDUBrwiq2w3p1C
22XX1X9z/gYvQGFHtC6XJMHGOyK+FBLFhn8ZkgUl8nl1f1LLTVyB/R0ISvIiU3l8
Peiwbp76GrZIEDXb3S8NmUhys4d63v6UC30GfgXppXfedQMhfYVF6+pgFfIKpK5T
Ww3uo0u8U9j4dfcrUxoDc44/5xRXi8028vf9emd4WAlz0LsIopQ=
=JYuu
-----END PGP SIGNATURE-----

--XAEV7zm15O60d1Zf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
