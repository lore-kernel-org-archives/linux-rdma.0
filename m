From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mlx5: Support RAW Ethernet when RoCE is
 disabled
Date: Mon, 16 May 2016 12:46:01 -0400
Message-ID: <6a25dc81-503e-15b4-58a2-66e1cb6a16f1@redhat.com>
References: <1463317066-29900-1-git-send-email-ogerlitz@mellanox.com>
 <f0e2e407-5a32-b5fb-1ff0-86a9bb4faa88@redhat.com>
 <d6b3c895-6af0-33b7-79c5-f932243e7c48@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6sN0c3CbqtEJlqWi6jBwo25csN36bgMRp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d6b3c895-6af0-33b7-79c5-f932243e7c48-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6sN0c3CbqtEJlqWi6jBwo25csN36bgMRp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 12:31 PM, Matan Barak (External) wrote:
> On 16/05/2016 18:14, Doug Ledford wrote:
>> On 05/15/2016 08:57 AM, Or Gerlitz wrote:
>>> On some environments, such as certain SRIOV VF configurations, RoCE i=
s
>>> not supported for an Ethernet port. Currently, the driver will not
>>> open IB device on that port.
>>>
>>> This is problematic, since we do want user-space RAW Ethernet
>>> (RAW_PACKET
>>> QPs) functionality to remain in place. For that end, enhance the
>>> relevant
>>> driver flows such that we do create a device instance in that case.
>>>
>>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> So this device is still going to present itself as a uverbs# device an=
d
>> libibverbs is still going to try and access it, but when it comes time=

>> for user applications to try and use it they will simply fail all QP
>> types except for RAW?  Is there no way to distinguish between a device=

>> with RoCE enabled and without?
>>
>>
>=20
> It's a bit broken, but you could query gid_tbl_len in ibv_port_attr.
> If it's zero, RoCE can't be used anyway.

OK, so you want a plain Ethernet device with QPs as a means of enabling
RDMA for Ethernet, but without the full blown Verbs support, just direct
data placement in memory.  That's a reasonable thing to want to do.
However, I'm not sure I agree with the implementation here.  It seems
very hackish.  This setup probably deserves its own type setting in the
RDMA stack to differentiate it (aka, InfiniBand, OPA, RoCE, iWARP,
USNIC, Ethernet + QPs).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--6sN0c3CbqtEJlqWi6jBwo25csN36bgMRp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOflKAAoJELgmozMOVy/dTMYP/RMLgrxowppOsVNbRKoWS2GY
zx0g+NXEvMUDBaJ/k0R+RLFMmw2shAoJBwHl/yZqFic6A4sdECFbTGVhd3sZfitI
y7JsVgPqKIC+UMKVKp2byb2LdNhWj0WJNHMcBwhxrXDyYgDQqMQUNtoY1SDgrTq8
jMXKy3hTt+zxpwiyhu+pZ2rnJoXLwLrmBWEy/DdTiUKhzuR6dN1S84UCX0a+YDUj
Ilb17PYKjFXpmwopRXJxLIeDfZfsIKqVtJItIpFjp6A6SfHLUGrA1dW1Qk4xF9I6
zf/pcFDVsNrkAyXje6OQmIKjbQRLiLUf/2ZIxM5Z6oI2YbjPY/FP7dkaTVzee9AC
EaMizs/88kuCqC5Z5vbGb7Ly4FRV1DNzN5VsnALYYpCUtQRXD8WQCZ6LjIxReDu7
Q8eizP4RMv+7WffCSsOohV0ceX+1eTBxOWA087q7ixIKnCXMdpjCkP/npNB8Qxxz
yOPtC0sKpOGh1NJ9jdkVpPeFKrI/kOK/C9OpqkNxp+unPkmtSeh7Od8eU+Ygkuhw
yJCM7IAKi1SdsP10GXWKAQXQ1SQYqnj3YCCCwHAVgspeq5un18aYpbMYpAVPHqzA
G3PrTmlNDEI7EvAVgAeMrGI0OAB8JvuYZCypVSrlnmZ2KE9FkqUO7h/saLyMN3ME
BAe5dfRkFrfTVz1kxE2x
=2YDs
-----END PGP SIGNATURE-----

--6sN0c3CbqtEJlqWi6jBwo25csN36bgMRp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
