From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Change rdma_protcol_iboe to roce
Date: Fri, 15 May 2015 23:32:46 +0200
Message-ID: <1431725566.11477.15.camel@opteya.com>
References: <1431630106-28829-1-git-send-email-ira.weiny@intel.com>
	 <1431702851.4214.3.camel@opteya.com>
	 <2807E5FD2F6FDA4886F6618EAC48510E1107F5B2@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1107F5B2-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le vendredi 15 mai 2015 =C3=A0 16:29 +0000, Weiny, Ira a =C3=A9crit :
> > Le jeudi 14 mai 2015 =C3=A0 15:01 -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org a =C3=A9=
crit :
> > > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > It has been decided that ROCE should be used within the kernel ra=
ther
> > > than IBOE as we used before.  Change iboe to roce on the new
> > rdma_protocol_* functions.
> > >
> >=20
> > Erk ... What's the usefulness of such patch=20
>=20
> Currently there is inconsistency in the naming of the RoCE technology=
=2E
>=20
> 12:27:35 > grep -r roce drivers/infiniband | grep -v Binary | grep -i=
 -v proce | wc -l
> 85
>=20
> All in the driver code.
>=20
> 12:27:48 > grep -r iboe drivers/infiniband | grep -v Binary | wc -l
> 130
>=20
> Mainly in the core and mlx4 driver.
>=20

I see thing a bit differently:

$ grep -ri 'roce' include/rdma/ \
                  include/uapi/rdma \
                  include/uapi/linux/if_infiniband.h \
                  drivers/infiniband/core | grep -vi proce | wc -l
0

$ grep -ri 'iboe' include/rdma/ \
                  include/uapi/rdma \
                  include/uapi/linux/if_infiniband.h \
                  drivers/infiniband/core | grep -vi proce | wc -l
30

(On next-20150515).

I believe the drivers can have the names they want, especially ocrdma,
Emulex OneConnect RoCE.

> This patch was to clean up the management helper function as a genera=
l
> move toward standardizing on roce rather than iboe.  Most people in
> the community refer to this as "RoCE" so that name was chosen to move
> to.
>=20

It's not the first time Linux use a name not matching the "vendor" one,
amd64, arm64, etc.

> >=20
> > IBoE is used throughout the IB/RDMA subsystem.
> >=20
> > Changing only these occurences is rather inconsistent.
> >=20
>=20
> I asked about changing all the references and Doug mentioned he would
> make a patch to change the other references.  Personally I don't want
> to see a massive rename patch but this could be done.
>=20

That's my main concern: I dislike patch that change such large portion
of code, for not well defined purpose.

I think "It has been decided that ROCE should be used within" is not
enough to justify the change.

But "Most people in the community refer to this as "RoCE" so that name
was chosen to move to." sound a bit better as an explanation.

And now, I'm stopping bikeshedding :)

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
