From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
Date: Tue, 28 Feb 2017 16:47:05 -0500
Message-ID: <3389d831-c135-b326-4b96-5f2a746de5ac@redhat.com>
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g@mail.gmail.com>
 <1488296882.86943.214.camel@redhat.com>
 <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560@HE1PR0501MB2812.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TnUIFNhRcqgJ4wKBpIFi24g40tGjphr7T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TnUIFNhRcqgJ4wKBpIFi24g40tGjphr7T
Content-Type: multipart/mixed; boundary="9I8okgKl3ID44m33NbfxjtFL5o0uDKbCs";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum
 <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <3389d831-c135-b326-4b96-5f2a746de5ac-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] libibverbs IB device hotplug support
References: <CAFgAxU9eQYwBad2+SJw1x+cQMMqzgkz0fpeumG7Rx=o_eQqo2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <1488296882.86943.214.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
In-Reply-To: <HE1PR0501MB28123E8F342607E2C2CA4DD9B1560-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>

--9I8okgKl3ID44m33NbfxjtFL5o0uDKbCs
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2/28/2017 11:32 AM, Liran Liss wrote:
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
>=20
>>> not part of this RFC. User space applications should monitor
>>> respectful changes
>>>
>>> in the system according to its specific logic to detect plugout or
>>> plugin of
>>>
>>> hardware devices. This can be does by means of: netlink, udev or othe=
r
>>> inputs.
>>
>> On this point I disagree.  I see no reason that we should implement ho=
tplug
>> detection in every application when the library can get it right just =
once and
>> make it available to everyone.
>>
>=20
> This is definitely something we should consider doing, but orthogonal t=
o
> obtaining an up-to-date device list.

Not really.  Half of the logic in the original RFC can be considered
hacks to work around not doing this properly in the first place.

>>> Here I suggest to modify the implementation of ibv_get_device_list()
>>> so that
>>>
>>> consecutive calls will re-scan the sysfs in the same manner as done
>>> today in
>>>
>>> order to create a fresh ibv_device list each time. We will remove
>>> caching of
>>>
>>> devices that support plugout, while keeping the ibv_device cache for
>>> devices
>>>
>>> which do not support plugout.
>>
>> I would argue that a better solution is to, on first call into
>> ibv_get_device_list() (which doubles as the library's init() entry), w=
e scan the
>> system for whatever devices there are, build a permanent list of these=
 devices,
>> then register the necessary hooks ourselves to get updates on both plu=
g out and
>> plug in, and on those events we update the list as appropriate (on plu=
g out,
>> notify the application via async event, after the application has proc=
essed the
>> event, if the device is unused, remove the device entirely, if the dev=
ice is still in
>> use, then move it to a defunct list and wait for the application to be=
 able to
>> release all of its references to it, and only then remove it; on plug =
in, add a new
>> device to the device list and notify the application via async event a=
t which point
>> the application can decide if it wants to use the device).  This might=
 actually
>> involve a new async notifier added to the libibverbs API that is not t=
ied to a
>> device and which an application would need to be modified to register =
with the
>> library.
>>  But since any applicaiton wanting to support this is going to need to=
 be modified
>> anyway, a new entry point isn't the end of the world.
>>
>=20
> I don't think that we should introduce an asych context into libibverbs=
=2E

Why not?

> Also, not all apps would like to process such asynch events - some mere=
ly want to
> use the RDMA subsystem at some time and get an up-to-date device list.

They don't have to.  If they want to register an event handler and get
notified, then they can.  If they don't want to, then they don't need
to.  Behind the scenes, if libibverbs simply does the right thing, then
an app that gets async events will work fine, and an app that wants to
simply call ibv_get_device_list and scan for new devices also works fine.=


>=20
> In the future, I would introduce some ibv_create_notifier_channel(), wh=
ich
> apps can ibv_get_notifier_event() from it that informs that the device =
list has changed...
>=20
> This is a simpler API that maintains backward compatibility with ibv_ge=
t_device_list().

I couldn't care less that this is simpler.  If it means maintaining two
implementations, or implementation hacks instead of a single proper
implementation, then it's not worth it.  Just do it right the first
time, especially since we aren't talking about some huge implementation
that would take months to get correct.  Taking baby steps and going one
piece at a time is, IMO, reserved for trickier things to implement than
this.  This is straight forward enough to go from start to final
implementation in one shot.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--9I8okgKl3ID44m33NbfxjtFL5o0uDKbCs--

--TnUIFNhRcqgJ4wKBpIFi24g40tGjphr7T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYte/ZAAoJELgmozMOVy/dJXgP/jgoVPAIPerGV+A4FyRD4qJ5
/nz3QK+956km/pWpCECC77Z6Xd/E8WQjbLjrFSAnOoSIx1y03FdVRtk6Go4+M0aQ
mjzSKbKlNdMc30Kp6FMLuvtbvalVM8T6csm0+m+wmMpfkzwbgeGVO+2ppaY0hUAh
wqxNawIskDHrZFC15HjG6FsX6nJXFVMRzThDys2FtBu20NTzG9ZwQb6GSiEnwzbF
cU0RDa8sB8TzvRMVwT2HPij2aJX7FNVrtO6svTfDjtpHV4xlNAawliGTlLJ8uBok
FRXvLp+0TynbtFdVRxvMM7rRZg97xAE9hAHUExAwagztV3b/LzC2w/4txM9NWQ+D
O2z7jm+lAz/vi+zH/A0jblx4cDqgvkrAz9qKFCFNExpcgdYHobIj+PBGHgjAnntw
IoAFCxfM68EdFBLlr3X5GDevSfi1yVUTehU5L8RtX9H9fTrzUDhyUuYpsWYBhWmT
Cdhkz2Eeu9e7ogCrlDiCXWjfNU6Ln0JEB9Q81mAYesSpQWuGgGlSuE3znNmEQOYO
hA+HSzgJllR2B0WgN7Gng32rVxPPzBc2MSgNworzCm6Hzbg1nKx1ObJGExuz5jYv
gK3Gf90uWi0egkQuJqHvR4pPno9+x8CBQlTGA58b5X5+xIovhTp2WCwqlMMIM5vX
CnEddttKSPZaoX1lWST1
=zJIv
-----END PGP SIGNATURE-----

--TnUIFNhRcqgJ4wKBpIFi24g40tGjphr7T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
