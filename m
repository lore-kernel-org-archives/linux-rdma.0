From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Mon, 7 Dec 2015 20:34:43 +0200
Message-ID: <CAG9sBKNXnzp7PgJhfcjbYvje5qgZWYqygJYkbs4WyTZtDc4ckg@mail.gmail.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
	<1449150450-13679-6-git-send-email-matanb@mellanox.com>
	<20151203140543.GA4283@infradead.org>
	<HE1PR05MB141857FA57EECD82D1533543B10D0@HE1PR05MB1418.eurprd05.prod.outlook.com>
	<20151207060241.GA19038@obsidianresearch.com>
	<CAG9sBKO0rsSQK1WcyBciZEONWJsusw9GwR19H7FfAsebEH63dg@mail.gmail.com>
	<20151207063415.GB20066@obsidianresearch.com>
	<CAG9sBKMBt6Toa25Ouasr7hudAcOYrxZyBUFYMXzrMTFZvooWfQ@mail.gmail.com>
	<20151207171228.GA26969@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207171228.GA26969-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Well, just tell me how you want to discover gid_index when you poll
the WC out of the CQ.
Like I said, the sgid itself is in the GRH that is scattered to the
buffers in the receive queue. When ib_poll_cq() is called the pointer
to GRH is not passed so there is no way to determine the gid_index
inside the polling context.
BTW, why do you argue about this only now? This is not RoCE specific
issue. sgid_index was always resolved outside the polling context. The
only difference between then and now is that with InfiniBand there was
no conflict about sgid_index once you had the sgid. Now, when same gid
value can be present in multiple entries you need an extra parameter
to get distinguish between them - that would be the netwrok_type


On Mon, Dec 7, 2015 at 7:12 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Dec 07, 2015 at 08:37:41AM +0200, Moni Shoua wrote:
>> On Mon, Dec 7, 2015 at 8:34 AM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > On Mon, Dec 07, 2015 at 08:15:40AM +0200, Moni Shoua wrote:
>> >
>> >> What you have though is the sgid taken from the GRH that is scattered
>> >> to the first 40/20 bytes of the receive WQE.  This is not enough to
>> >> determine the network type.
>> >
>> > It is enough to discover the sgid index which will tell you the type.
>> but how? all you have in hand is the sgid which can appear several
>> times in the GID table in different indices.
>
> Eh? Reliably recovering the gid index is not optional. The network
> namespace stuff that is already in the kernel hard requires that
> ability. (This is the same argument we went around on already why pkey
> had to come from the wc, not from the payload)
>
> If your position is it cannot be done from a WC,QP as is, then
> gid_index needs to be added to the wc, or something else to remove the
> ambiguity.
>
> In either case, network_type is absolutely the wrong thing to have in
> the wc.
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
