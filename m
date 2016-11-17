From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 17 Nov 2016 22:02:03 +0200
Message-ID: <20161117200203.GQ4240@leon.nu>
References: <58466423-c87e-3921-101e-bffab8989fd8@redhat.com>
 <20161117184950.GP4240@leon.nu>
 <582E089A.3040106@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4ECF1u7dKBoUGhe3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <582E089A.3040106-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--4ECF1u7dKBoUGhe3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 17, 2016 at 02:44:26PM -0500, Doug Ledford wrote:
> On 11/17/16 1:49 PM, Leon Romanovsky wrote:
> > On Thu, Nov 17, 2016 at 07:13:54AM -0500, Doug Ledford wrote:
> >> Hi Linus,
> >>
> >> Due to various issues, I've been away and couldn't send a pull request
> >> for about three weeks.  There were a number of -rc patches that built up
> >> in the meantime (some where there already from the early -rc stages).
> >> Obviously, there were way too many to send now, so I tried to pare the
> >> list down to the more important patches for the -rc cycle.
> >
> > Hi Doug,
> > Are you adding the rest to your for-next branch? We would like to have
> > enough time to check that nothing is lost.
> >
> > Thanks
> >
>
> Yes, it's already there in the mlx-next branch on github.

Thanks,
Do I understand you correctly that it is not final version and you
didn't upload general branch yet?

There is patch for the MAD which will be great to see in the list too.
https://patchwork.kernel.org/patch/9382745/
http://marc.info/?l=linux-rdma&m=147681123708587&w=2

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>    GPG Key ID: 0E572FDD
>   Red Hat, Inc.
>   100 E. Davie St
>   Raleigh, NC 27601 USA
>




--4ECF1u7dKBoUGhe3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYLgy7AAoJEORje4g2clinJJgQAJy9T7nEJFbTtntwRO0Y9/aT
hdrh7imQawdPk6RPLd/Y8Cez6zgKQFd7NC614pHi+8pMlYkmsW6JCPdlN/1AUkKu
j4KI7auw6kIguny+fidfEye5qDCdndhwtfzQu2ATq+uUG9RbhevaPSQemPFFLNo+
xyAgn47Q6e8968uWJc88veZY2ZUCy9C4wkeWm9XUlIO/xnmcxnr6Jxby/n1bua3S
Yve5HXaxjTfyj8R+NDlG8It9DerJErXUDtVcz/+Elcb0yXpwcZRpUDAbtIPm59aM
+OpTiepzOnYs1lZfAYO1yFGaddPNemmcyLr5EibwwExfeEHWWC0EiTNW7G8t0oGv
p4jwN1o/U8Ase2/tAMdLTed/Eu2brB1nEl28JvJ0pPwBU8Td+fnpJhSft8iFUd3e
TKaE1w578Bhnb540qfMs98yhnDRZWEmnhbwKW+2AvHoCK87qO/Bw90r5rm2NEHBq
HXTxvASMzrG7DPPm9OvpVzZBrEAuHmdyiHdqzlVVXZSkvnHTHkf1fLh/plrYYUTL
8iszfS3oaeK1OChluZm+Bs4nMOl5pXErGGp4DpseJc7YbTLlXGeztVDfZ/JyXMHV
PThQ97gdGn7BM7PjPD4UovMLP1U4YJ/rw+GUjhwpwtvtRqeb0T+9KMdHTEfhlQrS
pZu4Y83yB2FMf7G4HFcn
=DZb5
-----END PGP SIGNATURE-----

--4ECF1u7dKBoUGhe3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
