From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 42/47] IB/qib: Remove set-but-not-used variables
Date: Thu, 12 Oct 2017 18:54:04 +0300
Message-ID: <20171012155404.GR2106@mtr-leonro.local>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-43-bart.vanassche@wdc.com>
 <32E1700B9017364D9B60AED9960492BC3442B95A@fmsmsx120.amr.corp.intel.com>
 <1507668036.2815.55.camel@wdc.com>
 <20171012084412.GO2106@mtr-leonro.local>
 <1507823130.2448.16.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="im83/wVv0jiGQj4J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507823130.2448.16.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--im83/wVv0jiGQj4J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 12, 2017 at 03:45:31PM +0000, Bart Van Assche wrote:
> On Thu, 2017-10-12 at 11:44 +0300, Leon Romanovsky wrote:
> > I'm running more or less the same checks ( + "CHECK=sparse C=2") and for
> > a long time I'm trying to fix nes and orcdma endianess errors, but
> > without much luck. Did you look on them and plan to address in near
> > future?
>
> Hello Leon,
>
> My experience is that for some drivers, e.g. drivers/scsi/qla2xxx, making
> these endianness clean is a huge task. I prefer that the driver authors work
> on this. I have been using the following patch to suppress complaints about
> endianness issues for drivers that are not endianness clean:
> https://lkml.org/lkml/2017/10/6/638.

Thanks, I'll try your approach.

>
> Bart.

--im83/wVv0jiGQj4J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnfkBwACgkQ5GN7iDZy
WKcUVhAAtsGZZBK0B6MvsQ2ATVbOBHoWPeS9BuyE3H8NwMX0axxWaKiM3fdktVhI
tlzx/aHoi4D2zgWX2ZUTYP9SxOnr8VBouQM+q8co6g802BnJokCJ2QDpHoJNca/V
mtg77K5IETkMbaBMR58ArsZlw5jt4S4qwjkfYI11ZQ0DZn7qD7QHs5B0VXTnRfSB
NVd8s8089GK5z2lZWKACKJYlNynQWRAineVNqHamAehL1Wh2OXC4UNwmImTncOSR
cLTIuwH9wM62vWz1T3nD3PubU7fqpuYvt5elDZ00Npsw2Of1rYrrTgf95VWRQFP4
B64sWWUUMRZ80B/oMy6LDQJVbUUTtzPKoOOgkwLcmB8eE/KJf9Q/+fWzJbnJRgXY
foYHg18OMuKSiuDPaMmc44sj1Pz7Ll5F2NdOFrwL36d2QRFYxXVZAShuN2spHlZ7
n3vqhtnOnahyXXirtP33nazG4QDUgh6mL1Ri1onTwbtVRvk00VmXCc1k3XPYeiUu
5WE3SClTan6L7vFAHzOJOJbn+kOyRq/e5l6kXmvtFEKHK45wZ0um6SXkrQ1UzMOI
y78zXCq+34L/ubuXc+0ICT7mczwMvc+exGRXuax3jKQ8I7M/Yjcajj75hQXYjsfs
D7cftyS5ALpHw4M14d0XGkWrIkGVc5wBxS115ljJpSJKnqjvPCU=
=gCPy
-----END PGP SIGNATURE-----

--im83/wVv0jiGQj4J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
