From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add a rate based mechanism for SMP transactions
Date: Wed, 2 Jun 2010 18:31:06 +0300
Message-ID: <20100602153106.GG28549@me>
References: <20091216151115.GA22639@comcast.net>
 <20100601153234.GR28549@me>
 <AANLkTimDPaT0m-2Qa-0dTpng5FmQRhzUhpiBWFdxwGsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimDPaT0m-2Qa-0dTpng5FmQRhzUhpiBWFdxwGsQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06:58 Wed 02 Jun     , Hal Rosenstock wrote:
> 
> I had started with an algorithm along these lines but evolved towards
> the proposed one based on CPU utilization. An algorithm along the
> lines of the above wastes CPU (when "idling" and other times) which
> significantly impacts any other apps running.

So what are you saying? To skip this patch until better implementation?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
