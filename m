From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv1 0/6] IB/uverbs: check request parameters
Date: Mon, 04 May 2015 21:56:22 +0200
Message-ID: <1430769382.19516.9.camel@opteya.com>
References: <cover.1430743694.git.ydroneaud@opteya.com>
	 <1430761519.2407.87.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430761519.2407.87.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 04 mai 2015 =C3=A0 13:45 -0400, Doug Ledford a =C3=A9crit :
> On Mon, 2015-05-04 at 15:00 +0200, Yann Droneaud wrote:
> >=20
> > Please find a patchset against uverbs to improve the checks done
> > on uverbs request parameters. This patchset in an extract of a
> > previous patchset sent some times ago[1].
>=20
> I reviewed those patches last time they came around.  In general, I'm=
 on
> board with the idea of cleaning up option checking, but in your origi=
nal
> patch submission you point out that the patches have a non-0 chance o=
f
> breaking user applications that pass in parameters that wouldn't pass
> these checks but work anyway.  Have you done any looking into that
> possibility?
>=20

I believe applications using libibverbs are immune of any kind of
regression.

But I cannot tell for sure for applications that access directly uverbs=
:
those could be doing broken things.

Anyway, we should prevent such applications to broke into the kernel:
integer over/under flow or buffer overflow are not acceptable.

> > I've provided some explanation of the issues partialy addressed
> > by this patchset in a previous message[2].
> >=20
> > As we're now addressing overflows, I think it's time to apply
> > this patchset.
> >=20
> > Changes since v0 [3]
> > - updated against v4.1-rc2
> > - incorporated patches to add check on response buffer using
> >   access_ok()
> >=20
> > [1] "[PATCH 00/22] infiniband: improve userspace input check"
> >=20
> > http://marc.info/?i=3Dcover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> > http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> >=20
> > [2] "Re: [PATCHv4 for-3.13 00/10] create_flow/destroy_flow fixes fo=
r v3.13"
> >=20
> > http://marc.info/?i=3D1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWdBPR1lH4CV8@public.gmane.org=
ain
> > http://mid.gmane.org/1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbh0DlRQRlKF@public.gmane.org=
in
> >=20
> > [3] "[PATCH 0/4] IB/uverbs: check request parameters"
> >=20
> > http://marc.info/?i=3Dcover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> > http://mid.gmane.org/cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> >=20
> > Yann Droneaud (6):
> >   IB/uverbs: check userspace input buffer size
> >   IB/uverbs: check userspace output buffer size
> >   IB/uverbs: check userspace output buffer size in ib_uverbs_poll_c=
q()
> >   IB/uverbs: subtract command header from input size
> >   IB/uverbs: move cast from u64 to void __user pointer to its own
> >     variable
> >   IB/uverbs: check access to userspace response buffer
> >=20
> >  drivers/infiniband/core/uverbs_cmd.c         | 449 +++++++++++++++=
++++++------
> >  drivers/infiniband/core/uverbs_main.c        |  29 +-
> >  drivers/infiniband/hw/mlx5/cq.c              |   6 +-
> >  drivers/infiniband/hw/mlx5/main.c            |   2 +-
> >  drivers/infiniband/hw/mlx5/srq.c             |   6 +-
> >  drivers/infiniband/hw/mthca/mthca_provider.c |   2 +-
> >  6 files changed, 382 insertions(+), 112 deletions(-)
> >=20
>=20
>=20

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
