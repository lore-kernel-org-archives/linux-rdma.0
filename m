From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Tue, 15 Nov 2011 12:59:05 -0800
Message-ID: <CAL1RGDXa8hy-Hg-eauj3NbPv=YsFjpQkNq1fTF1qpE7cdhRdng@mail.gmail.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com>
 <4EBF7F3C.2020804@dev.mellanox.co.il> <CAL1RGDV3X=vrCC4YCuUBRx9UwMQp0LfRG0y6Lh5z6hx4ROZ4yw@mail.gmail.com>
 <1321315430.19223.YahooMailNeo@web24701.mail.ird.yahoo.com>
 <CAL1RGDVas0srOARofFV2e9=9_5z+VTTpa1k+Eh532xxGVC0uyw@mail.gmail.com>
 <CAL1RGDWNJrbVkTTQ9sDod_x5H6FBEWkyqXT=--TomX1DhTRSmA@mail.gmail.com> <1321387415.58210.YahooMailNeo@web24716.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321387415.58210.YahooMailNeo-HXL2TcxrD9byX4RqAA4FmIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 15, 2011 at 12:03 PM, Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org> wrote:
>> Actually where is your mlx4 driver coming from?=A0 The upstream kern=
el or OFED?
>
> It comes from OFED.

If it's possible, it would be useful to try with the vanilla kernel
and all upstream
modules too.  Otherwise I can't rule out the possiblity that we're chas=
ing a
bug that OFED introduces.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
