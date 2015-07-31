From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] update ocrdma to dual license
Date: Fri, 31 Jul 2015 13:38:17 -0400
Message-ID: <55BBB289.4000000@redhat.com>
References: <1434127505-17739-1-git-send-email-devesh.sharma@avagotech.com>
 <20150630060631.GA21105@infradead.org>
 <CANjDDBh3pxLFe2o08KzAtw8dtVq94GK04x4YZ0nXA+YnVh5Bng@mail.gmail.com>
 <20150701072120.GB31381@infradead.org>
 <CANjDDBinTi43KTt14C7cJ0Uo=Do8Vt3G6bXutLbsViUFUG=jRg@mail.gmail.com>
 <2807E5FD2F6FDA4886F6618EAC48510E110A880D@CRSMSX101.amr.corp.intel.com>
 <20150703155234.GA6099@infradead.org>
 <CANjDDBh1C8Hh_MN9P1=N-g9tvwa-GF0h387_SHiE12cNVKfH2Q@mail.gmail.com>
 <20150708080108.GB5668@infradead.org> <559D7FA9.1040200@redhat.com>
 <20150708200212.GA28030@infradead.org>
 <alpine.DEB.2.11.1507310930240.12455@east.gentwo.org>
 <55BB9C03.1030103@redhat.com> <55BBA0D6.3070604@redhat.com>
 <alpine.DEB.2.11.1507311147200.13467@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2Kqfx1f05xnxvims1GRTG793L4QA9lfxl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1507311147200.13467-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2Kqfx1f05xnxvims1GRTG793L4QA9lfxl
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/31/2015 01:03 PM, Christoph Lameter wrote:
> On Fri, 31 Jul 2015, Doug Ledford wrote:
>=20
>>> Everyone on that Cc: list (and I note in particular that your name is=

>>> *not* on that list) has been contacted and gave permission to
>>> Avagotech/Emulex to go ahead and change the copyright on the code.  A=
s
>>> such, it is their *right* to make that change if they see fit.  There=

>>> will be no revert, period.
>>
>> Also, just as a general rule, don't *EVER* come to me trying to assert=

>> copyright control on code you haven't even donated one line of effort =
to.
>=20
> I have not asserted any copyright on the particular files.
>=20
> But I have extensively contributed to core kernel code for 20 years wit=
h
> the understanding that the license for the kernel code as a whole is un=
der
> the GPL

(Note: this is my understanding, but I'm not an attorney, so seek more
experienced advice for an authoritative answer)

It is *exactly* that.  The kernel *as a whole* is under GPL.  And when
used as a whole, the code in the RDMA stack that is dual licensed falls
under the same license as the rest of the kernel.  The dual license on
this code does not allow someone to use the rest of the kernel as though
it were under a BSD license, and due to the kernel being a "compilation"
in nature, the GPL compilation clause spreads to this code whenever you
are using it as part of a whole kernel tree and requires that this code
be treated as GPL only and not the BSD variant of the license.

The only time that this code can be used under the BSD license is when
it's removed from the kernel as a whole and used separately (which is
what the OFED people do when they build their kernel tree....it is a
separate tree that has its own build environment and builds modules to
run against any given kernel they support, but is not a complete kernel
tree in itself, all of the core kernel code has been ripped out and only
the RDMA stack is left in their tree, and it must be compiled against
the devel headers of whatever kernel you want the modules to work with).

> and that others will contribute like I did under the GPL. It
> certainly is a surprise to me that someone can change the license of pa=
rts
> of the kernel to allow non-GPL licensing. Never seen that before.

It's been that way since day 1 on the entire RDMA stack.

> I will assert that the modifications of the IB stack that I have
> contributed over the years (mostly in passes over the kernel to
> change functions globally) are under GPL only. In this case you are luc=
ky
> that I never touched those files.

You can assert it, and since I'm not an attorney, I won't try to speak
as to whether that assertion will hold up.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--2Kqfx1f05xnxvims1GRTG793L4QA9lfxl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVu7KJAAoJELgmozMOVy/drmIQALWlAjdD7Ewf+6OGjcPHGJzg
YL2OWJIkBm6wMFB7nQC0+7HTclbTh8j8s0zO12ej9bOnzhqedhVN4naZ098TIph/
GPdi8JrZP1oie+Itbol5mL0hQ8prrlEDrAgd65RAkPsrX6CLUInbOJFsOQ86kuEW
4qfMvNAQAIcv40OgC+16xU6lLFpANMuAXkDmKelf4eGRNZIiy1Zx8qz3848YMimw
3kCEX4JSzRjFan5S2+pM4x0caIQMTQcDFkcXtk7A1W4AEMQXl9MJp2FGAsoJLFgh
QXjfwvBAInupOVNBxsWmQisGiibwjRCBh+QYoK0+i5qCGX+U8zEGROMq0QbXnvFa
XWlT7IU+XWI7HCAnKFdDgVmoQTyxPt4dMC5LweebrJVFWZHaGByMpePpLnNT2/Lv
YOBmSOkMqosR5nnKPZDot5BwlXTqQblfCb1dFAV9R2SMDuJbWGLP4ZrLNp6z75Rn
GRMKAnv1IkVGsh+N7LQ+GwOa+ddn6WQ6aJJ61ST47OBYc/e3lWF+LbnDWnQSwgdc
OI7WCb+tu+5x1WY7EW0uvt+eHHGl+anzKi2QMv88te80Y97t8DCPQLdGipdRoSLC
OpbRREHl2ZpT8Rcn3HXEQj41lNA9t0qpeIwSrjeFmeQQ9Y32zJvhd857/s2Tmz+p
t0boIDGtInUbjjReclNo
=jNtZ
-----END PGP SIGNATURE-----

--2Kqfx1f05xnxvims1GRTG793L4QA9lfxl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
