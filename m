From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH librdmacm 1/3] man: =?UTF-8?Q?rdma=5Fpost=5F*=28=29=3A?=
 =?UTF-8?Q?=20memory=20region=20is=20optional=20only=20with=20IBV=5FSEND?=
 =?UTF-8?Q?=5FINLINE=2E?=
Date: Sat, 17 Aug 2013 15:51:13 +0200
Message-ID: <fd8def92cb459f75e4e9732497808348@meuh.org>
References: <cover.1376746185.git.ydroneaud@opteya.com>
 <dfe767c849fc9472bd87c723c401052b89d40d7c.1376746185.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dfe767c849fc9472bd87c723c401052b89d40d7c.1376746185.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Le 17.08.2013 15:38, Yann Droneaud a =C3=A9crit=C2=A0:
> State explicitly when MR argument is optional.
>=20
> MR should be a mandatory argument to rdma_post_*() functions.
>=20
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> ---

=2E..

>  man/rdma_post_ud_send.3 | 2 +-

=2E..

> diff --git a/man/rdma_post_ud_send.3 b/man/rdma_post_ud_send.3
> index f8e2ada..dd40b8a 100644
> --- a/man/rdma_post_ud_send.3
> +++ b/man/rdma_post_ud_send.3
> @@ -24,7 +24,7 @@ The address of the memory buffer to post.
>  .IP "length" 12
>  The length of the memory buffer.
>  .IP "mr" 12
> -Optional registered memory region associated with the posted buffer.
> +Registered memory region associated with the posted buffer. Optional
> if IBV_SEND_INLINE_FLAG is used.

s/_FLAG/ flag/


--=20
Yann Droneaud

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
