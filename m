From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Avoid large frame size warning
Date: Mon, 6 Jun 2016 19:17:08 -0400
Message-ID: <d5f6df2a-50e4-7b37-70cd-f2e3d6a8a45d@redhat.com>
References: <1464681276-6494-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="D6xilUr4dejF5XMEQSpaNQnqewDPPXAK5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464681276-6494-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--D6xilUr4dejF5XMEQSpaNQnqewDPPXAK5
Content-Type: multipart/mixed; boundary="7aMr2weVcexsbJ5ud69bkmSxS8GSNecG1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <d5f6df2a-50e4-7b37-70cd-f2e3d6a8a45d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Avoid large frame size warning
References: <1464681276-6494-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1464681276-6494-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--7aMr2weVcexsbJ5ud69bkmSxS8GSNecG1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 5/31/2016 3:54 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> When CONFIG_FRAME_WARN is set to 1024 bytes, which is useful to find
> stack consumers, we get a warning in hfi1 driver.
>=20
> drivers/infiniband/hw/hfi1/affinity.c: In function
> =E2=80=98hfi1_get_proc_affinity=E2=80=99:
> drivers/infiniband/hw/hfi1/affinity.c:415:1: warning: the frame size of=

> 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]
>=20
> This change removes unneeded buf[1024] declaration and usage.
>=20
> Fixes: f48ad614c100 ("IB/hfi1: Move driver out of staging")
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.



--7aMr2weVcexsbJ5ud69bkmSxS8GSNecG1--

--D6xilUr4dejF5XMEQSpaNQnqewDPPXAK5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVgR0AAoJELgmozMOVy/dTrkP/2AhU690P+s3e/3mXHPvrtgZ
gBMb+2n/L59hAPr1b0aXl8aH1b2J6QQSa2+JDFL50kRLMF3/CN8p5csa9RvzYnYz
0TPMyZ46hAud4QWD5gj2Wyra5sq91ySwJUvuT3Fc195qsk7uoJK2gh8G4mf00Bk8
CBsg/z/kL4Cf4z6Cks/D3qIRWoYz62kXHT4zX7p0Ysp4Qsht6Pmf3HycGsUkuP64
R1KRFhuivvAHQDKPdiovuZ4cQUQhQVYN+fb7XRuJPaoZRjYcP4Sh4hfXtKeYtVHu
Z3ReOtFmqQFFckeTkZCTU1cM8EokzP/icA+kn0zY8+XIM8jo55//ZEWP8sOLBDQD
PGyZQWDEJGsacuEatpUfUMUZVRg6TpIAZHny0C8IunmYZU1BTsoo039tUQHCPQ1y
wwnqjRpwT4hwNPq1eRwHkjVdbsgXJ9yX4hLShdJzMKPfaEWtMnz+XgTW2YZL+boy
cgIUYIwVjkiPd1Yh2kV+lZbGsuzEqOGz8JYA1KwcxyXJ2JQ/mvn0mur8kSzoS8fj
dOAgrSXScSWiS6vF7F0lGwEFFx3AVQwJ1kMrzpn0vPg07NgygERtqEwNc+D6/dI9
18slHM2HnnVxAiz/oLXyLr6b3vS0b688SafRpqvT1HvKWWBxGqkf4qKCdmtGNnhC
nlUCId1MFILWOh3pG4bo
=/JZX
-----END PGP SIGNATURE-----

--D6xilUr4dejF5XMEQSpaNQnqewDPPXAK5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
