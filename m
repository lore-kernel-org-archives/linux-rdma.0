From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
Date: Tue, 7 Jun 2016 10:43:56 -0400
Message-ID: <5fc6bf69-ff7e-d94f-fbfe-46a42ee1e22d@redhat.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-3-git-send-email-leon@kernel.org>
 <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A@mail.gmail.com>
 <42668994-5666-f5b3-8d38-4c452f0cc70f@redhat.com>
 <CAAk-MO9gUtqZHKq+7xaHLkJRM_T-DgF0wOCFuykre9=0VUBbQw@mail.gmail.com>
 <27852e30-765c-012a-b54b-f5ba096121d4@redhat.com>
 <CAAk-MO-wPkMtyCsCBEo5yKktKitsh4EQG2m=naenSuzc+EjoSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="woPRkvaQnqxT4VX91fLvsasReLEtaLnLk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO-wPkMtyCsCBEo5yKktKitsh4EQG2m=naenSuzc+EjoSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--woPRkvaQnqxT4VX91fLvsasReLEtaLnLk
Content-Type: multipart/mixed; boundary="9ErkkjSG6BfvM2U5mkcKeC8Fims70SpLu"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <5fc6bf69-ff7e-d94f-fbfe-46a42ee1e22d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
References: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1465042524-25852-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <42668994-5666-f5b3-8d38-4c452f0cc70f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CAAk-MO9gUtqZHKq+7xaHLkJRM_T-DgF0wOCFuykre9=0VUBbQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <27852e30-765c-012a-b54b-f5ba096121d4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CAAk-MO-wPkMtyCsCBEo5yKktKitsh4EQG2m=naenSuzc+EjoSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAAk-MO-wPkMtyCsCBEo5yKktKitsh4EQG2m=naenSuzc+EjoSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--9ErkkjSG6BfvM2U5mkcKeC8Fims70SpLu
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/7/2016 10:32 AM, Erez Shitrit wrote:
> On Tue, Jun 7, 2016 at 4:48 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> On 6/7/2016 2:01 AM, Erez Shitrit wrote:
>>> On Tue, Jun 7, 2016 at 2:59 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>>>> On 6/5/2016 5:10 PM, Or Gerlitz wrote:
>>>>
>>>>>> -                       neigh->alive =3D jiffies;
>>>>>> +
>>>>>> +                       if (likely(skb_queue_len(&neigh->queue) < =
IPOIB_MAX_PATH_REC_QUEUE))
>>>>>> +                               neigh->alive =3D jiffies;
>>>>>
>>>>> why testing the queue len makes things right?
>>>>
>>>> I'm with Or on this one.  This test doesn't make sense unless you as=
sume
>>>> that the neighbor is being hit with a steady stream of packets.  If
>>>> someone just runs ping -c 1 to a dead neighbor, this test will fail.=

>>>> The idea of the patch is OK, but the test needs to be reworked for
>>>> situations other than a blasting stream of data.
>>>>
>>>
>>> I will try to explain the idea behind that test, and why it works (I
>>> hope I'll make it clear this time :))
>>>
>>> there are 2 objects that are taking place here, the garbage-collector=

>>> that removes neigh if was not used for defined time, and the
>>> path-query for each neigh.
>>> if the path-query failed the packets for specific neigh are kept in
>>> the neigh queue, but only if there are no more than
>>> IPOIB_MAX_PATH_REC_QUEUE, and the neigh is still kept for ever (let's=

>>> assume CM connected that was stopped without any notification with
>>> DREQ etc.)
>>> The only way to know that there is an unresolved neigh is by checking=

>>> its queue, if it is full we can assume that this is an unresolved
>>> neigh otherwise it is resolved.
>>
>> That's not true.  Reread what I wrote above (I was specific when I
>> picked that command).  Ping -c 1 will only send one ping.  It will not=

>> trip this test.  As I said, your test relies on a stream of packets, a=

>> single packet to a gone neighbor will never cause it to get deleted.
>=20
> If you ping one time (ping -c 1) there is no problem at all, the neigh
> will be deleted by the GC anyway, because no (unresolved) packet
> updates the neigh validity and the GC will check the last time it was
> refreshed and since only one ping refreshed it long ago, it will be
> deleted. (the GC always running)
>=20
> the problem is when there are non stop traffic to that neigh. IMHO
> that test works for that.

Ok, that makes sense.

>> You need a timeout on the queue and then if the packet in the queue
>> times out, regardless of whether the queue is full or not, then you ma=
rk
>> the neighbor for garbage collection and drop the packet(s).
>>
>>> So, the test doesn't take any assumption on the shape of the traffic,=

>>> even in a ping requests once a second it will failed after 3 times th=
e
>>> request was sent, and the neigh time will not be updated which will
>>> leave it to the garbage-collector to delete it, that gives the driver=

>>> the possibility to recreate the neigh and to update its ah/pr,
>>> otherwise the driver will try over and over to resend to that
>>> unresolved neigh.
>>>
>>>>
>>
>>



--9ErkkjSG6BfvM2U5mkcKeC8Fims70SpLu--

--woPRkvaQnqxT4VX91fLvsasReLEtaLnLk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVt2sAAoJELgmozMOVy/dJh0P/1qx/qSq2yYjq6ymAVBCeBWL
q9e7ewlF05y/ub4KF/M2lCjGv12RKA+zxIu7/1HF8qDmEMyEnPgClgsonl8iK/eu
7TcBs1vu7WOn/1wZvgZwReD6z7zze4Wc47fi7yhYf5Yqcc6cIn5ul+1MKKBO1geX
2WDfQgYBOrQlra670lpEk6xuNiGuO6hWs8MTBsgvCw48Y8V2WrZRNrq0sk37CYvF
gohQ+aRQazLuOurIsSbTnkWozsAstQpQmx6uynC3H6tUz6JFAMJQ4M35KFZrb5ok
Q1P/SJQmT+z1w3BAnG0Xsmr7D9C1Kna29UoT4Q2FAqkUjZS3hxXB6h1YlDb0GU7j
M8hecPV/jYLt21Zk1cA6UIMDh5No8kGz0OJpzVVmZ94NU7RymrNlYaG9XDclXksh
3zzFlHNkIxmlLvLAhfDWNK6cAJm/575UtSKpjg7jvtKrsR+5RU3EZDYUapVTGyNO
0ZQ/MNEb9skGSByef3+1obVNRp3DYJPR+yW8c8r9cECJjR9+HuADvnlvSZDt84qj
d3vy/ss3yBoZEs14SN4oLsz2+b45+32u1ab4+jDEtSV/8p08N+DONLpzHuJxPdg7
eRpkFhS7E1vdTXiuqIT7+zIHYKrEy0a7rVI8sG7T/9+Ofo4/VDO+/5S5jaHgcem6
60BTP2EvjVVjjBVrFeM7
=ikWM
-----END PGP SIGNATURE-----

--woPRkvaQnqxT4VX91fLvsasReLEtaLnLk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
