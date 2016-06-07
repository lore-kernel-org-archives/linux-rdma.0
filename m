From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
Date: Tue, 7 Jun 2016 09:48:29 -0400
Message-ID: <27852e30-765c-012a-b54b-f5ba096121d4@redhat.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-3-git-send-email-leon@kernel.org>
 <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A@mail.gmail.com>
 <42668994-5666-f5b3-8d38-4c452f0cc70f@redhat.com>
 <CAAk-MO9gUtqZHKq+7xaHLkJRM_T-DgF0wOCFuykre9=0VUBbQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TTTFPaV9BgVoJuEHUjIIXjsAoXdTMDGow"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAk-MO9gUtqZHKq+7xaHLkJRM_T-DgF0wOCFuykre9=0VUBbQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TTTFPaV9BgVoJuEHUjIIXjsAoXdTMDGow
Content-Type: multipart/mixed; boundary="m86uVA61dLBdKtni5VOXjETfB2QNuOngv"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <27852e30-765c-012a-b54b-f5ba096121d4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/7] IB/IPoIB: Don't update neigh validity for
 unresolved entries
References: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1465042524-25852-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <CAJ3xEMgYKnVh4JECrCSBUYmyCr4s-zxWhMywMVTQPZswLvF61A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <42668994-5666-f5b3-8d38-4c452f0cc70f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CAAk-MO9gUtqZHKq+7xaHLkJRM_T-DgF0wOCFuykre9=0VUBbQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAAk-MO9gUtqZHKq+7xaHLkJRM_T-DgF0wOCFuykre9=0VUBbQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--m86uVA61dLBdKtni5VOXjETfB2QNuOngv
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 6/7/2016 2:01 AM, Erez Shitrit wrote:
> On Tue, Jun 7, 2016 at 2:59 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> On 6/5/2016 5:10 PM, Or Gerlitz wrote:
>>
>>>> -                       neigh->alive =3D jiffies;
>>>> +
>>>> +                       if (likely(skb_queue_len(&neigh->queue) < IP=
OIB_MAX_PATH_REC_QUEUE))
>>>> +                               neigh->alive =3D jiffies;
>>>
>>> why testing the queue len makes things right?
>>
>> I'm with Or on this one.  This test doesn't make sense unless you assu=
me
>> that the neighbor is being hit with a steady stream of packets.  If
>> someone just runs ping -c 1 to a dead neighbor, this test will fail.
>> The idea of the patch is OK, but the test needs to be reworked for
>> situations other than a blasting stream of data.
>>
>=20
> I will try to explain the idea behind that test, and why it works (I
> hope I'll make it clear this time :))
>=20
> there are 2 objects that are taking place here, the garbage-collector
> that removes neigh if was not used for defined time, and the
> path-query for each neigh.
> if the path-query failed the packets for specific neigh are kept in
> the neigh queue, but only if there are no more than
> IPOIB_MAX_PATH_REC_QUEUE, and the neigh is still kept for ever (let's
> assume CM connected that was stopped without any notification with
> DREQ etc.)
> The only way to know that there is an unresolved neigh is by checking
> its queue, if it is full we can assume that this is an unresolved
> neigh otherwise it is resolved.

That's not true.  Reread what I wrote above (I was specific when I
picked that command).  Ping -c 1 will only send one ping.  It will not
trip this test.  As I said, your test relies on a stream of packets, a
single packet to a gone neighbor will never cause it to get deleted.
You need a timeout on the queue and then if the packet in the queue
times out, regardless of whether the queue is full or not, then you mark
the neighbor for garbage collection and drop the packet(s).

> So, the test doesn't take any assumption on the shape of the traffic,
> even in a ping requests once a second it will failed after 3 times the
> request was sent, and the neigh time will not be updated which will
> leave it to the garbage-collector to delete it, that gives the driver
> the possibility to recreate the neigh and to update its ah/pr,
> otherwise the driver will try over and over to resend to that
> unresolved neigh.
>=20
>>



--m86uVA61dLBdKtni5VOXjETfB2QNuOngv--

--TTTFPaV9BgVoJuEHUjIIXjsAoXdTMDGow
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVtCtAAoJELgmozMOVy/dTnEP/jKnFfb/wFPSiQlqPrWEa/5l
97dZSYFKvZURs3DM8419KyxDV++yG3gXABvyxulqGuzMJGG6kiB/GYc4GfSeSYA8
P1C8QwGMdjgHqLlE7u/ieeSS+TethNiUFgFRWw+nsGywMcRCOH7nnNlYeDjbLP5y
/DtvYJozlpKNbBuM7/fMM7jNlVK6FcvtWkMp9+tj7RIUFXdFqQVgFiNZu4ntyhin
/bbH4b2eIlldtJkYmIBrxrbvqbCGxksJVCg4j/QEu9hOOTynsz94zxyfb2RS6lS1
NWCR0+GvGIAO8chj/GsQigisiK/qIu9mkvcwznOVkrqlGR20tDeAGsXRgWfCOAJK
pbXf8HyjZ6cUbv/GQ+GqTe3xJ1Bn5RlnbCw9g24okxmEUZz2aQMezHEl+zMvgkGR
dM8CDvD7qpRXEnbgGl32HGzQQ3u6MQtocMQaprCXsIJ2if4Zv6g4K/FFUqUBV66I
7zfJfaUf8D7BPKo+HE0uUkzkRBtRX2Ju8kAi/X48Y8CfrVysJJX2nry2Sir8P/Jv
D4E0UFfh36Fi+wx4p0OJqG6oWVvmKAZju4mrlKf4H/kMOGg7UILr+tmkFshj+Wen
YOPXoVeYGUvO+q+tXHJGZtus1Ed2/284D+Bchobn0tvvKoHn1W0ADPcwUsj98TpX
2Bt0qg/wqgyH/Da10e6t
=yNpI
-----END PGP SIGNATURE-----

--TTTFPaV9BgVoJuEHUjIIXjsAoXdTMDGow--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
