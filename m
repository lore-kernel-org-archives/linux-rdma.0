From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 0/9] Export vendors specific ABIs
Date: Fri, 23 Sep 2016 19:58:16 +0300
Message-ID: <20160923165816.GP4088@leon.nu>
References: <1474554679-21953-1-git-send-email-leon@kernel.org>
 <20160922144716.GA10032@infradead.org>
 <20160922160924.GI4088@leon.nu>
 <701c2cd1-a47a-807d-41dc-c8057dd073bd@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vzUQzca511KWT6Hk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <701c2cd1-a47a-807d-41dc-c8057dd073bd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vzUQzca511KWT6Hk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 23, 2016 at 12:42:02PM -0400, Doug Ledford wrote:
> On 9/22/2016 12:09 PM, Leon Romanovsky wrote:
> > On Thu, Sep 22, 2016 at 07:47:16AM -0700, Christoph Hellwig wrote:
> >> Although I would have removed patch 8
> >
> > I'm not sure about it, but anyway it is separate patch which can be
> > easily dropped by Doug when he will apply it.
>
> Mostly easily, yes.
>
> >> and add the Kconfig changes to
> >> each individual driver change instead.
> >
> > I want logically separate move part and export part of this patch
> > series.
>
> There's no reason to separate them.  And it leaves dangling uapi header
> files that are in the uapi directory but not listed in the Kconfig.  I
> squashed the Kconfig changes and also the MAINTAINERS changes down into
> the main patches, so the series is now only 7 patches.

Thanks.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--vzUQzca511KWT6Hk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX5V8oAAoJEORje4g2clin3TEP/j8qZNoLlldARLfUC8FbYH7o
0De1xnoDWl5u3+h6MVud+7cYhe8heQBtTwNqb08TttkjNMY/JndQWQ4YahpcFp1N
aX+tSD1edVqe3jIymhLtXf4MevR2qKZ10l/2KfAC42KQAjM3WOCuSKU437CT92Wc
z37nNyVRvD8HsIJD4gA4kfl+y2uTWOoT3Cl/DpK5OKUw16wGjlhaZBDPTB+DY/m+
MBxbTC3nNSziIUwebiN08o3Sll2H0rRNDVXb3ujebLFZVcBfjNomzW8GJaZYUyBx
++WKH0xP2ppgqxluLVPru0aE1TIvQaG8ShvVfkuvDt5eRIpovkE7cb/3C5iUuMbZ
ZuDfBzekXUf+SLDj0KhuOWz/px2nhDLByc/wbxXspP+2EbtXKD//RF4qkES4ltOi
iQPpzYfBH5AANQleVmi66g7XVnbXBFCb6tJhTNIBtx2c8rH5y2U/4GDVam7G6WHz
Nj6eiY5S/8EYAMrX9y385+wTltC+24AEEbGjJr6yG8/Msjyy+b6W9WJ/axInxRhp
pm3yigrhrdy3g3hBINWmYISCIJF8dLzc7RLtkC8Fy9WJjqtXfC0J1GFpXHe9JUlC
aCwH6RbvchtEf31XyMlyLrsxzmYwI8Ecx7fpO9pkJ6VVwcWTw9x7RsFyz56bI+jd
uxN4toSeaBJwEE4Zi052
=kd6h
-----END PGP SIGNATURE-----

--vzUQzca511KWT6Hk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
