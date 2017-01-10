From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Missing Patches in Linux Kernel RDMA
Date: Tue, 10 Jan 2017 21:06:07 +0200
Message-ID: <20170110190607.GS7218@mtr-leonro.local>
References: <20170110143018.GM7218@mtr-leonro.local>
 <1484067238.2149.15.camel@redhat.com>
 <20170110182815.GN7218@mtr-leonro.local>
 <1484074377.2149.23.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Bzq2cJcN05fcPrs+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484074377.2149.23.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Bzq2cJcN05fcPrs+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2017 at 01:52:57PM -0500, Doug Ledford wrote:
> On Tue, 2017-01-10 at 20:28 +0200, Leon Romanovsky wrote:
> > On Tue, Jan 10, 2017 at 11:53:58AM -0500, Doug Ledford wrote:
> > >
> > > On Tue, 2017-01-10 at 16:30 +0200, Leon Romanovsky wrote:
> > > >
> > > > Hi Doug,
> > > >
> > > > While reviewing patches on mailing list, I was amazed to see
> > > > patches accepted before, marked such in patchworks but don't
> > > > exist in the Linus's tree.
> > > >
> > > > The first patch which brought my attention was Christoph's change
> > > > "IB: merge struct ib_device_attr into struct ib_device" [1]. The
> > > > other
> > > > missed patches were from our pre-ABI series "Refactor RDMA IOCTL
> > > > declarations" [2, 3].
> > >
> > > I obviously had these in my tree at one point, the last message I
> > > wrote
> > > in response to the 6th patch makes that very clear. =A0But, the patch
> > > series is indeed missing. =A0I must have failed to merge it some
> > > time,
> > > but thought I did merge it and moved it to my post-merge area which
> > > then eventually gets removed. =A0I'll have to re-grab them.
> >
> > Thanks,
> > Can you please publish official branch with them?
>
> They are in my k.o/for-4.11 branch.

Thanks Doug.

>
> > Matan is going to send ABI patches very soon (they passed our
> > verification) and he needs to be based on them.
> >
> > >
> > >
> > > >
> > > > I'm adding to CC major contributors to this subsystem, since I
> > > > don't
> > > > know
> > > > if any other patches are missing too and don't know how to check
> > > > it
> > > > without
> > > > doing full compare of Linus's tree with linux-rdma patchworks.
> > > >
> > > > However for these 7 patches, can you please grab them from
> > > > patchworks
> > > > again
> > > > and resubmit?
> > > >
> > > > Thanks
> > > >
> > > > [1] https://patchwork.kernel.org/patch/7372541/
> > > > [2] https://www.spinics.net/lists/linux-rdma/msg39954.html
> > > > [3] https://patchwork.kernel.org/patch/9312603/
> > > > =A0=A0=A0=A0https://patchwork.kernel.org/patch/9312593/
> > > > =A0=A0=A0=A0https://patchwork.kernel.org/patch/9312597/
> > > > =A0=A0=A0=A0https://patchwork.kernel.org/patch/9312601/
> > > > =A0=A0=A0=A0https://patchwork.kernel.org/patch/9312595/
> > > > =A0=A0=A0=A0https://patchwork.kernel.org/patch/9312599/
> > > --
> > > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > =A0 =A0 GPG KeyID: B826A3330E572FDD
> > > =A0 =A0
> > > Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57
> > > 2FDD
> >
> >
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD



--Bzq2cJcN05fcPrs+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh1MJ8ACgkQ5GN7iDZy
WKeL4w/+O79fvUJSJkoGllaOOkqRe8Y9FsN0bPBikMw2S0Mli/2jQken7dAv6I7+
6Z83Z6scHQMtU8YR0xs6e9CrfCRS1QDuzD0FT7k2BPqLeuQrmuJ4OfJCWpGtvv3l
Ddj9QBQZo2PYd+7fBBe00I+u0lAbMnOkZtlKxY4W4yq17Dg9Ww3LYg09PFkKYVfQ
R/pt1M8C6ZVm4sFt64OBeZIbISdxNqddNYwFu/jsPtXo3+3F/eki4W5VqISV5Lih
UTEzDhvDd2yl1OZvPy0Chmd6aKcBS3KoAoOLrdoWyxLs71eS4oSgifKEF5vYBu4P
f5EkoTmtBsW6QbomvL8SjqnCOMvbRdJKwxnK7PoksMM4uq+YA630QL73ryFqDEty
ridPuSwrT2ZlNBZQS7jsQQdp0ABqUHX34KTe3672h+MMhRRFM0txAnCdWXNp10xY
Nhe2b3pr+4dNa40K8UDVaA/K037pUBoMAngdAGY0WgAIXwu7CZX5mEj3Bu5A3aNk
TicRNxZOyB6lxgAZcTufiQfNT+WUVIVL3S3T/hMVHmIpvS+yBNdalv79OaXMTEu0
VywTU/N/+8E4fxVonT/phrifZoon5PF9g/E474ZdroBqLr3Ntk1PIk2mYf+tGsz2
SfLQrwaFiyfRhe3sZbPxaAVNGzpyJBsWAmcRS++WwgRDdzTmp7U=
=WVIA
-----END PGP SIGNATURE-----

--Bzq2cJcN05fcPrs+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
