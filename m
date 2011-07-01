From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [patch 37/44] rxe_sb8.c
Date: Fri, 1 Jul 2011 15:03:44 -0700
Message-ID: <CAL1RGDWLRw26RUr=WjUgzrn=6aGBukghoyOm5ordJv72mSsTBA@mail.gmail.com>
References: <20110701131821.928693424@systemfabricworks.com> <20110701132202.486466900@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110701132202.486466900-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 1, 2011 at 6:18 AM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> Slice by 8 implementation of CRC32.
> The code code is similar to the kernel provided crc32
> calculation except runs about 3X faster which allows us to
> get to ~1GB/sec.

Wouldn't the sane thing to do be to fix lib/crc32.c instead?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
