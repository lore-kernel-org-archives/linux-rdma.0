From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Wed, 9 Dec 2015 11:34:10 +0200
Message-ID: <CAG9sBKM2s9BMv8priCHnFaMcSnuafn4vf+6+0Rooc6Gw0ZSaLA@mail.gmail.com>
References: <20151203140543.GA4283@infradead.org>
	<HE1PR05MB141857FA57EECD82D1533543B10D0@HE1PR05MB1418.eurprd05.prod.outlook.com>
	<20151207060241.GA19038@obsidianresearch.com>
	<CAG9sBKO0rsSQK1WcyBciZEONWJsusw9GwR19H7FfAsebEH63dg@mail.gmail.com>
	<20151207063415.GB20066@obsidianresearch.com>
	<CAG9sBKMBt6Toa25Ouasr7hudAcOYrxZyBUFYMXzrMTFZvooWfQ@mail.gmail.com>
	<20151207171228.GA26969@obsidianresearch.com>
	<CAG9sBKNXnzp7PgJhfcjbYvje5qgZWYqygJYkbs4WyTZtDc4ckg@mail.gmail.com>
	<20151207184832.GA21402@obsidianresearch.com>
	<CAG9sBKNWMQA3XDGpDc_+2QoJcnnNL9o67p0JNoVqrU0u9UQCrA@mail.gmail.com>
	<20151208225251.GA27609@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208225251.GA27609-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Eh? I think you've missed the point, there is no net device when
> looking at a wc.
>
> Look, here is a concrete direction:
>
> Replace all the crap in
> ib_init_ah_from_wc/get_sgid_index_from_eth/rdma_addr_find_dmac_by_grh
>
> with a straightforward
>
>    rdma_dgid_index_from_wc(
>                         const struct ib_qp *qp,
>                         const struct ib_wc *wc,
>                         const struct ib_grh *grh,
>                         u16 *gid_index)
>
> Sort of function that reads the GRH and wc and returns the unambiguous
> gid index that was used to receive that packet on the UD QP.
>

I already answered this to but I'll do it again
RoCEv2 spec says that L3 header will be scattered to receive WQE in
the following way
IPv6 and RoCEv1 - 40 bytes of the L3 header (GRH or IPv6) to the first
40 bytes of the receive bufs
IPv4 - 20 bytes of the L3 header to the second half of the first 40
bytes of the receive bufs. The first 20 bytes remain undefined.

Now, if you think how you deduce network_type from GRH you'll see that
it requires tools like checksum validation and other validations and
you end up with a method that is not 100% error free. So,to eliminate
the need for heavy computation (with regards to the other option) and
be free from false deductions you have the option of getting
network_type from the hardware. So, if you do have hardware that
supports it why give it up?



> The gid cache is not allowed to create an ambiguity the driver cannot
> resolve.
>
> That said, I wouldn't object to vendor-specific bits in the wc. Ie if
> mlx hardware needs a network_type bit to implement
> rdma_find_dgid_index_from_wc, then fine - define a vendor specific
> place to put it. In this case rdma_find_dgid_index_from_wc would be a
> driver call back, which is fine, and what Caitlin was talking about.
>

This is not a Mellanox specific flag. See a quote from the spec

A17.4.5.1 UD COMPLETION QUEUE ENTRIES (CQES)
For UD, the Completion Queue Entry (CQE) includes remote address
information (InfiniBand Specification Vol. 1 Rev 1.2.1 Section
11.4.2.1). For RoCEv2, the remote address information comprises the
source L2 Address and a flag that indicates if the received frame is
an IPv4, IPv6 or RoCE packet.



> But, it is not part of our verbs API, and I'd *strongly* encourage
> other vendors and future hardware to simply return the gid index that
> the hardware matched instead of requiring the software to try and
> guess after the fact.

Could be problematic for virtual machine architectures that give a
portion of the entire GID table to a VM that index it 0..N
>
> This is the same issue/argument we went around and around on the
> lladdr ipoib details when working on the namespace patches, about how
> important it is to resolve the namespace from the hardware headers.
>
> Of course once we have the gid index we now have the net device and
> other information needed to make namespaces work.
>
> .. and this is part of what I mean what I said the interface from the
> gid cache code is not a sane API and needs to be changed.
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
