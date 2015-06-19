From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Upstream mlx4 driver very broken (when using SRIOV)
Date: Thu, 18 Jun 2015 20:57:25 -0400
Message-ID: <CFEE2FE0-21D6-469F-8B16-C211DED6BB45@redhat.com>
References: <557BC105.3070405@redhat.com> <CAJ3xEMi--ygFeYC12iiivXnbZLd=ox22fzt_f1+TFn7M0Emhug@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_3CBAE75B-970B-4752-8D89-DFFA248D9B71"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMi--ygFeYC12iiivXnbZLd=ox22fzt_f1+TFn7M0Emhug-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_3CBAE75B-970B-4752-8D89-DFFA248D9B71
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jun 14, 2015, at 10:31 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Sat, Jun 13, 2015 at 8:35 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>> I ran across a problem today when I went to do some run tests of my
>> for-4.2 tree.  For a second there, I was about to seriously have a
>> conniption fit.  But, after about 6 hours of work bisecting and
>> debugging, I've come to find that I wasn't so crazy after all.
>>=20
>> When I went to install my for-4.2 tree, IPoIB was totally busted, as =
in
>> DOA.  I knew the 4.1 code I submitted to Linus I had checked, but I
>> wanted to have a good starting point for a bisection so I compiled a
>> kernel from my for-4.1-rc branch.  And it was DOA too.  That =
seriously
>> unnerved me because I knew I tested that code.  I did a number of =
manual
>> checkouts at possible suspicious code points, and none of them showed
>> that the problem was resolved.  Then I started doing some debugging =
on
>> both the afflicted machine and on the opensm server.  I finally saw =
that
>> the afflicted machine was claiming that it was attempting to join the
>> multicast group, but was reporting error 110 (ETIMEDOUT).  The opensm
>> server was not seeing the requests at all.
>>=20
>> Long story short, I did my testing in the 4.1 merge window and rc =
phase
>> on machines without SRIOV enabled, but when you enable SRIOV in the =
mlx4
>> driver, the current driver seems to have broken QP0/QP1 multiplexing
>> support because the host becomes unable to join the IPoIB multicast
>> groups.  In addition, with SRIOV enabled, mlx4_en throws corruption
>> errors on reboot and requires that the machine be power cycled as
>> opposed to rebooting cleanly.  =46rom what I can tell, the 4.0 =
release
>> kernel has this problem too, and it still exists at least as far as
>> 4.1-rc7 + all of my queued up -next patches.
>>=20
>> =46rom my /etc/modprobe.d/mlx4.conf file if you want to try and =
duplicate:
>>=20
>> options mlx4_core probe_vf=3D0 num_vfs=3D7 port_type_array=3D1,2
>=20
> Doug,
>=20
> You were 100% right, due to recent FW bug SRIOV QP0/QP1 PV is broken
> with VPI config of IB/Eth (port_type_array=3D1,2), personally, I =
didn't
> step on it, since I moved my working environment to Eth/IB (2,1)
> couple of weeks ago, Oh well.
>=20
> The fix is easy, disable Granular VF QoS in that VPI config, I tested
> it and sent that now to net [1]
>=20
> We should check how come the upstream regression environment didn't
> catch that up.

Did this fix the mlx4_en shutdown issue too, or is there another patch =
needed for that?

> Or.
>=20
> [1] http://patchwork.ozlabs.org/patch/483991/
>=20
>> options mlx4_en pfctx=3D0x28 pfcrx=3D0x28
>>=20
>> And I'm guessing that your internal regression tests must not have a
>> machine in IB/Eth SRIOV mode as a standard config.  I would consider
>> adding it to the mix.  I have it myself, but only on a few machines =
and
>> I don't always use them for initial testing.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_3CBAE75B-970B-4752-8D89-DFFA248D9B71
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVg2j1AAoJELgmozMOVy/dsIIQAIFa2K5jyYDPFrGbTTvtQYW+
L+BpYWBieRBVUm8fTAQOx3XaN+gpczKVpHKq7scsmKeOLL7fpqL8lXRIP2Qfs6SY
tx2xn+rI2YHVlYJ7FUQrhrwToPrzlTZHzEslq8v3WUdFWSwpjoQ8FiPZnxfhXGFm
2o2SJ5eIURvXj8TbPphtj09Wg3V18YEU6aNT1u+f00ilXBXYzFV6i2Mcm8jakFw+
CvJ+Ban9f5ab+2AJ2wBss45O7ZcpGhKQ+0GiemHGypEINzFti5GEYywFDE/ziZ8P
M7i+1wkb4LaUt43SQXfc0r3g6nv1D0NK6S6Dc5IRxd7F/PrXePJRG0A4fp8mwHwU
KTWBzzxH2OmJudBOjZWsOvPSI43IB71eMBrEWO63IlD22a+ld0c7si3oNAQIlpxU
oUHSVc5B4PgQbc9sHRKQV0ySnsXJgbrNYGLHBPOmJiqtxubXiBk+hTAyxGVVbcxJ
7+nQth+hOQLBU7gvfBolZf8c+KrfvhSche0Wuc9lUeV82I8XqpC7tRP7asiBRJQE
iRglhE2GiuqH//Yxvdb1QxZEZTRbwpFIPLNDsh5iiReuK92gEhg1glRbN8gD0zG1
qfSIVnm2Wc23MsGbX6G/qQkkTYMpaz+22nQRpvwCH8ZZZSnOzwfwZ9DmC24sTC5V
daG1XhmKpCzxR9Ih9Dky
=P6L9
-----END PGP SIGNATURE-----

--Apple-Mail=_3CBAE75B-970B-4752-8D89-DFFA248D9B71--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
