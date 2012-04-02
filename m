From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/core: add missing string for the display of SDR
 rates in sysfs
Date: Mon, 2 Apr 2012 10:42:05 -0700
Message-ID: <CAL1RGDUCO+ijdYyaPsx7X9eYssj-qDEqeYm-gSAY30NwYo1Qpg@mail.gmail.com>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com> <1333377921-8349-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1333377921-8349-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 2, 2012 at 7:45 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrot=
e:
> =A0 =A0 =A0 =A0switch (attr.active_speed) {
> =A0 =A0 =A0 =A0case IB_SPEED_SDR:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 speed =3D " SDR";
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rate =3D 25;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case IB_SPEED_DDR:

I don't think we want this -- old kernels didn't print "SDR" so I think
we shouldn't change the interface at this point.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
