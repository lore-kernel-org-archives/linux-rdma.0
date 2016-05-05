From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/4] IB/netlink: Make ib_netlink a standalone
 module
Date: Thu, 5 May 2016 09:41:51 +0300
Message-ID: <20160505064151.GI29160@leon.nu>
References: <1462376518-6725-1-git-send-email-leon@kernel.org>
 <1462376518-6725-2-git-send-email-leon@kernel.org>
 <20160504184652.GC20554@obsidianresearch.com>
 <20160504205324.GA10115@rhel.ra.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yzvKDKJiLNESc64M"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504205324.GA10115-f85VyEmKvEatqXYlAKuG4QC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--yzvKDKJiLNESc64M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 04, 2016 at 04:53:25PM -0400, Ira Weiny wrote:
> On Wed, May 04, 2016 at 12:46:52PM -0600, Jason Gunthorpe wrote:
> > On Wed, May 04, 2016 at 06:41:55PM +0300, Leon Romanovsky wrote:
> > > From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >=20
> > > ib_netlink is initialized by ib_core, which means that any module
> > > ib_core depends on (ib_addr for example) can't use ib_netlink.
> >=20
> > What is the downside of merging ib_addr into ib_core?
> >=20
> > It seems like we have too many modules already.
>=20
> Agreed.

Thanks,
I'll move v1 of this patch to my "trivial fixes" series.

>=20
> >=20
> > Jason
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--yzvKDKJiLNESc64M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKusvAAoJEORje4g2clinJNkQAJ5wwOal9VE3TlC43KOXAJWv
tc3bLr1n7Bt95Na2FSpva0i0RiVbwauijwZ16a5frb92nfbOytPDfvUbQqWcZFCQ
4nWx5ywD37xYe2Tmc7CUvUZFVw0eyH6I0ImayFsDdGjXhlRgO1661vhtvPUly7RO
Mslq8dje0w2hEYrMZ6D9RP99N8ykWogw1iyQi7XYyIJXyVFF35PWYwesUEsJkjvG
xcKA5pxmB0K8dgmqiQfsQzoQ2P8mQMIov4YkDfoz0rSzmWZfgvTrsDs7Jaub8dPz
e9QRVPpR7HE0abM7ShVmwTMgPeGRwVfKc7vhfQ+7jcEbLatXiebimVVAi0UTisWU
B+08atpKyAAicJTxxJw0s0UjErJgp0dRVG0XwP/pVT2DJTWaBKuLelYqaxjJBgKR
g5Yqvbw07GAVsuHyx7OGOsM/lTkxAHLoefcmU0HFbw7Jdv0kHMSv4kprh78lVMEl
eBM9VtgQg61YgKFGSH6Le1GsCJS9iH7c302efYAx+sJLQ6B2xude6ZobbODRc4Sm
CkkaWa/02MTKFdycphg1H95cYMu7aC8pAa2FoUjYIncONcUDcr0qWs20Gbaxq45b
WqP+yjihJOvS1afj2a1LB5asQEupceQSJfssiuxGAq6sbxcHJi4SN6kuOQ9gkhpK
+EyPSiZl80zw1ZBmEXVX
=Abti
-----END PGP SIGNATURE-----

--yzvKDKJiLNESc64M--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
