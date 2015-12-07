From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 05/11] IB/core: Add rdma_network_type to wc
Date: Mon, 7 Dec 2015 08:37:41 +0200
Message-ID: <CAG9sBKMBt6Toa25Ouasr7hudAcOYrxZyBUFYMXzrMTFZvooWfQ@mail.gmail.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
	<1449150450-13679-6-git-send-email-matanb@mellanox.com>
	<20151203140543.GA4283@infradead.org>
	<HE1PR05MB141857FA57EECD82D1533543B10D0@HE1PR05MB1418.eurprd05.prod.outlook.com>
	<20151207060241.GA19038@obsidianresearch.com>
	<CAG9sBKO0rsSQK1WcyBciZEONWJsusw9GwR19H7FfAsebEH63dg@mail.gmail.com>
	<20151207063415.GB20066@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207063415.GB20066-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 7, 2015 at 8:34 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Dec 07, 2015 at 08:15:40AM +0200, Moni Shoua wrote:
>
>> What you have though is the sgid taken from the GRH that is scattered
>> to the first 40/20 bytes of the receive WQE.  This is not enough to
>> determine the network type.
>
> It is enough to discover the sgid index which will tell you the type.
but how? all you have in hand is the sgid which can appear several
times in the GID table in different indices.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
