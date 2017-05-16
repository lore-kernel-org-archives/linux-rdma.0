From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: iSER with policy based routing error
Date: Tue, 16 May 2017 10:19:17 +0300
Message-ID: <5441f53c-f81f-b5d6-3c05-0bbe141f152e@grimberg.me>
References: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
 <71232433-a3d1-1bc0-a995-ae32fc05913f@grimberg.me>
 <CAANLjFogRE3ShHoUtGG1DPt5VzxBe8SBOAL86xc+AebQLBomJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFogRE3ShHoUtGG1DPt5VzxBe8SBOAL86xc+AebQLBomJg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> We are getting errors with rping too, even on the same IPv4 subnet. All
> RDMA programs seem to be failing. It is like there is a missing library
> or something. We installed "Infiniband Support" group install, so I'm
> not sure what could be missing.

I assume you are running a custom kernel? This looks like a ABI
breakage.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
