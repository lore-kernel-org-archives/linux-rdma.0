From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [pull request][rdma-rc v1 0/4] RDMA fixes for-4.13
Date: Sun, 6 Aug 2017 11:12:31 +0300
Message-ID: <20170806081231.GB3636@mtr-leonro.local>
References: <20170801064137.8360-1-leon@kernel.org>
 <1501871458.79618.8.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501871458.79618.8.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 04, 2017 at 02:30:58PM -0400, Doug Ledford wrote:
> On Tue, 2017-08-01 at 09:41 +0300, Leon Romanovsky wrote:
> > Changelog:
> >  v0 -> v1:
> >   * Added Reviewed-by tags
> >   * Moved 10 patches to -next
> >
> > Thanks
> > ----------------------------------------------------------------
> >
> > The following changes since commit
> > 5dc78ad1904db597bdb4427f3ead437aae86f54c:
> >
> >   IB/ipoib: Notify on modify QP failure only when relevant (2017-07-
> > 23 10:52:00 +0300)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
> > tags/rdma-rc-2017-08-01
> >
> > for you to fetch changes up to
> > 0626c5a5dec2e601f06a2c03b295fb7d7288e29c:
> >
> >   RDMA/mlx5: Fix existence check for extended address vector (2017-
> > 07-31 20:43:06 +0300)
> >
> > ----------------------------------------------------------------
> > RDMA fixes for 4.13
> >
> > This patchset contains four patches:
> >  * Two kernel panic fixes from Yishai and Parav.
> >  * The bugfix to mlx5 wrong usage of big-endian variable.
> >  * Preventing leak of reserved field.
> >
> > ----------------------------------------------------------------
> > Leon Romanovsky (2):
> >       RDMA/uverbs: Prevent leak of reserved field
> >       RDMA/mlx5: Fix existence check for extended address vector
> >
> > Parav Pandit (1):
> >       IB/core: Fix race condition in resolving IP to MAC
>
> This patch, in particular, was very similar in description to another
> patch I already took for this -rc cycle.  Both of these patches ended
> up using ordered workqueues to resolve the problem.  Finding two
> different workqueues that needed to be made ordered in the same -rc
> cycle makes me wonder if we might not have some other issues lurking in
> the subsystem in regards to workqueues...

I hope no, we don't have many workqueues (except hfi1).

=E2=9E=9C  linux-rdma git:(topic/rdma-uapi-export) git grep 'alloc_workqueu=
e(\|create_workqueue('  drivers/infiniband
drivers/infiniband/core/addr.c: addr_wq =3D alloc_workqueue("ib_addr", WQ_M=
EM_RECLAIM, 0);
drivers/infiniband/core/cm.c:   cm.wq =3D create_workqueue("ib_cm");
drivers/infiniband/core/device.c:       ib_wq =3D alloc_workqueue("infiniba=
nd", 0, 0);
drivers/infiniband/core/device.c:       ib_comp_wq =3D alloc_workqueue("ib-=
comp-wq",
drivers/infiniband/hw/hfi1/init.c:                              alloc_workq=
ueue(
drivers/infiniband/hw/usnic/usnic_uiom.c:       usnic_uiom_wq =3D create_wo=
rkqueue(drv_name);
drivers/infiniband/ulp/iser/iscsi_iser.c:       release_wq =3D alloc_workqu=
eue("release workqueue", 0, 0);
drivers/infiniband/ulp/isert/ib_isert.c:        isert_comp_wq =3D alloc_wor=
kqueue("isert_comp_wq",
drivers/infiniband/ulp/isert/ib_isert.c:        isert_release_wq =3D alloc_=
workqueue("isert_release_wq", WQ_UNBOUND,
drivers/infiniband/ulp/srp/ib_srp.c:    srp_remove_wq =3D create_workqueue(=
"srp_remove");



>
> >
> > Yishai Hadas (1):
> >       IB/uverbs: Fix device cleanup
> >
> >  drivers/infiniband/core/addr.c        | 62
> > +++++++++++++++++++++++++++--------
> >  drivers/infiniband/core/uverbs_cmd.c  |  2 +-
> >  drivers/infiniband/core/uverbs_main.c |  3 +-
> >  drivers/infiniband/hw/mlx5/odp.c      |  2 +-
> >  include/linux/mlx5/qp.h               |  1 -
> >  5 files changed, 51 insertions(+), 19 deletions(-)
>
> I didn't use a pull (mainly because I was going through patchworks and
> saw the patches and took them from there before I saw the cover letter
> here with the pull tag...that and I'm not used to the pull request
> model so hunting through patchworks for the relevant patches is second
> nature and pull requests aren't).  I'll try to keep the pull option in
> mind next time.  In any case, thanks, series applied.
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
>

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmGz28ACgkQ5GN7iDZy
WKfuhQ//YIog7p0N1pw4OV/l/HDK9MqfCuAC57FY3z1bgGP8kLZipl/c2X1GJ2zj
6c0n3RgtqiSuL0zeIDvc0zad9LvvRg0mxB0R0qhJc7wWISgqDcEqEhRKKg3A/0wA
h6PZPYkhxZshS9oTaMiCWr0fm6A5KWwXGjCTLIFlHpXFKqeGSdaz/QMn/mRBMo6g
reFQn35T/RLvXgWlhaIzBt+5cR5Tp0b+MqctJs1LDOjZFEZ7vX10dfjLhOCoSG65
SuvFE/iMsjnIxWLKDjywcd/O9otvist43T/dO81a2b8wOKo9uASriShtGb+3wBb1
RY2V20lFFsyh58NmoKbvDx5R0ifZLB+fjYfduSIxJT+OP40YtfNGHn742h09FwEi
8zhlkcyGTXv9CTIL9yuLZf27IayQgJ0SGjntpVv0p/GUIIiIXOaxQvtJGCqcEDUe
2Cbc+lCxoeNRA44THB082TNxgfZ5YuOcNizmyu3URNUfYyPfq+C320modMuUhF1+
F5svsJTRTY9k7Cb8wSLmgQPkWWuYt4z0MQ9aumWltic+dMd0jQg+mcIYCeNYfl9k
GtFGVLQ7+vNvWyv4wH6BcEn1kIi3nATVBT9q15dVRSLlwqVSfRT1/HnrSHgVYD5p
NZvqqE1kTQlSrwZDgM6PbNcmoi5DcwPWp+iaHpPCcrAcfHXmwCk=
=FTul
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
