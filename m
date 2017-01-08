From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/15] IB/rxe: Constify the pool name
Date: Sun, 8 Jan 2017 11:40:50 +0200
Message-ID: <20170108094050.GM15685@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353445.3592.17.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GoZzJvFfKjxI3RhA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483353445.3592.17.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GoZzJvFfKjxI3RhA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2017 at 10:39:22AM +0000, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
> =A0drivers/infiniband/sw/
> rxe/rxe_pool.c | 2 +-
> =A0drivers/infiniband/sw/rxe/rxe_pool.h | 2 +-
> =A02 files changed, 2 insertions(+), 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--GoZzJvFfKjxI3RhA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhyCSIACgkQ5GN7iDZy
WKe3chAAm6TJ/Ii+zSya09WRTI8jNXReElIZzNfTUpuR6EiS3YegYwOeFuxyOG5G
jgAFGnIHwVX68LfnqcK8nXOdK67uSEV6vhluzXnV/tqdcprW83VW9kXhmnvx+TFE
2BcXpbt6+UfaG865i7PzR7pNi4DRcZpyWwy2AblAlWB/tlCLLRl8k6KtKP3Mrlmy
KyscNBciV99B/tDadJLBBH4T9BubmZt4YtBomYOhY3GkvDgRRq+hU6bs1ACDViXt
EjURn/G9Nhj+eNgQY2TRuX83k1eBbLQKsa+yJ6+vVPlcO3YXsMUfl8V4OWta43To
mVjpW0WN847JKcCfvU2qeAvxItHpzko6eQgHPJjfffqlTI3A3oVXe/aTKgCbafXY
/DAjLuV6Q+PKQRVz/MXdTUnLrp+NSNW0OZ3971OZohZnZ/kaafM0WlTNP5hW0eRV
DaeJoBCW25KtiZEU8dmiPTwsLABRaAUbGa6c55ZXlycZPNitb/Nv2SctuSOvB4vf
vhq6EVlV1jcCIRXTh1Mhxj4NUF8CZBQ1Zty1wsmKnzE/JLmTQHwF8K4MUzsoO0/S
qhIwQUF+15uwwpjBzU1H3HpyIZtgn5oI7MNxwuLifGg+2ZEDDYC2/yCsRjO/CyRk
XhLf9a+lCMllzQXLnWWvpdrTZ6DiZ2DKU2D/4NLtXv+9zECSWkk=
=ZyG3
-----END PGP SIGNATURE-----

--GoZzJvFfKjxI3RhA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
