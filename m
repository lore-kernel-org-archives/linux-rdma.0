From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Tue, 15 Nov 2011 00:03:50 +0000 (GMT)
Message-ID: <1321315430.19223.YahooMailNeo@web24701.mail.ird.yahoo.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com> <4EBF7F3C.2020804@dev.mellanox.co.il> <CAL1RGDV3X=vrCC4YCuUBRx9UwMQp0LfRG0y6Lh5z6hx4ROZ4yw@mail.gmail.com>
Reply-To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDV3X=vrCC4YCuUBRx9UwMQp0LfRG0y6Lh5z6hx4ROZ4yw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> On Sun, Nov 13, 2011 at 12:26 AM, Vladimir Sokolovsky
> <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>>  Try to update HCA's firmware to the latest version
>>  (http://www.mellanox.com/content/pages.php?pg=3Dfirmware_download).
>=20
> Independent of a firmware update, have you tried with an unpatched (u=
pstream)
> kernel?=A0 2.6.39.4 would be fine, or you could try 3.0 or 3.1.
>=20
> We shouldn't BUG no matter what FW version is burned on an HCA.

Hello Roland!

Yes, I've tested:
- OFED-1.5.3.2 with linux-2.6.39.4 (vanilla)
- OFED-1.5.3.2 with linux-2.6.38 (vanilla)
- OFED-1.5.4-rc4 with linux-2.6.39.4 (vanilla)

That's the original post:
http://thread.gmane.org/gmane.linux.drivers.rdma/10157

I want(ed) to test linux-3.1.1 (vanilla) but I had no time.
(I've tried to get MFT from Mellanox working - now I know I don't need =
it).
linux-3.1.1 will be the next I try while waiting for the new firmware.

Thanks for your answer!

Regards,
Lukas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
