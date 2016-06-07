From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
Date: Tue, 7 Jun 2016 10:50:54 -0400
Message-ID: <99eb8d42-95f2-6899-b427-b6258db5e44b@redhat.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-3-git-send-email-leon@kernel.org>
 <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A@mail.gmail.com>
 <42668994-5666-f5b3-8d38-4c452f0cc70f@redhat.com>
 <CAAk-MO9gUtqZHKq+7xaHLkJRM_T-DgF0wOCFuykre9=0VUBbQw@mail.gmail.com>
 <27852e30-765c-012a-b54b-f5ba096121d4@redhat.com>
 <CAAk-MO-wPkMtyCsCBEo5yKktKitsh4EQG2m=naenSuzc+EjoSg@mail.gmail.com>
 <5fc6bf69-ff7e-d94f-fbfe-46a42ee1e22d@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WBgc7e2kgmG5JbaUJ8eg0XfdtOEb0IuXH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5fc6bf69-ff7e-d94f-fbfe-46a42ee1e22d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WBgc7e2kgmG5JbaUJ8eg0XfdtOEb0IuXH
Content-Type: multipart/mixed; boundary="2TtRXVM10IirbpoHIsAmQneOIigjwGukr"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <99eb8d42-95f2-6899-b427-b6258db5e44b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
References: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1465042524-25852-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <42668994-5666-f5b3-8d38-4c452f0cc70f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CAAk-MO9gUtqZHKq+7xaHLkJRM_T-DgF0wOCFuykre9=0VUBbQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <27852e30-765c-012a-b54b-f5ba096121d4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CAAk-MO-wPkMtyCsCBEo5yKktKitsh4EQG2m=naenSuzc+EjoSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <5fc6bf69-ff7e-d94f-fbfe-46a42ee1e22d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <5fc6bf69-ff7e-d94f-fbfe-46a42ee1e22d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--2TtRXVM10IirbpoHIsAmQneOIigjwGukr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/7/2016 10:43 AM, Doug Ledford wrote:
> On 6/7/2016 10:32 AM, Erez Shitrit wrote:
>> On Tue, Jun 7, 2016 at 4:48 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>>> On 6/7/2016 2:01 AM, Erez Shitrit wrote:
>>>> On Tue, Jun 7, 2016 at 2:59 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>>>>> On 6/5/2016 5:10 PM, Or Gerlitz wrote:
>>>>>
>>>>>>> -                       neigh->alive =3D jiffies;
>>>>>>> +
>>>>>>> +                       if (likely(skb_queue_len(&neigh->queue) <=
 IPOIB_MAX_PATH_REC_QUEUE))
>>>>>>> +                               neigh->alive =3D jiffies;
>>>>>>
>>>>>> why testing the queue len makes things right?
>>>>>
>>>>> I'm with Or on this one.  This test doesn't make sense unless you a=
ssume
>>>>> that the neighbor is being hit with a steady stream of packets.  If=

>>>>> someone just runs ping -c 1 to a dead neighbor, this test will fail=
=2E
>>>>> The idea of the patch is OK, but the test needs to be reworked for
>>>>> situations other than a blasting stream of data.
>>>>>
>>>>
>>>> I will try to explain the idea behind that test, and why it works (I=

>>>> hope I'll make it clear this time :))
>>>>
>>>> there are 2 objects that are taking place here, the garbage-collecto=
r
>>>> that removes neigh if was not used for defined time, and the
>>>> path-query for each neigh.
>>>> if the path-query failed the packets for specific neigh are kept in
>>>> the neigh queue, but only if there are no more than
>>>> IPOIB_MAX_PATH_REC_QUEUE, and the neigh is still kept for ever (let'=
s
>>>> assume CM connected that was stopped without any notification with
>>>> DREQ etc.)
>>>> The only way to know that there is an unresolved neigh is by checkin=
g
>>>> its queue, if it is full we can assume that this is an unresolved
>>>> neigh otherwise it is resolved.
>>>
>>> That's not true.  Reread what I wrote above (I was specific when I
>>> picked that command).  Ping -c 1 will only send one ping.  It will no=
t
>>> trip this test.  As I said, your test relies on a stream of packets, =
a
>>> single packet to a gone neighbor will never cause it to get deleted.
>>
>> If you ping one time (ping -c 1) there is no problem at all, the neigh=

>> will be deleted by the GC anyway, because no (unresolved) packet
>> updates the neigh validity and the GC will check the last time it was
>> refreshed and since only one ping refreshed it long ago, it will be
>> deleted. (the GC always running)
>>
>> the problem is when there are non stop traffic to that neigh. IMHO
>> that test works for that.
>=20
> Ok, that makes sense.

Sorry, in case it wasn't clear, I grabbed this patch now (although I
reworded the commit message significantly).



--2TtRXVM10IirbpoHIsAmQneOIigjwGukr--

--WBgc7e2kgmG5JbaUJ8eg0XfdtOEb0IuXH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVt9OAAoJELgmozMOVy/dZ9sQAKHZErZmfK+4lTevXOmf5Xy1
md1fYEuxbA1hvCLoixDwDw96x0EZ4Il9/MtM19CD85jfc4zBhMHQL3jDg4Ju1vX4
2bNyJc8zZr7ljMx6IPN4iOaxkKu11LqW3TDzmIoqQdVsHeHzj/jlUbfjj/aTPy+H
aJagV36ElaytxTIokK+ZA9iHk+ZOGleK6ierjF0XQ/KrnSDqhX4P6Zckng9MF7bs
14SLlHUZ+BRtvRZl+rzAAN1AKxJTqYbLaCOqavRvxilY1bhkk3kolRORG7PdPEMN
rm0Ygk3lpphHzqUBVEqynwFCodONFgJ/+abplO3inpWjmnIN2enfYOWugDS56jII
HycX8SZ+3qbZ452vHRd3KfTTP+Y5xUH8fbRW6H0992vcnbXV3NyFYGPCfjigpkPC
vXTng649f+ZATbXD714BbSHNgK0Eq4tPdVxtq5MIQstDVD8i/Ecl1eBP7D5jHQ0E
UI+CihM12i7jqqEHTjq3SHx5fmzAJSCiCs2IOcx8FuR3kFpaOX6mu4ZTO/P2ip6M
mT8pteO8TRhku+JkLSEhrPzC38hIjZQ2QnyQXC6hJHQ+Y93KGfGQCuQ3fzypLY1Z
TO9m2jOhEJogTt+h+lc5h8kUa9Lbapw8ozh3fIxLLrWqzE5SLxF4HzqUMy+sAPFO
DW4KWHfDpebG1x0MpZsy
=cEl6
-----END PGP SIGNATURE-----

--WBgc7e2kgmG5JbaUJ8eg0XfdtOEb0IuXH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
