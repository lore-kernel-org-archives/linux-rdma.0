From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Tue, 28 Feb 2017 10:48:02 -0500
Message-ID: <1488296882.86943.214.camel@redhat.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-z66Qnul6Jd97195uoXzH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-z66Qnul6Jd97195uoXzH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-02-27 at 18:08 +0200, Alex Rosenbaum wrote:
>=C2=A0
>=20
> Today the IB device list is returned by ibv_get_device_list() from
> libibverbs.
>=20
> This IB device list is created by scanning of the
> /sys/class/infiniband_verbs
>=20
> [2]. The list is cached and never updated, no matter if there were
> hardware
>=20
> changes in the system.

Correct. =C2=A0This is something I've felt we've needed to update/fix for a
while now.

> Detection of hotplug events is not part of libibverbs functionality
> and thus
>=20
> not part of this RFC. User space applications should monitor
> respectful changes
>=20
> in the system according to its specific logic to detect plugout or
> plugin of
>=20
> hardware devices. This can be does by means of: netlink, udev or
> other inputs.

On this point I disagree. =C2=A0I see no reason that we should implement
hotplug detection in every application when the library can get it
right just once and make it available to everyone.

> Here I suggest to modify the implementation of ibv_get_device_list()
> so that
>=20
> consecutive calls will re-scan the sysfs in the same manner as done
> today in
>=20
> order to create a fresh ibv_device list each time. We will remove
> caching of
>=20
> devices that support plugout, while keeping the ibv_device cache for
> devices
>=20
> which do not support plugout.

