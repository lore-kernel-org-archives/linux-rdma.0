From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 28/31] IB/cm: Fix avoid sleep while spin lock
 is held
Date: Sun, 19 Nov 2017 12:52:11 +0200
Message-ID: <20171119105211.GW18825@mtr-leonro.local>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-29-leon@kernel.org>
 <BN3PR07MB2578DF2F9081ED97D5A4351EF82D0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jcnm62QQeDGsz6av"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB2578DF2F9081ED97D5A4351EF82D0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--jcnm62QQeDGsz6av
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 19, 2017 at 08:42:17AM +0000, Amrani, Ram wrote:
> > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > In case of LAP are used for RoCE, it can lead to a problem of sleeping a
> > context while spin lock is held in below flow.
> >
> > cm_lap_handler
> > 	->spin_lock
> > 	-> <..switch_case..>
> > 	-> cm_init_av_for_response
> > 		-> ib_init_ah_from_wc
> > 			-> rdma_addr_find_l2_eth_by_grh
> > 				wait_for_completion()
> >
> > Therefore ah attribute initialization is done for incoming lap requests
> > outside of the lock context.
> >
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Should you add a "Fixes:..."?

It wasn't clear to us the origin of the problem hence we decided to avoid Fixes line.

> Pardon my ignorance, but what is LAP?

It should be LAG.

>
> Thanks,
> Ram
>

--jcnm62QQeDGsz6av
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloRYlsACgkQ5GN7iDZy
WKcr7w//csWvoPLpML9QPhVDNf5lVZyU0VCeBwhbgmh5Obnf5C8q0OtkB/x67DV6
z0YIoyYqRuiCEndhhh1z+KsbMpN+6sfdDQq8jepaT+f2pdecwVN0To1uthbnoF0g
v//iVEaNXIuh3ft5RsQtsT3pP/lZRqalVq18ytzl6eUs9Sa3cLzu8sapRefIaV72
q4wfPffTHhqAWbjjFRLs/sQRDk7FSXWuzAnAZnR6BjV9wY24LAD6RgTfTDPBFmZU
OIvc9lyMgn8srXUM1E2fMsAak8WmewfpUhho23lP6LBzfb9UiKtXrxSbQ1gTr6On
OdHh97W73I417L/r246gNAsCmCtjsMLjgtNYwtg9mnLJ2pGtFhEjSTvOAhOtVOsh
/N+lNVufmakzLRqLxY9/RwPqUd/Y/84W5Zz2PyfpjS5FyKa5l2zaoLaSdJcnUqEd
QajfGIRzCFSbD5fihaES/lyLRuyuV5OOJcHsnE24zen3LlpZYV2c5UOHXtm/OF16
TiRlmbz9Mi8Q7yu8pdx/MTPiJE/cWjZe0zg/vTTthOKn0Jzy2muLkZ+i2+yxuG8b
Cp2+1XbNxtBOPKiX2DvhvC6Pog86Nz+ouL5cVQJGvwlbn+WL1lkzgln+XP8LGwar
QiZUU4Oecf9WABP43yBNPtmGdyVqLxQabEUsY6oc9IywJlBGaYk=
=LGpn
-----END PGP SIGNATURE-----

--jcnm62QQeDGsz6av--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
