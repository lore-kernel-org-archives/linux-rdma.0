From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Mon, 15 May 2017 17:36:32 +0300
Message-ID: <20170515143632.GH3616@mtr-leonro.local>
References: <809f87ab-b787-9d40-5840-07500d12e81a@mellanox.com>
 <1948057100.362217696.1491824459274.JavaMail.zimbra@kalray.eu>
 <33e2cc35-f147-d4a4-9a42-8f1245e35842@mellanox.com>
 <517fb6d2-a010-1926-b4cb-0e6041722c28@grimberg.me>
 <af9044c2-fb7c-e8b3-d8fc-4874cfd1bb67@mellanox.com>
 <c2a1436f-48a6-bdea-c910-168fc6031364@grimberg.me>
 <DE927C68B458BE418D582EC97927A92855088C6F@ORSMSX113.amr.corp.intel.com>
 <82dd5b24-5657-ae5e-8a33-646fddd8b75b@grimberg.me>
 <20170515133122.GG3616@mtr-leonro.local>
 <9465cd0c-83db-b058-7615-5626ef60dbb0@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AAiVQQES42Kk67ff"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9465cd0c-83db-b058-7615-5626ef60dbb0-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--AAiVQQES42Kk67ff
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2017 at 04:43:18PM +0300, Sagi Grimberg wrote:
> > > > Any update here?  Would love to be able to load up the new kernels without patching them every time. :)
> > >
> > > I would like that too,
> > >
> > > Max, can you send a patch? or should I?
> >
> > Sagi,
> >
> > Max is doing his best to provide a patch, unfortunately he is limited
> > by various architecture implications which he needs to resolve before
> > sending it.
>
> Well, he already sent a patch that fixes the issue.
> He said that he needs additional optimization for CX5 (which I assume
> doesn't need the strong fence), but that still does not change the
> fact that CX4 is broken. I asked to include his patch, fix the
> existing bug and incrementally optimize CX5.
>
> What do you mean by architecture implications? it's broken and there is
> a request from the community to fix it. Are you suggesting that it
> doesn't solve the issue?

I understand you and both Max and me are feeling the same as you. For more
than 2 months, we constantly (almost on daily basis) asked for a solution from
architecture group, but received different answers. The proposals were
extremely broad from need for strong fence for all cards to no need for
strong fence at all.

Thanks

>

--AAiVQQES42Kk67ff
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkZvO8ACgkQ5GN7iDZy
WKceQQ/+LIa5th55vH7E+nm+Cx7/x4C0co3k67C3zyvhcrS8TiiNlNb9VS4vW5Au
aYh7yTMs6Mk1sPKqvWb8dib5Pd/94rsrik6TAhGkh85aL3+UcwzGH9ymTrVXpEDK
NkQeLQCZEihXAhaCcnjkFbjQXMZDeS5cqdyLRWF5xlESpiQERZF3fSOhNTERxhIy
g8PyDWeyLpQKPDy5HYz/ptxJPaX6LxSHZLEOnvJf8GbRh3MqgYLpY6wnvT2Ljenc
fr1ZVXHHe2bRDDKwlvm7cDZMnXGfy92E27s6SqxUJYUDb7zo1HfsgGVHToguxaaV
Idm+ScGOPT5ytNfLSCfKgiajIR9+63zyBPIwlpaTCmdur3BMbJZ98C/Vwm/pyCcX
Jo1SEiJM2tEMGCENiRUxe2Fvb83+BQwU+w4ekhLpExd42pgtZxVuhKC8SiXiHu6V
U5V5QuX1andiyy1DHs9gYOOWo9v+Eq0zX538mpPtpkdz86ntgZG8FLcpxjo2txUT
/IgelYaUZlDsjGdoqYGNOHfLd0asxJaeTRcpYqfkWwV3fRkojf6NT8hxVB1bvWF/
OyQRmhMHATKCxYTd03ewmAfnXLb7PQ70fxhVfjx4Jvm57ipVlL3IZkAG6LAVtW9P
tt/9wzsPHYITqqcPamfDRDYg1Q3UfKg52ehqYlEyDQV0M/P07EE=
=Vq30
-----END PGP SIGNATURE-----

--AAiVQQES42Kk67ff--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
