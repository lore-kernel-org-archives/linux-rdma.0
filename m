From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
Date: Tue, 7 Jun 2016 09:46:20 -0400
Message-ID: <14b30d87-6f70-a7bb-14ea-e5152ce545bf@redhat.com>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
 <1465042524-25852-7-git-send-email-leon@kernel.org>
 <85e56121-5911-37f4-2ac3-a1af561d5a7a@redhat.com>
 <VI1PR05MB1391BC017005F864E1DAE3C0D25D0@VI1PR05MB1391.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aXUXwBuOxgJeERRUQGJnrws2RElL1Px1w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR05MB1391BC017005F864E1DAE3C0D25D0-79XLn2atqDP8GeyK7vyn2tqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aXUXwBuOxgJeERRUQGJnrws2RElL1Px1w
Content-Type: multipart/mixed; boundary="3NR1Wbl3T5X7Hpccljt3G6KknsUTOr7ET"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <14b30d87-6f70-a7bb-14ea-e5152ce545bf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
References: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1465042524-25852-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <85e56121-5911-37f4-2ac3-a1af561d5a7a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <VI1PR05MB1391BC017005F864E1DAE3C0D25D0-79XLn2atqDP8GeyK7vyn2tqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
In-Reply-To: <VI1PR05MB1391BC017005F864E1DAE3C0D25D0-79XLn2atqDP8GeyK7vyn2tqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>

--3NR1Wbl3T5X7Hpccljt3G6KknsUTOr7ET
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/7/2016 4:26 AM, Mark Bloch wrote:
>=20
>=20
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
>> Sent: Tuesday, June 07, 2016 2:54 AM
>> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Subject: Re: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocati=
on
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
> Hi doug,
> I might be missing something, but:
>=20
> hsag =3D kzalloc(sizeof(*hsag) +
> 		sizeof(void *) * (stats->num_counters + 1)
>                        	GFP_KERNEL);
>=20
> So now we have hsag and after it num_counters + 1 slots.
> Now we need attrs to point to a memory location, so we do:
>=20
> hsag->attrs =3D (void *)hsag + sizeof(*hsag);
>=20
> which means hsag->attrs is now pointing to a memory location right
> after hsag (remember we have num_counters + 1) slots there.
>=20
> for (i =3D 0; i < stats->num_counters; i++) {
>                 hsag->attrs[i] =3D alloc_hsa(i, port_num, stats->names[=
i]);
>                 if (!hsag->attrs[i])
>                         goto err;
>                 sysfs_attr_init(hsag->attrs[i]);
> }
>=20
> /* treat an error here as non-fatal */
>  hsag->attrs[i] =3D alloc_hsa_lifespan("lifespan", port_num);
>=20
> The for loop fills num_counters slots, and after that alloc_hsa_lifespa=
n uses another one.
> Which means we used all our slots and we are missing one as the NULL sl=
ot.
>=20
> Of course I might be wrong/missing something, it wouldn't be the first =
time :)
>=20
> Mark
>=20

Nope, you're right.  It's fixed now though.  with num_counters + 2 and
kzalloc, the final NULL terminator is in place.


--3NR1Wbl3T5X7Hpccljt3G6KknsUTOr7ET--

--aXUXwBuOxgJeERRUQGJnrws2RElL1Px1w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXVtAsAAoJELgmozMOVy/d7TQP/0NCxko+FOZufam6TGOp6w6l
1//dmDizDKWNxYIHdGTqZ/7EgUM/UO9Vn7h/w29svrSEb1rIUP3NGv1pxPK1rZcI
Li9MChjzbeWbD+Snf86tMKzZ+QAvxkTij8AwZwmKOaapkjjYZEq70rHCX76trYbH
Qc1mS+P7pikydQmM38buQzMCWZICYvQxhOsuYuhGoqCfQlEkCcktBTQrCceYZ6BR
y8YLidqip+qP9kbhr8LIrxv28Xp99Sb7HU1wry5fCsni4ZHMIBHMfiiyBBXDUiKO
u53yyBUPYl1oxa7JcS0apz1o+J3wXyhnMw6t5RoWxudXQGtPuNYi33XBjYOCAKej
0Ei2j1QqO9+JifhIwVf5Vv9hYHMnbgv3YqhdWlOERCTH6qhHWu6MI7XR5rymN2AT
81WGOhISKBa4FNuHF6hdrQXkykAcA8ON2tFOHKgVKuANEhAB5Gff7f1gPf+G2CDe
CNBXtmSXo39am3FOe7yXEszYUJYN5pKx/0IZ6MsS8PLmjnAUIme9Sg4fsVMPQVl8
LWxEMM+FWtFmNxLqWUSxzltJUbzkJUZbePoFDxFGVbFykwErkfeNT34icednUdCk
JoU2mHEMJOuCyCluDWPSKEwWkhmCbXrOFG4G8TDLHlOnQ0KkomPiQ+Wz0wkJmykt
iy7WUYr5bX9N/c2LSpBh
=bfVL
-----END PGP SIGNATURE-----

--aXUXwBuOxgJeERRUQGJnrws2RElL1Px1w--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
