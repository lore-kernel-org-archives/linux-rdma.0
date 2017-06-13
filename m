From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 4/5] verbs: Tag matching send interface
Date: Tue, 13 Jun 2017 09:33:31 +0300
Message-ID: <20170613063331.GH2576@mtr-leonro.local>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
 <1497249767-15353-5-git-send-email-artemyko@mellanox.com>
 <20170612164140.GB12282@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EemXnrF2ob+xzFeB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170612164140.GB12282-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--EemXnrF2ob+xzFeB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 12, 2017 at 10:41:40AM -0600, Jason Gunthorpe wrote:
> On Mon, Jun 12, 2017 at 09:42:46AM +0300, Artemy Kovalyov wrote:
> > Add tag matching header (TMH) and rendezvous header (RVH) definitions
> > to infiniband/tm_types.h
> >
> > Change-Id: I35a2088190ff4a1776f77b43a4564bb6f65ca83c
> > Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  libibverbs/tm_types.h | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 70 insertions(+)
> >  create mode 100644 libibverbs/tm_types.h
> >
> > diff --git a/libibverbs/tm_types.h b/libibverbs/tm_types.h
> > new file mode 100644
> > index 0000000..7626787
> > +++ b/libibverbs/tm_types.h
>
> There is no cmake stuff for this file, and it is never used in this
> series - what is the intention here?

Jason,

It is RFC, the intention is to present headers and APIs in most clear way
without distraction of error handling, manuals and Cmake changes.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--EemXnrF2ob+xzFeB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk/hzoACgkQ5GN7iDZy
WKeniw//dOU5c8FDGtqYGqrs8Koywvu7drwC+ndCH/AtAtyxyoUvZNQPsKjgsHTj
1EJzqdbyqz6DWZZPfvrF3WLpaXUcHJwdmeLv2AHVaP9ilnTbZv9+lqOOJ6XTHBN+
DN7+dBNrBYTxTLnexM5svOsYigJdhzslwRGHgYv8r7hRx+A5qemzClntRdjiLu1g
xdKk9Bu9vKXX93hkzTP8F4HDKFtuS7TEHwi1SsnhkU5rUx2rHZUpbGju5u0DOAdM
2rON1T2O5Ngx4lZeXsAVkTEaKoHeBSkjiR3cXuEUxzjXPe7xq4ojxHAGICL4tqxn
CWqH+Ip7YqaeNaKAc0eudCApIwfTx/Hz1Rqi4WBzHyCWwoWPsS2PNIF0U22KF2Rm
tjMjnrAuyUubVE6ouKbGeS4JuWFc4QXc6z4/8RpfgZYSENj5elvEd88F8qC8Kc5S
NPCREHdksJoOxo9fkj5fPiUok33DEx2BSbDNwv8YdPashwdul6kJQsRtnDPUVXHi
NbMcndCFCCbAAuC/BGIpVW7PjrNiUAwaxT0wSBvPVCZJ7k/gGNRFJCSIF3gyH8yr
q9b+XmANlg/GdKefierNksZiDJnKPA5IckmqAvZ65eaZc5ncCubDjt6icoJHSrgj
oxHDamhqqcj1tOzSvJkFEjo5ZpbRTfAuu5Lz0qV9aKDUyfJ/ZDI=
=9FHt
-----END PGP SIGNATURE-----

--EemXnrF2ob+xzFeB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
