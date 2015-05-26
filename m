From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Tue, 26 May 2015 12:53:46 -0400
Message-ID: <1432659226.28905.151.camel@redhat.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
	 <1432226406.28905.22.camel@redhat.com>
	 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
	 <1432242708.28905.73.camel@redhat.com>
	 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
	 <20150525211433.GA9186@obsidianresearch.com>
	 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
	 <20150525223235.GA9858@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-h7CnN7ppatBRM7vtxWVM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150525223235.GA9858-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-h7CnN7ppatBRM7vtxWVM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-25 at 16:32 -0600, Jason Gunthorpe wrote:
> On Tue, May 26, 2015 at 12:50:52AM +0300, Or Gerlitz wrote:
> > On Tue, May 26, 2015 at 12:14 AM, Jason Gunthorpe
> > <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > > On Mon, May 25, 2015 at 11:04:41PM +0300, Or Gerlitz wrote:
> > >
> > >> OK, so rewinding a bit, the IB VF [1] identity is their 8 bytes port
> > >> GUID, and as Jason noted the user/kernel API allows to deliver up to
> > >> 32 bytes between user and kernel under the set_vf_mac flow
> > >> (do_setvfinfo() in net/core/rtnetlink.c). Trying it out through
> > >> **non-modified** ip tool and net/core/rtnetlink.c things just work -
> > >> I can set eight bytes value to be the virtual port GUID :
> > >
> > > Was I not perfectly clear? You have to use the 20 byte LLADDR format =
here:
> > >
> > >> # ip link set dev ib0 vf 1 mac aa:bb:cc:dd:ee:ff:11:22
> >=20
> > Jason,
> >=20
> > I am aiming to provision the VF IB end-node address =3D=3D port GUID (v=
GUID)
> > in the same manner that VF Eth end-node address is their MAC, not
> > more, not less.
>=20
> I perfectly understand what you are trying to do.
>=20
> I care about the design and consistency of netlink - and that means
> there is one LLADDR definition for a net device, and every single netlink
> message that touches a LLADDR uses that definition - for IPoIB that is 20
> bytes.

So, here's my $.02.

First, 8 bytes is the right size for the data to be transferred.  The
remaining 12 bytes of the IPoIB LLADDR are generated constructs at least
partially controlled by elements outside of this machine, and moreover,
they are *not* the *actual* LLADDR of the underlying IB device and the
20 byte LLADDR never hits the wire.  So, it's an artificial construct.

The fact that the 20 byte LLADDR of IPoIB is problematic is born out by
multiple facts:  we only use 8 bytes in DHCP requests and responses,
only use 8 bytes in matching IPoIB netdevices against HWADDR entries in
the sysconfig/ifcfg-* files, only use 8 bytes for matching the udev
rules to rename IPoIB devices, etc.

This clearly demonstrates that attaching the netlink ndo points to the
IPoIB netdevice is, let's just say, a shortcut.  The *real* device that
we should be manipulating is not the IPoIB device, but the verbs device.
If we were manipulating the verbs device, no one would be arguing for
anything other than the exact proper item: an 8 byte GUID.  Of course,
the problem then becomes an issue of "can we attach the underlying verbs
device to the netlink ndo mechanism?"  And the answer there is "Not
easily, and Dave Miller would likely throw a fit" (and rightfully so, as
all netdevice entries are assumed to be IP capable and we aren't, and so
we can't really be used by the core of the net stack).

Since I don't see us getting permission from Dave to attach verbs
devices to the netstack just so we can A) be ignored by the core of the
netstack while also B) having only 3 or 4 of the ndo_ entry points
defined so we can co-opt their infrastructure for our own uses.

That leaves using the IPoIB device.  In which case, here's what I want:

If a user passes in a MAC addresses, please use the following checks:

if (mac_len !=3D 8 && mac_len !=3D 20)
	err out
set guid as lower 8 bytes of mac, leave remainder untouched regardless
of what's passed in

