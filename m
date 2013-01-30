From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] opensm/configure.in: Remove Default-Start from opensmd
 init script
Date: Wed, 30 Jan 2013 14:24:47 -0500
Message-ID: <5109737F.70101@redhat.com>
References: <20130129171850.GB2961@calypso.mtl.com> <5108E0F6.3060602@acm.org> <51093F8E.10905@redhat.com> <51094393.1060102@acm.org> <51095CD5.80503@redhat.com> <51097080.9000402@acm.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2NFJHJKEPQEVJQSMCHNRQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51097080.9000402-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2NFJHJKEPQEVJQSMCHNRQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 1/30/2013 2:12 PM, Bart Van Assche wrote:
> On 01/30/13 18:48, Doug Ledford wrote:
>> On 1/30/2013 11:00 AM, Bart Van Assche wrote:
>>> Which convention is followed for other packages ? This is what I
>>> found in
>>> the Fedora 18 iscsi-initiator-utils package
>>> (http://be.mirror.eurid.eu/fedora/linux/releases/18/Fedora/source/SRP=
MS/i/iscsi-initiator-utils-6.2.0.872-19.fc18.src.rpm):
>>>
>>>
>>> * iscsid.init: Default-Start: 3 4 5
>>> * iscsi-initiator-utils.spec:
>>
>> Okay, first off, any package that still uses the SysV initscripts as o=
f
>> Fedora 18 is not what I would call a package that is keeping up with t=
he
>> Fedora packaging guidelines or Fedora technologies.  As such, I'm not
>> really sure you want to use it as an example of a good package.
>> However, that being said, you will note in this spec file that the iSC=
SI
>> initiator package does exactly what you removed, or suggested be
>> removed, from the opensmd spec file.  It unilaterally adds the
>> initscript to the system.  The default start/stop settings are
>> different, but the add action is the same.
>>
>> All initscripts should be added to the system, regardless of their
>> default start/stop settings, and the default-start and default-stop
>> should be used to control *how* they are added by default, and chkconf=
ig
>> --level .* <scriptname> [on|off] should be used to control whether or
>> not they are on or off differently than their default settings.
>=20
> Thanks for the detailed reply. Regarding the purpose of the patch at th=
e
> start of this thread: do you know whether it is LSB-compliant to use
> "Default-Start: null" or should "Default-Start" be left out entirely in=

> order not to create the start links ? See e.g.
> http://refspecs.linuxbase.org/LSB_3.2.0/LSB-Core-generic/LSB-Core-gener=
ic/initscrcomconv.html.
>=20
>=20
> Bart.

I've always used "Default-start:" without any listed levels, but I
haven't really tested it either and the spec is not specific about this
particular possible configuration.



------enig2NFJHJKEPQEVJQSMCHNRQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRCXN/AAoJELgmozMOVy/dOlMQAKLlw+c1EGyT01fnVnWquXBN
JGs5Vnowviq11MrbVopavtZ2F4CwS69eW+1J2jWS8ReLoaajEk7yl2mJRPbaae8W
mCUsT+KeqvuuIo44NF0UYNJvpX4I9O5lXQ/k2NLJzv7ex3Grk+2Qgg21xQa1PSaT
Loyd6fCAdPs04UComTTj5cNydnsZnrnGGOh7V2KTfLrM0zhbMv3yYuEQJ8OOaXbq
+pYK5B04e41A0Uy2LiOGXSqAciYXf2GxYqrf0zqW2ifwuRF5UVuFrRViqyIYkEJa
sgQNzsXcsiq8BdrJyHz0spzcr5d/DtyVBSxFMU5DFzgVGVu86w98tRcoaWiS125Z
gm9JVWapz8A2Z8EvBnRNn7qj5BOkZPZw62PRvB5bWV/q+1aBgW0qMyMxsDESBSd4
TwW/UmZwihYmjK0MvwGdZZ3LXbk57nNJXza0rJ5edH40H91O9yusLCka6JmEJB8A
bAK+7OrSkCc5DsokThNyeklTG+bzivBXGEIug+ffwpLWw3/57YutlVfVcdqBQywt
XsbV5lVsTujoO1uVzkV7Sazkn9mJ7a3ZUenJAPG7eBdl7dXxYCpnkI5XkYadHbSD
mi//0h4q495bdoHrTmfzTdVC7S4q33MpbTV9CjjIxBo/YYSIcsSzHYfDWShxL812
TTxi1nxJpR25/Gz5CYS1
=ObcY
-----END PGP SIGNATURE-----

------enig2NFJHJKEPQEVJQSMCHNRQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
