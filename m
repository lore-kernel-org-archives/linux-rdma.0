From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Work completion error: "transport retry counter exceeded"
Date: Thu, 26 Jul 2012 10:45:00 -0700
Message-ID: <CAL1RGDVwy56YL7OLxVuvap5WZRzzZsosQmKBkhWZB73uy3ysDg@mail.gmail.com>
References: <20120725190719.475605dc169353b775cd3463@llnl.gov>
 <CAL1RGDWmpHy43b5TarBWpUk1RXOEdNitXWE4+xRCspgfpwUisQ@mail.gmail.com> <CALfB72Ad4+R48Nc-kawsrk1JQo964OkJ6DE46mcR5b9pS2_hEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALfB72Ad4+R48Nc-kawsrk1JQo964OkJ6DE46mcR5b9pS2_hEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I wonder if I might be seeing the same thing...
>
> How does one choose a good value for this setting?
>
> Apparently it maps to 4.096 x 2 ^ attr.timeout microseconds.
>
> What's the maximum value one can set here?
>
> What can go wrong if one goes for the maximum value?

In theory you want a timeout of around 2 * max packet life in the fabric
(ie max RTT) plus max remote HCA ack time (reported in device properties).

Max value is 31, which maps to a few hours.  If you choose that, then
a single lost packet will stall your connection for many hours (if you
choose 7 retries) before reporting an error.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
