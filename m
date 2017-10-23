From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Mon, 23 Oct 2017 21:03:36 +0300
Message-ID: <20171023180336.GQ2106@mtr-leonro.local>
References: <20171019213859.26124.37851.stgit@phlsvslse11.ph.intel.com>
 <20171020073724.GY2106@mtr-leonro.local>
 <14063C7AD467DE4B82DEDB5C278E8663875E0841@FMSMSX108.amr.corp.intel.com>
 <20171023081117.GE2106@mtr-leonro.local>
 <f03e51d6-4157-64b4-ec5d-9beac00ceb87@redhat.com>
 <20171023171211.GM2106@mtr-leonro.local>
 <1508780384.3325.13.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hiFLGGPPrqiESHj5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508780384.3325.13.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Torvalds, Linus" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hiFLGGPPrqiESHj5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 01:39:44PM -0400, Doug Ledford wrote:
> On Mon, 2017-10-23 at 20:12 +0300, Leon Romanovsky wrote:
> > On Mon, Oct 23, 2017 at 10:49:24AM -0400, Doug Ledford wrote:
> > > On 10/23/2017 4:11 AM, Leon Romanovsky wrote:
> > Doug,
> >
> > It has very little related to security here. The RDMA_NL_LS netlink
> > operations require CAP_NET_ADMIN capability set and it is checked
> > before
> > calling any callback.
>
> I disagree.  In this particular case, it wasn't a nefarious user, it
> was a simple misconfiguration that cause the kernel to oops.  So even
> if you have CAP_NET_ADMIN, you still don't want a user space issue to
> oops the kernel.  If you simply don't allow it to happen, then whether
> the CAP_NET_ADMIN program has been compromised by a black hat user is
> irrelevant.  That seems the right way to be to me.

OK, fix exists and if you want to call it "security issue", let's call it so.

Despite the fact that root misconfigured the system, root run the program,
root crashed the system, like all over kernel oops we are seeing in linux kernel.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--hiFLGGPPrqiESHj5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuLvcACgkQ5GN7iDZy
WKf2xA//RCSh5F4dgYs7bEj9RAjg0xDhLzp+T6vCirsLLCifU4YrceYv4IxwXueT
96WCiCeFYyw3km9gGQuomHnv9TJXwNocpgxyVoq5vpTMmeFSqo4gZCmF7nSSf5Ae
Xlw/exF5EmvBj5q+kqCamsJrZCoQUqyxzarcFqFjRkaCGauSIl3EffIx+lJdGDyB
B5xr87sgT6CKKK+nStxpItBPrdeDUIRqyiAaPRyNPuWky7F6r0wyDFpMbdpTAMqL
GdKxnk8SeJxOK43uVxgwyIPaTaduWgKcKJXGj9HJhWf0ine965T86gTtpwjJdm8r
3fmLkZlmXki/8/1SfeglCdGCqAI075tlfLfTYPTZJSXc44ewktvGJaUA0p915zvs
ehj47V6s2IlMqhyIkHayFN7xN1+Nk3mDXIg0U+vAxO4CGcV5L4SoVylDGUy/mWTr
I6D10vYzbadNIhzTjVhbn2Nj6IgY2xrL6I6ztNGgn1n/KLg06WV/YbXLGmbFeH5Q
lehjVbC8bUSUSd+v2WQBMpEUWsqHa+tCQUQDtJHfRTWvSlG0g1D3U5GeAbUxSjF4
o2fcRzqiWiumvwZPG201wkWr9JvLqYF7wxQrHl30o/s3ILSX+MtXlsBf7IpkO9Wy
8wBeCCGAGnVsxp8ge1nVUSaX8D4ZNzs+7VqZU3oUUA5zQt4iJiM=
=Fhfn
-----END PGP SIGNATURE-----

--hiFLGGPPrqiESHj5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
