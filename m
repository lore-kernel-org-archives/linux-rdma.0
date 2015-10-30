From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core, cma: Make __attribute_const__ declarations
 sparse-friendly
Date: Fri, 30 Oct 2015 18:00:40 -0400
Message-ID: <5633E888.7090303@redhat.com>
References: <55BF9E80.3030306@sandisk.com> <55CE410C.7080002@redhat.com>
 <56328C9A.1030105@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DLA9DJp1KriOmggBOSpCWLnAVHKmGpEKi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56328C9A.1030105-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DLA9DJp1KriOmggBOSpCWLnAVHKmGpEKi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/29/2015 05:16 PM, Bart Van Assche wrote:
> On 08/14/2015 12:27 PM, Doug Ledford wrote:
>> On 08/03/2015 01:01 PM, Bart Van Assche wrote:
>>> Move the __attribute_const__ declarations such that sparse understand=
s
>>> that these apply to the function itself and not to the return type.
>>> This avoids that sparse reports error messages like the following:
>>>
>>> drivers/infiniband/core/verbs.c:73:12: error: symbol 'ib_event_msg'
>>> redeclared with different type (originally declared at
>>> include/rdma/ib_verbs.h:470) - different modifiers
>>>
>>> Fixes: 2b1b5b601230 ("IB/core, cma: Nice log-friendly string helpers"=
)
>>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>>> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Thanks, applied.
>=20
> (replying to an e-mail of two months ago)
>=20
> Hi Doug,
>=20
> On which branch has this patch been applied ? I couldn't find it in you=
r
> k.o/for-4.4 branch.

I can't find it myself.  Either I said I was taking it and then it got
overlooked, or it got lost sometime during a rebase.  I've added it to
the for-next stack.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--DLA9DJp1KriOmggBOSpCWLnAVHKmGpEKi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWM+iIAAoJELgmozMOVy/d+QgP/jnSOBnQXxud/I97JKyjW3Ng
6BTDCs/WdTHNLFclgnz01ShQrVPoe+xfnSLApTV6D13dp+kGWYD0MWZ3Qsvx9PA5
ZUGFxNZW1FGu36p5OQ4nf5DH4EV6MPizyBFNHVt1mf4u1JQSgnyUCjxveMw6vI/v
lPhTZTzjDFI73++0blke0N1hEJvaPetBV+AltRGeSZuPjvaKJNANSeVKyJDBldNE
NG2Z8ZUe1YvH74AB8E5grYhAIOxS0v9PWQ1DQvq2Wiu965AsGbW23lrUeTasOpHj
13N5JC138yRhUAP1PEdKFx3XaFu6nbsMRr/DoM5wdlMJcbyfDql3zdb/dhw6gcEH
f6WjKFyNhIKw7vV4386blbAl8SoxB2w1Kql7WdfRym27Ba9Hm8wX/ZHYv1u6FiAu
rps9QXrztf53NRkaiHDjch5MsPXsgSCYCDMSTyIxQil7zh0oP23sdZoNYoZ7gHfQ
H8hXjl8bToUPs/cYzXV0qyTpEVHkdXMnh2sm1Ez3fwaC/gwycd5CqrlHF+IVAHBO
OKQ5uiJa9qWQn9r9d0+THd0UAbRZpUEUaezZgRPxtG4mvQVX/cDrfFIOCMlIRsWX
PEtF6oF5DLN2WpqCj3kVC4h9R+ZFhcsrTuVVPfx7v7qNcpiuf6ywYEmDxwh7X9Mk
5QmnruIdmVb+BMDJIkMV
=Igh8
-----END PGP SIGNATURE-----

--DLA9DJp1KriOmggBOSpCWLnAVHKmGpEKi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
