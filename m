From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Tue, 15 Nov 2011 11:47:44 -0800
Message-ID: <CAL1RGDWNJrbVkTTQ9sDod_x5H6FBEWkyqXT=--TomX1DhTRSmA@mail.gmail.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com>
 <4EBF7F3C.2020804@dev.mellanox.co.il> <CAL1RGDV3X=vrCC4YCuUBRx9UwMQp0LfRG0y6Lh5z6hx4ROZ4yw@mail.gmail.com>
 <1321315430.19223.YahooMailNeo@web24701.mail.ird.yahoo.com> <CAL1RGDVas0srOARofFV2e9=9_5z+VTTpa1k+Eh532xxGVC0uyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVas0srOARofFV2e9=9_5z+VTTpa1k+Eh532xxGVC0uyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 15, 2011 at 11:10 AM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> Sorry, I missed the "vanilla" in your original email and just saw "OFED".
>
> Anyway yes, looks like a bug in the mlx4 driver.

Actually where is your mlx4 driver coming from?  The upstream kernel or OFED?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
