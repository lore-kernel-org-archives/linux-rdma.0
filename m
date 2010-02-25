From: Dries Kimpe <dkimpe-zhzY/AYb9nBYTrM/R70HSA@public.gmane.org>
Subject: Re: link width question / opensm
Date: Thu, 25 Feb 2010 13:37:21 -0600
Message-ID: <20100225193721.GB15303@X300.wifi.conference.usenix.org>
References: <20100225063905.GA4690@X300.wifi.conference.usenix.org>
 <f0e08f231002250645u1a728u60e6269921affac8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231002250645u1a728u60e6269921affac8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


* Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> [2010-02-25 09:45:04]:

> The link won't renegotiate automatically. The link needs to be reset
> after updating the speed/width enabled values. Was that done ?

I assumed OpenSM was resetting the link. Are you saying I need to run
ibportstate reset in addition to running a modified opensm?
(Or, using only ibportstate using ibportstate speed followed by a
ibportstate reset?)

> > - Is there another way to get what I want (control over link width+spee=
d)?

> The latest ibportstate can do this.

I installed the latest version, and it indeed has width and speed.
However, it doesn't seem to have any effect:


[dkimpe@f28]~% sudo /usr/sbin/ibportstate 232 1 query
PortInfo:
# Port info: Lid 232 port 1
LinkState:.......................Active
PhysLinkState:...................LinkUp
LinkWidthSupported:..............1X or 4X
LinkWidthEnabled:................1X or 4X
LinkWidthActive:.................4X
LinkSpeedSupported:..............2.5 Gbps or 5.0 Gbps or 10.0 Gbps
LinkSpeedEnabled:................2.5 Gbps or 5.0 Gbps or 10.0 Gbps
LinkSpeedActive:.................10.0 Gbps

[dkimpe@f28]~% sudo /usr/sbin/ibportstate 232 1 speed 1
Initial PortInfo:
# Port info: Lid 232 port 1
LinkSpeedEnabled:................2.5 Gbps or 5.0 Gbps or 10.0 Gbps

After PortInfo set:
# Port info: Lid 232 port 1
LinkSpeedEnabled:................2.5 Gbps
[dkimpe@f28]~% sudo /usr/sbin/ibportstate 232 1 query =20
PortInfo:
# Port info: Lid 232 port 1
LinkState:.......................Active
PhysLinkState:...................LinkUp
LinkWidthSupported:..............1X or 4X
LinkWidthEnabled:................1X or 4X
LinkWidthActive:.................4X
LinkSpeedSupported:..............2.5 Gbps or 5.0 Gbps or 10.0 Gbps
LinkSpeedEnabled:................2.5 Gbps
LinkSpeedActive:.................10.0 Gbps

[dkimpe@f28]~% sudo /usr/sbin/ibportstate 232 1 reset
ibportstate: iberror: failed: smp query nodeinfo: Node type not switch


  Thanks,
  Dries

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkuG0XEACgkQv/8puanD4GoYigCgi4aA0sORtb7TS/oGwNArPUh4
wNgAnRyGp9JQ7ES/3ymBlW7zwiUj4Fpy
=8LI/
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
