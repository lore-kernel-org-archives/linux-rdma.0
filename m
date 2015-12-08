From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Tue, 8 Dec 2015 09:23:18 +0200
Message-ID: <CAG9sBKNWMQA3XDGpDc_+2QoJcnnNL9o67p0JNoVqrU0u9UQCrA@mail.gmail.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
	<1449150450-13679-6-git-send-email-matanb@mellanox.com>
	<20151203140543.GA4283@infradead.org>
	<HE1PR05MB141857FA57EECD82D1533543B10D0@HE1PR05MB1418.eurprd05.prod.outlook.com>
	<20151207060241.GA19038@obsidianresearch.com>
	<CAG9sBKO0rsSQK1WcyBciZEONWJsusw9GwR19H7FfAsebEH63dg@mail.gmail.com>
	<20151207063415.GB20066@obsidianresearch.com>
	<CAG9sBKMBt6Toa25Ouasr7hudAcOYrxZyBUFYMXzrMTFZvooWfQ@mail.gmail.com>
	<20151207171228.GA26969@obsidianresearch.com>
	<CAG9sBKNXnzp7PgJhfcjbYvje5qgZWYqygJYkbs4WyTZtDc4ckg@mail.gmail.com>
	<20151207184832.GA21402@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207184832.GA21402-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 7, 2015 at 8:48 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Dec 07, 2015 at 08:34:43PM +0200, Moni Shoua wrote:
>> Well, just tell me how you want to discover gid_index when you poll
>> the WC out of the CQ.
>
> Hey, I'm not desiging this rocev2 stuff, this is something the rocev2
> community needs to sort out.
>
>> Like I said, the sgid itself is in the GRH that is scattered to the
>> buffers in the receive queue. When ib_poll_cq() is called the pointer
>> to GRH is not passed so there is no way to determine the gid_index
>> inside the polling context.
>
> Then have an API to let the consumer recover it.
>
>> BTW, why do you argue about this only now? This is not RoCE specific
>> issue. sgid_index was always resolved outside the polling context. The
>> only difference between then and now is that with InfiniBand there was
>> no conflict about sgid_index once you had the sgid.
>
> I think you answered your own question. In IB and rocev1 the sgid
> index is not ambiguous, rocev2 breaks that requirement without
> adaquately fixing it.
>
> It is probably also the case that rocev1 has similar problems,
> depending on how vland and macvlan ended up being implemented.
>
>> Now, when same gid value can be present in multiple entries you need
>> an extra parameter to get distinguish between them - that would be
>> the netwrok_type
>
> Eh?  You are only worried about duplicates between rocev1 mode which
> uses the GUID and v2 mode which uses the host's IP address?
>
> What about duplicates entirely within v2 mode where vlan and macvlan
> can create duplicate host IP addresses.
In that case these entries will be distinguished  byt its eth devices
(eth device is part of the gid attributes structure)

>
> You can also just not create duplicate entries in the first place. For
> instance there probably isn't a really a good reason to use rocev2 for
> IPv6 link local addreses, that trivially eliminates the v1/v2
> collision.
First, spec says that I must.
Second, even if you have an example that makes it unnecessary for some
it is still necessary for others and therefore the netwotk_type in WC
is still needed
Third, regarding the IPv6 link local example,  IPv6 link local packet
is almost identical to RoCEv1 but not entirely. The former is an IP
protocol packet while the later isn't. Switches and network admins may
care about this.

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
