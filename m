From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch opensm] Allow for easily configuring multiple fabrics
 on one opensm server
Date: Wed, 29 Feb 2012 14:47:00 -0500
Message-ID: <4F4E80B4.5010508@redhat.com>
References: <4F4DB11C.5080203@redhat.com> <20120229112229.136f25b7.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBD0A7DB5B645B06D556AAC70"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120229112229.136f25b7.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBD0A7DB5B645B06D556AAC70
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/29/2012 02:22 PM, Ira Weiny wrote:
> Doug,
>=20
> First thanks for this.  Some comments below.
>=20
> On Wed, 29 Feb 2012 00:01:16 -0500
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
>> There are two things that stand in the way of opensm being run on
>> redundant fabrics easily:
>>
>> 1) The opensm init script only starts one instance of opensm and opens=
m
>> will only work on one fabric per instance
>> 2) Even if you start multiple instances, you have to hand modify confi=
g
>> files for each instance and then when you upgrade the opensm rpm you
>> either loose your modifications or loose getting new default settings
>>
>> I worked around both of these issues, I've attached the files I used t=
o
>> do so.
>>
>> First, I have an opensm init script that allows starting multiple open=
sm
>> instances.  It supports configuring this in one of two ways:
>>
>> 1) Create multiple opensm.conf files, each with a numbered suffix (so
>> opensm.conf.1, opensm.conf.2, etc.) and it will start one opensm
>> instance per config file.  This allows an admin to copy the default
>> config over and edit the things they need, and on rpm upgrade there wi=
ll
>> be a new default opensm.conf file so they can diff between their edite=
d
>> version and the new default and see if there are changes they need to
>> bring back in.  This also allows for complete flexibility in setting u=
p
>> the different fabrics, for instance you could use one type of routing =
on
>> one and a totally different type on the others.
>>
>> 2) Edit the file /etc/sysconfig/opensm and define more than one GUID i=
n
>> the GUIDs variable.  This will cause the opensm init script to
>> automatically start one instance per GUID, passing the GUID in on the
>> command line.
>=20
> I know you are going for ease of use here, which is good, however, I wo=
rry about this file becoming a redefinition of opensm.conf.

Hehehe, I don't think you'll ever have to worry about that.  You have
looked at opensm.conf in recent times I take it?  Replacing that with
command line options in a shell startup script isn't reasonable.

However, if you are going to run a redundant fabric setup, then the two
things you *know* you will have to set are the guid and subnet_prefix
(assuming you want to use openmpi).  If you are going to run
master/slave setup, then the one thing you *know* you will have to set
is the priority.  Supporting setting those items in an init script is
reasonable.  Beyond that, I would agree, you should just edit the config
files.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enigBD0A7DB5B645B06D556AAC70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPToC0AAoJELgmozMOVy/d5FgP/01d2CX5lBNpnY1qLtxbin+G
5611n2r/xWoH0ROltpQP2v0X2ow8nGxGXYJy65W2AicsbE/fk/cON+8oOQN/+ARB
ZCc2O+8ry7mTGIQ7uOO+EnVmCmpPRHidkjb0IB8z+HEVTDAxcyVH41fb+YXH73vg
jZRHbMON8YuiFO04KGjHYcJRcwWQWV6iI97vLedcfo1r95e0MeIp3sUhKO5ARakX
k9yN9+fmqDY/9uDBI/NN8clJ2nwTlzlOkzoye2Z6+R9A/MC9bIyzwMsMQ6rrPtcQ
9qlFZAl3D5xBwP5+W3oQtYNYrOAnJsqSg/HQ+IEbYQztWF8zqHaJvrTIomwxm4/m
x6rggS4Qb507LMv7UUgQu4EWnrU8q7wC7nHIdGFii7A4nZeTAd6t8Y8Pv9De1Dn/
SJq+bORJ5Ff1No7It0cHZ1YpXFaWrxkaVq6fN0VzF7Pk2OfKkD3P9VCDnGk7zAD1
lTawwOASr/fux8x2zUzfzFGPdur+4cpiGPenMoJHWDwRzrKpOk9wFrxCrp+pPss5
YbKoOhPQu4yWLnq4uajyaaIAZKpwVurXh/qA+Pi1K3ZF37CNM5UssshypUBlNGti
G2fT2V/wGpRhw/x0xVovNL7ujvj5DeQeBRAZPkYrcp9z2CpKzlwU8f6ND7tYtLfD
8VmdA76o4m5yU907XsEN
=0jiz
-----END PGP SIGNATURE-----

--------------enigBD0A7DB5B645B06D556AAC70--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
