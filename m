From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error
 state
Date: Thu, 11 Jan 2018 08:22:52 +0200
Message-ID: <20180111062252.GP7368@mtr-leonro.local>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
 <1515620434.3403.169.camel@redhat.com>
 <1515621700.3403.174.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Zl+NncWK+U5aSfTo"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515621700.3403.174.camel@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Moni Shoua <monis@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--Zl+NncWK+U5aSfTo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 10, 2018 at 05:01:40PM -0500, Doug Ledford wrote:
> On Wed, 2018-01-10 at 16:40 -0500, Doug Ledford wrote:
> > On Tue, 2018-01-09 at 11:23 -0800, Bart Van Assche wrote:
> > > The following sequence:
> > > * Change queue pair state into IB_QPS_ERR.
> > > * Post a work request on the queue pair.
> > > Triggers the following race condition in the rdma_rxe driver:
> > > * rxe_qp_error() triggers an asynchronous call of rxe_completer(), the function
> > >   that examines the QP send queue.
> > > * rxe_post_send() posts a work request on the QP send queue.
> >
> > If rxe_completer() runs before rxe_post_send(), the send queue is
> > believed to be empty while a stale work request stays on the send queue
> > indefinitely.  To avoid this race, schedule rxe_completer() after a work
> > request is queued on a qp in the error state by rxe_post_send().
> >
> > I think that improves the log message, yes?
> >
>
> I did some further edits.  But, patch applied to for-next.

The proposed patch definitely decreases the chance of races, but it is not fixing them.
There is a chance to have change in qp state immediately after your "if ..." check.

Thanks

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--Zl+NncWK+U5aSfTo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpXArwACgkQ5GN7iDZy
WKc24RAAmC/5O2g8Xw4wMaW8RqO+/Ss2Q880B09oLTzK+sobVK/EeIXuh+Q9M2Zt
7KE4a8ducCO0un0zh2CiZJ8L1Koh7fC35yhRmbfyELSiv3E7dOecF7btIu9lv+ft
wAOuUmx9gURr7Mh6cPE5CcyNgbdKhYqkJFKcnh2Br3GgrgujgN9s6o+pGDT4Je0n
1r1hzK5/PFP4ywkINDR28/0WxjcqS4MNBLp8sw7MBKjOmKGFaVMWZ/2BjvMk18AD
HGDK4UAQSPOoUK1TDsH5OJkZuvD0meZTaNIAJFKTPnsNzJJI72qirIrhF90cljlK
NM7vaUfw5lgrmhJDtaowKhKXLD7ujzRXUvwkqnMzx6TKqLna7diV8JWVzp5juwDd
X7a0g/Beki6mUaNPB9w3YQNtL/Ya++gpuMIH9qUFdb40fxZrKRG22nUH1AzTjazf
wN7otEDo69RSMNcTjStNVoLr96tETyVNOan+FYXt+H9yDYxqDvyUMkVDDkP6Z5P1
MQHUkFjpZlWLjWdoqwZ+sqEyNX57jpy/Z5Tv45vAT9Jz8nUMdlC25W47b0l8hi4P
5zDvMyQZKO1vcrYKsZx7NbhT2JnhQ5WLsAIkilqKSq4H7F7xLK0NoXwGa24+ZIyJ
M4lWxiwmZgIEfgO0+iRXHHepQuDUMKuyYCBvdSySecd5qsxhLt0=
=vVaG
-----END PGP SIGNATURE-----

--Zl+NncWK+U5aSfTo--
