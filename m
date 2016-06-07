From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
Date: Tue, 7 Jun 2016 09:43:29 -0400
Message-ID: <97ef54ca-d3c4-f294-4bb7-4422ae25dde4@redhat.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-7-git-send-email-leon@kernel.org>
 <85e56121-5911-37f4-2ac3-a1af561d5a7a@redhat.com>
 <20160607071621.GB3663@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KeMamBpqRBVJGeFPOsTswGDxmuGgs3J87"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160607071621.GB3663-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KeMamBpqRBVJGeFPOsTswGDxmuGgs3J87
Content-Type: multipart/mixed; boundary="2u7KlLd49iQ5ho8NwXD91dGSlnPKv74i7"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <97ef54ca-d3c4-f294-4bb7-4422ae25dde4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
References: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1465042524-25852-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <85e56121-5911-37f4-2ac3-a1af561d5a7a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160607071621.GB3663-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160607071621.GB3663-2ukJVAZIZ/Y@public.gmane.org>

--2u7KlLd49iQ5ho8NwXD91dGSlnPKv74i7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/7/2016 3:16 AM, Leon Romanovsky wrote:
> On Mon, Jun 06, 2016 at 07:53:43PM -0400, Doug Ledford wrote:
>> On 6/4/2016 8:15 AM, Leon Romanovsky wrote:
>>> From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>
>>> In a attribute group struct, attrs should point to a NULL
>>> terminated list. Which means we need to allocate one more
>>> slot in the array.
>>
>> This patch is both right and wrong.  You're right with the intent (tha=
t
>> there should be a total of 2 extra entries in the array size, one for
>> the NULL termination and one for the lifespan entry), but wrong with t=
he
>> mechanics (unless I've missed something).  We already have two extra
>> entries because sizeof(*hsag) includes our first counter, so just
>> num_counters is actually enough to NULL terminate the list, and + 1
>> gives us lifespan plus a NULL terminate spot.  The comment could be
>> cleaned up to make this more clear though, so I'll do that.
>=20
> Thanks Doug.
>=20

I was wrong with this BTW (I tested to make sure).  Even though the
struct includes the name for the array, because it's 0 length, it
reserves 0 space.  I thought it would reserve one u64.  In any case, I
ended up writing a fix of my own since I had already marked your patch
as not needed in patchworks.  I listed Mark as the reporter in that patch=
=2E


--2u7KlLd49iQ5ho8NwXD91dGSlnPKv74i7--

--KeMamBpqRBVJGeFPOsTswGDxmuGgs3J87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVs+BAAoJELgmozMOVy/dpRUP/jaV1s9/DswRSw4r9/2ekTFh
RFfCaa1FOrp3er5LEWfDeDEscTbmwNU+W8rF8Jhz6rEXO5XXcp4hHLRvWxNnhY5p
tgOkYjgTrRWtd59L8Wd0fwWFrABONVJAAlKaDTJFDDFFGu3s5hq+5vCf7ttmzClk
e7BZCwEBxyb+G5wxDdcX2phki5XxqY9Wor8dOv0B+oXmIzxNsMnUZwW7KsgwjGhR
eOm1McxW/Gy7yjRboHQTqGeflknEAhL8MuONSsjaqmZXIrlHl6KsM1VhtsDYg0nL
MK3LuN0239bCN7N7fEhoMwo+WRJdOH8Up6TFFePTwgs2ewggCoqqLezfequwgVDF
+/j/Mu2mOCTBHoph6yfIHv4gQQMgCs+QIy+4w52l7Q3HE8qAAYmA35IrM49B49vf
KZUbrdTZjCZ8Ncq8Z4Po8XTZcnT+AStiicUZSXWGIJNPx6P6KdCdTaRje8csBKWO
RRg7qG4eKh4D4NW/j4/2uDopVhnD0hNvyfY8tdUB9EPrp4VPlba5pyaMi7eFzeCb
4tx+StQ8/RGnVXGsk+oTGICJS1RAsdVVGa/h2n7g4B7l0oJAtBCaUpwfT7fMnG7J
8X0+XVmPZb7Ate5jfiy06mwdukSQDdsJOpI3Btw2oxc3WHM8EF0GGgDUH7DCL94W
5CqUevlOFyYip6qiGkRO
=ujuU
-----END PGP SIGNATURE-----

--KeMamBpqRBVJGeFPOsTswGDxmuGgs3J87--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
