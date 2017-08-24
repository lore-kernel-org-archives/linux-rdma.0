From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Return pointer to CQ doorbell
Date: Thu, 24 Aug 2017 18:50:36 +0300
Message-ID: <20170824155036.GN1724@mtr-leonro.local>
References: <99bc8f57-6a58-d309-7142-74cc498f7feb@dev.mellanox.co.il>
 <20170821152237.GA3400@obsidianresearch.com>
 <912a3e5b-7dbc-061a-53f5-b3cf3bce9d9e@dev.mellanox.co.il>
 <20170822163007.GB4922@obsidianresearch.com>
 <1b7e41dc-4873-7c0a-6cdb-bc499af70af2@dev.mellanox.co.il>
 <20170823160816.GA11188@obsidianresearch.com>
 <20170823164555.GV1724@mtr-leonro.local>
 <20170823165221.GB23928@obsidianresearch.com>
 <20170824052716.GD1724@mtr-leonro.local>
 <20170824150045.GA23110@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mwyYwuEU+DI08Yj7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824150045.GA23110-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mwyYwuEU+DI08Yj7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 24, 2017 at 09:00:45AM -0600, Jason Gunthorpe wrote:
> On Thu, Aug 24, 2017 at 08:27:16AM +0300, Leon Romanovsky wrote:
>
> > It is not complete output as I would expect to see. It doesn't have
> > mlx5dv_init_obj (without explicit @MLX5_1.2). There is a need to declare default
> > function name for the static linking has no knowledge of versions.
>
> symver support and static linking in verbs has never worked properly,
> we need to do more work overall to fix that..

Fix yes, but push something that works to be broken is a different story.

>
> Some common macros a bit of use of .alias will do the job, but nobody
> has cared enough about static linking to do it. We shouldn't worry
> about that now...

Maybe it is true for libibverbs, but it is not for libmlx4/5 which can
be statically linked.

>
> > The simplest approach which is used in whole rdma-core is just retain
> > the original function name and the patch below on top of your patch
> > achieves it.
>
> Well, if this is the result you got:
>
> >     99: 000000000000dab0    55 FUNC    GLOBAL DEFAULT   13 mlx5dv_init_obj@MLX5_1.0
> >    165: 000000000000dab0    55 FUNC    LOCAL  DEFAULT   13 __mlx5dv_init_obj_1_0
> >    194: 000000000000d8f0   443 FUNC    LOCAL  DEFAULT   13 mlx5dv_init_obj
> >    268: 000000000000dab0    55 FUNC    GLOBAL DEFAULT   13 mlx5dv_init_obj@MLX5_1.0
>
> Then changing the name totally broke the dynamic symbols.

Yes, I see, mlx5dv_init_obj should be GLOBAL.

>
> Which is what I remember when I last tried to work on this (to avoid
> having to specify a prototype for the __).
>
> I concluded the linkers broke if there was a symbol in the link with
> the same name as the versioned symbol when using _symver.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--mwyYwuEU+DI08Yj7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlme9cwACgkQ5GN7iDZy
WKer0A/+KlIiddiwLnw73Laapd5WSbxImsnYKKGo0ssyf2BSAiE64yHMdr7dTjSZ
/2eOafCcH7OYzjmzdUj66WkB9lUSMuGXMQ3ITpB2l/VhvKpGDwSFIidy+F1S54LM
gDDbgyJ9PqKF/jVO3352iJR/IE5sBps3D/ljKIQzckX2WNkB/H/Kce0M5ogFe9Wd
D/W3Y0FXK/q0kRs2hVVozfAU3j/bMFovpmwOmEhQUmjdr+K4XJt1nbg3PSGc34Vi
PJsBERYV6kqXvw25y/TMFMR/Ug5Z1MjDwam+fLqjs5doTdKkRHdvMOp1y2sF0DQ9
4Vk+GqL3MupuyzOn18vMHTj/8PiUNvf5BbjC9R6ic14z8Cnvw9THKQOoehsV8/yr
dYYNR5LgNt6GYZVPwBBG4rHIWHyVhTdSuEdfx5JVrnndSxL4Dw7hyDMQ7K8CrViv
/LgPubVc7wVwyuHF8Rlvt7pvU/9U1oizCvebqdRbW486P88EBaUqoyEzrxt7AsNs
3nhVizbN7ZUU73vFJHSz87PWH2CJIZuQ/1K2SV+jynGdfFCJmYxjY6lx8PqiiA/k
UUpkDjjf42r5krYKKuFEaF1+Cb7KKxcsrp/2Q2FvpY8FdBVwuwpp5gVeo+jf/c6k
FCULQpFXU7KfE28mm5esfQ/X4+qtN1T+HtZ+aJepMoWWGhc0rEI=
=Ur/T
-----END PGP SIGNATURE-----

--mwyYwuEU+DI08Yj7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
