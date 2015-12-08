From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Tue, 8 Dec 2015 15:52:51 -0700
Message-ID: <20151208225251.GA27609@obsidianresearch.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKNWMQA3XDGpDc_+2QoJcnnNL9o67p0JNoVqrU0u9UQCrA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 09:23:18AM +0200, Moni Shoua wrote:
> >> Now, when same gid value can be present in multiple entries you need
> >> an extra parameter to get distinguish between them - that would be
> >> the netwrok_type
> >
> > Eh?  You are only worried about duplicates between rocev1 mode which
> > uses the GUID and v2 mode which uses the host's IP address?
> >
> > What about duplicates entirely within v2 mode where vlan and macvlan
> > can create duplicate host IP addresses.

> In that case these entries will be distinguished  byt its eth devices
> (eth device is part of the gid attributes structure)

Eh? I think you've missed the point, there is no net device when
looking at a wc.

Look, here is a concrete direction:

Replace all the crap in
ib_init_ah_from_wc/get_sgid_index_from_eth/rdma_addr_find_dmac_by_grh

with a straightforward

   rdma_dgid_index_from_wc(
                        const struct ib_qp *qp,
                        const struct ib_wc *wc,
			const struct ib_grh *grh,
			u16 *gid_index)

Sort of function that reads the GRH and wc and returns the unambiguous
gid index that was used to receive that packet on the UD QP.

The gid cache is not allowed to create an ambiguity the driver cannot
resolve.

That said, I wouldn't object to vendor-specific bits in the wc. Ie if
mlx hardware needs a network_type bit to implement
rdma_find_dgid_index_from_wc, then fine - define a vendor specific
place to put it. In this case rdma_find_dgid_index_from_wc would be a
driver call back, which is fine, and what Caitlin was talking about.

But, it is not part of our verbs API, and I'd *strongly* encourage
other vendors and future hardware to simply return the gid index that
the hardware matched instead of requiring the software to try and
guess after the fact.

This is the same issue/argument we went around and around on the
lladdr ipoib details when working on the namespace patches, about how
important it is to resolve the namespace from the hardware headers.

Of course once we have the gid index we now have the net device and
other information needed to make namespaces work.

.. and this is part of what I mean what I said the interface from the
gid cache code is not a sane API and needs to be changed.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
