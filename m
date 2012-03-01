From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch opensm] Allow for easily configuring multiple fabrics
 on one opensm server
Date: Thu, 01 Mar 2012 08:31:55 -0500
Message-ID: <4F4F7A4B.4060007@redhat.com>
References: <4F4DB11C.5080203@redhat.com> <20120229112229.136f25b7.weiny2@llnl.gov> <4F4E80B4.5010508@redhat.com> <20120301021501.GB961@bukharin.us.cray.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig06E90F172D561AC9D1E71026"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120301021501.GB961-7GFyYy+Av7rWWZS0+0nfmVaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Ginsbach <ginsbach-WVYJKLFxKCc@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig06E90F172D561AC9D1E71026
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/29/2012 09:15 PM, Brian Ginsbach wrote:
> On Wed, Feb 29, 2012 at 02:47:00PM -0500, Doug Ledford wrote:
>> On 02/29/2012 02:22 PM, Ira Weiny wrote:
>>> Doug,
>>>
>>> First thanks for this.  Some comments below.
>>>
>>> On Wed, 29 Feb 2012 00:01:16 -0500
>>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>>> There are two things that stand in the way of opensm being run on
>>>> redundant fabrics easily:
>>>>
>>>> 1) The opensm init script only starts one instance of opensm and ope=
nsm
>>>> will only work on one fabric per instance
>>>> 2) Even if you start multiple instances, you have to hand modify con=
fig
>>>> files for each instance and then when you upgrade the opensm rpm you=

>>>> either loose your modifications or loose getting new default setting=
s
>>>>
>>>> I worked around both of these issues, I've attached the files I used=
 to
>>>> do so.
>>>>
>>>> First, I have an opensm init script that allows starting multiple op=
ensm
>>>> instances.  It supports configuring this in one of two ways:
>>>>
>>>> 1) Create multiple opensm.conf files, each with a numbered suffix (s=
o
>>>> opensm.conf.1, opensm.conf.2, etc.) and it will start one opensm
>>>> instance per config file.  This allows an admin to copy the default
>>>> config over and edit the things they need, and on rpm upgrade there =
will
>>>> be a new default opensm.conf file so they can diff between their edi=
ted
>>>> version and the new default and see if there are changes they need t=
o
>>>> bring back in.  This also allows for complete flexibility in setting=
 up
>>>> the different fabrics, for instance you could use one type of routin=
g on
>>>> one and a totally different type on the others.
>>>>
>>>> 2) Edit the file /etc/sysconfig/opensm and define more than one GUID=
 in
>>>> the GUIDs variable.  This will cause the opensm init script to
>>>> automatically start one instance per GUID, passing the GUID in on th=
e
>>>> command line.
>>>
>>> I know you are going for ease of use here, which is good, however, I =
worry about this file becoming a redefinition of opensm.conf.
>>
>> Hehehe, I don't think you'll ever have to worry about that.  You have
>> looked at opensm.conf in recent times I take it?  Replacing that with
>> command line options in a shell startup script isn't reasonable.
>>
>> However, if you are going to run a redundant fabric setup, then the tw=
o
>> things you *know* you will have to set are the guid and subnet_prefix
>> (assuming you want to use openmpi).  If you are going to run
>=20
> Assuming you are doing this for openmpi.  The subnet_prefix should
> not be needed if the separate subnets are for disjoint networks
> (mpi and storage) or multiple storage networks.

True enough, but that's why I said openmpi.  It is, after all, a primary
IB fabric user.

>> master/slave setup, then the one thing you *know* you will have to set=

>> is the priority.  Supporting setting those items in an init script is
>> reasonable.  Beyond that, I would agree, you should just edit the conf=
ig
>> files.
>>
>=20
> Not everything can be done in the config files.  I'm not sure that
> it is a good idea to have every opensm instance using the same
> temporary and cache directories (OSM_TMP_DIR and OSM_CACHE_DIR
> environment variables).  Seems like these fall into the *know* you
> will have to set category.

Unless opensm is smart enough to allow more than one instance to open
the same log file and interleave their log messages successfully.
Temporary files or cache files could do something like use a pid suffix
if need be.  But yes, I see your point.  Opensm has lots of junk it
likes to put on the drive :-/

> You'd also want to make sure that other potentially very useful
> things are configured in the config files (e.g. log_file and
> log_prefix).  Aren't these also things you *know* you will have to
> set.

I would say we are simply getting to the point where we *know* we need
opensm to handle more than one fabric from a single instance ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig06E90F172D561AC9D1E71026
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPT3pLAAoJELgmozMOVy/dnrAQAI8apq+Qpc+rLGKbGzssrwvL
IKyCrtf8hzuBxctbVrpP7QkcYNMDHsYUUQhmE1HpIqHxihPsnmyRl+1lzs8JlP3o
egq1A6up36bh4ctISUZiAc9kg9kKPVTeKbANhxiuHOF1YJW6jnDXl0TS/XoITowT
YrLW05lepUUdrPBNkHgCch9SOAwMPbbRlRz6DdUtPoU8uau0dXZIHFUWJa4hKfqG
vAZNLrOSVK1ITA58nYFb+kQ66NCOy9bXcMMRcTHNFCyjFzPiZzIfpRXrCyxlalaS
wjAJcoVKxdLOGjo2u7l51f4a/gMLpcIOY9ysmT9L6leWEOOFtxY/7wogmTdtXxPu
Z1dH8GostdJFCaZZLUBrYh15ulW/8rUHzT6p9oIIvGC2+wcsKz752K6pBg8ha2Zo
BDR/EhplMirqpYADZhTh7lXUO4ALNz0My1ICG8JnUi8oIMCF9cWdGtqlSVgcYifj
qp0jBzQ3cbC7jg1PrUHP50yAjRHMzO1318m2Ne5CaXgvuf23r+SN5d15moB55m9g
0yihhx2J912Crf3kKPT345g7Gosn8574uChcKc8xV6b730LzyWMBq/QFcPUuYVRk
TLEVXnKuvQ70OpYFQeQLsBu5sHCZQ87YuaOqmyy0CQRm3arV2QqMbiDOzyYQGKge
3kEYpIq+rHhhUfd9gi+n
=QOS5
-----END PGP SIGNATURE-----

--------------enig06E90F172D561AC9D1E71026--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
