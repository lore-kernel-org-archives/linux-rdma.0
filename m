From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Prepared RDMA Tree for 4.7
Date: Sat, 14 May 2016 09:09:54 -0400
Message-ID: <f9210e1d-667d-5f62-f1bd-7545a0ff6153@redhat.com>
References: <20160512174406.GB11827@leon.nu>
 <9dbc023f-e442-843a-ab68-eec38ca1d6b7@redhat.com>
 <20160513042217.GD11827@leon.nu>
 <9e5233c8-6641-7f6b-3825-1b67eb70c05b@redhat.com>
 <20160514043353.GG11827@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LCm30JDab4rNt6Rcc201oHqa0K0lLx6IQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160514043353.GG11827-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LCm30JDab4rNt6Rcc201oHqa0K0lLx6IQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/14/2016 12:33 AM, Leon Romanovsky wrote:
> On Fri, May 13, 2016 at 12:31:55PM -0400, Doug Ledford wrote:
>=20
> <snip>
>=20
> I had an intent to help you,

That's fine.  As I pointed out in my email, I need to know what I'm
sending to Linus.

> So can you please share with us your plans on how-to address the
> general lack of "communication, transparency and coordination",
> which is definitely happen here?

I could always just artificially limit each release to no more than 100
patches or something like that.  Then I would have more time per patch
to be communicative.  But that wouldn't make people happy, it would take
months and years to get things done.

But you guys are only partially mad at me.  I'm not the sole
person/group holding you up from getting your way.  For example the LSO
patches aren't in, and that because they are an API extension that not
everyone understands what LSO in that context means.  The patch set
needs more explanation so that others can actually say if it's generic
enough to meet their needs.  You guys have a ton of features you want to
get into the kernel, each one being a different sort of hardware
offload, and while you may have worked with customers to do the initial
creation, you didn't work with the community on describing them or
anything else, and you bring them here fully done to your satisfaction,
and it takes other people time to wrap their head around what they are,
whether or not they might be usable in their own hardware, and then to
decide if the design as presented would work for them if they did decide
to implement it.  Without their input, I'm left in a rather untenable
position.  And frankly, I'm rather sick of being in that position.

I'm quickly coming to agree with the results of the collaboration summit
in that if a patch set implements a new feature in the form of a user
visible API change (aka, a new flag to create_qp or a change to user
visible work completions, that sort of thing), then patches will need
buy in from other vendors before I'll accept them (where buy in means
they've read it, they've understood it, and they've publicly given their
Acked-by: line....silence does not equal buy in!).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--LCm30JDab4rNt6Rcc201oHqa0K0lLx6IQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNyOiAAoJELgmozMOVy/dm3wQAKPlH+Mi7pMjsmxmrDOMUlIl
xBqqEaWRdGEj3lrB6bIb/9JOvlMTpSSihVND2xj+he0DqSvezKTUSOJ72v6EQXC5
kUz5RKJKoYljdJ5tFN42x3Y132Gaygyw+1qVB0V0s4gYgyu1qoRRvR1CfFXfnv3u
GkXChmsLjTs8qZ96WcqGmjdmHMMO9C2X3gpBd4lOQOdoVRbWJB+Di6xquST+4lUw
AeZWuPzV6eTwwo3GRb8OL3grw54UrJAboisyA/2dHAEpDCEfBEoe/Q31rMfwxbX7
eVr9vlOsIlU5nscFpHsuPiUkLmg+52rgTnx71D1HPwlXcPI6ZFWuBcWXTuLvzWuk
EiAB2Wn3eG3UGRrugevW5vSmNtlG902EWtncE/50hNhUt3HFBk/a6v/uLd3huzq5
6u/AjSYUtSY5ww1pgM0IQ2CiGLYk5LkXGY6//UZfEs+OvWJjPI8w/Myj4QTXf6p7
CUZjI/IKecrcIIDTYxKV6lgfZECYpAMMJs75Cie70bi14z2qBeDsFtEljvUPrnYl
ciYtZCtUSj7jbHiAJEs5NUxWtV1ukX0at+ywx9UIrG1Hu/qO8Yxi+L4gaKqIysuC
w88FjYM/S7KJkkimGmscVHrC33zkH5creUez2gv/+JfnJQYAj9JqU0RaKdMTpBo8
8WoDDXqDyZoaZfWS9j6t
=G6Vy
-----END PGP SIGNATURE-----

--LCm30JDab4rNt6Rcc201oHqa0K0lLx6IQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
