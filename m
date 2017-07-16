From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: This merge window...
Date: Sun, 16 Jul 2017 06:57:49 +0300
Message-ID: <20170716035749.GB14674@mtr-leonro.local>
References: <824b3771-78a6-7c80-50d9-a34383169185@redhat.com>
 <CAJ3xEMh-YcUgydmc96UumX3cfgr7P+0rRenOvBe_6m_bo+K3mg@mail.gmail.com>
 <1499875106.2924.26.camel@redhat.com>
 <20170712160432.GA24552@infradead.org>
 <20170712171044.GE1528@mtr-leonro.local>
 <e3a1c07f-8a52-351e-312c-6e374ec7d136@grimberg.me>
 <alpine.DEB.2.20.1707140926080.27726@nuc-kabylake>
 <11752e09-6ac3-6362-0aac-8e735b80033b@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <11752e09-6ac3-6362-0aac-8e735b80033b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 15, 2017 at 02:12:42PM -0400, Doug Ledford wrote:
> On 7/14/2017 10:28 AM, Christopher Lameter wrote:
> > On Thu, 13 Jul 2017, Sagi Grimberg wrote:
> >
> >> Join on the awesomeness.
> >
> > It would even be more awesome if we had multiple people that can work the
> > release process so that we do not have a single person bottleneck.
> >
> > Doug: Would you please do some more detailed planning and delegate things
> > as possible? A couple of developers should be able to review the current
> > state of things and help to move things forward if there is a bottleneck
> > currently or coming up.
> >
>
> I am, without a doubt, reworking my process.  I will not be syncing up
> against Dave Miller's tree any more.  When I take patches, they should
> apply cleanly to my tree and work without dependencies.  If there are
> dependencies, then people need to send the dependencies through Dave's
> tree (assuming that's where they go) in release X, and then send the
> dependent code to my tree in release X + 1.

There are two parts in this proposal, while second part (dependency) is
fair enough and possible to meet, it is unclear to me the first part
(apply cleanly).

1. On which branch should we send our topics?
2. Are you acknowledge that this branch is going to be updated +/- on daily basis?
3. How do you see us submitting multiple topics? Sequential submission - like DaveM,
and it should be applied close to submissions (if no objections and so on ..).
Or parallel submissions - like it is now and the conflicts are unavoidable.
4. If 2 and 3 are not going to change, should we wait till late rc and submit all (100+)
patches at one or two shots to avoid merge conflicts?

I would be glad to get the whole picture of submission process, before
we are moving forward.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllq5D0ACgkQ5GN7iDZy
WKdSkA//UPQrWh4Rnbt1EdbdnPhp60jQJPptKnwffyDkBAtgkaBLfoKp+bauhJlv
+TBOAh1/A6Ii5jZU/llRaU3QpiwxeEg0Xucsl+6HfUepoREdbn836AOSidUQLxyh
FY1Mjss4MwY7EslsIXYZL7N3qSEc5u9eIwkU0iPr5b8d9VhEouboPdtcfO3oOrPV
73VgOi2YZS3mkSO1fbbyhDPgQoPB/bWgdHUBqZwajCoLzJ1HxsDdHh6WQUpkJOKT
+W7gcYztfzz4raycVnLUPp8AwlaYGHDnds5jIFTHJTAQn1gItXdZPkmuVXmhbv89
Xw9JuRwRVDFXHg5uJVm59EP/50LwM7VghUwyq9Amsv3PIZnlg8CKJsM7lGiRFD9v
D/twXNaV/maY8UHFX6RvDP7nLQNWIAAFRNJkZOv5OzJyCZ5MCVw6SYnEy9nMB4FZ
G6+RqOB30wd7e+KGbhKMX0zgOEVBXq0pkKoaRkM2mHGUDc3RxzetBtZxw90PPxiV
45J+M2KlAInD9czLeRkqjgDDoxPX94ldmTwyf9JdNAnuda1xZp8I+5/yrx4ql3Cr
I6ZMEVDkLGtxCCcAohQWW8u6HUKLCwiuLdNO2QnbDeGyCikYKMins9RLk6anfKlF
B3bX1PRNB6IG03bTxDnFkpjj1tR8+l8F0C3hF9FPP1ilg3DTqOw=
=3TfZ
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
