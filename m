From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch opensm] Allow for easily configuring multiple fabrics
 on one opensm server
Date: Fri, 02 Mar 2012 10:31:26 -0500
Message-ID: <4F50E7CE.6050204@redhat.com>
References: <4F4DB11C.5080203@redhat.com> <20120229112229.136f25b7.weiny2@llnl.gov> <20120302103015.GB6644@calypso>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3F612EDB8892B535E6706F4E"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120302103015.GB6644@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3F612EDB8892B535E6706F4E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 3/2/2012 5:30 AM, Alex Netes wrote:
> On 11:22 Wed 29 Feb     , Ira Weiny wrote:
>> Doug,
>>
>> First thanks for this.  Some comments below.
>>
>> On Wed, 29 Feb 2012 00:01:16 -0500
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>>> There are two things that stand in the way of opensm being run on
>>> redundant fabrics easily:
>>>
>>> 1) The opensm init script only starts one instance of opensm and open=
sm
>>> will only work on one fabric per instance
>>> 2) Even if you start multiple instances, you have to hand modify conf=
ig
>>> files for each instance and then when you upgrade the opensm rpm you
>>> either loose your modifications or loose getting new default settings=

>>>
>>> I worked around both of these issues, I've attached the files I used =
to
>>> do so.
>>>
>>> First, I have an opensm init script that allows starting multiple ope=
nsm
>>> instances.  It supports configuring this in one of two ways:
>>>
>>> 1) Create multiple opensm.conf files, each with a numbered suffix (so=

>>> opensm.conf.1, opensm.conf.2, etc.) and it will start one opensm
>>> instance per config file.  This allows an admin to copy the default
>>> config over and edit the things they need, and on rpm upgrade there w=
ill
>>> be a new default opensm.conf file so they can diff between their edit=
ed
>>> version and the new default and see if there are changes they need to=

>>> bring back in.  This also allows for complete flexibility in setting =
up
>>> the different fabrics, for instance you could use one type of routing=
 on
>>> one and a totally different type on the others.
>>>
>>> 2) Edit the file /etc/sysconfig/opensm and define more than one GUID =
in
>>> the GUIDs variable.  This will cause the opensm init script to
>>> automatically start one instance per GUID, passing the GUID in on the=

>>> command line.
>>
>> I know you are going for ease of use here, which is good, however, I w=
orry about this file becoming a redefinition of opensm.conf.
>>
>>>
>>> For the most part, this works well.  However, openmpi in particular
>>> doesn't like you to have physically separate fabrics that have the sa=
me
>>> subnet_prefix, and you can't specify a subnet_prefix on the command l=
ine
>>> to go along with the GUIDs.  So I wrote a patch for that and made the=

>>> init script unilaterally increment the subnet prefix for each differe=
nt
>>> GUID it's attaching to.
>>
>> If you only allow option 1 above this takes care of itself by making t=
he admin configure his subnet prefixes in each config file as appropriate=
=2E  The only down side is the loss of new configuration options as you u=
pgrade.  However, that is probably better taken care of by a default conf=
ig file with each package.  I mentioned this to Sasha years back and was =
denied since "you can always generate a new one with '-c'".  :-(
>>
>> Alex would a default config file be acceptable?  It would mean more wo=
rk on your part.
>>
>=20
> What the default opensm.conf would be used for? Just as a reference to =
the
> default values?

No, he's referring to having a default config file that is parsed, then
an override config file that is parsed where you only put options you
want to update in the override config file.  That way you could have,
for instance, a default opensm.conf in the normal location and totally
unedited so that it gets updated with each update of the opensm rpm,
then you could create an opensm.conf.1 that is empty except for just a
guid setting, a subnet_prefix setting, maybe a cache dir setting, etc.
In that way, if say the default routing engine gets a new option in the
future, your override config file won't already be populated with the
old stuff.  It's a means of inheritance that is functionally identical
to specifying all this stuff on the command line, but doesn't require a
huge command line or a complex init script.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig3F612EDB8892B535E6706F4E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPUOfUAAoJELgmozMOVy/dHgMP/jmtiC+hwtXsqNRclnXrqJsP
uM8+78a1SQBbygZrJzi1EyjmTlsEier8TMrEXohlW9J2koV27rDWJklIjP3gsBa3
PcoiUHwLjc67NmBPOCY/PsACtPNeG4bMHtirSVn8EKTwozJqfbVr+GCPtaiZFG1y
4JmJeJGQh57khvot89ki8St13zI1Sffg6GBWfAaUQu1lOYQvIUWPq1+Jkdl4iNK4
/po4It8xaMdTgsFn88fTNYh4Jf0eb3nX19V64m8W+JnU79MWCqlFAQfbbepk2cLk
uRIt/Tj9kX+0eV+J+Czo+cMLHlwXgTJMyocP1pjKy1Nxuf0XBSshrFns8rKn1rEy
AFe4w2KI0M3PyU87Z2zpRY2410P9o066fWmYJyiTyLmrQ296Fyasw6vHB9nhQEUQ
zrRfh/4Vi3gIpJnAgHw1WZNnfHiApJ2nF6jvjQg81V35al0mC05wmfR40vTeDQQA
3zGi0If1ndszZFb1UYHacdRC8kLjS0pwMZ+ODyGL15cpQpJ9Xg1xfnIsZ+ndTv6r
6+rE6ESTt7IPKAvQJjHA/iFbwufs9SOn/ZG27DdwuMeLII8pmg19zXIV7RjTGV+k
eboGU2gbOJfSCg21/i7ZlIVtYwYJbggpSDfW492cKvCa5mFrHG5sTFfa3vMkhWOG
Fs41hozsVWWY0pEtJM5B
=5Xrw
-----END PGP SIGNATURE-----

--------------enig3F612EDB8892B535E6706F4E--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
