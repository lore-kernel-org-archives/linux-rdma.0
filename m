From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: (unknown)
Date: Mon, 26 Jun 2017 08:21:17 +0300
Message-ID: <20170626052117.GX1248@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7fXEoLLey27Fs/d6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--7fXEoLLey27Fs/d6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Bcc:
Subject: Re: Proposal for the 2nd RDMA microconference (LPC 2017)
Reply-To:
In-Reply-To: <786f10f7-6253-c95b-49e2-a89010a43781-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sun, Jun 25, 2017 at 11:43:35AM +0300, Marcel Apfelbaum wrote:
> Hi Leon,
>
> Here is our proposal for the coming conference.

Thanks Marcel for sending proposal, I'm looking forward to see you and
Yuval there.

In the meantime, I'm adding David who is our LPC POC and would like to
ask some questions.

>
> Abstract
> --------
> QEMU's limited RDMA support leaves it behind other modern hypervisors.
> Marcel and/or Yuval will present the implementation of an emulated RDMA
> device, analyze its performance and usability, and finally talk about future
> plans for a possible virtio-rdma device.

How are you implementing different fabrics? Does it completely SW
implementation and/or it requires HW beneath like prvdma? Namespaces,
migration?

What are the expectations from the community?

>
> Audience
> --------
> The audience is developers interested in device emulation / RDMA.
> They can expect an interesting discussion on what are the difficulties to
> work with RDMA in Virtual Machines and they will be welcomed to share their
> ideas.
>
> Benefits to the Ecosystem
> -------------------------
> Knowing how to tackle RDMA on virtualization may give developers an easier
> start on adding RDMA support to QEMU, which in turn will leverage the modern
> RDMA cards on virtualized environments.
>
>
> Thanks,
> Marcel & Yuval

--7fXEoLLey27Fs/d6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllQmc0ACgkQ5GN7iDZy
WKda9A//bD6nusi6QtYGVIbKvuQyV2SjetKX5Hq1EpKhxaxiW1eikHPaUGvMmKbs
4do4zceTiMqi+tL9G6aBLkp/OmJ5I+2Oc1TWE92EZd1BQamY1cKR9OJZM8YiIEVL
x5GVsiGBqgYpAn7UzH4A6Yl1gfGVAIAZPKJsCsQFk1MR+lqhiCZoYxM+VHSlE6Q9
mFtHJSc8HkjGuzZEwa1FK1ziXXoxsYdkGExhw0nfu1bP5NA1qC1i4rm1cJKTu6uJ
aV673CIzMmI8FMoqF/ufk5Icstn9LIKMg4VCdixmWRePD++flvnFexTZESBbSkJc
quEG6TBb3BA4YfqtiBQy6iNSGTphmP3dLrdkXhKquhlWfRADed4ry9R1Jyld7mOa
5AYZSSLPl1+g4WPaUgscLzbFvKmW3aoPrq164CV2Qb1eYz2xy6LwKdVx9h1fp7AK
VAXzbfBEkifkRtv7GGJwZzo7Croci90lC1fBls9P5SN8Nr9zvIiBMoXxWDTH52RR
0GNVyWWLJ1cV3PpiDTmE7ic9wKx9KYUp9jzgs0Ho7iLg3LmToG3eyl+MjMFZeVNe
6LrKrPYE1y5oatQ4XTTVPZiVrLsanCbjDMPwnRcwvE/R2IC/t/Nd5orGEEIIU9tz
1K0s+dQuXbd956jxLqciEzKOc/cqGHJfLavkonIKiTPeLGcprdk=
=wlgh
-----END PGP SIGNATURE-----

--7fXEoLLey27Fs/d6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
