From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Remove unused vlan_tag variable
Date: Tue, 31 Oct 2017 06:56:54 +0200
Message-ID: <20171031045654.GD16127@mtr-leonro.local>
References: <20171029150522.23641-1-leon@kernel.org>
 <201710310908.yPZM7LsV%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kgkihKxW3Un7xdgA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201710310908.yPZM7LsV%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--kgkihKxW3Un7xdgA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 31, 2017 at 09:36:54AM +0800, kbuild test robot wrote:
> Hi Leon,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on rdma/master]
> [also build test ERROR on v4.14-rc7 next-20171018]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Leon-Romanovsky/RDMA-bnxt_re-Remove-unused-vlan_tag-variable/20171031-085111
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git master

It should be against k.o/for-next. There is no rdma_addr_find_l2_eth_by_grh() call there.
https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git/tree/drivers/infiniband/hw/bnxt_re/ib_verbs.c?h=k.o/for-next#n659

Thanks

--kgkihKxW3Un7xdgA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln4ApYACgkQ5GN7iDZy
WKc+lg//StZWW53g5RD8fZry0pAfi2kH6XM9/ifFX3XXdiOC66i0LpwOcJFBp3iX
vgm9DXynlXt6lD1ZxyZaoJjiLz1gPjE04oNoQTf+RekgSee54XeqGuw4uRX4J491
scn99LhKgFMYrpKMWKR6zot5en4VHdzFzh4ciZc4E687HlYthjMjaHN6ZapHnSLd
DPcOn58FSV1j6Q1CM+nlSMt35spquZMoa6855nSgqkrGlU6cBf2DDtcm0thhD3eI
Rl6OEKfxRytaT10aJrDqsDAB7iwyTe3hswARn2mDPfj+UL81/eG7Z+2Dp+HNmbyI
SFycbi9BFwP9kPIXnIeivh/Y8k3csciljJ6/b0rywmdyjoz9Xy2OmSb2Qh4fXRP3
kpxo4Zy9suZQcCQC63dDMU7/VaJjKpQ8vxEBj/8V/V8CAki5b87HaJjRcEVHt5bo
6+MT6gQAX4cDWKLA+5CMiwY0NcCW4/2gQvkOSf4DobWQ2I2ukGSwVZsYpNR3xlwb
WXiDmBWa1cgagr+CGqh1lhBn6XIn31+BE4qUaTWQogoK+Ozunj0qzYqr2NrGhR4U
/0deNxXPwIPD9tSK90CQ360ErOoHFAuAEGy0z7Vkpu+9YrCGsBCMt2vgd0rhJ3de
jEkWyrK91cQlfmCBDJHA0QUuM4XtTM749ntPA/klSsfu16GtAjE=
=7jh+
-----END PGP SIGNATURE-----

--kgkihKxW3Un7xdgA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
