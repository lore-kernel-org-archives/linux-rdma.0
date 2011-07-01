From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [patch 37/44] rxe_sb8.c
Date: Fri, 1 Jul 2011 18:09:10 -0500
Message-ID: <000601cc3843$e3854cb0$aa8fe610$@systemfabricworks.com>
References: <20110701131821.928693424@systemfabricworks.com> <20110701132202.486466900@systemfabricworks.com> <CAL1RGDWLRw26RUr=WjUgzrn=6aGBukghoyOm5ordJv72mSsTBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWLRw26RUr=WjUgzrn=6aGBukghoyOm5ordJv72mSsTBA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Perhaps. We have some ICRC specific APIs as well as plain Jane CRC
calculation that includes a copy at the same time.
If I knew who maintained crc32.c I would be happy to talk to them and see
what they think. The reason I wrote this
Is that crc32.c takes about 6 clocks per byte and this one takes < 2 clocks
per byte. We couldn't get over 200-300 MB/sec
With crc32.c and this algorithm was hitting 900MB/sec. Sandy Bridge has a
generic CRC instruction that should be able to
Reduce the time to nothing on top of a copy I have heard.

Bob

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
Sent: Friday, July 01, 2011 5:04 PM
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [patch 37/44] rxe_sb8.c

On Fri, Jul 1, 2011 at 6:18 AM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> Slice by 8 implementation of CRC32.
> The code code is similar to the kernel provided crc32 calculation 
> except runs about 3X faster which allows us to get to ~1GB/sec.

Wouldn't the sane thing to do be to fix lib/crc32.c instead?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
