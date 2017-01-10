From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Missing Patches in Linux Kernel RDMA
Date: Tue, 10 Jan 2017 20:28:15 +0200
Message-ID: <20170110182815.GN7218@mtr-leonro.local>
References: <20170110143018.GM7218@mtr-leonro.local>
 <1484067238.2149.15.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AqCDj3hiknadvR6t"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484067238.2149.15.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--AqCDj3hiknadvR6t
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2017 at 11:53:58AM -0500, Doug Ledford wrote:
> On Tue, 2017-01-10 at 16:30 +0200, Leon Romanovsky wrote:
> > Hi Doug,
> >
> > While reviewing patches on mailing list, I was amazed to see
> > patches accepted before, marked such in patchworks but don't
> > exist in the Linus's tree.
> >
> > The first patch which brought my attention was Christoph's change
> > "IB: merge struct ib_device_attr into struct ib_device" [1]. The
> > other
> > missed patches were from our pre-ABI series "Refactor RDMA IOCTL
> > declarations" [2, 3].
>
> I obviously had these in my tree at one point, the last message I wrote
> in response to the 6th patch makes that very clear. =A0But, the patch
> series is indeed missing. =A0I must have failed to merge it some time,
> but thought I did merge it and moved it to my post-merge area which
> then eventually gets removed. =A0I'll have to re-grab them.

Thanks,
Can you please publish official branch with them?
Matan is going to send ABI patches very soon (they passed our
verification) and he needs to be based on them.

>
> > I'm adding to CC major contributors to this subsystem, since I don't
> > know
> > if any other patches are missing too and don't know how to check it
> > without
> > doing full compare of Linus's tree with linux-rdma patchworks.
> >
> > However for these 7 patches, can you please grab them from patchworks
> > again
> > and resubmit?
> >
> > Thanks
> >
> > [1] https://patchwork.kernel.org/patch/7372541/
> > [2] https://www.spinics.net/lists/linux-rdma/msg39954.html
> > [3] https://patchwork.kernel.org/patch/9312603/
> > =A0=A0=A0=A0https://patchwork.kernel.org/patch/9312593/
> > =A0=A0=A0=A0https://patchwork.kernel.org/patch/9312597/
> > =A0=A0=A0=A0https://patchwork.kernel.org/patch/9312601/
> > =A0=A0=A0=A0https://patchwork.kernel.org/patch/9312595/
> > =A0=A0=A0=A0https://patchwork.kernel.org/patch/9312599/
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD



--AqCDj3hiknadvR6t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh1J78ACgkQ5GN7iDZy
WKdCkBAAtoBrbiz5fAIq5bR2GbSLDQc3PlaHGhr97/15DoGvLFUKoDULoOKTfPGK
+7C3zZpzyxJb05+W2PMnlZY3bt8myvMCivdaol4BOjTdhKqGU4o5JIUF4Y5Z8c+N
NZZEyKaboC5HIwNztUaPJZDqj1jfBXAPDdPGZf8Z2ooJULZbUSadyBZRGNdqS/xE
wqs8RJoZsq1xklQFibcVzl6ue1BYAu89qeP+IVTzB9h3gAv20W9BdfqvxhyE/clE
pdbjGJUM1IIYUTx3ObTsA3pcd7/3H1bKsv5oIuaZ3smXjSI4aSyWFTx+HzgM1x3n
JByZ3PWqNdTeIGNTUHFO+UFRL+xlvG1vHmbJqajOCWSkwpzr4SV0TGmG9a9GWzve
Jk+rC0HBIsj+XVZCfZgNVaq7U3s4PTYnwHWYJG4+bd3YFzStc0gRySg4WjgssiqW
kVmoY5pECO36H4RB/wVXrKDcpmx2wAdmSMF9Qgcxiaeor+stNjrC8+Bta/xLbrsC
KhmH72ZHLpwffJKjO/2BeIfVpYkrDf+lWcFI3YKVREVVL2LPrw5MBGhkMXJmKAjJ
Ot6U54KO8tV9kD8NqfElWvzQuC04WRwkSpAE8xnr8CW18p3OqG/kA8HQrGDeltes
xNZNZROu5cQvhAjAfZYzrsEEdD3cF6qNDV7dB223WHGo5Ezn2Jo=
=NgTa
-----END PGP SIGNATURE-----

--AqCDj3hiknadvR6t--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
