From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: avoid destroying a NULL mr in reg_user_mr error
 flow
Date: Thu, 3 Sep 2015 14:43:31 -0400
Message-ID: <55E894D3.70600@redhat.com>
References: <1441089671-3390-1-git-send-email-haggaie@mellanox.com>
 <1441090616-20640-1-git-send-email-haggaie@mellanox.com>
 <55E55C7A.2090602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ogdpKOgc3olMMO50Brnsou7V8fIC9wHBS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E55C7A.2090602-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ogdpKOgc3olMMO50Brnsou7V8fIC9wHBS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/01/2015 04:06 AM, Sagi Grimberg wrote:
> On 9/1/2015 9:56 AM, Haggai Eran wrote:
>> The mlx5_ib_reg_user_mr() function will attempt to call clean_mr() in
>> its error flow even though there is never a case where the error flow
>> occurs with a valid MR pointer to destroy.
>>
>> Remove the clean_mr() call and the incorrect comment above it.
>>
>> Fixes: b4cfe447d47b ("IB/mlx5: Implement on demand paging by adding
>> support for MMU notifiers")
>> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ogdpKOgc3olMMO50Brnsou7V8fIC9wHBS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6JTTAAoJELgmozMOVy/dcGQQALISfWFYU89fZCyZWTDAE1q+
i3cjB6rkuQgFSQlV7CtkDoPIQDUZs6C6fbFqsGlWe6URJeZ2XI4m/rHsYrLCjY3w
SHCenCNC7FMWMbhmHt8YSBXQKQhW5ZKPB6dhVsXJS3M9/dmKQrTv/70prXuyamYN
brDBLw0vgERvFDQN9hHXhfIWMhcHMeA1i0DspztwDLl/xTQKxl3MzuQMl6MMwwsg
ULwExXemUo4i4i0zAAXDDE+Xti6jLlZ1xjanPxgI0EwZu1kEIinUdJ0o7jDMoNpj
mTlsTMjAlw7bcXZstJYv+aie35oTp0Ay51vZHP715YIXXuNoTA33zAzPdkV9oLFp
kwWFWal8E2Vhpx/gCOrGSSSMm6elahNzxoOfwyJjRV+fLw4atZZJ9dhZFps3chtZ
CmkU1kYjm6Jl1IAwQfKdlJ6ywhlaw3CKgoeS12JnDAW+3z7308rt/4XNmwd/1r1J
N0MWXc+EHX4FpRpU2iQPjMDwGcJMW5/zsst3KMo2Qlc0ZFkdVuB+EVf7RWZyUwIA
HFoCcAuk1ypi3OJDmTZKiyBXYvs9PL/tpUhtovmivbQVn5p84MFlVpAyA2fF6IRV
QZUeScFfEmlBeZt6Bu2yAMed9oowOu1fhEG5rWAB1VjlVYpsTbKSR+FOxI8X6OAU
VptaAavN5CaVZk/pjzcG
=GsC/
-----END PGP SIGNATURE-----

--ogdpKOgc3olMMO50Brnsou7V8fIC9wHBS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
