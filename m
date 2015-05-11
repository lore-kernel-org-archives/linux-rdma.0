From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libibverbs init.c: remove stderr warnings if no
 userspace driver found
Date: Mon, 11 May 2015 23:32:42 +0200
Message-ID: <1431379962.4969.7.camel@dworkin>
References: <1431109314-31662-1-git-send-email-jsquyres@cisco.com>
	 <1431180267.3617.5.camel@dworkin>
	 <91CD4206-FE67-45DF-BFFD-3AFBC4DE30E3@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <91CD4206-FE67-45DF-BFFD-3AFBC4DE30E3-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 11 mai 2015 =C3=A0 20:32 +0000, Jeff Squyres (jsquyres) a =C3=A9=
crit :
> On May 9, 2015, at 8:04 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org> wrot=
e:
> >=20
> > Le vendredi 08 mai 2015 =C3=A0 11:21 -0700, Jeff Squyres a =C3=A9cr=
it :
> >> Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> >=20
> > This is a little short for an explanation: what was the issue with =
the
> > error messages ?
>=20
> Cisco has stopped shipping its libibverbs usnic driver, although we
> are still using the kernel driver in the /sys/class/infiniband space
> (since it's the only way to be upstream).  Specifically: instead of
> using libibverbs for userspace access, we are now using libfabric.
>=20

OK.

(I have to find some information about this libfabric which is already
released as 1.0.0 version).

> That is: it's not a warning or an error if libibverbs cannot find a
> userspace driver for kernel devices.  Indeed, returning a num_devices
> of 0 is sufficient -- the middleware shouldn't be unconditionally
> printing out stderr message; let the upper layer application do that
> (if it wants to).
>=20

This paragraph should definitively be part of your commit message.

> FWIW, Sean just removed a similar set of stderr warnings from librdma=
cm:
>=20
>    http://git.openfabrics.org/?p=3D~shefty/librdmacm.git;a=3Dcommitdi=
ff;h=3D2b2aad809afc56fa3157f5cf99036f92b9c90f16
>=20

I don't think this a good thing to remove all the error messages
unconditionally. It could have been made a build option + an environmen=
t
variable option to help mere mortals to debug their setups.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
