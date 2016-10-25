From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: New providers in rdma-core
Date: Tue, 25 Oct 2016 09:08:34 +0300
Message-ID: <20161025060834.GO25013@leon.nu>
References: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ@mail.gmail.com>
 <580EF0D4.9050209@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cnBsrynPgIOyCJkL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <580EF0D4.9050209-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--cnBsrynPgIOyCJkL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 25, 2016 at 01:42:44PM +0800, oulijun wrote:
> =E5=9C=A8 2016/10/20 0:18, Leon Romanovsky =E5=86=99=E9=81=93:
> > Hi All,
> >
> > I want to remind you that latest kernel is exposing different vendor
> > specific structures (include/uapi/rdma/*-abi.,h) and new coming user
> > space drivers should use these headers directly and not copy/paste the
> > code from them.
> >
> > In the future, we will convert already accepted drivers too.
> >
> > Thanks
> >
> > .
> >
> Hi, Leon
>   I am preparing for the userspace library of hns and have learned your e=
mail.
> I have the same question with Jason Gunthorpe. Meanwhile, the new provide=
r qedr don't
> do this.
>   I think that your plan will have a more clever discussion coming forwar=
d. In order to
> not be blocked, I will don't something more until it is a step closer. Af=
ter that, i
> will fix it seraparete separately.

Sure, no problem.

>
> thanks
> Lijun Ou
>

--cnBsrynPgIOyCJkL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYDvbiAAoJEORje4g2clinYFQP/1++CaVyq/6O5neJvTye45U9
mPfa6Kwsgzh+3w1vDdsh2O6NQDSqLLYNxS4UCiqCcsaXaQat571W7HaGDht0YEfM
KE1JmgyB+QMVm/9qYtp4bCsuVaxfbVHUFl6vTNwbSV3zShq4Oz6eaZXE/v48UCdA
dnYAFd+14f9UPY8m67BsdzAntbf3okX4WAU9MgZzCrp+bd6L2/fkkNEiXS/kw2Da
/nRp6fG9KQtQ+IMMrbaZ2Prp34YsLvxAjzdQlbSA7QKCcNirYINH/Ncuh7XP+MH/
99DGITBm4hsS1RNb6gloQX7etisdmnyiIBsNT/JL0KCbu1UQSkeUEYFnzMUgF3jw
d5nR3K9j62YODXE6AjXQmaAu3YhPCEWlNoOJDIMf2VwZi7sGg7URu35IUihxfTZl
BperGZIlR0AgYwmvWmbQXSvRpXqjyhcsfXCmJ0e1/BT1HYncRy9HH2jxPKcfu/L+
wrhOH2Rmhq9T7fF64y28w9wjSNrZMfJegBLghWgX7LaRs1lJVqGIkWuZrErLO9gC
fVfCy0DMnrVBuprrqDcpuPdmODBWVTAOiEez86K2ZJnTzdSx4qwMgq5qma9RUlu2
8VByzwT0VrRfys7b/Dku/4ODtlU9oUSgIn/WPLvBOfPS5CQa5kd2koKg4kbfGTp9
dlQgnMzYvL9byNLiDdVf
=UOqv
-----END PGP SIGNATURE-----

--cnBsrynPgIOyCJkL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
