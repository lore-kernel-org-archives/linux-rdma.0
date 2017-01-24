From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5] qedr: remove CQ spinlock from RDMA CM completion
 handlers
Date: Tue, 24 Jan 2017 12:16:16 +0200
Message-ID: <20170124101616.GC6005@mtr-leonro.local>
References: <1485185187-18689-1-git-send-email-Ram.Amrani@qlogic.com>
 <1485185187-18689-4-git-send-email-Ram.Amrani@qlogic.com>
 <20170123191313.GB6005@mtr-leonro.local>
 <SN1PR07MB2207B69B469AC2113C757E6CF8750@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="R+My9LyyhiUvIEro"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB2207B69B469AC2113C757E6CF8750-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--R+My9LyyhiUvIEro
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 24, 2017 at 09:02:55AM +0000, Amrani, Ram wrote:
> > Don't you need to remove this lock from struct qedr_cq too?
>
> The CQ lock has other uses so it cannot be deleted.

What do I miss here?

Your patch removed all usages of this lock.

=E2=9E=9C  linux-rdma git:(master) grep -rI comp_handler_lock drivers/infin=
iband/hw/qedr/*
drivers/infiniband/hw/qedr/qedr_cm.c: spin_lock_irqsave(&cq->comp_handler_l=
ock, flags);
drivers/infiniband/hw/qedr/qedr_cm.c: spin_unlock_irqrestore(&cq->comp_hand=
ler_lock, flags);
drivers/infiniband/hw/qedr/qedr_cm.c: spin_lock_irqsave(&cq->comp_handler_l=
ock, flags);
drivers/infiniband/hw/qedr/qedr_cm.c: spin_unlock_irqrestore(&cq->comp_hand=
ler_lock, flags);
drivers/infiniband/hw/qedr/qedr.h:	spinlock_t comp_handler_lock;


>
> Thanks,
> Ram
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--R+My9LyyhiUvIEro
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliHKXAACgkQ5GN7iDZy
WKcESA//f54iwGstD7DrhKRXF9Blq4CX+wURE5ojbgsC/zHFKdlzjNxHcVSMDLvF
Tql1Hz+/RTXT+lUOMHaFu/dAOJqcOTti9zgjFgu2s7gxY8Rzn4tZKhZDrwgkt6V4
PGdxGCWdQNm6RTLws7aT33fJLQjaLn0BS6MiF0C7vwikRZ3ApfASrpoDRdqWXOvC
TF3slJOQbmTSE6g0fP4kin9NO4uanJu3T2q1EAmuyONCfA618mHVFSYFhyvD750n
I30dbRQlWK81CUIfjUkM2Dg1kyqiN7XNUEj68nRRGotfonZWwxFtJgLMBUFosNPZ
ZK9uW1DmazoRh0Rzub124vYDfF0jSo4eZqNkANNAnZolCC6WHJGh3PigmadOnS+O
i4HzQapazxKdH5Z3wCyIUWyVGHp4N7gaXT1yZfyW6J1zcRR0rdC7CLkgwqIcUrYS
iwXWMP/GQuPlFpLYKmg7bPHGvt/QbqYwXX3mErmOVYMS8vbeqP/SmbPKklVDDBNs
4Jm5wNvLlIlHPUbGrgMZu12ikofT4OYKoRrxvhme4Q50+vamfvgDYkdxD1QcqTrf
gKjnuDZqEqCYI+2HAnxoPOvHV+NiKPLrARqwdZizzw5iFJRkwzKxQinVwQAgpA6o
qOWKFCLdb9rvnsPeCMQkTf+MwfMFw2X9xro3XX4B2YMfIY5tM1g=
=i1Es
-----END PGP SIGNATURE-----

--R+My9LyyhiUvIEro--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
