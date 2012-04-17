From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ibacm: Fixes to ACM package to support distros
Date: Tue, 17 Apr 2012 12:33:38 -0400
Message-ID: <4F8D9B62.9070201@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A823734519A805@ORSMSX101.amr.corp.intel.com> <4F7DC3F8.2030406@redhat.com> <1828884A29C6694DAF28B7E6B8A823734519B048@ORSMSX101.amr.corp.intel.com> <20120405204038.GA6575@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4A1BBFF53B2EEDC512D8D035"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120405204038.GA6575-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4A1BBFF53B2EEDC512D8D035
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/05/2012 04:40 PM, Jason Gunthorpe wrote:
> On Thu, Apr 05, 2012 at 07:10:25PM +0000, Hefty, Sean wrote:
>>>> +PATH=3D$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbi=
n:/bin
>>>
>>> I'm not very keen on including /usr/local in the search path on syste=
m
> =20
>> To say that I'm not sure what autotools and the init scripts are
>> doing is an understatement...  The init script finds ibacm in
>> /usr/sbin, but not /usr/local/sbin where it ended up being
>> installed.  I'm not sure how to fix that.
>=20
> In this instance you need to have configure variable substitute your
> init script as well. You should not manipulate PATH from an init.d
> script, and you should use an absolute path to the daemon to avoid
> contamination from the invoking user's environment.
>=20
> So you want:
>=20
> %prefix$/bin/IBACM_BIN -foo
>=20
> (use start-stop-daemon if appropriate for RHEL, I'm not sure what
> their conventions are...)
>=20
> There might be a better choice than %prefix% for this, check the
> config.sub output for a better substitution.
>=20
> Also, these days it would be very forward-thinking of you to
> contemplate how this will work in a systemd world. Make sure it can be
> demand started, have a daemon that has a running mode that is systemd
> compatible, etc. I think Doug was saying that the latest FC has IB and
> systemd together?

The latest FC has IB and systemd, but IB still uses SysV init scripts
and systemd does the emulation to start IB.  It's on my list of things
ToDo to get it converted to native systemd.  My seemingly never ending
ToDo list :-/


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig4A1BBFF53B2EEDC512D8D035
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPjZtiAAoJELgmozMOVy/dCIoQAKIQx5Ia6cTfppDnxyz4tOX5
7EDkSoWzazncrmqqld4IdfdJqP1gSik4ZunNB3hJ9vSoxIdtoyy7bB2/dlyQXbEh
EbHuDkSEgXZtIUoV+EHfnlUQwESCo4aQ/y2r+np07Dz0rq+6e3WqXSvNEpheWLgk
ybqjuhILn+oYX//FdLOYIZt8n9yWor68QCJGNmB/KiWwbbXwoPi0pgQOWjPLbuG3
VZKoOVbsjZLKU85utMAHEsTvdygSPQ2sjzfoJZbbsZ/I/+QoMjtuQweZtFrLvz2N
ENDvmqsE30Ty7a2XUB3yjAChcoxUxjHFWFp9fZVTkV9B+wX3haO2TB+wNipprABa
aS+3/sh4v+u8D4hB7Eh+NbmQIEmpiQ7+RKIK5QzbX1fmaejRIc/XbvsV8mJVMbwQ
HTNQ713qcNOvRHL75pov2WRSAvpLrva2wZS6Js5xdx9mkDwIU29jt6jo3Gp6IXWl
tTpWU6JU8yqGwoKvBmZy7ODOCQAL4YdAVsYGRyYQ6YK1nsVzIMrK2rh5W9EeUZEF
edWeJw+jTIfJL0gkuiK3xTohrIpZ5k1j05B4VSRlHjcaeWF7FS8iCHKTWWlW1J9S
37Ec82mn9JcmNRKQO5HUTk7+Rf1NMFu+HSsGkAcSnFX43PBfcgWNxxeqVJmjquS6
rYqPOwCg3Ru1K56YmLEs
=ysl0
-----END PGP SIGNATURE-----

--------------enig4A1BBFF53B2EEDC512D8D035--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
