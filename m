From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Tue, 14 Nov 2017 20:02:07 +0200
Message-ID: <20171114180207.GA18825@mtr-leonro.local>
References: <20171113144024.26655-1-leon@kernel.org>
 <20171113192432.GL6918@ziepe.ca>
 <20171114080550.GR18825@mtr-leonro.local>
 <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
 <20171114095605.GU18825@mtr-leonro.local>
 <20171114152350.GA4263@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="63wdK++BfKwBXp+k"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114152350.GA4263-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--63wdK++BfKwBXp+k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 08:23:50AM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 14, 2017 at 11:56:05AM +0200, Leon Romanovsky wrote:
>
> > > what didn't work exactly?
> >
> > Started from compilation, continued to wrong data presented.
> > There is no need to carry 7-years old code, which no one cares about it.
>
> If it legiminately doesn't actually work then that is reason enough to
> be able to drop a uAPI, IMHO.

I'm propose proper patch at -rc1 phase. It will give enough time
to test it and revert before next merge window.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--63wdK++BfKwBXp+k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloLL58ACgkQ5GN7iDZy
WKd38Q/+I01zgJ3JeERHOHqeHNIgiwMvWEytuCVH20+mNHx0oDkOq5D02StQ7+Rv
b9sCSJvnmsSsWnyux5iiHVHWGRozmdA7Jc84jhjZ3MTDLkqZlbbXPpIBol8Vvoc8
/hN7uAAtNw9SBddcIZxxJS6nZiJThALM9F2XRj9iNWijgv/quSrNMoE9Mzi66ChS
ZEvNP9HgPcVYSjPSs7VbiLnaxrR9l1zn3bBMHzA45rbB+n+YklaXfsDPXd27YNZ4
YjcscNi/FuHDsfaxFhocbwxnGFIk0YSbkDkBKURWkGDvHkhkwFYoEcP44lhBZdjM
RZE61q/hEYDSfs+10wRVT83dIFcC3hIUUEc9wllROcZaAE5Lq49D2GASd8CgwyIo
ZcJjoDCjA1YrfYSvBDECWB/aApfSArdXpWzuZ+Jkb01PSNiuMPQU42EXTU5bMknZ
8dQbb9hsD15QrSSEUiBcWih2R8imXv1HEIyWdYFtc/oxeZRhjgtqvS6Q8VmI4MC4
5+SRoaJ7i1Z479JCY/sSCh85vfCdJH1HP7fjD7w8neyyiq7AjOT1GMlpqBtA9gM1
8L2ccoIJbcOmVaczYWrTbRRhBXobOrEep9LaEi4rarydnhNYQpZ8OsrATEQPdcxp
ZZNW7Qr+YB8Js/tDZLIsgpUXn+J2S0dRuhlRcuJqSmzlT0DZWZk=
=hoSf
-----END PGP SIGNATURE-----

--63wdK++BfKwBXp+k--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
