From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: avoid putting a large struct rxe_qp on stack
Date: Mon, 12 Dec 2016 16:30:27 -0500
Message-ID: <90b06f14-b2d4-77fa-2d01-36335bb68395@redhat.com>
References: <20160919115826.553858-1-arnd@arndb.de>
 <20160919132811.GI3273@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EC4LoR6OnhtsUSEGvbRX26j3aCpwQ24dP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160919132811.GI3273-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EC4LoR6OnhtsUSEGvbRX26j3aCpwQ24dP
Content-Type: multipart/mixed; boundary="G1wmDi7aRiXGamp8hvOqEBl7TTu6KiWWu";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <90b06f14-b2d4-77fa-2d01-36335bb68395-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rxe: avoid putting a large struct rxe_qp on stack
References: <20160919115826.553858-1-arnd-r2nGTMty4D4@public.gmane.org>
 <20160919132811.GI3273-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160919132811.GI3273-2ukJVAZIZ/Y@public.gmane.org>

--G1wmDi7aRiXGamp8hvOqEBl7TTu6KiWWu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/19/2016 9:28 AM, Leon Romanovsky wrote:
> On Mon, Sep 19, 2016 at 01:57:26PM +0200, Arnd Bergmann wrote:
>> A race condition fix added an rxe_qp structure to the stack in order
>> to be able to perform rollback in rxe_requester(), but the structure
>> is large enough to trigger the warning for possible stack overflow:
>>
>> drivers/infiniband/sw/rxe/rxe_req.c: In function 'rxe_requester':
>> drivers/infiniband/sw/rxe/rxe_req.c:757:1: error: the frame size of 20=
64 bytes is larger than 1024 bytes [-Werror=3Dframe-larger-than=3D]
>>
>> This changes the rollback function to only save the psn inside
>> the qp, which is the only field we access in the rollback_qp
>> anyway.
>>
>> Fixes: 3050b9985024 ("IB/rxe: Fix race condition between requester and=
 completer")
>> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>=20
> Thanks Arnd,
> It is much cleaner approach.
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--G1wmDi7aRiXGamp8hvOqEBl7TTu6KiWWu--

--EC4LoR6OnhtsUSEGvbRX26j3aCpwQ24dP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYTxbzAAoJELgmozMOVy/dOIUQAKKfck83+Lo+XzGk1l7R5b3t
adBerQnbxoXiW0h+qt9iExQ0RJgl8A8KwVQVc2ZiPXf1og3PEOlkihthNu5N19ZP
JgRbDdetqFW9Hu7ymltObBQESqwXqaR92ACtWPLf79k/ZnaUHHo+QS5DH6lBwj2F
UAumY8WexUORzKvEMjD05EMe3uc9Z4WYcQHRKP1DsiEPudzYElwO/4anzmZgZEBE
V8JzkzVXG/rT7wKuYU1mIvzexZ0yPJOh2KnGDh2h55+Z38QQ9BKa200acP2fG73+
3EfSLFvfJsV4Ru/LDWqYmkkVDh1Q+3V6WTB1WokO+TblJdBETLpPv4FEYRTTsctv
1rkAxuleoIotsWOc+HsCHuWcM9XC183yhD73yjR5jHZ5VGk3G6XmE/spQKkU9woo
IaS4VjP3Nhby3wx6nT0Q1O7kJG1MP5qHKXUk6JfPQ5D2R4YeQx3Y9n8N7oL07ljH
2gYkhVY4IaWz6dgtaWmd5CtKW6qSLqOTCL+RznycrIfKGnWo/pBC6zha65mkpomW
VzxAv0BNYYXLquRPty3ks2GG8ydvOCj+g9WrFNi5J9jf8QByhg0KW36L6bOZmFfg
Q6iJUi8utR9ORvH24bqr2lJUOxEKNrjG7fDY4pPW8+xmzeFCW1Lkkk8VGLsFTW++
bAW7I8/fO+GVziRr980d
=szkA
-----END PGP SIGNATURE-----

--EC4LoR6OnhtsUSEGvbRX26j3aCpwQ24dP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
