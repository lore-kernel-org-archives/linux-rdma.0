From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/14] IB/srpt: Add RDMA/CM support
Date: Tue, 30 Jan 2018 17:29:33 -0500
Message-ID: <1517351373.19117.6.camel@redhat.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
         <1516230870.3403.292.camel@redhat.com> <1517271807.2687.65.camel@wdc.com>
         <1517334206.27592.291.camel@redhat.com> <1517336389.2589.22.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-bEIv5eTH5od0dlutyc1j"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517336389.2589.22.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-bEIv5eTH5od0dlutyc1j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-30 at 18:19 +0000, Bart Van Assche wrote:
> On Tue, 2018-01-30 at 12:43 -0500, Doug Ledford wrote:
> > On Tue, 2018-01-30 at 00:23 +0000, Bart Van Assche wrote:
> > > On Wed, 2018-01-17 at 18:14 -0500, Doug Ledford wrote:
> > > > On Tue, 2018-01-16 at 16:14 -0800, Bart Van Assche wrote:
> > > > > Hello Jason and Doug,
> > > > >=20
> > > > > This patch series not only adds RDMA/CM support to the SRP target=
 driver but
> > > > > also fixes a number of race conditions in that driver.
> > > > >=20
> > > > > The RDMA/CM listener port number has to be specified as an ib_srp=
t kernel
> > > > > module parameter. The default value for that parameter is zero wh=
ich means
> > > > > that RDMA/CM support is disabled.
> > > >=20
> > > > Since srpt is already configured via the lIO framework, wouldn't th=
at be
> > > > a better place for the listen port?  In fact, shouldn't it be part =
of a
> > > > portal like you have for iSERt?
> > >=20
> > > Wouldn't that be overkill to have one listen port per RDMA port? I th=
ink
> > > it will be easier for users if they have to configure the RDMA/CM por=
t once
> > > instead of one time per RDMA port. How about using the following loca=
tion in
> > > configfs for the RDMA/CM port:
> > >=20
> > > /sys/kernel/config/target/srpt/discovery_auth/rdma_cm_port
> >=20
> > Hmmm...maybe the real answer here is to start considering how serious w=
e
> > are about the RDMA_CM support in SRP.  If we're serious, should someone
> > contact IANNA about a reserving port number and just use whatever they
> > give us?  If we want to do the simple thing, a module option is fine,
> > while we decide on this issue, then I can see that being OK.  I'm more
> > OK with using configfs if there's a chance we won't get a well known
> > reserved port and the config option will stick around long term.  And I
> > tend to agree, per interface port configuration is probably not that
> > interesting.  But the ability to specify something other than the
> > wildcard IP address to listen on, and the ability to specify more than
> > one IP address to listen on, are.
>=20
> Hello Doug,
>=20
> My motivation for posting the RDMA/CM patches on the linux-rdma mailing l=
ist
> for the SRP initiator and target drivers was to allow others to run the
> srp-test software on a setup that does not have any RDMA adapters, namely=
 by
> using the SoftRoCE driver. Since IANA has not yet assigned a port number =
to
> SRP over RoCE I choose to make the port number configurable.

Sure, that makes sense.  I was just saying that if the intent is to
truly support this on anything other than an IB-like network, such as
actual iWARP or RoCE, then it's worth thinking about the long term
things that need done.

> Personally I don't think we have to postpone the ib_srpt RDMA/CM patch un=
til
> IANA has assigned a port number.

No, we don't.

> Regarding configuring on which IP address to listen, one possibile approa=
ch
> is to move the rdma_cm_port port number configfs attribute from
> /sys/kernel/config/target/srpt/discovery_auth/rdma_cm_port to
> /sys/kernel/config/target/srpt/$port/$port/attrib/rdma_cm_port where $por=
t
> is an RDMA port GUID or GID (both are accepted). That would allow to
> enable/disable RDMA/CM support per RDMA adapter port. The ib_srpt driver
> could e.g. create one listening rdma_cm_id per IP address that is associa=
ted
> with an RDMA port.

That would work as well.

> One approach I have considered for allowing to configure per IP address
> whether or not to accept incoming connections is to accept IP addresses a=
s
> RDMA port identifier ($port). However, that would complicate the ib_srpt
> driver because there is code in that driver that assumes that there is a =
1:1
> relationship between RDMA ports and struct srpt_port instances. As an
> example, the port[] array in struct srpt_device is an array with two elem=
ents.
> Code like srpt_event_handler() and srpt_cm_req_recv() uses that array to
> translate a port number into a struct srpt_port pointer.
>=20
> Yet another approach would be to introduce a new directory hierarchy in
> configfs for configuring IP access control. However, I don't think that w=
ould
> be possible without modifying the LIO target core. And as you probably kn=
ow
> since several months the LIO target core maintainer is mostly interested =
in
> bug fixes and not in new features or any other kind of patch that changes=
 the
> target core significantly.

Since you envision this mostly as a testing tool, we can worry about
things like this later if it is decided to make it a "supported" item.=20
It would be worth noting the testing status in some way that makes it
clear to users, maybe in docs or somewhere else.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-bEIv5eTH5od0dlutyc1j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpw8c0ACgkQuCajMw5X
L927/RAAp7GJRTVUKskdwPYOxdueaiECT35G3LKXaUZdOWCv5id+M5Z5yImukBEB
bt95g71Tu+hJEYqNRVx/j6VJeD/g1ZwhjW/vFZ8KPzmcys9NI7ICUP6Op9wgl/zq
QT2IEDsc/5MPtTBTaXrEQrq+R/WfozcKE9IfXfqH9Y3nYCD1NZwGrvHCigziHAEM
zU25tEAEGlHdFEO8nyZkDYwWz1jpELWC0JHqLRYrqcQiH64czDiBefQNb821Sudp
1Iq+pC5onU6NUtOWOX5dQ8qdFEE1kZf6BEOD1b32lB0ieTlyJ0VgC9dJEhU9WcLD
fZ9sUKb/iEFESrjEQz8SaS+kc28gNrebRtvy3iXF06Mb6qv1yfBOBPIzlgPi5bR9
vhQqttCFxUvPZHATdfX3npuTXDwswJVP0mHVKkeEsFsEINbEqb3nRq3/+dxQCMXi
SXuGiGMW7aNGKACrUCpuBULwtsqwowJ3+f683kyDyty/T0Ze5vl8q8xXHgxgIpSP
LsHjTBe58TXNJGRJNnjARSyNz0XNdvbWIB1TvbGgR9MB86yJuBppx5GdAzl5B1Mq
/gcHno9iAMBXO4bD2FszLydMJubCy75Izyq6etOfMCwUkR8M68o7IliqZ3CrRU9u
VxAuRcVm0EJq0RcBNNVBUHVSF9FB3rn+85MAn9xXO+sWJTkVLuU=
=r1oF
-----END PGP SIGNATURE-----

--=-bEIv5eTH5od0dlutyc1j--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
