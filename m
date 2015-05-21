From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Thu, 21 May 2015 17:11:48 -0400
Message-ID: <1432242708.28905.73.camel@redhat.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
	 <1432226406.28905.22.camel@redhat.com>
	 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-IsaA8Y5v29fZjhd7OB/x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-IsaA8Y5v29fZjhd7OB/x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-05-21 at 22:55 +0300, Or Gerlitz wrote:
> On Thu, May 21, 2015 at 7:40 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
>=20
> > The MAC/GUID mapping isn't the only thing that has to be faked here
>=20
> Exactly nothing is faked here, Virtualization systems such as
> open-stack provision unique 48 bit mac values to VMs, and it's
> perfectly legitimate and viable to derive 64 bit guid value from that
> mac.

OK, faked wasn't the best use of words.  How's converted behind the
software's back?  And if the management software set the MAC, then tried
to check it via ARP after the guest is up and running, it would never
find the guest.  I don't know if Open-Stack or any other controller
would both A) attempt to set the MAC of the device in libvirt and start
the guest and B) enter the MAC into a dhcp.conf file for static IP
assignment, but they could, and this sort of manipulation would directly
break that.

> > Why are we suggesting to make this work with unmodified software?  Why
> > aren't we doing this right and adding a new ndo entry point for the GUI=
D?
>=20
> Because rome wasn't built in a day and nor will be the support for IB
> in today's/tomorrow's virtualization systems, e.g if you follow on
> this layering
>=20
> [1] Open-Stack / ODL controller
> [2] Open-Stack neutron / ODL agent
> [3] libvirt
> [4] user/kernel netlink API
> [5] kernel ndo API
> [6] ipoib
> [7] kernel verbs API
> [8] PF IB driver
>=20
> with the approach presented here,  we only simply (yeah, simplicity
> could turn to be critical criteria in engineering) to few kernel only
> patches that deal with layers 6-8 and we are ready for all sorts of
> bring-ups, testing and even production!

You're ready to pretend that your IB device is a regular ethernet
device.  Not even a RoCE or iWARP device.  You totally obscured that the
device is RDMA capable and made the entire stack above 6 unawares of
what you are doing.  If your guest actually intends to use any RDMA
capabilities, then this is, at best, a quick and dirty workaround to get
you up and running while you work through the process of doing things
right, which includes making libvirt aware of the difference between
RDMA capable devices and not and how to select those devices and how to
mark certain guests as RDMA device needy.

> For reasons which I don't really see the practical / real life use
> case where there's a must to get them to work (but I will happy to
> hear on) one can go & change the world, namely patch layers 5 ---> 1
> too and deal with all sort of dependencies for setting up a system.
> But guess what, this can be perfectly done in parallel with this small
> change.
>=20
> > you would also have to fake the vlan/pkey mapping.  This just
> > seems the wrong thing to do.
>=20
> Repeating the above argument --- virt systems provision 12bit vlan-id
> to be set for VM traffic, which can be nicely map to 16 bit IB pkey
> doing the same job.
>=20
> I understand that you have sort of  desire to see IB ala the full spec
> going into libvirt and from there up to the whole virtualization
> management space, but this doesn't need as an argument to not enable
> doing thing in the right direction. The upstream kernel supports SRIOV
> for IB over mlx4 for 3 years now, but this can't work with libvirt as
> is. Using these patches can make the thing.

It's a workaround.  It comes with limitations, and if we get around to
adding an ndo later for really setting the guid, then it would be
possible to call the set_guid ndo with a complete guid that didn't use
fffe in the middle 2 bytes, and then when we call get vf_info, we get a
MAC back that removes those 2 bytes and generates an inconsistency
between what we *think* our constructed guid should be and what the set
guid actually is.

> Couple of months ago, we both attended a call with the libvirt
> developers / maintainers from red-hat and they really liked this
> staged approach.

My recollection of that call was they said "Oh, you guys don't have an
API for us to set the GUIDs yet.  Ok, we'll close all the bugs and wait
until you do."  And they promptly closed the bugs and moved on.  But
that didn't specify the API to use.  That's what we are doing here.  But
I'm not finding this an entirely convincing solution.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-IsaA8Y5v29fZjhd7OB/x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXkoUAAoJELgmozMOVy/ddIAP/2rMRip8dn2cQqXv3NJDCZ1O
VsBlR/OWO1Ga9Zhwr6gLijIWczW+jbBOawoKIqciqJ/z//qSxchDmMi+Eu1nYKBA
/o7OZhatKIinPFZRY5ibqFtK3LjPDcsaOaCI65DR7o4rU8xxtdRvcNXefAy4N+Zm
rINQ0oIGyo2gKLY8Hl5x0A58voE/vlzMkgVX24RxkCE/Ndkd6W+zXeVrYWXUj8xk
VVZN/Or0TVnLYat//dTaz2dFMrY0O0iEij+MC0klbr+tpxAQrpfQfiFUVpwCBBmw
mkob+4ocR4ExW3hrLizwJp4X7yrtB9yP6Wkg7SEoToY/kf3FQmuWUqweSaBd7dVD
GcU14bor0dQ43176IribK0fPxAhY4YiR/tWS5BVl+VO0cWBiK7xDlKqrxVXbajKe
pKSniqAwJM28FPdcLUgZIDOsauWvy1WcidRN5nGL6t7AEtkIMSP4BJ3ooWCYS8/Z
oyaMQEi+SQXYbfrSs6CFSur3vlhtrPoA3wJjmmyi6+/kB4s9F6SHIDYy+YcUCjcf
4QTZ1Ybxzs5334TZ7x2zg9A1zmajdH/Bwm33mBIKy7irBNGlhckiNEMEuR591LRQ
GQg+kvZKW3tOXyPB+ziLZs4QKKkPgAb6vOJaRsvX6uN5P6vNMKA3zsP8zNBbzbt7
/tOlUb9Dnx7ov00llsAh
=9tE5
-----END PGP SIGNATURE-----

--=-IsaA8Y5v29fZjhd7OB/x--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
