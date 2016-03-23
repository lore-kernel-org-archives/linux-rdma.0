From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Tue, 22 Mar 2016 21:46:33 -0400
Message-ID: <56F1F579.3080403@redhat.com>
References: <56F1B00F.7010406@redhat.com>
 <CAJ3xEMhG0x_+DAAY+Cv0OAnW=2VmMuHZUv8DOP_YCkNHfSjX9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="V3WeU7eJngVDBJVqlodxjmsQ4OxIAwrh6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhG0x_+DAAY+Cv0OAnW=2VmMuHZUv8DOP_YCkNHfSjX9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--V3WeU7eJngVDBJVqlodxjmsQ4OxIAwrh6
Content-Type: multipart/mixed; boundary="6EttlNv6B4Q637KEnDEmo1KAmV9am8HX5"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <56F1F579.3080403-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
References: <56F1B00F.7010406-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CAJ3xEMhG0x_+DAAY+Cv0OAnW=2VmMuHZUv8DOP_YCkNHfSjX9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAJ3xEMhG0x_+DAAY+Cv0OAnW=2VmMuHZUv8DOP_YCkNHfSjX9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--6EttlNv6B4Q637KEnDEmo1KAmV9am8HX5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 3/22/2016 6:23 PM, Or Gerlitz wrote:
> On Tue, Mar 22, 2016 at 10:50 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> This is a monster pull request.  I held off on the hfi1 driver updates=

>> (the hfi1 driver is intimately tied to the qib driver and the new rdma=
vt
>> software library that was created to help both of them) in my first pu=
ll
>> request.  The hfi1/qib/rdmavt update is probably 90% of this pull
>> request.  The hfi1 driver is being left in staging so that it can be
>> fixed up in regards to the API that Al and yourself didn't like.
> [...]
>> Round two of 4.6 merge window patches
> [...]
>> - A huge set of updates to the Intel hfi1 driver.  Of particular inter=
est
>>   here is that we have left the driver in staging since it still has a=
n
>>   API that people object to.  Intel is working on a fix, but getting
>>   these patches in now helps keep me sane as the upstream and Intel's
>>   trees were over 300 patches apart.
>=20
>> Mitko Haralanov (41):
> [...]
>>       IB/hfi1: Re-factor MMU notification code
>>       IB/hfi1: Allow MMU function execution in IRQ context
>>       IB/hfi1: Prevent NULL pointer dereference
>>       IB/hfi1: Allow remove MMU callbacks to free nodes
>>       IB/hfi1: Remove the use of add/remove RB function pointers
>>       IB/hfi1: Notify remove MMU/RB callback of calling context
>>       IB/hfi1: Use interval RB trees
>>       IB/hfi1: Add MMU tracing
>>       IB/hfi1: Remove compare callback
>>       IB/hfi1: Add filter callback
>>       IB/hfi1: Adjust last address values for intervals
>>       IB/hfi1: Implement SDMA-side buffer caching
>>       IB/hfi1: Add pin query function
>>       IB/hfi1: Specify mm when releasing pages
>>       IB/hfi1: Switch to using the pin query function
>>       IB/hfi1: Add SDMA cache eviction algorithm
>=20
> Doug, this series is under review and a reviewer (me...) have posted
> comments claiming that such pin down cache doesn't belong to kernel
> but rather to be part of a user-space library [1]
>=20
> This comment still hold even though the cache is serving a proprietary
> (non verbs) user-space code b/c it claims that code X doesn't belong
> to the kernel and we need not load into the kernel what doesn't belong
> there.
>=20
> Could you please comment why not let the discussion converge and/or
> hear your maintainer opinion on the matter before this is pushed up to
> Linus?
>=20
> Or.
>=20
> [1] http://marc.info/?t=3D145746462200001&r=3D1&w=3D2
>=20

You made your arguments, which I thought were nebulous in the first
place ("does not belong in the kernel" is not a well defined objection,
it's like saying "I don't like that", you would need a more concise
objection to carry stronger weight).  Their response to your argument
was that putting it in the kernel saves multiple context switches per
memory region in the cache.  This was a sufficient answer IMO (context
switches are expensive and on 100GBit hardware, multiple context
switches that aren't needed is positively huge).


--6EttlNv6B4Q637KEnDEmo1KAmV9am8HX5--

--V3WeU7eJngVDBJVqlodxjmsQ4OxIAwrh6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW8fV5AAoJELgmozMOVy/dkRoP/RSmKt78JSbglILg8ojdemKQ
xelTJYNgS3RmpbSmu8CHzJgAFOWArD3QypiFfRmTT17TLVR6CRMEL7efM5OlfTfQ
MgM4mNlPKGOEVXKdmy1vbdJgokwfmxy9uRQcFNnv89u29veQ9bn9/NDwJtXaxTTo
RJ6bisyh+imSyAO6rVThcGV0brh8VYB+TQhrtF07MVA74gkvzGoP5Q14T79TaZP/
Hkpa6Cuw7zb7AmAnxOfQTjgwGEIQhwpTQ8Oj4bj1N+oH6wSMg9NTLy58mbqOlTkS
2W+mUVu7smdxL2okvjw4n+XQA+yuYq/JuXCrnfMwjKz0XpdrmyFudAoRUZfxeLa5
QhHgcC8ISrb8iCStM72aR7okFrFJiPJEncbCAGcVJkA7j9ybvwIAJCn6GCVvP2Vi
1s5a8Fuxb69HHPmrt4kcYyTL4QkTU7mhT6h9KGMo16amfVZ69Bj4TmB588MsxmkM
D3BVP1SghQVrevuhJsSyxFEYFiVSTftBu991+pwvQEa68SIkpNAhh2KvefDTRahV
hHjKWa+bAhTQNyxaxXcfGlNfXShrMh/mv1Trw2CKTVFDtQ6RranHojnPpYVbr0gD
8f1MMFZprE+Evi1gDlV3Z6tGXNWtxKXWY5KTj8+XljVhUPKUvBeMHBe64qO0Vrwh
PbiHZSkkdHRqEkOHdWn4
=qUIk
-----END PGP SIGNATURE-----

--V3WeU7eJngVDBJVqlodxjmsQ4OxIAwrh6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
