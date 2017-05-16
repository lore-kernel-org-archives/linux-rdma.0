From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iSER with policy based routing error
Date: Tue, 16 May 2017 11:39:45 -0600
Message-ID: <CAANLjFq_KsPhiXVzfTG3A9-7OR05AV+JYwsjviZ7GB6jXFkNHQ@mail.gmail.com>
References: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
 <71232433-a3d1-1bc0-a995-ae32fc05913f@grimberg.me> <CAANLjFogRE3ShHoUtGG1DPt5VzxBe8SBOAL86xc+AebQLBomJg@mail.gmail.com>
 <5441f53c-f81f-b5d6-3c05-0bbe141f152e@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5441f53c-f81f-b5d6-3c05-0bbe141f152e-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 16, 2017 at 1:19 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>
>> We are getting errors with rping too, even on the same IPv4 subnet. All
>> RDMA programs seem to be failing. It is like there is a missing library
>> or something. We installed "Infiniband Support" group install, so I'm
>> not sure what could be missing.
>
>
> I assume you are running a custom kernel? This looks like a ABI
> breakage.

This is a custom kernel. I just built 4.9.28 this morning and made
sure to install the uAPI headers (make headers_install
INSTALL_HDR_PATH=/usr). Is there something that I'm missing? Do I need
to rebuild rping/libibverbs/etc?

Thanks

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
