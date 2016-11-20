From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] rxe: Remove perl::switch module dependancy
Date: Sun, 20 Nov 2016 16:33:27 +0200
Message-ID: <20161120143327.GD4946@leon.nu>
References: <1479286006-5265-1-git-send-email-yonatanc@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8nsIa27JVQLqB7/C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1479286006-5265-1-git-send-email-yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8nsIa27JVQLqB7/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 16, 2016 at 10:46:46AM +0200, Yonatan Cohen wrote:
> Remove perl::switch dependency from RXE, since it is
> not installed by default.
>
> Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.
https://github.com/linux-rdma/rdma-core/pull/40

--8nsIa27JVQLqB7/C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYMbQ3AAoJEORje4g2clindfMQALdz4aMk6iVHlO+KSUKGQl1t
2TG2ErAG/zH87ke1AQJ6vWOh+RI6+vaBLVyY7fBmgzk8pq0pziRf+qOaes8WcK5+
3Su2NVzn4wLx7///bqQtQMSd+gKwXrjChh7QybGPc3loHkuyvcuFQX2UoZokpe6P
UTs2c5tLMaccsOoSf2RVksoub6tAE4/oPsZwi8z21xV441z9zlTa6rwnmX0YVkAL
DIo7FXBvfMTKhYTqdGivhhIQ4iZisW8sm/DrzRVbq9W6Jp3sSRnGUKGbb9h+T7XL
xps9EC3c0xWGXQPPHQODOKw9r0GfKuue0Mivt7TQQimLVsTX41KxSuWXn8HlGqL0
u3zgH+5LVccnTv5w/FC6BoCXRydFUkgD+/Qzn7YvN0C/+pGiOgm0NKmlDSRW2ZsP
LvD4zzspRKbS4Qcfhk/qBSMirMn0jWd4Lpq44MpFSf9d5MuizDBdg/44P2P1hH1x
8PTaI2V/dGDrMk+PsZgBiFIxViALugvwFf17YgTyw9D37aDsfhLmtMP6up7IKJhK
3P2T8CcFC2Yxtz9oRSxGqkO5wYqFgneoO8LEz4JCsYKBMH9MWgHzeg9fmR9Lo7gd
GMFHygtrrfw1mImXEJ3aykX0Zlv6pgj2CvjtCbmf85wwQ/Ki5IO7/JNejUGE5GTP
4XNntlgPwSQX3aS//iDw
=v3Wp
-----END PGP SIGNATURE-----

--8nsIa27JVQLqB7/C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
