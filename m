From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Mon, 14 Nov 2011 15:23:55 -0800
Message-ID: <CAL1RGDV3X=vrCC4YCuUBRx9UwMQp0LfRG0y6Lh5z6hx4ROZ4yw@mail.gmail.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com> <4EBF7F3C.2020804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EBF7F3C.2020804-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 13, 2011 at 12:26 AM, Vladimir Sokolovsky
<vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Try to update HCA's firmware to the latest version
> (http://www.mellanox.com/content/pages.php?pg=firmware_download).

Independent of a firmware update, have you tried with an unpatched (upstream)
kernel?  2.6.39.4 would be fine, or you could try 3.0 or 3.1.

We shouldn't BUG no matter what FW version is burned on an HCA.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
