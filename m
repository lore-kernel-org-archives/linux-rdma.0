From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/9] IB/ipoib: factor out ah flushing
Date: Sun, 15 Mar 2015 11:42:05 -0700
Message-ID: <3A0A417D-BFE4-475C-BAB3-C3FB1D313022@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com> <b06eb720c2f654f5ecdb72c66f4e89149d1c24ec.1424562072.git.dledford@redhat.com> <54EF1F67.4000001@dev.mellanox.co.il> <1424968046.2543.18.camel@redhat.com> <54F2B61C.9080308@dev.mellanox.co.il> <1425308967.2354.19.camel@redhat.com> <54F585E9.7070704@dev.mellanox.co.il> <CAJ3xEMgxxHu5BQdADaRe-Grtf4rm1LMfsCRiDyF6ToPdV_62OA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2074.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_95B64AB4-27C1-43B7-9DA1-E1501D824D52"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgxxHu5BQdADaRe-Grtf4rm1LMfsCRiDyF6ToPdV_62OA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_95B64AB4-27C1-43B7-9DA1-E1501D824D52
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Mar 13, 2015, at 1:39 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Tue, Mar 3, 2015 at 11:59 AM, Erez Shitrit =
<erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On 3/2/2015 5:09 PM, Doug Ledford wrote:
>>>=20
>>> On Sun, 2015-03-01 at 08:47 +0200, Erez Shitrit wrote:
>>>>=20
>>>> On 2/26/2015 6:27 PM, Doug Ledford wrote:
>>>>>>>=20
>>>>>>> @@ -1037,6 +1038,7 @@ static void __ipoib_ib_dev_flush(struct
>>>>>>> ipoib_dev_priv *priv,
>>>>>>>        if (level =3D=3D IPOIB_FLUSH_LIGHT) {
>>>>>>>                ipoib_mark_paths_invalid(dev);
>>>>>>>                ipoib_mcast_dev_flush(dev);
>>>>>>> +               ipoib_flush_ah(dev, 0);
>>>>>>=20
>>>>>> Why do you need to call the flush function here?
>>>>>=20
>>>>> To remove all of the ah's that were reduced to a 0 refcount by the
>>>>> previous two functions prior to restarting operations.  When we =
remove
>>>>> an ah, it calls ib_destroy_ah which calls all the way down into =
the low
>>>>> level driver.  This was to make sure that old, stale data was =
removed
>>>>> all the way down to the card level before we started new queries =
for
>>>>> paths and ahs.
>>>>=20
>>>> Yes. but it is not needed.
>>>=20
>>> That depends on the card.  For the modern cards (mlx4, mlx5, qib), =
it
>>> isn't needed but doesn't hurt either.  For older cards (in =
particular,
>>> mthca), the driver actually frees up card resources at the time of =
the
>>> call.
>>=20
>>=20
>> Can you please elaborate more here, I took a look in the mthca and =
didn't
>> see that.
>> anyway, what i don't understand is why you need to do that now, the =
ah is
>> already in the dead_ah_list so, in at the most 1 sec will be cleared =
and if
>> the driver goes down your other hunk fixed that.
>=20
> Doug, ten days and no response from you... lets finalize the review on
> this series so we have it safely done for 4.1 -- on top of it Erez
> prepares a set of IPoIB fixes from our internal tree and we want that
> for 4.1 too. Please address.

I didn=E2=80=99t have much to say here.  I said that mthca can have card =
resources freed by this call, which is backed up by this code in =
mthca_ah.c

int mthca_destroy_ah(struct mthca_dev *dev, struct mthca_ah *ah)
{
        switch (ah->type) {
        case MTHCA_AH_ON_HCA:
                mthca_free(&dev->av_table.alloc,
                           (ah->avdma - dev->av_table.ddr_av_base) /
                           MTHCA_AV_SIZE);
                break;


I=E2=80=99m not entirely sure how Erez missed that, but it=E2=80=99s =
there and it=E2=80=99s what gets called when we destroy an ah (depending =
on the card of course).  So, that represents one case where freeing the =
resources in a non-lazy fashion has a direct benefit.  And there is no =
cited drawback to freeing the resources in a non-lazy fashion on a net =
event, so I don=E2=80=99t see what there is to discuss further on the =
issue.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_95B64AB4-27C1-43B7-9DA1-E1501D824D52
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVBdJ9AAoJELgmozMOVy/dgA8QAKWUNPiMjQ+vPDFIBeGJWgtQ
jrPOuI9IVJsepbBTPyEoK3TvvW1D84e8TzVWQbxe1vK5rreZ+tz5BkS7q1WcDZCe
LatPKz+Yg5od9GLONpFo/4PLF5OafAQCHIFnxYULFiCxckFNE6yFXo1BJIgnJRrH
FBIYiJQYsnQarPU75z6CiGKQiiPAKdXyOAFq0ot8k9xdj7uT2e+hrGSjXZfpNhA1
6bBjoOFEmvrC5fKkb/DRB0rzjVz8elHrQ0uo3wyLC/+8v1BgRxAON4lqgUJSmr5P
fX1F8JFuqYFdUbT+gtjcrTvePvO8p7TB2XvTFce5T76kxzOvNj7VpTgKy00mReOP
O4FChvIVjQllb5Ykkwvri277b0tYlAVdaue/BFXUuV1zt+LqqOiZsM95fFlDZaQi
DI2mV73x3knqOIKpW072pFDdo1OXCBiOJTgU2OAtDr6I5etEzfth9PS/jgQaEP24
Uf4GMoM00ZwWYK4GRkiorp10RmdHfmfsT6HOvIb8PUAM+f0TP3JANB22RNZblMxD
IbxPAwoH0Q5GwPGkeqkGTHPfiFONFIt83rGQ540qKwmmheBi4PvNk0WrBUOiQAkP
XHlG0EgRUNV2iAbI21syUX5L/Fr+Tc4BaohK4emInsp40OksSG7KNxmyS/0DZDiw
PrGYHDhZCxrC2QGCj3xk
=eFjR
-----END PGP SIGNATURE-----

--Apple-Mail=_95B64AB4-27C1-43B7-9DA1-E1501D824D52--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
