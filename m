From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Thu, 10 Dec 2015 09:53:24 +0200
Message-ID: <CAG9sBKM-uYvesintoti3JLc9y+fRx1wRNtt5OfcBRc=ASEhnPQ@mail.gmail.com>
References: <20151207060241.GA19038@obsidianresearch.com>
	<CAG9sBKO0rsSQK1WcyBciZEONWJsusw9GwR19H7FfAsebEH63dg@mail.gmail.com>
	<20151207063415.GB20066@obsidianresearch.com>
	<CAG9sBKMBt6Toa25Ouasr7hudAcOYrxZyBUFYMXzrMTFZvooWfQ@mail.gmail.com>
	<20151207171228.GA26969@obsidianresearch.com>
	<CAG9sBKNXnzp7PgJhfcjbYvje5qgZWYqygJYkbs4WyTZtDc4ckg@mail.gmail.com>
	<20151207184832.GA21402@obsidianresearch.com>
	<CAG9sBKNWMQA3XDGpDc_+2QoJcnnNL9o67p0JNoVqrU0u9UQCrA@mail.gmail.com>
	<20151208225251.GA27609@obsidianresearch.com>
	<HE1PR05MB1418B1F0F393AD0D92424043B1E80@HE1PR05MB1418.eurprd05.prod.outlook.com>
	<20151209180920.GE31636@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151209180920.GE31636-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> No, I am defining an API that *make sense* and doesn't leak useless
> details. Of course that doesn't force code duplication or anyhting
> like that, just implement it smartly.
>
> I think mlx made a big mistake returning network_type instead of gid
> index, and I don't want to see that error enshrined in our API.
>
returning gid_index is wrong because it forces CQ pollers to be aware
of the entire table. Like I already mentioned, the GID table is a HW
resource that can be divided and handed to multiple VMs,

>> The Verbs are a low-level API, that should report exactly what was
>> received from the wire.  In the RoCEv2 case, it should be the GID/IP
>> addresses and the protocol type.  The addressing information is not
>> intended to be used directly by applications; it is the raw bits
>> that were accepted from the wire.
>
> Low level details isn't what any in kernel consumer needs. Everything
> in kernel needs the gid index to determine the namespace, routing and
> other details. It is not optional. A common API is thus needed to do
> this conversion.
>
> API-wise, once you get the gid index then it is trivial to make easy
> extractors for everything else. ie for example:
> rdma_get_ud_src_sockaddr(gid_index,&addr,wc,grh)
> rdma_get_ud_dst_sockaddr(gid_index,&addr,wc,grh)
>
>> ib_init_ah_from_wc() and friends is exactly the place that you want
>> to create an address handle based on completion and packet fields.
>
> CMA needs exactly the same logic as well, the fact it doesn't have it
> is a bug in this series.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
