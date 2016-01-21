From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Back from PTO
Date: Thu, 21 Jan 2016 14:01:55 -0500
Message-ID: <56A12B23.6000403@redhat.com>
References: <569D57B1.2060205@redhat.com>
 <CAG9sBKP8kqax_wqyej+1J+hFaaCUFKdFyAX8e4Hxg3HoafWjrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5NU7h61JQ8nlMWoeSCIE7oPwSgD5JA6Hp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKP8kqax_wqyej+1J+hFaaCUFKdFyAX8e4Hxg3HoafWjrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5NU7h61JQ8nlMWoeSCIE7oPwSgD5JA6Hp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01/19/2016 12:04 PM, Moni Shoua wrote:
> On Mon, Jan 18, 2016 at 11:22 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:

>> rdmavt
>> qib->rdmavt changes
>>
>> Things that I intended to submit after the merge window opened and
>> Greg's merge was done:
>>
>> Retake staging/rdma
>> Delete staging/rdma/{amso1100,ehca,ipath}
>> hfi1->rdmavt changes
>> Add staging/rdma/soft-rxe
>>
> Doug,
> it's not clear if you intend to take rdmavt into drivers/infiniband/sw

I had intended to.  However, on Jan 6th at roughly 1pm EST, Dennis
submitted v3 of his rdmavt patch set.  At roughly 2pm EST you submitted
a completely different, competing patchset that resides in the same
place in the filesystem, has the same name, but is 100% different
internally.  I know Intel and Mellanox have a hard time working
together, but geeze...

> IMHO such a central piece of code needs to go through proper design
> stages, be written with a clear and sharp interface and be published
> with documentation.

Yes, you've repeated this multiple times.  As this is a kernel internal
interface only, and a private one to the IB stack, we can be a bit more
flexible than you suggest here and do things a little more on the fly.

> To me it looks like the only purpose of rdmavt is to pull hfi1 driver
> out from staging.

That's obviously the piece that Intel cares about, sure.

> If we want it as an infrastructure for any kind of
> low level driver it needs to stick to infrastructure standards.

This statement is too vague for me to say anything constructive.

> I hope that you agree

Again, too vague to answer.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--5NU7h61JQ8nlMWoeSCIE7oPwSgD5JA6Hp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWoSsjAAoJELgmozMOVy/dYjgQAIFWJNalX/QlJS8uoy2kAuAm
Qk2qzxk67s1bLGPVh470SSAYDzPSQkMUQSbRpRhl3zwRCpa+3ZAXINtJ8b/gvUuo
cPGe2ldMed2OQM913YmZIob/DiHFcVE1DzBwJzGW9QiQyYwMYL4XIp9YSPFcSVEP
KymXAtdl8+O6JsacacwgouSL1y0F52ikOO82XPi+lEQCEfFS0RbjYzzJvsuqt56S
lmj++wEswSnu8Bz8RyQt0tM+yhtc3tA+cGqqcUmmNVN6Dn1uwS/9+AcNRSn2itG6
kFvoxz4OefWfX/WIyEo1zpqS8EvS6AAfOo32WEin+HeB5P3u0B1qb2PHmnpIBIJE
ov6PSoVtJIqg9hJJRwQqIIdfOTLyxne0xMnyJecHBrRPPI5bGJ/bgT4KO0uxO+qi
xGsPmfXXCQHEhzk52IIvlzd9OZhw4NzGDrE/gEVlVEe/CuKHxkNsoDehpi3EzcoZ
Zr53r0kR/y0UcMlz4qMVLFVhrSSfeYRhqIsZs8c4+yuoygARA9q5dlvEUvy8kw7o
Qq7vMzc/r7RKrqsZ6EwUiQxjQDUFcmaPo8cVnwL3WI75rjQluVrTgZwSMQBQ7KXA
OWCzHN4fs3yCevdJZKxXQ/CVesD0cAkR8Yqm92aRCx5VcqTRHmvQ29WXlwL5fXsI
t9A3oaTfjJ5v9XT9mzlA
=2+M0
-----END PGP SIGNATURE-----

--5NU7h61JQ8nlMWoeSCIE7oPwSgD5JA6Hp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
