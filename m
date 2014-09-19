From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Add QP creation flags, allow
 blocking UD multicast loopback
Date: Fri, 19 Sep 2014 10:23:31 +0200
Message-ID: <1411115011.24808.15.camel@localhost.localdomain>
References: <1410700802-27848-1-git-send-email-ogerlitz@mellanox.com>
	 <1410700802-27848-2-git-send-email-ogerlitz@mellanox.com>
	 <1410799972.7830.25.camel@localhost.localdomain>
	 <541AD55A.50102@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <541AD55A.50102-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hi,

Le jeudi 18 septembre 2014 =C3=A0 15:51 +0300, Or Gerlitz a =C3=A9crit =
:
> On 9/15/2014 7:52 PM, Yann Droneaud wrote:
> > Le dimanche 14 septembre 2014 =C3=A0 16:20 +0300, Or Gerlitz a =C3=A9=
crit :
>

[...]

> >> As a result, applications who send and recieve over the same QP to
> >> the same multicast group get all their packets bouncded back to th=
em,
> >> which is terribly bad performance wise.
> >>
> >> To fix this long standing issue, add the ability to provide QP
> >> creation flags through uverbs.
> >>
> >> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> ---
> >>   drivers/infiniband/core/uverbs_cmd.c |   35 ++++++++++++++++++++=
++++++++++++-
> >>   include/uapi/rdma/ib_user_verbs.h    |    2 +-
> >>   2 files changed, 34 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infini=
band/core/uverbs_cmd.c
> >> index 0600c50..1ad489c 100644
> >> --- a/drivers/infiniband/core/uverbs_cmd.c
> >> +++ b/drivers/infiniband/core/uverbs_cmd.c
> >> @@ -1579,6 +1579,31 @@ ssize_t ib_uverbs_destroy_cq(struct ib_uver=
bs_file *file,
> >>   	return in_len;
> >>   }
> >>  =20
> >> +enum ib_uverbs_qp_create_flags {
> >> +	IB_UVERBS_QP_CREATE_LSO	    =3D 0,
> >> +	IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK =3D 1,
> >> +	IB_UVERBS_SUPPORTED_FLAGS
> >> +};
> > IB_UVERBS_QP_CREATE_LSO and IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOO=
PBACK
> > should moved in include/uapi/rdma/ib_user_verbs.h.
> >
> > If this is going to be flags, these values might be OR-ed together =
?
> > Then the userspace values should be defined like the kernel ones
> > (see commit 47ee1b9f2e7b):
> >
> > +enum ib_uverbs_qp_create_flags {
> > +	IB_UVERBS_QP_CREATE_LSO	    =3D                  1 << 0,
> > +	IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK =3D 1 << 1,
> > +}
> >
>=20
> Some misunderstanding here.. enum ib_uverbs_qp_create_flags is intern=
al=20
> kernel construct used
> to check the flags provided by user space (the _flags suffix is=20
> confusing, will remove it). The actual flags
> values to be used by user space are shifted values (e.g 1 <<=20
> IB_UVERBS_QP_CREATE_LSO).
>=20

OK, I haven't pay attention to the shift in the conversion function.

I would still prefer having the flag value be declared, instead of the=20
shift offset.

> As the whole set of flags/enum/attribute values moved between libibve=
rbs=20
> to the kernel, this will be defined
> in libibverbs header (take a look on include/uapi/rdma/ib_user_verbs.=
h=20
> it doesn't have the enumeration for event types defined).
>=20
>=20

OK.

(BTW, not having the flags/enum/attributes in=20
 include/uapi/rdma/ib_user_verbs.h is a pity, as the header=20
 is supposed to expose kernel API/ABI to userspace).

> > IB_UVERBS_SUPPORTED_FLAGS must be kept in this module, but defined
> > as:
> >
> > #define IB_UVERBS_QP_CREATE_FLAGS_ALL (IB_UVERBS_QP_CREATE_LSO | \
> > 				       IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
> >
> >> +
> >> +static int ib_uverbs_create_qp_trans(u8 u_flags)
> >> +{
> >> +	int i;
> >> +	int res;
> >> +	static const enum ib_qp_create_flags ib_uverbs_qp_create_flags[I=
B_UVERBS_SUPPORTED_FLAGS] =3D {
> >> +		[IB_UVERBS_QP_CREATE_LSO] =3D IB_QP_CREATE_IPOIB_UD_LSO,
> >> +		[IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK] =3D IB_QP_CREATE=
_BLOCK_MULTICAST_LOOPBACK,
> >> +	};
> >> +
> >> +	if (u_flags & ~((1 << IB_UVERBS_SUPPORTED_FLAGS) - 1))
> >> +		return -1;
> >> +
> > 	if (u_flags & ~(u8)(IB_UVERBS_QP_CREATE_FLAGS_ALL))
> > 	   return -1;
> >
> >> +	for (i =3D 0; i < IB_UVERBS_SUPPORTED_FLAGS; i++)
> >> +		if (u_flags & (1 << i))
> >> +			res |=3D ib_uverbs_qp_create_flags[i];
> >> +
> >> +	return res;
> >> +}
> >> +
> > This function can be replaced by compile time assert:
> >
> > BUILD_BUG_ON(IB_UVERBS_QP_CREATE_LSO !=3D IB_QP_CREATE_IPOIB_UD_LSO=
);
> > BUILD_BUG_ON(IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK !=3D
> > IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK);
> >
> > This way the values can be used without conversion.
>=20
> We prefer to have larger flexibility here which we can do with run ti=
me=20
> checks (this is slow path) and remain with the practice suggested by =
the=20
> original patch.
>=20

I don't buy this argument: it's not clear for me that there's an=20
advantage in such complexity. If the internal kernel flags are going to
change, the function might be needed, but until it happen, it's not.

What I've suggested is a common construction, see

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/=
signalfd.c?id=3Dv3.17-rc5#n262
fs/signalfd.c:signalfd()

        /* Check the SFD_* constants for consistency.  */
        BUILD_BUG_ON(SFD_CLOEXEC !=3D O_CLOEXEC);
        BUILD_BUG_ON(SFD_NONBLOCK !=3D O_NONBLOCK);

        if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK))
                return -EINVAL;


http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/=
signalfd.c?id=3Dv3.17-rc5#n381
fs/timerfd.c:timerfd()

        /* Check the TFD_* constants for consistency.  */
        BUILD_BUG_ON(TFD_CLOEXEC !=3D O_CLOEXEC);
        BUILD_BUG_ON(TFD_NONBLOCK !=3D O_NONBLOCK);

        if ((flags & ~TFD_CREATE_FLAGS) ||


See also perf_event_open() for the check against recognized flags.


Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