I would argue that a better solution is to, on first call into
ibv_get_device_list() (which doubles as the library's init() entry), we
scan the system for whatever devices there are, build a permanent list
of these devices, then register the necessary hooks ourselves to get
updates on both plug out and plug in, and on those events we update the
list as appropriate (on plug out, notify the application via async
event, after the application has processed the event, if the device is
unused, remove the device entirely, if the device is still in use, then
move it to a defunct list and wait for the application to be able to
release all of its references to it, and only then remove it; on plug
in, add a new device to the device list and notify the application via
async event at which point the application can decide if it wants to
use the device). =C2=A0This might actually involve a new async notifier
added to the libibverbs API that is not tied to a device and which an
application would need to be modified to register with the library.
=C2=A0But since any applicaiton wanting to support this is going to need to
be modified anyway, a new entry point isn't the end of the world.

>=C2=A0
> Applications Behavior
>=20
> -------------------------------------------------------------------
> -------------
>=20
> Applications use different logic to decide which ibv_device is the
> relevant
>=20
> device they want to use. And each application has its own detection
> logic to
>=20
> track such changes in device availability.
>=20
> Few examples: librdmacm logic is based on GUID values. Socket
> acceleration
>=20
> (libvma) maps an IB device to its corresponding net iface based on
> netlink and
>=20
> sysfs. DPDK applications lookup the IB device PCI address. And most
> MPI
>=20
> implementation want human specified IB device name in command line
> and will
>=20
> probably not handle any hotplug (out or in) events.
>=20
>=20
>=20
> It is the application's responsibility to check which ibv_device
> returned from
>=20
> ibv_get_device_list() has changed from previous scan and which is of
> interest.

With an async event notifier, and with a static list of devices, it
would be possible to simply pass the new device in with the notifier.
=C2=A0Makes things much simpler for the app IMO.

>=20
>=20
> Verbs can issue an IBV_EVENT_DEVICE_FATAL async event on an open user
> space
>=20
> ibv_context for device's which support the ib_device-
> >disassociate_ucontext().
>=20
> This event will indicate to the application that the device is no
> longer
>=20
> operational. In addition, user space CQ channel fd=E2=80=99s blocking cal=
ls
> on recv(),
>=20
> select(), poll() or epoll() will be released with EINTR errno.
>=20
>=20
>=20
> Typical user space application will monitor hardware changes and/or
> call for
>=20
> ibv_get_device_list() only from control path dedicated thread, and
> not from the
>=20
> fast path threads.
>=20
>=20
>=20
> Pitfall
>=20
> -------------------------------------------------------------------
> -------------
>=20
> If a legacy user space application did not follow the
> ibv_get_device_list()
>=20
> man page definition, and it saved a private copy of an ibv_device
> pointer and
>=20
> used it after releasing the device list (call to
> ibv_free_device_list()), then
>=20
> ibv_open_device() might seg-fault based on this new suggestion.
>=20
> We can work around this by moving the IB device re-scan logic to a
> new API
>=20
> 'ibv_refresh_device_list()' so that only new application using this
> API will
>=20
> have correct behavior as needed.

Following what I wrote above, this would no longer be a problem. =C2=A0The
call to ibv_get_device_list can simply return the existing list (on
first call we init this list), and we can make ibv_free_device_list a
no-op. =C2=A0The async events can notify of adds/removes, user can update
their own list accordingly, but we would also protect ourselves in all
of the ibv_ calls such that if the user space code calls into our code
with a defunct device we don't crash. =C2=A0We might want to protect all of
our calls, even hot path calls, from invalid ibv_context pointers now
as a result of this support.


>=20
>=20
> Reference
>=20
> -------------------------------------------------------------------
> -------------
>=20
> [1] https://www.kernel.org/doc/pending/hotplug.txt
>=20
> [2] https://github.com/linux-rdma/rdma-core/blob/master/Documentation
> /libibverbs.md
>=20
>=20
>=20
> API changes
>=20
> -------------------------------------------------------------------
> -------------
>=20
> Signed-off-by: Alex Rosenbaum <alexr@xxxxxxxxxxxx>
>=20
> --- a/libibverbs/verbs.h
>=20
> +++ b/libibverbs/verbs.h
>=20
> @@ -1336,6 +1336,7 @@ struct verbs_device {
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ibv_context *ctx, int c=
md_fd);
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0void=C2=A0=C2=A0=C2=A0=C2=
=A0(*uninit_context)(struct verbs_device *device,
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ibv_context *ctx);
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0void=C2=A0=C2=A0=C2=A0=C2=A0(*=
uninit_device)(struct verbs_device *device);
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_t=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ref_count;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* future fields added he=
re */
>=20
> };
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=20
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-info.h=
tml
--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-z66Qnul6Jd97195uoXzH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYtZuyAAoJELgmozMOVy/dT/UP/iEy6NYH+Yu1Y0zdqXc3wxZR
OFRN5/rFP72u5FdQ65eQk1RQl7Ym0EnLKQGe12+3CCzEGRt8xOXGhJFS9FaiGezi
9VRizRfqPAzCTN0rW1CZNkTlpfo6393i+v2YrdcwOPvQV420PX0JIbGKEG1sRYO2
xVPrLVtObBlTVDAydW/AJ/MgJLE4k+s7jDF0fmIgEH4KSa2PNKC42FPzX4/KYLG2
e2mwo1sgrhev97ONjmjSXfcd09oUZx6BlNtzBMjz/KbguM6tAmVz2K2UGyTZawew
r4p2xAPHMhkA2G0lIlpTV8HnXh1Gfx7D076HncmYpFIRgNkex+Y2ljDXjK4EXF8P
l9Pt0bgzTbDJUfVnOTfi5abupVc5dp1t3AnF7KI3MArxGdCb5CzaqxenCF8lz2AT
cwBnzQvGtgEqS/trDMT2fT9xXSy5lZVkPaU9R/M1irhIbMWYHF4hFBLKR+ZaSGDn
ApoxGjPZOa6QJeqx78AUtdPVg4ahXHQdtA+7Y6gciPSkiD7G/a/CYxxBQPE2JnUJ
Qtz1S7sNOXgffnZlAMahfmUfvOLJxhu07tqGAkGJy8SOdcq1MJ3mtt0HR2kRbCc3
IatHGeyrC/4a4KIaQteAigGCXlmogZrG7WR3AbCp41kAiFPeXjbckqX0+/ActRXz
Gw6SgfK8JdFKWKdss3bh
=SPB/
-----END PGP SIGNATURE-----

--=-z66Qnul6Jd97195uoXzH--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
