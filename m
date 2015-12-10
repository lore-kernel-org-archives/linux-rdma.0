From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Thu, 10 Dec 2015 09:58:51 +0200
Message-ID: <CAG9sBKPNWsO7ugdyhd5sYp_yOSrUkG0b-Lfq6Eenrydg3MzyvQ@mail.gmail.com>
References: <20151207060241.GA19038@obsidianresearch.com>
	<CAG9sBKO0rsSQK1WcyBciZEONWJsusw9GwR19H7FfAsebEH63dg@mail.gmail.com>
	<20151207063415.GB20066@obsidianresearch.com>
	<CAG9sBKMBt6Toa25Ouasr7hudAcOYrxZyBUFYMXzrMTFZvooWfQ@mail.gmail.com>
	<20151207171228.GA26969@obsidianresearch.com>
	<CAG9sBKNXnzp7PgJhfcjbYvje5qgZWYqygJYkbs4WyTZtDc4ckg@mail.gmail.com>
	<20151207184832.GA21402@obsidianresearch.com>
	<CAG9sBKNWMQA3XDGpDc_+2QoJcnnNL9o67p0JNoVqrU0u9UQCrA@mail.gmail.com>
	<20151208225251.GA27609@obsidianresearch.com>
	<CAG9sBKM2s9BMv8priCHnFaMcSnuafn4vf+6+0Rooc6Gw0ZSaLA@mail.gmail.com>
	<20151209180129.GD31636@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151209180129.GD31636-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>
>> A17.4.5.1 UD COMPLETION QUEUE ENTRIES (CQES)
>> For UD, the Completion Queue Entry (CQE) includes remote address
>> information (InfiniBand Specification Vol. 1 Rev 1.2.1 Section
>> 11.4.2.1). For RoCEv2, the remote address information comprises the
>> source L2 Address and a flag that indicates if the received frame is
>> an IPv4, IPv6 or RoCE packet.
>
> rdma_dgid_index_from_wc satisfies the above spec requirements without
How? Please explain.

> creating a horrible API, or requiring all vendors to implement a
> network type flag.
>
Actually you haven't suggested anything yet besides a name to the function.
I already said that calculating gid_index from wc and grh requires
extra CPU cycles and is prone to mistakes. But, I might be wrong and
you have a better idea. Do you?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
