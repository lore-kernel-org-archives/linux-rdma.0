From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for -next v2 6/7] IB/core: extended command: an improved
 infrastructure for uverbs commands
Date: Fri, 08 Nov 2013 11:01:05 +0100
Message-ID: <956216e98357e13fd39cf8ed3dd0cc2a@meuh.org>
References: <cover.1383773832.git.ydroneaud@opteya.com>
 <2c3b64e8b42c3bd7434b03e3439c58df874992f2.1383773832.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2c3b64e8b42c3bd7434b03e3439c58df874992f2.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

It seems that even after so many iterations,
I failed to provide a "perfect" patch.

Le 06.11.2013 23:21, Yann Droneaud a =C3=A9crit=C2=A0:

> diff --git a/drivers/infiniband/core/uverbs_cmd.c
> b/drivers/infiniband/core/uverbs_cmd.c
> index 19f14d8..8ea9aa5 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -2823,7 +2819,7 @@ ssize_t ib_uverbs_destroy_flow(struct
> ib_uverbs_file *file,
>=20
>  	put_uobj(uobj);
>=20
> -	return ret ? ret : in_len;
> +	return ret ? ret : 0;
                ^^^^^^^^^^^^^^

What a complicated way to mean

+	return ret;

>  }
>  #endif /* CONFIG_INFINIBAND_EXPERIMENTAL_UVERBS_FLOW_STEERING */
>=20

Will roll a v3 if Roland have not yet picked the patchset.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
