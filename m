From: Vinson Lee <vlee-CC+yJ3UmIYqDUpFQwHEjaQ@public.gmane.org>
Subject: =?UTF-8?B?bGludXgtbmV4dCBidWlsZCBlcnJvciAiY2FsbCB0byDigJhfX2NvbXBpbGV0aW1lX2Fzcw==?=
	=?UTF-8?B?ZXJ0XzM0MeKAmSBkZWNsYXJlZCB3aXRoIGF0dHJpYnV0ZSBlcnJvcjogQlVJTERfQlVHX09OIGZhaWxl?=
	=?UTF-8?B?ZDogX19tbHg1X2JpdF9vZmYobWFuYWdlX3BhZ2VzX291dCwgcGFzW2ldKSAlIDY0Ig==?=
Date: Tue, 16 Aug 2016 11:57:23 -0700
Message-ID: <CACKvgLHp0jc_0drhk2u7GChhZkwBXhA0ps55=+J8NXp=u7u7Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi.

Commit a533ed5e179c "net/mlx5: Pages management commands via mlx5 ifc"
introduced this build error with GCC 4.4.

  CC [M]  drivers/net/ethernet/mellanox/mlx5/core/pagealloc.o
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c: In function
=E2=80=98reclaim_pages_cmd.clone.0=E2=80=99:
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:341: error: call
to =E2=80=98__compiletime_assert_341=E2=80=99 declared with attribute error=
:
BUILD_BUG_ON failed: __mlx5_bit_off(manage_pages_out, pas[i]) % 64
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c: In function =E2=80=98g=
ive_pages=E2=80=99:
drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:290: error: call
to =E2=80=98__compiletime_assert_290=E2=80=99 declared with attribute error=
:
BUILD_BUG_ON failed: __mlx5_bit_off(manage_pages_in, pas[i]) % 64
make[5]: *** [drivers/net/ethernet/mellanox/mlx5/core/pagealloc.o] Error 1

Cheers,
Vinson
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
