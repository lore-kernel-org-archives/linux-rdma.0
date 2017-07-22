From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/iser: Handle lack of memory management extentions
 correctly
Date: Sat, 22 Jul 2017 13:15:57 -0400
Message-ID: <2dadd0cf-5435-5a5d-b85b-9d46f896b03b@redhat.com>
References: <20170622190110.27788.19910.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qUVvIKAF5N84FjF8dmq39U8iFBmS45Ic5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170622190110.27788.19910.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qUVvIKAF5N84FjF8dmq39U8iFBmS45Ic5
Content-Type: multipart/mixed; boundary="NtdL4DaOovUskuxjkgbHrAaKcwpVW50Jc";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <2dadd0cf-5435-5a5d-b85b-9d46f896b03b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/iser: Handle lack of memory management extentions
 correctly
References: <20170622190110.27788.19910.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
In-Reply-To: <20170622190110.27788.19910.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>

--NtdL4DaOovUskuxjkgbHrAaKcwpVW50Jc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/22/2017 3:01 PM, Mike Marciniszyn wrote:
> max_fast_reg_page_list_len is only valid when the
> memory management extentions are signaled by the underlying
> driver.
>=20
> Fix by adjusting iser_calc_scsi_params() to use
> ISCSI_ISER_MAX_SG_TABLESIZE when the extentions are not indicated.
>=20
> Reported-by: Thomas Rosenstein <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>
> Fixes: Commit df749cdc45d9 ("IB/iser: Support up to 8MB data transfer i=
n a single command")
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This was accepted in 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--NtdL4DaOovUskuxjkgbHrAaKcwpVW50Jc--

--qUVvIKAF5N84FjF8dmq39U8iFBmS45Ic5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4hNAAoJELgmozMOVy/dv7wP/iAMntM7S3iaNxlJr2m+0A31
MTO92QIbSkzlTiQYAtXo62cHWZIZ9orz+843CZzWUUTOui0TgRWhvv2CIGt86zUf
bCOmJuuBzQN4ZX50K172kvqwi5Da6rDxg6zqiat7zLL+0uFOYei+4QwD0J/ZVxWG
F9VMHKooRuFb2HyD6B8GDG3e8jxeSzgwG7M8hzByT0nvLMaw6SKx46Jsl+Eo0GrT
bwv/Ubarcsdvdc9YdOTv5A0ZeOIsAJXhYzu6eQdy2oPRa8fkwhYc5Euwxf23zJcC
jtEgyZ+Nu/j7p98RP8wCxFzv6k/TSibTB1DIvMuySGOUTVuR059Fau7UNrtumrZh
ZvMHMOeVtHQdn08hKRsa1m62wzdXHtqX+Imin0QvpYn4QBK+1v7jamjTnB0hro1d
I7VYXqpN+B0KJ05e+Vkfen8vDU/XlhaPPzGP0W7AXljIML1d5/0HcxARpOf2xK4t
DNYF7EU4f1a42petAeqgZEC7eF+6Nn/yZvu4SFzLj2VHi24lbMv58I8c3SllDCWb
4H4QjjX31BYqfuhoY6+NlAXcBfHB/K+RbHlFJ+G1g8am3xRX9bKLdFjCLExC2rHV
M0DW9rvE5gSYdUsUTcFZ2WT5Rx2+AuBdT09OQ/fth2rfjbHpMcgl6dVVoIOHF09x
/5HPUfR7wjqPFnVgb9xy
=lGNL
-----END PGP SIGNATURE-----

--qUVvIKAF5N84FjF8dmq39U8iFBmS45Ic5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
