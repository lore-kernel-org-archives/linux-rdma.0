From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/ipoib: Enable ioctl for to IPoIB rdma
 netdevs
Date: Thu, 24 Aug 2017 13:59:25 +0300
Message-ID: <20170824105925.GI1724@mtr-leonro.local>
References: <20170823053721.18510-1-leon@kernel.org>
 <20170824081156.GB2448@yuvallap>
 <20170824092035.GE1724@mtr-leonro.local>
 <20170824102657.GC2962@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YOUJ+9SC2P4ELYXZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824102657.GC2962@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YOUJ+9SC2P4ELYXZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 24, 2017 at 01:26:58PM +0300, Yuval Shaia wrote:
> On Thu, Aug 24, 2017 at 12:20:35PM +0300, Leon Romanovsky wrote:
> > On Thu, Aug 24, 2017 at 11:11:57AM +0300, Yuval Shaia wrote:
> > > On Wed, Aug 23, 2017 at 08:37:21AM +0300, Leon Romanovsky wrote:
> > > > From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > Adds support for ioctl callback in the RDMA netdevs to allow
> > > > supporting functions not handled by the generic interface code.
> > >
> > > Suggesting:
> > > s/supporting functions/supporting ioctl functions
> >
> > I think the "ioctl" word in the line above catches all readers who are
> > doing grep in the commit message to find relevant for them, but if you
> > still not convinced and think that it needs to be updated, please say it
> > and I'll resend.
>
> No. This is minor, no need for new post just for that.
>

Thanks.

--YOUJ+9SC2P4ELYXZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmesY0ACgkQ5GN7iDZy
WKeI6BAAltzIghp9ISYojAb3aH24zpWEsT5epV7xq1Js1L0hvOBkQgyD9eE22Eym
vG92Fk/YP8BLE3NGdvyS3MsrSw/QhoU3w55UoakM8VbmI6Ms68SgjzkBXB7GLIMW
i6P+bGoleQ/DbNzm3Qq6QshSwWYp3iXCldcuenE5SecNCOfZYV9sE80k7y9JRBLu
dutGD7TON/bl5FTyeW6bkjqEsQ9SM4T0TWP0wgV9XgKEK/Bwj0K/cabXw70IeuJ8
JDWeCta3Ze4RVud34k276z3mu8eto4X7zN7UNMVhekHE3O5lo2O+zBS2GkAtf2Zf
u25JvszYHZYvXQtDWMOkZVIwipjFb6rYn7aRFhmH3nCDMjNMtFSGXdlrvsM1hUJH
tvU72fKhIHgJfQ04NKcBJZEZr1W5/ujrxiNrqs1YBMIZOZg1Sijgii6KquppzbXF
ILxjy406Ck6x0CkK2nEwB5CKOy3xXJ60pM1LZUV494hz980Yr6utltO2teX/d6cG
dz35Sa80YGi6MEUw147pmLMWPSDS1ZgoSix2PRGZNdB7RVr5ymU/2EzW3YQgh/o3
T3iBiyZ/6K1Bf/7D1ZUWalyfQ6zetQMe3BRPLUpgmgASMgt8i/vjSGm5CHQzCJrZ
yLTxywsMRKvQ7e6g4VIghXDLyucf69+bBtUtE+CFd/nCNwwjS7k=
=vXo4
-----END PGP SIGNATURE-----

--YOUJ+9SC2P4ELYXZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
