From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/ipoib: Scatter-Gather support in connected mode
Date: Tue, 12 May 2015 09:08:16 +0300
Message-ID: <20150512060815.GA2668@yuval-lab>
References: <1431338642-22812-1-git-send-email-yuval.shaia@oracle.com>
 <1431344407.25060.29.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431344407.25060.29.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 11, 2015 at 01:40:07PM +0200, Yann Droneaud wrote:
> Hi,
>=20
> Le lundi 11 mai 2015 =E0 03:04 -0700, Yuval Shaia a =E9crit :
> > By default, IPoIB-CM driver uses 64k MTU. Larger MTU gives better p=
erformance.
> > This MTU plus overhead puts the memory allocation for IP based pack=
ets at 32
> > 4k pages (order 5), which have to be contiguous.
> > When the system memory under pressure, it was observed that allocat=
ing 128k
> > contiguous physical memory is difficult and causes serious errors (=
such as
> > system becomes unusable).
> >=20
> > This enhancement resolve the issue by removing the physically conti=
guous memory
> > requirement using Scatter/Gather feature that exists in Linux stack=
=2E
> >=20
> > With this fix Scatter-Gather will be supported also in connected mo=
de.
> >=20
> > This change reverts the some of the change made in commit
> > e112373fd6aa280bd2cbc0d5cc3809115325a1be
> > ("IPoIB/cm: Reduce connected mode TX object size)".
> >=20
> > The ability to use SG in IPoIB CM is possible because the coupling
> > between NETIF_F_SG and NETIF_F_CSUM was removed in commit
> > ec5f061564238892005257c83565a0b58ec79295
> > ("net: Kill link between CSUM and SG features.")
> >=20
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> > v2: Enhance commit log message
> >=20
> > I'd like to thank John Sobecki <john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> and
> > Christian Marie <christian-x8YiTEMPTCFhl2p70BpVqQ@public.gmane.org> for helping me with reviewing=
 this patch.
> > I will be glad if you can ACK it.
> >=20
> > v3: Add an empty line to start a new paragraph and use 12 hex-digit=
s identifier
>=20
> Thanks, but you don't have to use the full commit identifier, 12
> characters were enough.
Will do.
>=20
> Anyway, you haven't addressed the comments embedded in the patch in m=
y
> reply [1] to your v2 patch.
Changing comments was quite easy, the rest will take a bit more, v4 wil=
l address it.
>=20
> [1]
> http://marc.info/?i=3D1431335754.25060.26.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> http://mid.gmane.org/1431335754.25060.26.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
>=20
> Regards.
>=20
> --=20
> Yann Droneaud
> OPTEYA
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
