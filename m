From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/ipoib: Scatter-Gather support in connected mode
Date: Mon, 11 May 2015 13:40:07 +0200
Message-ID: <1431344407.25060.29.camel@opteya.com>
References: <1431338642-22812-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431338642-22812-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le lundi 11 mai 2015 =C3=A0 03:04 -0700, Yuval Shaia a =C3=A9crit :
> By default, IPoIB-CM driver uses 64k MTU. Larger MTU gives better per=
formance.
> This MTU plus overhead puts the memory allocation for IP based packet=
s at 32
> 4k pages (order 5), which have to be contiguous.
> When the system memory under pressure, it was observed that allocatin=
g 128k
> contiguous physical memory is difficult and causes serious errors (su=
ch as
> system becomes unusable).
>=20
> This enhancement resolve the issue by removing the physically contigu=
ous memory
> requirement using Scatter/Gather feature that exists in Linux stack.
>=20
> With this fix Scatter-Gather will be supported also in connected mode=
=2E
>=20
> This change reverts the some of the change made in commit
> e112373fd6aa280bd2cbc0d5cc3809115325a1be
> ("IPoIB/cm: Reduce connected mode TX object size)".
>=20
> The ability to use SG in IPoIB CM is possible because the coupling
> between NETIF_F_SG and NETIF_F_CSUM was removed in commit
> ec5f061564238892005257c83565a0b58ec79295
> ("net: Kill link between CSUM and SG features.")
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v2: Enhance commit log message
>=20
> I'd like to thank John Sobecki <john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> and
> Christian Marie <christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org> for helping me with reviewing t=
his patch.
> I will be glad if you can ACK it.
>=20
> v3: Add an empty line to start a new paragraph and use 12 hex-digits =
identifier

Thanks, but you don't have to use the full commit identifier, 12
characters were enough.

Anyway, you haven't addressed the comments embedded in the patch in my
reply [1] to your v2 patch.

[1]
http://marc.info/?i=3D1431335754.25060.26.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
http://mid.gmane.org/1431335754.25060.26.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
