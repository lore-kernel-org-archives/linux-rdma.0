From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Remove the obsolete libibcm library
Date: Tue, 2 Jan 2018 17:10:44 +0200
Message-ID: <20180102151044.GG10145@mtr-leonro.local>
References: <20171225123132.6063-1-leon@kernel.org>
 <20171227201945.GG25436@ziepe.ca>
 <20171228053029.GO3494@mtr-leonro.local>
 <ea55cca5-1bf9-dd54-9be1-6450ca9002ef@dev.mellanox.co.il>
 <20180102142658.GF10145@mtr-leonro.local>
 <3146d449-0d75-9954-8c0b-bb122aaaa102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="R6sEYoIZpp9JErk7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3146d449-0d75-9954-8c0b-bb122aaaa102-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--R6sEYoIZpp9JErk7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 02, 2018 at 09:32:27AM -0500, Hal Rosenstock wrote:
> On 1/2/2018 9:26 AM, Leon Romanovsky wrote:
> > On Tue, Jan 02, 2018 at 09:18:59AM -0500, Hal Rosenstock wrote:
> >> On 12/28/2017 12:30 AM, Leon Romanovsky wrote:
> >>> On Wed, Dec 27, 2017 at 01:19:45PM -0700, Jason Gunthorpe wrote:
> >>>> On Mon, Dec 25, 2017 at 02:31:32PM +0200, Leon Romanovsky wrote:
> >>>>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>>>
> >>>>> The libibcm library was marked as obsolete long time ago,
> >>>>> the following patch is first step before removing ucm from
> >>>>> the kernel.
> >>>>
> >>>> I understand the distros will not want to loose libibcm in their
> >>>> stable releases.
> >>>>
> >>>> It might make more sense instead to just not build libibcm by default
> >>>> with a cmake option but still keep the sources..
> >>>
> >>> We are not removing it from the stable branches, so if they want to keep it
> >>> till last person who used this library dies, they are free to do it.
> >>>
> >>> The disabled build doesn't give much benefit at all. It will be dead code exactly
> >>> as now, but without any alert that it is broken. Most possible, it will be broken
> >>> till some distro will notice it.
> >>
> >> Since when has it been broken and how is it broken ? Last I knew it
> >> worked but was not used by anything in tree.
> >
> > Hal,
> >
> > Where did you see me saying that it is broken?
> >
> > I said that it WILL be broken if we don't compile it by default.
>
> OK but that's not how I interpreted what you wrote:
> "It will be dead code exactly as now, but without any alert that it is
> broken."
>
> Anyhow, if distro still wants to include this, wouldn't they build and
> test it ?

It depends on them, not all distribution are going to support it. I see
no difference between this library (libibcm) and any other abandoned library.

Thanks

>
> -- Hal
>
> > Thanks
> >
> >>
> >> -- Hal
> >>
> >>> Exactly as some distros have EOL, this libibcm library came to its EOL.
> >>>
> >>> Thanks
> >>>
> >>>>
> >>>> Jason

--R6sEYoIZpp9JErk7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpLoPMACgkQ5GN7iDZy
WKdxdA/8CS1VksqaEuDiFyv0tJc3oQdboDZsVH8kQug0GnXWYa/3p+Z+YUrDS6yL
HY83iqhKmXgDpovrwNn092/x7d4V7OdwIb0t/qh8tJEvi7OdjRhrADHxqQRjltHN
ieLG5B+LbBK6ti+V15cvUrVnw9UdC0W1Dcwobgrk0Lke1hJns/U4vuYBAm6jpl3L
K3kzBC9fc+gZgD256HZG8VFufJo+k323Tw5tHzfQ/ueusakpn1ciWP2r9w8ipAw0
MrfVeBr5man0pbcz6Vqb8LFUtlGmaOTyfdmnk6kXQ6pvoRVcR/JP7Fj+GSdlrAW6
Cmxcy+BAwCBxWcM1P+EgT4NWCz8Hkd7EtQMvsJ4+Z1pIC6xPMZlFpAD7PoDfHxbF
uPdMIOh6zzUypos7XNFw+gGH9yE2w0wNC2RLuR74m8eM14fsbI7q7Z3zQQoAsYjU
rdcuolW6LjZOty+HgYPPwqsBJ3Uo13VMpc0nK0kmfl7mZgxkcnRUEtAhdX4g3ROg
TaxkZoW4V5mgWmsCTiwpAx3d+Go3Is2rfhzjfKGv2NFOGb3WZ4j3TXSOLakQYVop
qa/y7ojHhmcGZokKhWj/sJrbBNNihyccInlYKCG1njk1gv62lvEbPW11gB0kpT8b
O98AP9Fbp+9re7IX++RBoexE8kJzOIzh3sNuu8ZAD5zGZ0ei/58=
=fc8o
-----END PGP SIGNATURE-----

--R6sEYoIZpp9JErk7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