You will note that if someone passes in a mac size of 8, this is not an
error.  It is consistent with the existing NetworkManager device
settings, ifup-ib device settings, and udev device settings that an 8
byte MAC for IPoIB devices is the right thing to uniquely identify the
device.

Here's why I disagree with Jason.

If you have an app that queries a device, sees that it has a 20byte MAC,
and then tries to set that MAC, it may have no specific knowledge of how
IPoIB relates to the underlying verbs device and could just be trying to
set a MAC blindly.  And that's ok, but we aren't going to honor the
entire MAC they pass in, and that's likely to confuse the app (or the
person running the app).

On the other hand, if we advertise a 20 byte MAC, and the app/person
passes in an 8 byte MAC instead, then that implicitly denotes that the
app/person *knows* this is an IPoIB device, and *knows* that we are
actually setting the underlying GUID of the verbs device, and is aware
of and prepared for the fact that the entire 20 byte MAC is not in fact
settable.  IPoIB and verbs devices are an exception to the rest of the
netdevice stack, and this usage tacitly acknowledges that fact.  So I am
of the opinion that if an app/user knows exactly how accessing the IPoIB
device is merely as a passthrough to the verbs device and that 8 bytes
is the right size, then we should accept it instead of requiring them to
supply fake data they know won't be used.

> To violate that design invariant needs an incredibly strong argument,
> and you haven't made it.

Hopefully my argument satisfies your requirements.

> This allows generic code to work with the LLADDR - for instance 'ip
> link set vf mac' should have checked the size of the IFLA_ADDRESS and
> demanded that the address argument is the same number of bytes. It is
> very broken the command happily accepts an 8 byte and 6 byte argument
> for the same device.
>=20
> Yes, it is ugly that the PF side's ndo_get_vf_config cannot return the
> same 20 byte address of the VF's ipoib interface, but I think that is
> less ugly than forcing a different address format just for the vf calls.
>=20
> If you have doubts then *ask netdev*. Ask them if ndo_set_vf_mac must
> follow the same address size and format as IFLA_ADDRESS, or if we can
> use something else.
>=20
> Such a netlink architecture choice is beyond the authority of
> linux-rdma.
>=20
> Jason


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-h7CnN7ppatBRM7vtxWVM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZKUaAAoJELgmozMOVy/dEGwQAJs0k6YQ/JZ0u5oDGTidhYEK
7pmZAqA2LZlxq+ekngd99QPYz4DLCWoCYPbwzh3/WS5rIQ8HNej8tGDgQ1LKGHCg
9hzOgGx9vg9FGv75/kHqQq9uKXkCxq/K7u3VNhTGVX9rHc1yFLjdClKKFuvmpr0b
5T9tkIaN34tPV+hsZ9BM6F6v+E9NnDM221tPWR3N0KCeX99qrsNvL2O9hnqMgKXB
TQTIZuceWnX+5gjdwROckfEz33Qt8fn8J0xSC/y856HskDbdtY2LVTMx+FtrbgqQ
LunvHUUIa53lRQwm6DIx8KO4dFNJRca9nqgjL3VtU/bjIPuBEPHKF0IaH/yI/dp8
pC75ZiIncWAtC75yGBxmU1dLsKIG/O/h7oZCWa/MhXRYR+I9j6TjWw9Kqz06pZx/
sMar6F3B5Lm34OWGVNlIppwvQz/slxt8OJqH7RwLGYVEvEYjmV3f8AOrsXhcrFD1
jpnJ4XfSQvcrh9jbD1CxV8N3bxi/NOGwIZW8O/VnGrlmp8cSQrlSmALtiTJGl+T6
et/m8HrMfWPD9gL+ARiek9XpdE6RVBZXA5+hE8i9jTC7kw7snvUZOTYTqb0uctPJ
+pOJurGFSjo2nfMqg8glUW/WN+C1AHcVgJJu1jr3JxD98KKR9iaGhxg/ve9kNnZo
VuTFSyUkjnHSAsDsBl/o
=Ju83
-----END PGP SIGNATURE-----

--=-h7CnN7ppatBRM7vtxWVM--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
