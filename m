From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 23 Mar 2016 09:37:54 -0400
Message-ID: <56F29C32.305@redhat.com>
References: <56EAE9D6.2030908@redhat.com>
 <CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg@mail.gmail.com>
 <20160318173748.GL25216@leon.nu>
 <CA+55aFwNcyywn3gYQ=H_+6WMt=s+xZ5bgpX3O9z8b2o5EhDMGQ@mail.gmail.com>
 <20160323105708.GP25216@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bODJGxpSoxiOLQloo9uPRr8xeWiGPgrpE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160323105708.GP25216-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bODJGxpSoxiOLQloo9uPRr8xeWiGPgrpE
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/23/2016 06:57 AM, Leon Romanovsky wrote:
> On Sat, Mar 19, 2016 at 02:37:08PM -0700, Linus Torvalds wrote:
>> So the *best* situation would be:
>>
>>  - your two groups talk it over, and figure out what the common commit=
s are
>>
>>  - you put those common commits as a "base" branch in git
>>
>>  - you ask the two upper-level maintainers to both pull that base bran=
ch
>>
>>  - you then make sure that you send the later patches (whether as
>> emailed patches or as pull requests) based on top of that base branch.=

>=20
> Hi David and Doug,
>=20
> Are you OK with the approach suggested by Linus?
> We are eager to know it, so we will adopt it as soon
> as possible in our development flow.
>=20
> The original thread [1].
>=20
> [1] http://thread.gmane.org/gmane.linux.drivers.rdma/34907
>=20
> Thanks.
>=20

I'm fine with it.  Since I happen to use topic branches to build my
for-next from anyway, I might need to be the one that Dave pulls from
versus the other way around.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--bODJGxpSoxiOLQloo9uPRr8xeWiGPgrpE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW8pwyAAoJELgmozMOVy/dzuMP/iP4x9ndYnn6cuuDWtP9CBA5
fW9EA1aKfxOY/wUHT3s3iJJqHi7ypWiEwQvqn7KQ3boUX/zD6s3BWxJ1Wz+JF202
QaRqicrg7FHb6/9YBLR8ZcOe2q+5tGnMwGOdhSzAjOHiD3EJBD5OKvPqSEfLh3Sa
Iqd0gsBZW72hs6SQ8Qcmi6ORuWYj1Bsnjx/78bnODJzFr+5vcEQychsI33vdrFLp
FP3q0pALZ0dranTMKHTZRydfWjYZOInZ45zytOEvLj5P82jCkEzqDL/yzRjLQNMe
i/PhY2m1xCNaXtvnO/ZZIa2sV0YaFVTG4txiOf522l/Ok3seZj/utSTtOA8RgTQF
/N3VIDcpxmKB/IN81w6C4zvATm5C+YSWdyAxs3AUIeXnc/fwJCveyuowyWMKj+Cx
yC6n8d0Ce949ujylzJQG6++Yaw5q4/aXyuq8bai0tWLDVKSbT8L3mcYqnEp0WfZK
9BJXsiFKkJ+5rwwRqV02F483PFongyVMILiPt/NgqJZu+HkfRXT8WCvUGL5aRbQ3
jYJM+/aPAgau1roK4TTZByRQjMgyKwudo9LLDRSnGGIaFBHWLfyXx3qEh2u4b7yh
UiNc4GfeQ9nWl47stvDlJyL9KhEuhLqbV2yJBzbWGLPpDBVESoaBXhCNAWJ8VRDw
7ZQADegpb9twEFZz/zw0
=D9hw
-----END PGP SIGNATURE-----

--bODJGxpSoxiOLQloo9uPRr8xeWiGPgrpE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
