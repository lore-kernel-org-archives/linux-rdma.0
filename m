From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-RC] IB/cm: Fix sleeping while atomic when creating AH
 from WC
Date: Wed, 23 Dec 2015 15:04:18 -0500
Message-ID: <567AFE42.2080107@redhat.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
 <1444568298-17289-2-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A9734356@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BCe_LAuyxifm=j-Am44S1k4nT328WrGBC+Day+XxMxk9g@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373A9734A57@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BAF763brdhsrHtpm_peHk--g3iza53AioiUefepHM_s2w@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373A9735914@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Pg1qtql82eRHpMk8f6lRXgGWFLPvrR0hn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9735914-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Pg1qtql82eRHpMk8f6lRXgGWFLPvrR0hn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/15/2015 12:58 PM, Hefty, Sean wrote:
>>>> ib_create_ah_from_wc needs to resolve the DMAC in order to create th=
e
>>>> AH (this may result sending an ARP and waiting for response).
>>>> CM uses this function (which is now sleepable).
>>>
>>> This is a significant change to the CM.  The CM calls are invoked
>> assuming that they return relatively quickly.  They're invoked from
>> callbacks and internally.  Having the calls now wait for an ARP respon=
se
>> requires that this be re-architected, so the calling thread doesn't go=
 out
>> to lunch for several seconds.
>>
>> Agree - this is a significant change, but it was done a long time ago
>> (at v4.3 if I recall). When we need to send a message we need to
>=20
> We're at 4.3-rc5?
>=20
>> figure out the destination MAC. Even the passive side needs to do that=

>> as some vendors don't report the source MAC of the packet in their wc.=

>> Even if they did, since IP based addressing is rout-able by its
>> nature, it should follow the networking stack rules. Some crazy
>> configurations could force sending responses to packets that came from=

>> router1 to router2 - so we have no choice than resolving the DMAC at
>> every side.
>=20
> Ib_create_ah_from_wc is broken.   It is now an asynchronous operation, =
only the call itself was left as synchronous.  We can't block kernel thre=
ads for a minute, or however long ARP takes to resolve.  The call itself =
must change to be async, and all users of it updated to allocate some req=
uest, queue it, and handle all race conditions that result -- such as sta=
te changes or destruction of the work that caused the request to be initi=
ated.
>=20

I don't know who had intended to address this, but it got left out of
the 4.4 work.  We need to not let this drop through the cracks (for
another release).  Can someone please put fixing this properly on their
TODO list?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Pg1qtql82eRHpMk8f6lRXgGWFLPvrR0hn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWev5CAAoJELgmozMOVy/d1pkP/jrZhE3vBWIbmbo7dmEhxlMq
AiGJ0ImBFGl1L+8WFQY1DCpqHL9VwrTHnhxhWg8qL6stnXHurPF7MDNLZVeQMiGG
jGF5lGKrp8zq5ekg7/3AmFMvlk8VUvzjh/xXKqOioWutoWXVkvJ3w9Ien/873QNp
hADSuMQopXTA5o9LIcL9lG/g1YJN6E05O5GarXMhrZWhB006fMts7g6zEtXA5i/k
7feYjt4FaB+NP5Zu4hYBiiCMdJGCYJDGnyNMsNGGda81aeHJaDPaoTUvL7cqfOX4
wc0LAKiCCotNETTaaMa8nE1SucsT4oObKl/CVQyWpoe2werFFYE251xZ3o1yPEMj
7FgaUjGhLNcdj6TiIxD45xXRkDUBbUP0o8vR40XPxtzr5yYjS/9a+v9DgJ0tbYL6
zKm8Sywu98Igz+sjhKa1c7rp5txRfd0aSyRLISqyszMOsmJNaTVsoy822WH3PP+I
WJNd/lSn//1ck7MLn2CLijM8s4ant4OB9nfehB0jNG21raK1w9ALh0kB2qQ0fums
arvf/xOCzf4D5aNM9j2RUq+ODKRQRLF/LxW2Qdg8Sg1fuET6hadPC8slNU1eIBx9
4/Cd0LdC2cQ0qUcBxDW92F/lBKp0c1hVjR5CqT4CUQOlJlJZrDd5xHpuAKCtEeoX
4nniMWMrWgfgvvHHC3GI
=DAqa
-----END PGP SIGNATURE-----

--Pg1qtql82eRHpMk8f6lRXgGWFLPvrR0hn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
