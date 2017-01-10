From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Missing Patches in Linux Kernel RDMA
Date: Tue, 10 Jan 2017 16:30:18 +0200
Message-ID: <20170110143018.GM7218@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+sHJum3is6Tsg7/J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+sHJum3is6Tsg7/J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Doug,

While reviewing patches on mailing list, I was amazed to see
patches accepted before, marked such in patchworks but don't
exist in the Linus's tree.

The first patch which brought my attention was Christoph's change
"IB: merge struct ib_device_attr into struct ib_device" [1]. The other
missed patches were from our pre-ABI series "Refactor RDMA IOCTL
declarations" [2, 3].

I'm adding to CC major contributors to this subsystem, since I don't know
if any other patches are missing too and don't know how to check it without
doing full compare of Linus's tree with linux-rdma patchworks.

However for these 7 patches, can you please grab them from patchworks again
and resubmit?

Thanks

[1] https://patchwork.kernel.org/patch/7372541/
[2] https://www.spinics.net/lists/linux-rdma/msg39954.html
[3] https://patchwork.kernel.org/patch/9312603/
    https://patchwork.kernel.org/patch/9312593/
    https://patchwork.kernel.org/patch/9312597/
    https://patchwork.kernel.org/patch/9312601/
    https://patchwork.kernel.org/patch/9312595/
    https://patchwork.kernel.org/patch/9312599/

--+sHJum3is6Tsg7/J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh07/oACgkQ5GN7iDZy
WKcXGQ/9HVV3za6jqqF3ylqFGYpjN+siKIelW9FwRtOp8pzeYxxWgnidxrGfnRvv
xqM0WLjm1nj93yWr7fcNvY7jgTBBwtR+knKasTG5MpDq2isVgRZQjzVNzTSieyb8
oWNZK0Uyh7vl1CekTK6o9J7mHifcQ/H/Bo8+K42UYIm0j2k7k4wVJApuTq04S/H9
bwxRDvjCCbce172bqdzAzjZM3Fs2AsH/6h0G4Ls0hTJvATu0KuRaaxXZfcB7QyQD
NM+ywhT+HrRycDjRhh+8eZyY62B3aQnaZzD5M/5TnroFnsJKoeBabI2GeO+hCrNC
m05PIBnFdM7/3VNcxr1tgdCaFXdwNLtV6W4FODD3hEe7AkuVcuy7OIe9Q2545CP7
K8VcriVdJisM+7yTb9DjUcYQGDrIRDdii81HBdjf2e8GkFH0L15L1id663jaLkY5
o9cbfUabc0vYHvDHaXux1SQtzU+rpNvdc197ez6rXwr8Dwcx5rr9OkoRcoZwyqHU
21dXB80aQawP3msPRbyxmnrZH27K3iiWDuanSPPUoy3EB99gvHoE1AqtmSW9LxJR
6OCe8tujKGlWjNMD/5QR3nS0PzwnKFQ+l4iUNZkEZTF/BjMBrGKHIKZSVhkdnQSV
c4/hMEaL8jGxheXxCbLC698p/YIXCcb6sEBXfCJF7m/K+OKj584=
=kWE/
-----END PGP SIGNATURE-----

--+sHJum3is6Tsg7/J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
