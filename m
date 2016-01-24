From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 20:26:01 -0500
Message-ID: <56A42829.90401@redhat.com>
References: <56A2727B.8040809@redhat.com>
 <CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
 <56A30910.9010002@redhat.com>
 <CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
 <56A3A777.3@redhat.com>
 <CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw@mail.gmail.com>
 <56A3FE6F.4000800@redhat.com>
 <CA+55aFz9Dnu7Ri8XA291VdSYZ5gqyt+cmaaRNULQ0hVetoAJZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rlGeMvAtSck4cJrHQFP1lFwPfq7Iikp7P"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFz9Dnu7Ri8XA291VdSYZ5gqyt+cmaaRNULQ0hVetoAJZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rlGeMvAtSck4cJrHQFP1lFwPfq7Iikp7P
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/23/2016 07:38 PM, Linus Torvalds wrote:
> On Sat, Jan 23, 2016 at 2:27 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>>>
>>> So how ready and stable is this? IOW, if I do this pull, can I rely o=
n
>>> that being "it", and really just get fixes.
>>
>> I still want to send the staging changes.
>=20
> I'm not at all convinced I will pull them.
>=20
> And I'm now looking at pulling the stuff you sent yesterday, and I'm
> close to just saying "screw this". Again.
>=20
> This is now the *second* time that two different teams inside Mellanox
> decided to play games with the kernel maintainers, and I'm not at all
> sure the end result is not worth my time to sort out.

Understood.

> Doug, you need to stop taking patches from the Mellanox people until
> the get their shit together.  Really. I'll spend some time looking at
> this mess, but next time I see two Mellanox groups fighting inside
> their own driver, I will just not pull. It's that simple. If you take
> shit from them, I'll not take the end result.
>=20
> I don't know what problem the Mellanox people have, but one group
> sends their changes through the networking tree, and another group
> sends it through you. They do similar things, but different enough to
> not be the same.
>=20
> You tell them to stop sending that stuff to you, because I'm getting
> it through Davem. And I'm not interested in cleaning up after their
> mess.
>=20
> Adding David and Mellanox people to the cc.
>=20
> This kind of idiocy where one company has two different groups, and
> they are fighting over the same driver, and then expecting upstream to
> sort out their mental problems for them is not acceptable. It's not
> the job of either me or the subsystem maintainers to sort out your
> differences for you.

Can I get some specifics of what you are talking about here?  The reason
I ask is that I know in this merge cycle there was a function modified
in the mlx4 driver (I think, or maybe mlx5) where it was first modified
by a patch series that went through Dave's tree, then further modified
by a series in my tree.  In both cases, the modification was part of a
larger series that was specific either to the network tree or the rdma
tree.  If that's the sort of thing you are talking about, I'm not sure
how we can resolve that.  The fact that the mlx4_core and mlx5_core
modules essentially straddle the networking and rdma trees presents a
unique situation with its own difficulties.  If the problem I listed is
what you are referring to, the only way I know to fix that is to have
Mellanox send all of their patches through one tree, and that means
either Dave or myself is going to have to deal with stuff they wouldn't
normally deal with.  Of course, if I'm wrong about what you are
referring to, then enlightenment would be appreciated ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rlGeMvAtSck4cJrHQFP1lFwPfq7Iikp7P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWpCgpAAoJELgmozMOVy/d27MP/2NG3JbFEInUhUUpHPyxTUvl
RTAnn3BqiRnB3yvK+qVAHol3EAo8w0//mxpbtdPrLvNyqJOCTDaaJ+E7aOdOFn3b
qB7y1xyGha19zaMifp91DClderOxXzg1uARUX9i2DxaAt92M7GoMHOCXm+G9pkaU
wHISRIiR/GaqDbtC9jUUNtBcyaVtTwTwB2i2NGrKRahESugl/DS65Q2DVgmCiK6A
Xblrm4M1bH9T9fcVVbPcHzzgJiRArBOqS+T7FMjqm6n8Vn74htRkgIpX6uAXsfjZ
xw2kA/N3KpRFhxh+QAwZMdDmEBnFmKdGWeZFGcn5ivjMwe33I2PD/jSrti0lKpMc
g6ZTPaLwWjKvLmT4Sr6j9ihCmujVjBV30EeK9Axxst/VD49wiM+qnJzoiheK2DNh
i/d8/mvjEAgC8hbHvzarZMLwUkZ68B8w+Yguu1WfNGsFJOPPifJYDI3AFOT+JVHq
ZVp7RmcJxO9HgTr68eDiQQPDxmYlGAi7EVmRN4ihMFi3wqnFaON4W/Oy52GTi8KW
gXyyBEzwKZhhGWNDGHgCU6qVjBjpT8Vn1Q15LxglWVnCrUDSBZMSNoyYadnFtrzR
MUencfHyaPUtYGy01NanPDM7Wd+qiDFbNNHEkFmiZ95oYMtMnZZoze5wPFDcyB+l
7AyThWekvW9TEo3BG90t
=3U8/
-----END PGP SIGNATURE-----

--rlGeMvAtSck4cJrHQFP1lFwPfq7Iikp7P--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
