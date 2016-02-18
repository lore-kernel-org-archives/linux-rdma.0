From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 15/21] IB/srpt: Log private data associated with REJ
Date: Thu, 18 Feb 2016 10:14:18 -0500
Message-ID: <56C5DFCA.9000609@redhat.com>
References: <56BCDAAD.7030906@sandisk.com> <56BCDC1C.107@sandisk.com>
 <56C49854.6010204@redhat.com> <56C50110.7060003@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qq3JGBWgQJv09i3oLkfeuBmL9k56m0Jmv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C50110.7060003-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qq3JGBWgQJv09i3oLkfeuBmL9k56m0Jmv
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/17/2016 06:24 PM, Bart Van Assche wrote:
> On 02/17/2016 07:57 AM, Doug Ledford wrote:
>> On 02/11/2016 02:08 PM, Bart Van Assche wrote:
>>> To make it possible to determine why an initiator sent a REJ,
>>> log the private data associated with the received REJ packet.
>>
>> This particular function is all sorts of broken...I fixed it up as I
>> took it in.  But, issues were:
>>
>> 1) We always allocate priv even when private_data_len is 0
>> 2) Since we always allocate priv, the test for priv in the pr_info arg=
s
>> isn't really helpful, but the way the test is set up, if priv exists,
>> then we actually pass NULL, if it doesn't, we pass the static string.
>> 3) In the event we have priv and private data, then there is a nit abo=
ut
>> formatting because priv will end with a space right before the null
>> terminator, which makes the period in the pr_info format hang out in
>> open space.
>>
>> My changes:
>>
>> 1) Only alloc priv if private_data_len is not 0
>> 2) Change priv to be space prepended instead of space postpended
>> 3) Change pr_info format to work with space prepended string
>> 4) Fix test in pr_info args
>=20
> Hello Doug,
>=20
> Thanks for stepping in and addressing this. But as far as I can see
> these changes have not yet been pushed out to the k.o/for-4.6 branch on=

> git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git ? I wil=
l
> have another look once your tree is publicly available.
>=20
> Bart.

It's in my srpt branch at the moment.  I haven't pulled the topic
branches into my k.o/for-4.6 branch yet (when I pushed it last night to
github it was to get 0day testing before committing it to my k.o branch
and pushing it to k.o).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--qq3JGBWgQJv09i3oLkfeuBmL9k56m0Jmv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxd/TAAoJELgmozMOVy/d4M0P/Rivdi2wMQIblo/7BAFR1Tt5
tPqTltgEeHPB6XJrk69Q9SZcuBWY25rKotau4JjASJfyA0dd2IVPkYC4yLakTgML
Ye2wMaBAMq3ErhZZNBAyVe6JELhFegW9mxR2QUAiq3hC3Ehc2m1HA+Vxz6irp479
Mx5+YPjXo5qvG5Dj4MCiup0WOfbP9fw4mtqQYjE6B4ucgbZOWyZF10nsLy2Ym28E
s76gpzQxdxdkcsiJzUdufW9EEN8IijWDydzNNcKg/xLZbR0105THPSVNiUSJLY9f
yC2a/DnCjMMPMYWG+6DAYSJ7jjWjba7ybUQ7fgGLd3NXKN62kKKy/RchBck+/lpR
3dEbvlJWDm+jlw0nvgwDl9GA27vo0/r1rM2aeNEQBc6uCqKe5YaqDgnS9Kwu+Fkt
C2kDEHO9/QpLM3ID+CZZCtJWtWZ+lEjAwYdPIBsDd/VpzOFvnexe/9uuVmE/O3CA
uRnGVaq9W7123J02+ub/wzcwYX7NBP3AFrvSZj5d7PzDTXHWN1DVh9mUGrXqiMfC
XaP0Nj4POjosDgGIaqkYRJ6tSvGY5Q1SNqi7l/jvJOK3Rfp3Ne5Hz699LyQJuNE7
UaNfrO2lZrjW89FMMJhTKpaaO0aDG3o2OckML/rrS/BUnqUUMFFBdYVmfPR+P7rd
Ubuhstplm30EGJjR9Ci3
=/7Kc
-----END PGP SIGNATURE-----

--qq3JGBWgQJv09i3oLkfeuBmL9k56m0Jmv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
