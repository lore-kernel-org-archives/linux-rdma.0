From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v2 19/20] IB/rdmavt, IB/qib, IB/hfi1: Make percpu
 refcount optional for user MRs
Date: Thu, 6 Apr 2017 15:37:26 +0300
Message-ID: <20170406123726.GH2269@mtr-leonro.local>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
 <20170321002631.28538.2121.stgit@scvm10.sc.intel.com>
 <1491417489.2923.6.camel@redhat.com>
 <f008c532-340e-01f2-80e6-4bea74175e3e@intel.com>
 <CALq1K=JsjSCiSBeZVe4kHQmjw7tznL36JcsamZTVGZ5RhBvZPw@mail.gmail.com>
 <32E1700B9017364D9B60AED9960492BC342EA858@fmsmsx120.amr.corp.intel.com>
 <20170406074955.GG2269@mtr-leonro.local>
 <8cdf2fbb-f2a9-0b4b-b144-397ee73d1569@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hcut4fGOf7Kh6EdG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8cdf2fbb-f2a9-0b4b-b144-397ee73d1569-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hcut4fGOf7Kh6EdG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 06, 2017 at 07:45:16AM -0400, Dennis Dalessandro wrote:
> On 04/06/2017 03:49 AM, Leon Romanovsky wrote:
> > On Wed, Apr 05, 2017 at 08:09:16PM +0000, Marciniszyn, Mike wrote:
> > >  > Is there a another way we should be looking at for setting things like this?
> > > >
> > > > Use vendor channel interface to configure your driver.
> > > >
> > >
> > > What is that? configfs or something else?
> >
> > An immediate answer without digging into your code is Matan's KABI work.
> > https://github.com/matanb10/linux/tree/abi-devel-latest
>
> Until that code is formally accepted and actually in the kernel we can't
> base our changes that are ready to go now (for 4.12) on it.

And we can't accept module parameters. I already presented my setup,
which I know in use by many people. Standalone kernel with everything
compiled in, everything runs in read-only small image without distro bloat.
it gives very small footprint, very fast execution and system
protection.

In such case, we'll be required to rebuild whole image to update command
line for one module parameter and we will need to do it just for
specific application, which is insane.

I'm glad that you realize now the importance of Matan's work and how it
can help overcome your current problems, You (Intel) are invited to help
him to make it faster.

>
> > However, I have an question, how do you ensure that user memory has no
> > users without refcounts? Will it be possible to dereg the memory despite
> > the fact that there are users?
>
> Mike can correct me if I'm wrong but it is still refcounted. Just not per
> CPU, global if you will.

IMHO, global will be always more expensive than percpu, due to locality.
However your patch presents different picture. You are claiming that removing
percpu_refcnt and leaving global will make work faster. How will it be?

Thanks

>
> -Denny
>

--hcut4fGOf7Kh6EdG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljmNoUACgkQ5GN7iDZy
WKed7BAAp94cJEVZ7MsUHFqXnkkZt8U6o2cauWFHT0g4/3liMluovIYUVtu7Xt1+
OhuNZP18yX2pMwq+pdTc6v3AcNvHnlXaKyph+O9BRtQvq7IByXM6lg2VbiWWwv0/
IJwBd683Y+uynNc5ag/UWUjYABwgBMx5Qff/dxz6futkUKagX8sA9pL1L5hO29o7
ebPC3/7i/eeNY3Uf95vZMsC5nge1fMQA5p30SAO5Rf80EDpXHrk1jf2c5UTl8N5J
XivVACw3h5FGKdqjwi9KyrRwBO3UctqhgfTIgl9Yu7zmx0BaVTam+6U7SGQKr89r
Rs0SEH0e/KE5TzZ7Bo+br45jJlpM0sPyV3xZkVLFHnKkiPHVGv5x8v3+68VR2geI
rSqmEcCUVDI0FEQ0Ai1Lo5vBdvZeUltx7KHzqKHHX0K4vDjLTdSfrJAvWO3InKVd
Ea+bYMWOMkKj/ojoBParNEjPeafb6+rQOr2RBN/3W9bxGoAjMvKHXS4Kv8ZniMW7
LVDb4/L47Mi7WOb2/HPaMe01BXniDOYIrfvnZhK2ZfZfjJbeto817oZb1Yi6W/R5
ld693LK4jy1HTsatff/hxf2t7A/j9K9pQgYMNRCWZg4S+fpjXkU8g/Jdv81XfIv6
qFYq37q09LoVnaQE+ll3qPG6GgL3/tYPUkL/CsHvuFD2CbzSDZ4=
=Jrep
-----END PGP SIGNATURE-----

--hcut4fGOf7Kh6EdG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
