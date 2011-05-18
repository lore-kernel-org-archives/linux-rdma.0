From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Wed, 18 May 2011 09:44:01 -0700
Message-ID: <BANLkTimWMU9ohSQGYEEnFR0HbBaypFR51A@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373F7AB-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 16, 2011 at 2:13 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> libibverbs
> ----------
> We define a new device capability flag IBV_DEVICE_EXT_OPS, indicating=
 that the library supports extended operations. =A0If set, the provider=
 library returns an extended structure from ibv_open_device():
>
> =A0 =A0 =A0 =A0struct ibv_context_ext {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ibv_context context;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ver=
sion;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ibv_ext_ops ext_ops;
> =A0 =A0 =A0 =A0};
>
> The ext_ops will allow for additional operations not provided by ibv_=
context_ops, for example:
>
> =A0 =A0 =A0 =A0struct ibv_ext_ops {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int =A0 =A0 (share_pd)(struct ibv_pd *=
pd, int fd, int oflags);
> =A0 =A0 =A0 =A0};
>
> In order for libibverbs to check for ext_ops support, it steals a byt=
e from the device name:
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Support for extended operations is recorded at the =
end of
> =A0 =A0 =A0 =A0 * the name character array.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0#define ext_ops_cap =A0 =A0 =A0 =A0 =A0 =A0name[IBV_SY=
SFS_NAME_MAX - 1]

I like this idea of allowing for future extensibility... but if we
could go even a bit further
and have support for named extensions, I think that would be even bette=
r.  ie
we could define a bunch of new XRC related stuff and then have some int=
erface
to the driver where we ask for the "XRC" extension (by name with a stri=
ng) then
that would be very handy for the future.

I wonder if a "ummunotify" extension would make integrating ummunotify
stuff into
libibiverbs easier...

This is inspired by my very limited knowledge of OpenGL, so maybe a
more detailed
look at the mechanism there would be helpful.

I think stealing a byte from the name to mark this support might make s=
ense, but
then I would probably go a bit further and change the second parameter =
of
ibv_register_driver to be an ibv_driver_init_func_ext() so we can exten=
d even
before the open of the driver.

Anyway thanks for rebooting this work, Sean.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
