From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC rdma-next 0/3] Move mlx5 vendor specific to UAPI directory
Date: Thu, 15 Sep 2016 08:06:17 +0300
Message-ID: <20160915050617.GH26069@leon.nu>
References: <1473841649-8923-1-git-send-email-leon@kernel.org>
 <20160914172145.GI16014@obsidianresearch.com>
 <1495514480.6044744.1473882367077.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="smOfPzt+Qjm5bNGJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1495514480.6044744.1473882367077.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--smOfPzt+Qjm5bNGJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 14, 2016 at 03:46:07PM -0400, Laurence Oberman wrote:
>
>
> ----- Original Message -----
> > From: "Jason Gunthorpe" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > To: "Leon Romanovsky" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Sent: Wednesday, September 14, 2016 1:21:45 PM
> > Subject: Re: [RFC rdma-next 0/3] Move mlx5 vendor specific to UAPI directory
> >
> > On Wed, Sep 14, 2016 at 11:27:26AM +0300, Leon Romanovsky wrote:
> > > The consolidate library revealed the fact that vendor specific
> > > structures and defines are copy/pasted between kernel and user-space,
> > > instead of sharing.
> > >
> > > This RFC was tested by compilation only and not-ready for merge yet.
> >
> > Yah, this is exactly what I had in mind. We need to give this
> > treatment to all the drivers :|
> >
> > > Leon Romanovsky (3):
> > >   IB/mlx5: Move and decouple user vendor structures
> > >   IB/core: Export mlx5 vendor specific strucutres
> > >   MAINTAINERS: Add mlx5 uapi file
> >
> > One patch is probably enough, 3 patches per driver is going to be
> > alot.
> >
> > Jason
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> Leon, I have not kept up with testing all the mlx5 changes and latest patches.
> Going to wait until this settles then will take snapshot and start testing.

Thanks Laurence,

I will set the topic branch when I'll create patches for all drivers. I don't
expect any additional testing to compilations and header installations.

At the end, It is simple file moves from one place to another without
any functional changes.

>
> Thanks
> Laurence

--smOfPzt+Qjm5bNGJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX2ixJAAoJEORje4g2clinh0MQAMq3Lb1XsBHUzlN8yoQC6pj/
5G7WOCEysdqPFfMBGkwqhgPdOVUYtHDWKFE9CkxUVyXnw5VkBNVEElpBZinE//uG
IqY2Q+AvTZrGE/CjWTref9np/3UbRmn4j3k9sufIL7QUYhH01AtmojnsQEIfY8R3
axZ6Sv2sZr3XYTDEqefXZEE+FPc8/cFcSwiAIPDkx0ApsqIaVStibk4L7e2IFU3F
Wk0LF5OU26rv3/IqHpB516EbUTNnOAY7tlc8Pfkg9wcFCFufw3Vw2BXquo6NhETr
A6+v3hrXA/2L+BXHDtNnT05XQ13HNQ3vGIa950RCB38+qb6QjrqD6l2RrrO10D6a
WXhmhFVXKIt+Mw7HGdW7V7+zboQ+mYv/BEX+gx10q6fbnDLeZrlhMZ7f4kcK6EiK
MC2/Si7GTSskraKy0x13ameBaGlD+hK7cHFbhcHUyLVF6nEXOWb2BWZ4VFBnnird
zdXf7EtLOuUsVjx9nBklKniL1FeGfBWy4mhPv4gCBaZw3MFURYPJ7jD8vAFVjF+t
MPo2pXDMV/hkGtfQ2c4fhiPLa42JxZ8KanwmdfrrGOBC7xmSt1DlBAYmfGVk0c08
6bAIhEpsw49PnXCZtFn1vP5dKIVB2vzudTikzLIfOHYt0rtyJaVguoP/WYlA+Hd3
5SsbZvC1juqlhKyKiPr1
=tvtT
-----END PGP SIGNATURE-----

--smOfPzt+Qjm5bNGJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
