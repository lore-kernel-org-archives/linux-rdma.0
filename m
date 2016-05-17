From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mlx5: Support RAW Ethernet when RoCE is
 disabled
Date: Mon, 16 May 2016 21:01:05 -0400
Message-ID: <18402022-8a88-f166-d813-10df90e16662@redhat.com>
References: <1463317066-29900-1-git-send-email-ogerlitz@mellanox.com>
 <f0e2e407-5a32-b5fb-1ff0-86a9bb4faa88@redhat.com>
 <d6b3c895-6af0-33b7-79c5-f932243e7c48@mellanox.com>
 <6a25dc81-503e-15b4-58a2-66e1cb6a16f1@redhat.com>
 <CAJ3xEMinuAUeb2EzGBwR7fxE6+cLMxJ1WQnfM1GQ03D_-kQYZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KxiDWQATRb2N6THLfTtTpLpOpTthTSToH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMinuAUeb2EzGBwR7fxE6+cLMxJ1WQnfM1GQ03D_-kQYZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KxiDWQATRb2N6THLfTtTpLpOpTthTSToH
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 05:03 PM, Or Gerlitz wrote:
> On Mon, May 16, 2016 at 7:46 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 05/16/2016 12:31 PM, Matan Barak (External) wrote:
>>> On 16/05/2016 18:14, Doug Ledford wrote:
>>>> On 05/15/2016 08:57 AM, Or Gerlitz wrote:
>=20
>>>>> On some environments, such as certain SRIOV VF configurations, RoCE=
 is
>>>>> not supported for an Ethernet port. Currently, the driver will not
>>>>> open IB device on that port.
>>>>> This is problematic, since we do want user-space RAW Ethernet
>>>>> (RAW_PACKET QPs) functionality to remain in place. For that end,
>>>>> enhance the relevant
>>>>> driver flows such that we do create a device instance in that case.=

>=20
>>>> So this device is still going to present itself as a uverbs# device =
and
>>>> libibverbs is still going to try and access it, but when it comes ti=
me
>>>> for user applications to try and use it they will simply fail all QP=

>>>> types except for RAW?  Is there no way to distinguish between a devi=
ce
>>>> with RoCE enabled and without?
>=20
> Doug,
>=20
> To answer your questions: YES there is a way, namely
> RDMA_CORE_CAP_PROT_ROCE and RDMA_CORE_PORT_IBA_ROCE - under this
> patch, when RoCE isn't supported we do create the device but not
> advertizing these caps.

I wasn't referring to the kernel.  I was referring to a user space
application.  There is currently no way for a user space app to tell the
difference between this and a full RoCE device until they try to create
something other than a raw Eth QP and it fails.

>> OK, so you want a plain Ethernet device with QPs as a means of enablin=
g
>> RDMA for Ethernet, but without the full blown Verbs support, just dire=
ct
>> data placement in memory.  That's a reasonable thing to want to do.
>> However, I'm not sure I agree with the implementation here.  It seems
>> very hackish.  This setup probably deserves its own type setting in th=
e
>> RDMA stack to differentiate it (aka, InfiniBand, OPA, RoCE, iWARP,
>> USNIC, Ethernet + QPs).
>=20
> Why? we should be doing things for a reason. There's no entity I know
> of in the stack which needs to be operative and is not b/c that new
> type you're suggesting was not defined.

The reason is to properly support this as a valid device type.  Not full
RDMA, but still with direct data placement in user memory.  That has
value, I'm thinking it should be properly represented.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--KxiDWQATRb2N6THLfTtTpLpOpTthTSToH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOm1RAAoJELgmozMOVy/dAqEQALKHIFtV307cCuRPm7CASA6m
czUVIjpGvhj84YWe41p/+yuoVEnuWv3ZSQy8y7QwFSP2G3IjNzqh6dF0MxwlmisT
blSoytrxi7i2QivtmSx7Nl/u3zYu5DYDOGLHaaur3RUYFfJwB02B837uXFTZXNDo
bIfEk+9fEK/KE7JnTBtYi+7B3/YI8WSuVASVczOIXrdUt2j51CXdPAreddg3VABh
G4NpOMdlOVL0YHuNnoR9AEguvIOwahIRkimu0IOGNeh8mk5unj5WjS+t+8NnwYCr
8g2hplFyFKwKFi37iTnU9fRSWgakvv5b9p0LmCj38+UPX6n4RaQRV4OjOMDJCrm5
i//bZYaPfY/Qlu4d3MkcAQhu3HwrnWr6QG/b70G3RWXdQd2oE8Iy/SwHBlzmeNrC
lQPqA0CPlvTouZDelHsuTrnxHs7l9xnuSZ4CS1sIuZlrTN+JX/j/0fHwAxH+3+XR
UG9HjQZZN/oYYpjiNp+sdq9eCuKb70OqAliG1IUcJmrSTyvzc1aYdjjHzePDi2G8
IGwmzEnr+5WZ7N9PTsN6r8J4Q6EhN0lh4RSDnJlGg6Zq+HbVoE594TZQGP2i8dsf
RF/dRjwW2bn21N2FfZn9QVuYGUl4wEYmHmDRzDJbyiBAnGlF1psw3xvQzlcACPCS
xlKQewtlZlAYitxh7Liv
=xfAJ
-----END PGP SIGNATURE-----

--KxiDWQATRb2N6THLfTtTpLpOpTthTSToH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
