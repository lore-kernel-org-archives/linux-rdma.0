From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ibacm: Fixes to ACM package to support distros
Date: Thu, 05 Apr 2012 15:21:56 -0400
Message-ID: <4F7DF0D4.5040101@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A823734519A805@ORSMSX101.amr.corp.intel.com> <4F7DC3F8.2030406@redhat.com> <1828884A29C6694DAF28B7E6B8A823734519B048@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2A093E5F0FA8484FFE840BC2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823734519B048-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2A093E5F0FA8484FFE840BC2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/05/2012 03:10 PM, Hefty, Sean wrote:
> I've incorporated most of the changes, but see below.
>=20
>>> -EXTRA_DIST =3D src/acm_mad.h src/libacm.h \ -	     linux/osd.h
>>> linux/dlist.h ibacm.spec.in $(man_MANS) acm_opts.cfg \ -
>>> acm_addr.cfg +EXTRA_DIST =3D src/acm_mad.h src/libacm.h ibacm.init
>>> \ +	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS)
>>> ibacm_opts.cfg
>> \
>>> +	     ibacm_addr.cfg + +install-exec-hook: +	if ! test -d
>>> $(DESTDIR)$(sysconfdir); then \ +		mkdir -p
>>> $(DESTDIR)$(sysconfdir); \ +	fi; \ +	if ! test -d
>>> $(DESTDIR)$(sysconfdir)/rdma; then \ +		mkdir -p
>>> $(DESTDIR)$(sysconfdir)/rdma; \ +	fi; \ +	if ! test -d
>>> $(DESTDIR)$(sysconfdir)/init.d; then \ +		mkdir -p
>>> $(DESTDIR)$(sysconfdir)/init.d; \ +	fi; \ +	install -m 755
>>> ibacm.init $(DESTDIR)$(sysconfdir)/init.d/ibacmd;
>>=20
>> I'm curious why you didn't just do install -D -m 755 ibacm.init=20
>> $(DESTDIR)$(sysconfdir)/init.d/ibacmd instead of all the
>> individual calls to mkdir.
>=20
> ignorance on the existence of the '-D' option  :)
>=20
>>> +PATH=3D$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin=
:/bin
>>
>>
>>>=20
I'm not very keen on including /usr/local in the search path on system
>> binaries.  It can be done, but we would patch it out (and I imagine
>> SuSE would too).  It's a support issue.  Having /usr/local override
>> the system installed binaries means that you can end up with
>> strange things happening, and support scratching their head and
>> going "what the hell is causing that" and in the end it's because a
>> different binary than the one RPM installed is actually running.
>=20
> I create a .tar.gz package using 'make dist', copy it to another
> system, then install it using 'configure && make install'.  When I do
> that, sysconfdir defaults to /usr/local/etc, sbindir /usr/local/sbin,
> and bindir to /usr/local/bin.  I added /usr/local to PATH, so that
> the init script would work.  Otherwise I get a 'command not found'
> error when running the script.  On a side note, my ibacm
> configuration files end up in /usr/local/etc/rdma.

configure --prefix=3D/usr --sysconfdir=3D/etc && make && make install

> To say that I'm not sure what autotools and the init scripts are
> doing is an understatement...  The init script finds ibacm in
> /usr/sbin,

Which means some time it got installed there, either by an rpm or
something else.

> but not /usr/local/sbin where it ended up being installed.
> I'm not sure how to fix that.

Do an actual rpm build and install from the rpm.  Or use the command I
listed above to get the configure directories correct (configure
defaults to /usr/local).  But it's generally best to have your files
tracked by rpm.  It makes upgrades and uninstalls work much more
smoothly.  And the rpmbuild program and the macros in the spec file
processing get all your directories correct for you too.  Assuming you
have an rpm based system that you are running from of course.  In that
case, it's fairly simple to do something like the following:

make dist
rpmbuild --rebuild <name_of_tarball>
rpm -Uvh ~/rpmbuild/RPMS/<arch>/<rpmlist>

You might need this in your ~/.rpmmacros file:

%_topdir %(echo $HOME)/rpmbuild


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig2A093E5F0FA8484FFE840BC2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPffDUAAoJELgmozMOVy/dAu4P/RKCyGAXC6EhBfQH4B6ctvJD
JfVSGjCK/OmCTsw0wpQduVU/HYVnLO6hMqaEpAwXHjR29CeUNzL1n1yEUp3FrUVc
bDSNzEjjq9BPovr17W8ddQlXJg7+nJ4v8LfhoY8f66PKmGC/Up2cftK3/CLZl0jK
pzUAk/5uHTEUbYlr3XeOlGsNHcsL2EmxE+hcdolQCyrr8JsERXRdOF2f7i6R17rF
n+IsTkV6tIHD+hc6LbP8Pznv2hZ5kkmua60frXCfQDOAVpa+jZFvCA6UC93cwHVn
vJ7qmn9rKnZ//IgpSThLaaqF+bW9NdYHWYFeNy86U1mPbOF7m/bqQ9l/qOeFeYFN
s5aYn5bfo2jtWrbmkqeanr2TiJzF7WS+jfST6J25KJMouOzeY6SemWij0iyAXjy5
qWI8RRdWOoCX8m9VZ+3sIra2+Ztz9BO1PVIdFrGosDPz+7rTfr3RpfzL24i11WOk
xDILbCwMppHRu4fuV2tGYL89mjn8tB8alra+x6lhbtHIx5IFv0K3WOgg5tMfUnU4
mb9WPZYU3Z13ylOc2gdESSOWhoeyrC6HwDq99N6JpYSqnPz7FlPbvJ8YdQ5v+8vq
HH7viGjBlchB+WvKd987REoW2Zb2Yb9p6Vvw2KuKIqsuzxVycJLSX+HrppJNHhQb
SBlwgC/64yqYlXOFTwaS
=kUFH
-----END PGP SIGNATURE-----

--------------enig2A093E5F0FA8484FFE840BC2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
