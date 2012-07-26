From: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Work completion error: "transport retry counter exceeded"
Date: Thu, 26 Jul 2012 14:21:58 +0200
Message-ID: <CALfB72Ad4+R48Nc-kawsrk1JQo964OkJ6DE46mcR5b9pS2_hEA@mail.gmail.com>
References: <20120725190719.475605dc169353b775cd3463@llnl.gov> <CAL1RGDWmpHy43b5TarBWpUk1RXOEdNitXWE4+xRCspgfpwUisQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWmpHy43b5TarBWpUk1RXOEdNitXWE4+xRCspgfpwUisQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello

On Thu, Jul 26, 2012 at 9:15 AM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> On Wed, Jul 25, 2012 at 7:07 PM, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:
>>         attr.timeout         = 14;
> Is this timeout sufficient to account for the round trip on
> the fabric and the ack delay on the remote HCA?
> I don't think there are any other attributes that would affect
> getting transport retries.

I wonder if I might be seeing the same thing...

How does one choose a good value for this setting?

Apparently it maps to 4.096 x 2 ^ attr.timeout microseconds.

What's the maximum value one can set here?

What can go wrong if one goes for the maximum value?

Regards

Albert
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
