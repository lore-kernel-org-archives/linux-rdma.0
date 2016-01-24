From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sun, 24 Jan 2016 09:27:04 -0500
Message-ID: <56A4DF38.8010803@redhat.com>
References: <56A2727B.8040809@redhat.com>
 <CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
 <56A30910.9010002@redhat.com>
 <CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
 <56A3A777.3@redhat.com>
 <CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw@mail.gmail.com>
 <56A3FE6F.4000800@redhat.com>
 <CA+55aFz9Dnu7Ri8XA291VdSYZ5gqyt+cmaaRNULQ0hVetoAJZg@mail.gmail.com>
 <56A42829.90401@redhat.com>
 <CA+55aFy0OuZ+TOsNRkqyGbpJf1LvLAodO2DqUfpcrKsQHQWLxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xTof0v2cqiVCGwfl1FbxITVj2Ct3RnKu9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFy0OuZ+TOsNRkqyGbpJf1LvLAodO2DqUfpcrKsQHQWLxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xTof0v2cqiVCGwfl1FbxITVj2Ct3RnKu9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/23/2016 09:03 PM, Linus Torvalds wrote:
> On Sat, Jan 23, 2016 at 5:26 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 01/23/2016 07:38 PM, Linus Torvalds wrote:
>>>
>>> This kind of idiocy where one company has two different groups, and
>>> they are fighting over the same driver, and then expecting upstream t=
o
>>> sort out their mental problems for them is not acceptable. It's not
>>> the job of either me or the subsystem maintainers to sort out your
>>> differences for you.
>>
>> Can I get some specifics of what you are talking about here?  The reas=
on
>> I ask is that I know in this merge cycle there was a function modified=

>> in the mlx4 driver (I think, or maybe mlx5) where it was first modifie=
d
>> by a patch series that went through Dave's tree, then further modified=

>> by a series in my tree.
>=20

[ snip detailed explanation of horrible merge mess ]

Thanks, that makes absolute sense.  Digging your eyeballs out with a
rusty spoon seems preferable in this case.

> In other words, there are lots of different alternatives to improve on
> what's going on. But this "throw crap against the wall and hope it
> sticks" approach that the two groups are clearly using now is *not*
> acceptable.

Agreed.

> If this was the first time it happened, I'd just be annoyed. As it is,
> something similar happened not that long ago, witht he same people. At
> this point I'm past "pissed", and firmly in "if this happens again,
> I'll just stop pulling the crap" camp.

Mellanox has been working to get one official Mellanox git repo through
which all of their patch submissions flow.  I'll simply stop taking
anything from them that doesn't come from this (yet to be announced
where it will live) git repo.  They can then merge their disparate
efforts prior to ever submitting them upstream to either Dave or myself.
 That should address the merge issue.  It won't, however, address
consistency issues in coding style.  That's something Mellanox will need
to address internally.  I know they have tapped Saeed to handle that
merge tree, and he's on the Cc: list here, so Saeed, you will need to
get your tree up sooner rather than later and I'll expect patch
submissions to start coming from you.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--xTof0v2cqiVCGwfl1FbxITVj2Ct3RnKu9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWpN84AAoJELgmozMOVy/dawEP/39c/8VrB1K3KyDOfOZy+KtM
EYKwVerSreh7aVVJ1EyIUvuyk9KwCIfY2QsHIqs7IabizQvzaKP/v0k7Csk+NRaZ
lN9fs//Y7CnzqgKpQfZu0/ncmpVleG8HdiGuwdTFnyUwKffMKt+MDB7d0ptQ2O6l
ELL4vTMd//HkpM9lTuIA91Bf2K/aF3q5EGs7694evQHzo6gE/BSqJQQluKj/u+52
+vNo4MnLvYNLts7J+Zyhr144fMdgdZtKWOJC+VELVgqTcB9BcYUNbF48sTSTuPoM
sbMySUoVq9NEEoq1qhU8tG3rfjfkTpQ4CJcT4Eabt2t3oo3BX83rpshf1z0InK1h
ZJUIh+T5mib6+uAm9R0K+I9ersbgqGA+SB+K1fRKib9Tx92pCDaKtYJFW38935/P
3kSkmFZS4kwaVz9SkOfw5ceLQuWdUyNcJaBW+ngHoRnH74HSXkQt4OQxt1BrnVwo
KFRkOdKJy37mYkctjf9evT7jVbcJGHNuBGVu8WNpLydzuoVKt4TxjbB9YI/Lmfja
xofvHjdFLBCdV5Vbm6IK3CXMunOwj0uS9cGMVBGNlQ8YzPKlbz7MZwqIePv+jf1l
Z/O5zPq63z4+FtW3N8VxhODCHSPngKAexJ46lpPrR7PrVbqHIChazHocxA+5JwhA
PU0dfn3ltXaVkICKKwDA
=pgJb
-----END PGP SIGNATURE-----

--xTof0v2cqiVCGwfl1FbxITVj2Ct3RnKu9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
