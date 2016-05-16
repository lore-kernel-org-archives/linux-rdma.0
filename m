From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Prepared RDMA Tree for 4.7
Date: Mon, 16 May 2016 16:15:45 -0400
Message-ID: <04c7b983-66b4-0609-9cf4-3c7b1e126a53@redhat.com>
References: <20160512174406.GB11827@leon.nu>
 <9dbc023f-e442-843a-ab68-eec38ca1d6b7@redhat.com>
 <20160513042217.GD11827@leon.nu>
 <9e5233c8-6641-7f6b-3825-1b67eb70c05b@redhat.com>
 <20160514043353.GG11827@leon.nu>
 <f9210e1d-667d-5f62-f1bd-7545a0ff6153@redhat.com>
 <20160515060005.GH11827@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bN9KD1wutCMEht4cpfwiC50V6OWVcciFa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160515060005.GH11827-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bN9KD1wutCMEht4cpfwiC50V6OWVcciFa
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/15/2016 02:00 AM, Leon Romanovsky wrote:
> On Sat, May 14, 2016 at 09:09:54AM -0400, Doug Ledford wrote:
>> On 05/14/2016 12:33 AM, Leon Romanovsky wrote:
>>> On Fri, May 13, 2016 at 12:31:55PM -0400, Doug Ledford wrote:
>>>
>>> <snip>
>>>
>>> I had an intent to help you,
>>
>> That's fine.  As I pointed out in my email, I need to know what I'm
>> sending to Linus.
>>
>>> So can you please share with us your plans on how-to address the
>>> general lack of "communication, transparency and coordination",
>>> which is definitely happen here?
>>
>> I could always just artificially limit each release to no more than 10=
0
>> patches or something like that.  Then I would have more time per patch=

>> to be communicative.  But that wouldn't make people happy, it would ta=
ke
>> months and years to get things done.
>=20
> Most of the patches are fixes and a lot of them one line only. They can=

> be acknowledged and applied in more timely manner. This will definitely=

> remove the tension.
>=20
> For example, I have a build warning fix for hfi1 driver, but I prefer
> don't send it till I see their fixes are applied.

I don't know what you are talking about.  All of their approved fixes
*have* been applied, and commented as such on list.

>> You guys have a ton of features you want to
>> get into the kernel, each one being a different sort of hardware
>> offload, and while you may have worked with customers to do the initia=
l
>> creation, you didn't work with the community on describing them or
>> anything else, and you bring them here fully done to your satisfaction=
,
>> and it takes other people time to wrap their head around what they are=
,
>> whether or not they might be usable in their own hardware, and then to=

>> decide if the design as presented would work for them if they did deci=
de
>> to implement it.  Without their input, I'm left in a rather untenable
>> position.  And frankly, I'm rather sick of being in that position.
>=20
> What is wrong with SELinux patches?

They need time for people to think about them.  You call them the
SELinux patches, but that is somewhat misleading.  When I think of
SELinux, I think of things like limited context server applications
("Can httpd read home directories?", "Can dovecot write to home
direcories?  Can dovecot listen on port 993? 995?", etc.)  It's very
general purpose and has a lot of policy that goes with it.  From what I
read, these patches are different.  They are mainly used to enforce the
subnet manager's P_Key policy.  There isn't anything else they do.  From
that standpoint, they look like the user space half of the namespace
equation.  But they're devoid of any of the other policy decisions that
SELinux often makes.  I haven't read them closes enough to see if they
could be easily extended to implement any of these other types of policy
or not, but that's certainly an issue.  If you are going to go monkeying
around in the SELinux subsystem (and 7 of the 12 patches do), then
making sure we do things in a manner that is not going to paint us into
a corner seems appropriate.  I haven't had the time to do that level of
looking at these patches.

> There are three issues with this request:
> 1. It is not silence, but readiness to merge, since all feedback is
> answered and everything is understandable. LSO patches are great
> example for it, if the people don't understand they will ask and will
> request to adjust patches accordingly.

No, you don't merge things before they are understood and then adjust
them.  You merge things you already understand.

> 2. It will limit ability to move IB stack further and will eliminate
> fair competitive market.

Competition is not a valid reason to merge poorly understood or poorly
designed code.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--bN9KD1wutCMEht4cpfwiC50V6OWVcciFa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOipxAAoJELgmozMOVy/d4VMP/3lA8184XdXgiiFWMgmBnjrq
c7s07HsaSty3mUYq4/FvYwW+XuaCAfdBzSDnSCgGaoeVN7d8I+pOx1+05KYhWWR+
4p4Mwj03p4LVIZJ8Vb+kQwWfzuIsdIVW7FlLdZl5ZEuOdflLR3pyjjJ+OVgD12kz
oNbc2DXGwRV3lDcmT8fEAR2gOd68A+17q7u5f8Q+t2Jk+Je/9sSFiMt4z5FNOcji
eOOiYzP94kLQ4ptY40spr+TVFoF31PrWH2aWOS72raH4h7FEwbkU/kmYoPOVuvNx
hhizb2bGYXM9W9C7+4M6b8rrTz07ouBwSJIzNldRN7WMMZ7rd3vyv9kE6x7A3/rd
Db8kxrWdcKk65fcRUFz95s4VHYLuyR2WCOOWUPSPU9w7SlzeyYQiPtxSVzXvPsFQ
G1XYdW5nOzcDt/Qrs9VszgtwFdpwugEjVCW/vpp4bKGelDkeGA9sjC+KWt2pbbP6
Gx0zy87erQ4/9M4UAOieNjSCUB0wH55B6EbKiijmdOHuQuwefgR5urouUmKIdF7c
/vMwoNBF7mk8d/kM1XqqRKj0UonlcxrEgvnChz0N/PAbb8AQZEuXnSgSqpEB9Gmp
Fi+Myghb0VjyOJ/fdGcbF0d7VDltYy1R9X4ChhSZyO6rKtVH5TdTd/2CSNKXqpsn
TKd2O7+dBf3zBASZInpf
=Mgkz
-----END PGP SIGNATURE-----

--bN9KD1wutCMEht4cpfwiC50V6OWVcciFa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
