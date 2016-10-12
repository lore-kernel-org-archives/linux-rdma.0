From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] add a build.sh helper to allow for a one-stop build
Date: Wed, 12 Oct 2016 15:22:20 +0300
Message-ID: <20161012122220.GU9282@leon.nu>
References: <1476113282-19194-1-git-send-email-hch@lst.de>
 <c2d80cd4-74b8-8391-1855-3c666f611d91@acm.org>
 <20161010155949.GA20091@lst.de>
 <ec4f3158-a25d-7cd8-216c-fbec52577e75@acm.org>
 <20161010164758.GB1796@obsidianresearch.com>
 <20161012093015.GS9282@leon.nu>
 <20161012105208.GA9491@lst.de>
 <20161012121845.GT9282@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PseDLKNfj4uXA+Je"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161012121845.GT9282-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--PseDLKNfj4uXA+Je
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 12, 2016 at 03:18:45PM +0300, Leon Romanovsky wrote:
> On Wed, Oct 12, 2016 at 12:52:08PM +0200, Christoph Hellwig wrote:
> > [full quote deleted, sigh..]
> >
> > > What do you think about following code, instead of 3 lines above?
> > >
> > > + mkdir -p "$BUILDDIR"
> >
> > Fine with me.  Feel free to send an incremental patch.
>
> https://github.com/linux-rdma/rdma-core/pull/17
>
> I'll apply it once travis will finish.

Done, applied.

>
> Thanks



--PseDLKNfj4uXA+Je
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/ir8AAoJEORje4g2clin8rEP/0BwqVErs4+CM3qmqxGfOv1P
UUFTPcvFvA8ULcPjyFGiWUZ2Bd0AkOUgF7svcdBGofYyNPZ42hPifEBrthCLKKwB
l1y09v/VzyvS2/maumoU4fNsvH2FakHJPPLO5G7J290ln9JS1JR3zdSRdDLNxi4D
4dVJtzkowCElFFkto1BS+xdm3MVli603M5zA/Qg8Q+y6n3clDzyIBrIr1nMWwUwK
oFhDq9QfVObaAhU0TmcfHVVzLN556zcvpYmUEy8WaNy7Ti5N+KBSm6SNsT7rugec
Amm9nHgb72EwBiqvPcL1YYiuRteeD3w98VLoL/mV7sKefNCe7J28vIae4DuIQvsF
1MK48Kv4K3ubCG7z2WDq0CuNuhGAOzlo9ZLW8YsT6CQcB47yWhxiuU4piWkCwJJR
7Ee5MtKg4r2Q6o8S2QQ+9lVCY9ukomyo1VAL4wGYp199bWC2jZTE81D2JZltsXXv
15kuvd6kq0I17yPlqKjIPzMK5L/YJzl/nnaXjZKZvBegcbyavpyWqHgzcQgc99qI
R//FfPodT4DKVupO06hRkjEBL8FIM7jUh82VbAzZw+zT9d9aaiTjgqmJGCBrmvy8
R+OQOJW02L8Y8AhlqT994X6Om7HvGweY8HPSXFWydNQDtn/SKCuoDNgYtkCT8zCO
F0iMD1hVP9qah+44qOHY
=5EWa
-----END PGP SIGNATURE-----

--PseDLKNfj4uXA+Je--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
