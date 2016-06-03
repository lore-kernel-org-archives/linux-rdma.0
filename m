From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix bit curruption in ib_device_cap_flags
 structure
Date: Fri, 3 Jun 2016 13:47:08 +0300
Message-ID: <20160603104708.GL7477@leon.nu>
References: <1464859685-18666-1-git-send-email-maxg@mellanox.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S6vg04ofUPzW4qJg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464859685-18666-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--S6vg04ofUPzW4qJg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2016 at 12:28:05PM +0300, Max Gurtovoy wrote:
> ib_device_cap_flags 64-bit expansion caused caps overlapping
> and made consumers read wrong device capabilities. For example
> IB_DEVICE_SG_GAPS_REG was falsely read by the iser driver causing
> it to use a non-existing capability. This happened because signed
> int becomes sign extended when converted it to u64. Fix this by
> casting IB_DEVICE_ON_DEMAND_PAGING enumeration to ULL.
>=20
> Fixes: fb532d6a79b9 ('IB/{core, ulp} Support above 32 possible device cap=
ability flags')

Everything fine, except this Fixes line, which is similar to the issue,
but unrelated. The sign extension error was produced after adding
bit(32) to the enum and the commit fb532d6a79b9 didn't do it and didn't
mean to do it.

--S6vg04ofUPzW4qJg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXUWAsAAoJEORje4g2clinlx8QAJLSPAezn+scVg1xrDh+XfdL
zU1Fu6b31OXBgzEuHqLmgBri2fOJjf29Ishm0vseke8WA/xTyCeuoO/Q917ioskx
zTo1QQr+W9KpF2/ID5xJ18mz2h2Qcmj2HREqt2PlAYQzrv45fBJtYTzIPyF3Udt7
n3gQpjBrUt/Ze0Q0JV73pUVdGorTuDp2YwtY3ykAWHMJUsmApw285ukOzvVUIj2L
UuVnwPkBt42feemylVfhKqgjtJXjuZHeHuKQNgc69DhvWQQS6Xd+shAZABOn1OzI
7M/Lpzphj3sXySmlLGuyD0IcjFX4CLX4dyG3Cu9EuoHN66wFLD66NtBS4cf5vRcy
x8WW2u7rpcPWjBvW5wpma/0hXs9PHR+Ly19aJmMXUpZVPCWKU6cwxNTw83s1xwEh
Xs+40VdvlwHjC9E0BNZvNK/Y5Mi/sNyD7N7oYZ/5I+kcY3kMv9YEQv42+h2oYlQy
K9l1X968X/0jV2ZU1O/ExAoNAn1sWAMKWqQwttJ24b5zzcfiG0W5+rZM8rBCrch0
ejgxx+AmKpc4zIEG8uTjyt7mepnLlCUj79v699Mr/2eiqPAo/HXUMy7cZxcj0pgd
5Keo9aumCIQmWVtM19uEoxJWMjFdWFWkg2l3JXPBU0Bf7dNT+N17WXB0Hu1bnP6k
/7lpLPbJIPLTDucxhSim
=+hAI
-----END PGP SIGNATURE-----

--S6vg04ofUPzW4qJg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
