From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting
 tomorrow - 9/13/2016 at 11:00PDT
Date: Thu, 15 Sep 2016 08:00:05 +0300
Message-ID: <20160915050005.GF26069@leon.nu>
References: <VI1PR0501MB2189FBF50563679C4E61B1EFB1FF0@VI1PR0501MB2189.eurprd05.prod.outlook.com>
 <CAG53R5XUDkVgu5R2wHOyxd0FGEuEU+CTf1H_d9=Mk+DnDS51Ug@mail.gmail.com>
 <20160913064857.GA5988@infradead.org>
 <CAG53R5UO50zXYF_oUUA_MUhx+xYS8FbDkTsAzon6Fn4syDyWvQ@mail.gmail.com>
 <20160913070418.GA31616@infradead.org>
 <20160913103238.GW8812@leon.nu>
 <20160914123059.GA868@infradead.org>
 <20160914171349.GG16014@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qftxBdZWiueWNAVY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160914171349.GG16014-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--qftxBdZWiueWNAVY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 14, 2016 at 11:13:49AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 14, 2016 at 05:30:59AM -0700, Christoph Hellwig wrote:
>
> > I'm not fine with HFI exposing the non-verbs interfaces through
> > drivers/infiniband/core interface, which as far as I can tell it
> > currently does not even do, although some discussions here suggest
> > that a future interface should cater to those interface.
>
> The counter balance is that the Kernel Community has had a lot of bad
> experiences with drivers growing their own user APIs and 'subsystem'
> like functionality.

Do you see any desire of HFI authors to move to new general user API?

>
> Jason

--qftxBdZWiueWNAVY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2irVAAoJEORje4g2clinigIQALR/QBFbViSAedCWR0wuBdey
PkyGBtPaMvUsK1Qpbfrg9X0o/2xD2EzlWURk72wIW1PObrPuP+RlmC4Ysii3Qkmd
dyd6uGLfreaZibO26buyr/i+LIhuWPsY9h6wl+rU8jGqaxZoWi/Xf5fJ7JSzQxRr
czpZ6AOcXsCDRc/VNqv2KB8AjcTrgrFos9WLcKTtVR2CIfXeBTBjbU2WmTwX7ES9
vREp0QNUy/HdvWrV9qq+E0wGSKHHoSZgA9F6V2dIi+cswqF2omDWnOZWeT7Htrhw
c9svwK5Mae2XWkXC1sQQzfYuvnCp41yD1vZR8mx/sJzX9Rc/Wn+9nWz9+/g7bclQ
8fsiQ90K+nd4xigprbEaVAvJY7NC6daO2hCJZNmuWUwBV4TYmSPicapPeJfUUgMJ
/ThqsuGCux1V7FJ//S8UiUwJ2ShKR6OB6+UxH7HwqOIy1CBHsnKUzgIVAGtogLQH
RdPgr0dBqQsPEEOkXgo5+QEAP86PrAYkAL4Gtmyl/tcrUZdMWTEbOs6FAP/NG2LH
nwtt0PnfPLBhD2ODScAfTPZdlalYxnYPAAdoIrUYhfUiUYEK7XBfjoXQKWrp+rE/
lt6HcG9xQMVTvKwjTvodYNhtK46S4VNwnClym+5SWpCIBIS0jCpt/ef2KVRVdRJh
56SzomWHJWsPXKen3eHZ
=OcTh
-----END PGP SIGNATURE-----

--qftxBdZWiueWNAVY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
