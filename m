From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: fix IPv6 address resolution
Date: Fri, 14 Aug 2015 22:05:46 -0400
Message-ID: <55CE9E7A.8080303@redhat.com>
References: <1439493550-5958-1-git-send-email-sbaugh@catern.com>
 <CAL1RGDVO0N98f=ip6R7X1QK=Xuxa156HkRUOvfnNCVdD4thoCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rTkuQ8KW5gANGgcKpD72NcdJ4KHVglOkV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVO0N98f=ip6R7X1QK=Xuxa156HkRUOvfnNCVdD4thoCQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Spencer Baugh <spencer.baugh-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Joern Engel <joern-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "open list:INFINIBAND SUBSYSTEM" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rTkuQ8KW5gANGgcKpD72NcdJ4KHVglOkV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/13/2015 03:21 PM, Roland Dreier wrote:
> Reviewed-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
> <mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>>
>=20
> On Aug 13, 2015 12:19 PM, "Spencer Baugh" <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org
> <mailto:sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>> wrote:
>>
>> Resolving a link-local IPv6 address with an unspecified source address=

>> was broken by commit 5462eddd7a, which prevented the IPv6 stack from
>> learning the scope id of the link-local IPv6 address, causing random
>> failures as the IP stack chose a random link to resolve the address on=
=2E
>>
>> This commit 5462eddd7a made us bail out of cma_check_linklocal early i=
f
>> the address passed in was not an IPv6 link-local address. On the addre=
ss
>> resolution path, the address passed in is the source address; if the
>> source address is the unspecified address, which is not link-local, we=

>> will bail out early.
>>
>> This is mostly correct, but if the destination address is a link-local=

>> address, then we will be following a link-local route, and we'll need =
to
>> tell the IPv6 stack what the scope id of the destination address is.
>> This used to be done by last line of cma_check_linklocal, which is
>> skipped when bailing out early:
>>
>>         dev_addr->bound_dev_if =3D sin6->sin6_scope_id;
>>
>> (In cma_bind_addr, the sin6_scope_id of the source address is set to t=
he
>> sin6_scope_id of the destination address, so this is correct)
>> This line is required in turn for the following line, L279 of
>> addr6_resolve, to actually inform the IPv6 stack of the scope id:
>>
>>       fl6.flowi6_oif =3D addr->bound_dev_if;
>>
>> Since we can only know we are in this failure case when we have access=

>> to both the source IPv6 address and destination IPv6 address, we have =
to
>> deal with this further up the stack. So detect this failure case in
>> cma_bind_addr, and set bound_dev_if to the destination address scope i=
d
>> to correct it.
>>
>> Signed-off-by: Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org
> <mailto:sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>>
>> ---
>>  drivers/infiniband/core/cma.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)

I've picked this up, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rTkuQ8KW5gANGgcKpD72NcdJ4KHVglOkV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVzp56AAoJELgmozMOVy/d+BQP/0dRnrUqnkfWjOICm0MyxxOt
uUksXCceN7zk7W0CQCFqYC8avHbmFaTL9qzdQuc6wvJNverbT44peanj19GFIS6b
NHc3TpiUKdibaD1PKg/mtfhs0Mr/MHJQ5HQGuuEC4YnZYQN8qtGWYVZ5ZgcDCfmn
bKSbPoZOG+I+fLJXvShXtASznWskZLtnnv/VRK3SpYQ3irXXp3jMq/s2xGpWL8Fh
yWz7bSFVswtBtPx4nsSzmzdi215HhdTWLlXzJnVZ6vEz3lP6mAp/hwF1/INYMpq6
dWiH+5K972YFUJsrG5kiQxOzYbVBSAXqLvPP1aFj8T6iDS4c3zEoC7xxbnTOcY+7
o8wNu47pMGNyKi9LuKzZ6v1rjBGaScWY9DIJtZhxphBYWORSggqwGti8uMtLPHra
QUm2b0utWSdUwTEDeiAVs4JdIJGz/6a0+Tx+S9d3XCzv9SCHIBJxrsmOnrYA1U11
KWS3MnpbOLIWxJ1j2aWmNFRVNnbFRojsCn+sHIqi3l2UV5iXd+wnTs+VT6OADeSr
j5pav3r1DItrlZttniJkq5oQWfa6InLkdfhsiJfRmxKBhmRJmhyb5pp/s4JOW7N7
8Jz53nW/KrnAxHjgL1kB8bIqKlnJPsyUBkDuHWyEnfPn2TfE7O6OunMNKSXjw0nO
dBknq5+Jdj9CMT49MwKV
=HkHg
-----END PGP SIGNATURE-----

--rTkuQ8KW5gANGgcKpD72NcdJ4KHVglOkV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
