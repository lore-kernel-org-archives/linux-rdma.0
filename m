From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Wed, 26 Aug 2015 12:43:15 -0400
Message-ID: <55DDECA3.4010207@redhat.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DCAACD.3000307@redhat.com> <20150825182233.GA20744@obsidianresearch.com>
 <55DCB56F.5000001@redhat.com> <20150825194945.GA22335@obsidianresearch.com>
 <55DDC12E.6030705@redhat.com> <20150826161829.GA27407@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7MkulJRWq8bS2IqFQNtKOP1oTo5WL9138"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150826161829.GA27407-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7MkulJRWq8bS2IqFQNtKOP1oTo5WL9138
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/26/2015 12:18 PM, Jason Gunthorpe wrote:
> On Wed, Aug 26, 2015 at 09:37:50AM -0400, Doug Ledford wrote:
>=20
>>> Sure looks like these two race:
>>>
>>> 		if (test_and_set_bit(IPOIB_MCAST_FLAG_ATTACHED, &mcast->flags))..
>>> 		clear_bit(IPOIB_MCAST_FLAG_FOUND, &mcast->flags);
>>>
>>> Resulting in corruption of the flags.
>>
>> Incorrect.  On all arches, the set_bit and friends functions are defin=
ed
>> to be atomic.
>=20
> Ah, right, I always forget about that because they don't use the
> atomic type or naming scheme like everything else :|
>=20
>> Which brings me to what I was alluding to earlier.  In your patch, you=

>> move the complete(mcast->done); to inside the spinlock.  I don't
>> actually like that.  While the flags are atomic and therefore visible
>> the moment they are done, any other writes to the mcast struct might b=
e
>> reordered.  By releasing the spinlock before you call complete(), you
>> force a write memory barrier and make all changes visible.  That way
>> anything that was waiting on that complete has a guaranteed clean
>> picture when they get woke up.  Calling complete() within the spinlock=

>> takes that guarantee away.
>=20
> complete() is a guarenteed memory barrier.
>=20
> /**
>  * complete: - signals a single thread waiting on this completion
>  * @x:  holds the state of this particular completion
>  [..]
>  * It may be assumed that this function implies a write memory barrier =
before
>  * changing the task state if and only if any tasks are woken up.
>  */

That still takes us back to the fact that the locking changes are
unneeded.  I'm not opposed to them, but as you mentioned in your first
email, they should go with the changes that require them, and none of
the changes in the first patch require them.  Which means that if we
want to keep them, it might be worth splitting them out and giving them
their own patch with an explanation of why they are a benefit (lightly
contended code, saves a release/reacquire on the failure path).


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--7MkulJRWq8bS2IqFQNtKOP1oTo5WL9138
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV3eyjAAoJELgmozMOVy/d/tMP/i4AhZJDV3Odjv0eDKKUmVtW
OA1xkjmMEkjXsb133CnuUDeA+S6XsOGxHyn5yqezgoFkQIKlRQKfiRFIzamgf1HW
ndYwiPU+Md98vzsOBYgJTh+8BiCWD0cSXsztmsXG3YQQqccPmjgrpAiHN+h+YNbo
Ek4tnWDkAPnBReodyRYt+ENh/qam96LqSHYCYF9Qq5NqIyuVCGmEz23hY6IG6BSt
7tdTk+Rk3yXr0plPxB7DeahjyvJUHZ0KT8WBNFWi4U+k4VFXkxS93KF30yw+681D
Jwg0Vm/XZuKu2rDHFdMR/lR85O3S2XhnGMj/nRwsUPYK7Y8n8iHDNE8Bct+ZwJde
pRnHUEOai1fJ9zn+cnAznAFlYbOAeyF32PqQAHQm550pDX4se+kSG6RuvzqeOzX1
JDXhGGegzlTw1tWxiIN8lH49gUqwcGuR2P8IgZfo7Omjc2lDbZOlHEh8zsX/oXc4
+jeHlJkJM7REV8QHkRaYUSIOS01ncbsCVgsySUqEyv9Pw8PioC6MvuGAuGjMHQRd
SHnJJW9EKYmk8P60e6yDjPfYtiQYl0yAwrdYnrxWhPtda78np8fU+7uToZJ/PnAt
+lyGTRsZvXX5i167s61/IoPsB5WYwnzQl8vk6j3RhC70jRUn4caruJCB4W/L3Ulu
i2d1Pp8816MZuGK/zSXC
=LcJH
-----END PGP SIGNATURE-----

--7MkulJRWq8bS2IqFQNtKOP1oTo5WL9138--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
