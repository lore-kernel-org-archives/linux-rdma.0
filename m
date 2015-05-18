From: Parav Pandit <parav.pandit-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: RE: [PATCH] IB/core: Change rdma_protcol_iboe to roce
Date: Mon, 18 May 2015 21:45:49 +0530
Message-ID: <cdc5efd8a350e6a98c98f5f8169fe487@mail.gmail.com>
References: <1431630106-28829-1-git-send-email-ira.weiny@intel.com>
	 <1431702851.4214.3.camel@opteya.com>	 <2807E5FD2F6FDA4886F6618EAC48510E1107F5B2@CRSMSX101.amr.corp.intel.com>
 <1431725566.11477.15.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431725566.11477.15.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

At present we have chosen to call it RoCE. However I believe IBoE is mo=
re
generic for the reason where,
If the future RoCE versions may work on non-converged Ethernet, IBoE wo=
uld
be more appropriate name in long haul.

Parav

-----Original Message-----
=46rom: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Yann Droneaud
Sent: Saturday, May 16, 2015 3:03 AM
To: Weiny, Ira
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH] IB/core: Change rdma_protcol_iboe to roce

Hi,

Le vendredi 15 mai 2015 =C3=A0 16:29 +0000, Weiny, Ira a =C3=A9crit :
> > Le jeudi 14 mai 2015 =C3=A0 15:01 -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org a =C3=A9=
crit :
> > > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > It has been decided that ROCE should be used within the kernel
> > > rather than IBOE as we used before.  Change iboe to roce on the
> > > new
> > rdma_protocol_* functions.
> > >
> >
> > Erk ... What's the usefulness of such patch
>
> Currently there is inconsistency in the naming of the RoCE technology=
=2E
>
> 12:27:35 > grep -r roce drivers/infiniband | grep -v Binary | grep -i
> -v proce | wc -l
> 85
>
> All in the driver code.
>
> 12:27:48 > grep -r iboe drivers/infiniband | grep -v Binary | wc -l
> 130
>
> Mainly in the core and mlx4 driver.
>

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
>

It's not the first time Linux use a name not matching the "vendor" one,
amd64, arm64, etc.

> >
> > IBoE is used throughout the IB/RDMA subsystem.
> >
> > Changing only these occurences is rather inconsistent.
> >
>
> I asked about changing all the references and Doug mentioned he would
> make a patch to change the other references.  Personally I don't want
> to see a massive rename patch but this could be done.
>

That's my main concern: I dislike patch that change such large portion =
of
code, for not well defined purpose.

I think "It has been decided that ROCE should be used within" is not en=
ough
to justify the change.

But "Most people in the community refer to this as "RoCE" so that name =
was
chosen to move to." sound a bit better as an explanation.

And now, I'm stopping bikeshedding :)

Regards.

--
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
