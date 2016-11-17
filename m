From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core release process questions
Date: Thu, 17 Nov 2016 12:28:46 +0200
Message-ID: <20161117102846.GJ4240@leon.nu>
References: <13AA599688F47243B14FCFCCC2C803BB10AB79D5@fmsmsx104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lildS9pRFgpM/xzO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <13AA599688F47243B14FCFCCC2C803BB10AB79D5-96pTJSsuoYQ64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--lildS9pRFgpM/xzO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 17, 2016 at 04:56:45AM +0000, Nikolova, Tatyana E wrote:
> Hi,
>
> We are submitting patches to the kernel space driver i40iw and to the user space plugin libi40iw, which is currently part of rdma-core. Some of the changes need to be coordinated so that they appear in both kernel space and user space in corresponding releases. We have some questions regarding the process about submitting patches to rdma-core which have dependencies on kernel patches.
>
> 1) Can user space patches target a for-next rdma-core release, if the corresponding kernel patches are queued for the next kernel?

I don't see any problem with that, once the patches accepted for the -next by Doug,
they can be accepted to the rdma-core too. Anyway these changes should be compatible
with old kernel without such new feature.

> 2) How are ABI changes handled in rdma-core?

Do you have specific thing in mind?
Generally speaking, send to ML pass review and we will apply.

>
> 3) Could you explain the release process for rdma-core?

The process as agreed will be something like that:
a. Review/accept/decline patches in 1-2 weeks time frame.
b. Once kernel released, stop accepting new features.
c. Wait for 1-2 weeks to see no one complains. It is just to be on safe side,
because the library is always ready for release and checked constantly.
d. Create new tag and push release.

>
> 4) Is each rdma-core release going to correspond to a specific kernel version?

As Jason wrote, It will be aligned in release time to the kernel,
but library should remain backward compatible.

>
> Thank you,
> Tatyana

--lildS9pRFgpM/xzO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYLYZdAAoJEORje4g2clinFfQQAKr+gGIGGicKwXFv54gdBJUp
bn3UY2rPCb5zFpeoIobohFS/F8/KyjnJbFLhXcZLCBrtXs/fJ7RchV45faz0kGu2
14Jm7+eW8conh9ZVp1iwnOo38+n/ObJKNlPJKSasx2fZsaBOgFtFLDA5HBGTwoLI
K+aKZNgE6GFwuhm4eyg+WwDwOGKemy3PYxvBBkZ7J7K57BtU4CS2kRXAXPY0wInd
9qHqU2AuphWGzslwdt9oEA02m3ppazXNBFz7RTwwEh6IYla+8jPKujy7IFPQLVzA
povrFz3v54HZxBYmk3A6TNh5kagxozhFlhH24X0/iNqhicfXIVxAri8TvVHWNpLH
hrf1LwqS15UKlZ+/Yb5SLVUmVqHgtIPRWtnMX/ihhz8nVF4J9zoY+Gda+YtODqdh
zgArjWWPTALWq4E/vHjBDMsvxMsvOXfwHmT43v3c/wlgWJqWMS6cZwV3YObltU4k
eb9NgqqedqAMpDwCiqtTIue+zkcVdyVGhuolWsm4VVBUGmSK3XpJPnca1iZ8YIry
PaH1W7KDiHtJG1pSnNkb9o2d+gjGwkJU12ldKFqNKl6Jop7uwpQaBmQq4cv8i73L
ZtkdcbgFJ8YUEB7qhZqSXfP6ZGK024HR5MIZpxW9eZ0m+wwB1/o6KAH8qTuBJnO1
FNfTWW8YLfV0Jg6c6p+q
=WTx2
-----END PGP SIGNATURE-----

--lildS9pRFgpM/xzO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
