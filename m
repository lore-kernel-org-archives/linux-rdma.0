From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] mlx5: Avoid that sparse complains about dubious !x &
 y expressions
Date: Wed, 14 Dec 2016 13:46:12 -0500
Message-ID: <3a0525b6-d8d7-ef38-f7c4-53322366a9d0@redhat.com>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com>
 <572c702f-589f-2d5a-9e13-45223191db85@sandisk.com>
 <CAJ3xEMjPZYgLhDi_6Jxkx_dg_RaehD=3SchMt_noLzQEChPrxQ@mail.gmail.com>
 <20161208175322.GB11025@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TTnXsB84IkiPsQcmnBefSNM3Bre5OsdSu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208175322.GB11025-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TTnXsB84IkiPsQcmnBefSNM3Bre5OsdSu
Content-Type: multipart/mixed; boundary="rCKSoLOsc9I8iXSWkEVDmWMBqtWfUkFNJ";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>,
 Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <3a0525b6-d8d7-ef38-f7c4-53322366a9d0-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] mlx5: Avoid that sparse complains about dubious !x &
 y expressions
References: <9ff07804-492c-c67a-e729-b31e0f863027-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <572c702f-589f-2d5a-9e13-45223191db85-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
 <CAJ3xEMjPZYgLhDi_6Jxkx_dg_RaehD=3SchMt_noLzQEChPrxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <20161208175322.GB11025-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161208175322.GB11025-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--rCKSoLOsc9I8iXSWkEVDmWMBqtWfUkFNJ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/8/2016 12:53 PM, Jason Gunthorpe wrote:
> On Thu, Dec 08, 2016 at 11:26:32AM +0200, Or Gerlitz wrote:
>>  /* insert a value to a struct */
>>  #define MLX5_SET(typ, p, fld, v) do { \
>> +       typeof( v ) _v =3D v; \
>>         BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);             \
>>         *((__be32 *)(p) + __mlx5_dw_off(typ, fld)) =3D \
>>         cpu_to_be32((be32_to_cpu(*((__be32 *)(p) + __mlx5_dw_off(typ, =
fld))) & \
>> -                    (~__mlx5_dw_mask(typ, fld))) | (((v) &
>> __mlx5_mask(typ, fld)) \
>> +                    (~__mlx5_dw_mask(typ, fld))) | (((_v) &
>> __mlx5_mask(typ, fld)) \
>>                      << __mlx5_dw_bit_off(typ, fld))); \
>>  } while (0)
>=20
> Ugh, that is ugly.
>=20
> This is better, it has proper type safety :|
>=20
> static inline _mlx5_set(__be32 *p, u32 dw_mask,
>                         u32 mask, u32 dw_off,
> 			unsigned int bit_off, u32 val)
> {
> 	*(p + dw_off) =3D cpu_to_b32((be32_to_cpu_p(p + dw_off) &
> 	             ~dw_mask) | ((val & mask) << bit_off));
> }
>=20
> #define MLX5_SET(typ, p, fld, v) \
> 	_mlx5_set(p, __mlx5_dw_mask(typ, fld),
> 	           __mlx5_mask(typ, fld),
> 	           __mlx5_dw_off(typ, fld),
> 		   __mlx5_dw_bit_off(typ, fld), v)
>=20
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

Dropped this patch and will wait for fixed up version from Mellanox.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--rCKSoLOsc9I8iXSWkEVDmWMBqtWfUkFNJ--

--TTnXsB84IkiPsQcmnBefSNM3Bre5OsdSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZN0AAoJELgmozMOVy/daGAP/io40Vh1DKwD/bju5p4Si9eO
wJ0vEb+FwAAwxeH2uiWzX8KLMHO7enZkSuBPaLhTu9L+pJc7AeJHZkgJD1W3MfJj
LG1kXdy9zeMinjCHqct2LeR0G6PUilCIT5JG6COgflbB+sa/ybWyR/gL59fP9rzc
jpvS7+lN4cxWU6fOwjW+KxAoT3/5s8yO9XmBJHELnfEJc5SCkXm0v+MMaV4vIbwN
wkJocf/2fkxy5xzXNd6N3Whkdzl/bIOPjHYu4WOUuAoaK1K+33OKcRnndeITS5DU
O0gWHq/vEEkeQMYQMsb+ZxHa6pSLfDCeRAFimn26+9mY6RcleKNHOFvWfoXqr8/C
JUCaNwJeWT6MeA+vBKp4iOiv5mhTUPm2gliD4JDIoEDHoFzBqDRHuhvdw5iMSu+A
Fwz/x2EhOfMbR241P3E8rbU/M6k5BvwuSVGsUj2mt6nUjxLz7KOrs+AY8rpw9gEd
3dW7G1wdTRn/wgrikW6Dm7bB37eB5OpDxz6eY0OrT0VVJGNFFlH2ocFJHgDacJi0
pXT6lwdbaiuQgIa/HSO3v6276y6Nbf2iTSdU+LoyOcDxg/WEde2NvXaiFc5sLScP
9FTTl2vNxSK5m5r17QLlHuoE7kNhylLrVg34HHx0iU/Kj5lw4ucHo95fe7fhr3K/
SDhEygO2zrbuemH59+XD
=Y5pZ
-----END PGP SIGNATURE-----

--TTnXsB84IkiPsQcmnBefSNM3Bre5OsdSu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
