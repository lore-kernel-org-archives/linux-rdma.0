From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libibverbs init.c: remove stderr warnings if no
 userspace driver found
Date: Sat, 09 May 2015 16:04:27 +0200
Message-ID: <1431180267.3617.5.camel@dworkin>
References: <1431109314-31662-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431109314-31662-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le vendredi 08 mai 2015 =C3=A0 11:21 -0700, Jeff Squyres a =C3=A9crit :
> Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

This is a little short for an explanation: what was the issue with the
error messages ?


> ---
>  src/init.c | 14 --------------
>  1 file changed, 14 deletions(-)
>=20
> diff --git a/src/init.c b/src/init.c
> index d0e4b1c..9c21768 100644
> --- a/src/init.c
> +++ b/src/init.c
> @@ -557,19 +557,5 @@ HIDDEN int ibverbs_init(struct ibv_device ***lis=
t)
>  	}
> =20
>  out:
> -	for (sysfs_dev =3D sysfs_dev_list,
> -		     next_dev =3D sysfs_dev ? sysfs_dev->next : NULL;
> -	     sysfs_dev;
> -	     sysfs_dev =3D next_dev, next_dev =3D sysfs_dev ? sysfs_dev->ne=
xt : NULL) {
> -		if (!sysfs_dev->have_driver) {
> -			fprintf(stderr, PFX "Warning: no userspace device-specific "
> -				"driver found for %s\n", sysfs_dev->sysfs_path);
> -			if (statically_linked)
> -				fprintf(stderr, "	When linking libibverbs statically, "
> -					"driver must be statically linked too.\n");
> -		}
> -		free(sysfs_dev);

I believe this free() was necessary to not leak some memory.

> -	}
> -
>  	return num_devices;
>  }


Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
