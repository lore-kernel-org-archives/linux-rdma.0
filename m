From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Avoid using uninitialized variable
Date: Tue, 7 Jul 2015 14:10:05 -0400
Message-ID: <1CC57EBD-887E-42CF-B042-484BC62CD8BE@redhat.com>
References: <1435228455-25862-1-git-send-email-sagig@mellanox.com> <558C0E97.5010204@sandisk.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_B51E0FC6-0C72-4801-A971-8B63700F1174"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <558C0E97.5010204-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_B51E0FC6-0C72-4801-A971-8B63700F1174
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


> On Jun 25, 2015, at 10:22 AM, Bart Van Assche =
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>=20
> On 06/25/15 03:34, Sagi Grimberg wrote:
>> We might return res which is not initialized. Also
>> reduce code duplication by exporting srp_parse_tmo so
>> srp_tmo_set can reuse it.
>=20
> Good catch.
>=20
> Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

Picked up for 4.2-rc, thanks!

=97
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_B51E0FC6-0C72-4801-A971-8B63700F1174
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVnBX9AAoJELgmozMOVy/dQsgP/2Z4A3Ga/3pOcT9f8Qi9a0RL
61KyKIJrTHz4tWhFqbk9s7raNG83Bo9E9yzATTSoApKl33ijUkL9CLR+99UzP5+q
YRucw2Vmstp4pijlMLIleguvyz8/WQOTWIm5zxG+dfIxfkUNNhAHpnNneWUX7Dr2
VGP65/mLtizshjP2j/u9RSTyirY2L4N6gvSbMoSNIBOFTVdikb0bb8Jj8BALroiS
XxoUG+0B6p3OM6wmMR4h2NsQTc3kKdooLcylvXzYVF4LHhf5v7dYesMppc4KDaV+
Ry7o5+uXAOCHTAnEUI+5hWqvJpUcS4ghJYQuor92WLemuEkGYrRqPlx/S3HeuttC
YjYd6UO4dWmeXx1zo1xfpxmxOO1TCI0SR4UtShwRhaVsBaYszJ51lSIMwEWMfWGm
xoL8SHtXV+7nIrw4i4hF1lXMXlr1g/5/1Raz0geeVP5mzucXDd3oldNPimcQ8ZvE
PcoGOt7H72TuBNTO/AOGcu5MlqqOaYRj2kUFHK29Tdx7WusFNaU0nWwsc0aKE5rd
ndoNcbQnD20oDo3Bzo2lGW08AM41/UWJymQpY/eJccwZ80Bn0RIXBWfC3v9MPQlY
eRHBRxPh9ogW4FLMSPVoFhKWGWL1mCeRrnlv7cB+zwKO5qwP8Fpz2Wfx7MsqEL8i
SIezFLV18d1nwRnurDy5
=wi19
-----END PGP SIGNATURE-----

--Apple-Mail=_B51E0FC6-0C72-4801-A971-8B63700F1174--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
