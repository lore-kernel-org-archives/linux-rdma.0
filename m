From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Fixing segfault in libibverbs
Date: Fri, 27 May 2011 12:50:33 +0200
Message-ID: <1306493434.1835.4.camel@deela.quest-ce.net>
References: <OFC348E58C.B4C03447-ONC125789D.0035F094-C125789D.0036C4F7@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFC348E58C.B4C03447-ONC125789D.0035F094-C125789D.0036C4F7-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Animesh K Trivedi1 <ATR-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le vendredi 27 mai 2011 =C3=A0 11:58 +0200, Animesh K Trivedi1 a =C3=A9=
crit :
> Hi,
>=20
> This patch fixes SEGFAULT in libibverbs in case when there are no use=
r
> space drivers found. I've cloned the libibverbs from
> git://git.openfabrics.org/ofed_1_1_5/libibverbs.git (I hope this is
> correct)
>=20

I sent some patches a few month ago to address the same problems (and
others).

See thread "Hardenize libibverbs initialisation"
Message-Id: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

Link: http://thread.gmane.org/gmane.linux.drivers.rdma/7790

Regards

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
