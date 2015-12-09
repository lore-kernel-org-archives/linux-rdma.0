From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Wed, 9 Dec 2015 09:38:21 +0000
Message-ID: <HE1PR05MB1418B1F0F393AD0D92424043B1E80@HE1PR05MB1418.eurprd05.prod.outlook.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208225251.GA27609-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]

> Look, here is a concrete direction:
> 
> Replace all the crap in
> ib_init_ah_from_wc/get_sgid_index_from_eth/rdma_addr_find_dmac_by_
> grh
> 
> with a straightforward
> 
>    rdma_dgid_index_from_wc(
>                         const struct ib_qp *qp,
>                         const struct ib_wc *wc,
> 			const struct ib_grh *grh,
> 			u16 *gid_index)
> 
> Sort of function that reads the GRH and wc and returns the unambiguous gid
> index that was used to receive that packet on the UD QP.
> 
> The gid cache is not allowed to create an ambiguity the driver cannot resolve.
> 
> That said, I wouldn't object to vendor-specific bits in the wc. Ie if mlx
> hardware needs a network_type bit to implement
> rdma_find_dgid_index_from_wc, then fine - define a vendor specific place
> to put it. In this case rdma_find_dgid_index_from_wc would be a driver call
> back, which is fine, and what Caitlin was talking about.
> 
> But, it is not part of our verbs API, and I'd *strongly* encourage other
> vendors and future hardware to simply return the gid index that the
> hardware matched instead of requiring the software to try and guess after
> the fact.
> 

You are pushing abstraction into provider code instead of handling it in a generic way.

The Verbs are a low-level API, that should report exactly what was received from the wire.
In the RoCEv2 case, it should be the GID/IP addresses and the protocol type.
The addressing information is not intended to be used directly by applications; it is the raw bits that were accepted from the wire.
I don't want to replicate resolution code in every RoCE driver.

ib_init_ah_from_wc() and friends is exactly the place that you want to create an address handle based on completion and packet fields.
This is what applications will use (and only if they are interested in generating a response; otherwise this overhead can be skipped).

As I said earlier, we can make sure that protocol type information doesn't incur any additional overhead.
--Liran

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
