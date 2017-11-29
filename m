From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Please update the linux-next location for the RDMA subsystem
Date: Wed, 29 Nov 2017 18:24:41 +0200
Message-ID: <20171129162441.GC29104@mtr-leonro.local>
References: <1510948060.3973.29.camel@redhat.com>
 <20171119064640.GV18825@mtr-leonro.local>
 <9a80e43d-d32a-742b-fa6b-adacb152e8dd@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="flpRHSNNLnUanxKW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9a80e43d-d32a-742b-fa6b-adacb152e8dd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--flpRHSNNLnUanxKW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 29, 2017 at 11:12:44AM -0500, Doug Ledford wrote:
> On 11/19/17 1:46 AM, Leon Romanovsky wrote:
> > On Fri, Nov 17, 2017 at 02:47:40PM -0500, Doug Ledford wrote:
> >> Hi Stephen,
> >>
> >> Jason Gunthorpe is now co-maintaining the RDMA subsystem with me.  We
> >> have a shared repo that we can both write into.  I would like you to re-
> >> aim the RDMA linux-next pull point to:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git tags/for-
> >> next
> >
> > Doug,
> >
> > Does it make sense to get rid of "k.o" notation for for-next and for-rc branches?
> > It is already on kernel.org and seems to me as a redundant.
>
> Jason and I talked about this offline.  The reason it's there is
> actually more technical than anything else.  In order to have WIP
> branches that you want to quickly/easily get on github, but to not have
> them pollute k.o with WIP branches that haven't passed 0day yet, the
> easy solution is to add this to your .git/config for your kernel repo:
>
>         push = refs/heads/k.o/*:refs/heads/k.o/*
>         push = +refs/tags/for-linus*:refs/tags/for-linus*
>         push = +refs/tags/for-next*:refs/tags/for-next*
>         push = refs/heads/master:refs/heads/master
>
> That keeps only the stuff you really want going to k.o going there, and
> everything can then go to your WIP repository.  Going forward, whether
> Jason decides to use a github repo for 0day like I do or not, it now has
> a second benefit in that we can each have our own private namespace,
> which is basically anything not in k.o/, and treat the k.o/ namespace as
> a shared namespace where we worry about branch name conflicts, fast
> forward only updates, etc.  So, it's redundant to the people pulling,
> but I still think it has value for Jason and I.

AS long it works for both of you, we can live with that too.

My scheme is similar to you, but with one repo:
 * master - follow Linus's master
 * rdma-next/rdma-rc - submission queues equivalent to your k.o
 * topic/* - for on-going development
 * testing/* - different experiments

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>




--flpRHSNNLnUanxKW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloe30kACgkQ5GN7iDZy
WKcrXg/+NVfkGa0hIC23s9zRQm1ssTIzdpEOb/+2zJKZv0nXO05o75tqnNAQy80j
m9dPdJ3tNUV3cFipb5PUdT/BRHKODwa2VJdHT3nYUVyfsFfvf1riTVxc7UHTm4eL
/zfoRudWFjVms9kv0kmAfFX630ckyrIPrvrUozjvR9//1magzRNfn8JOh7d+M5sp
pZHC2ESgSIA1vr002T1TxdiAz2TmRlVOlkVLUDRJyaaDCZaGLZ6PoP3vzaVVtY+Y
xmGRA8J9XuGxbfLQJVs3i1TP20Fv/4N2JMU8KT6jzd+wnERG8U5LOWqAtGqDxXlm
WIZVZ7mAIMsu5L8sCSUfdxuB15SJVq2LyBaFw4mNsQVFAFPOKuFD8XEZOW3XHnjb
BHB7Sy01m34Hvf6iSUVwmhA+Ig28rIe+FCkHS2/hKnphrq8iYyfhawIHtqqoT8y4
TAIpFDrARYLK11uHp8IevJqwfqEFcP9V/f6CfceCmgBPbxfHotElkBKudCL2FHjq
7Et2VrrB57FZfOLgHDDi+xiw1q4epQQsUL9xxpvUWl87cEfalBPWlwigtXQTt0o1
qj8g7niSLmTk/fW/+LX4nh1BQFSKFNAVI6IBKZ1cVQc0+VQgspTd43fRuxm8yHN7
mt1yL85o/VBJyREAvD5HRGMVD/HuUpgFPtobsW6Wn07uq9MN3WQ=
=aN28
-----END PGP SIGNATURE-----

--flpRHSNNLnUanxKW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
