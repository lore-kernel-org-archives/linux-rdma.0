From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] ib_srp: Avoid that LUN scanning creates duplicate devices
Date: Sat, 25 Jun 2011 07:02:13 -0400
Message-ID: <20110625110213.GA13273@infradead.org>
References: <201106251010.30994.bvanassche@acm.org>
 <20110625085843.GA3172@infradead.org>
 <BANLkTinuQKz9_uBZVDirNMaEH1WVRyMEnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTinuQKz9_uBZVDirNMaEH1WVRyMEnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 25, 2011 at 11:42:31AM +0200, Bart Van Assche wrote:
> The default for max_channel is already zero, so strictly speaking it
> is not necessary to set max_channel in srp_target_create(). I choose
> to set it anyway to make the intent clear that currently ib_srp only
> supports channel == 0 and id == 0.

You're right.  I'm not sure changing max_id is as easy - most SCSI
drivers are still for old SPI HBAs, so we'd need to update them all.
Eventually we should do it, though as most modern topologies don't
need the traditional sequential target scanning at all.  In fact
we shouldn't be using scsi_scan_host for them to start with.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
