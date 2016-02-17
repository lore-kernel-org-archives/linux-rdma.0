From: davide rossetti <davide.rossetti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/7] Peer-direct memory
Date: Tue, 16 Feb 2016 20:13:58 -0800
Message-ID: <CAPSaadx3vNBSxoWuvjrTp2n8_-DVqofttFGZRR+X8zdWwV86nw@mail.gmail.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
 <20160211191838.GA23675@obsidianresearch.com> <56C08EC8.10207@mellanox.com>
 <20160216182212.GA21071@obsidianresearch.com> <CAPSaadxbFCOcKV=c3yX7eGw9Wqzn3jvPRZe2LMWYmiQcijT4nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPSaadxbFCOcKV=c3yX7eGw9Wqzn3jvPRZe2LMWYmiQcijT4nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kovalyov Artemy <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "leon-Dj0/KMMU01E@public.gmane.org" <leon-Dj0/KMMU01E@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

resending, sorry

On Tue, Feb 16, 2016 at 10:22 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>
> On Sun, Feb 14, 2016 at 04:27:20PM +0200, Haggai Eran wrote:
> > [apologies: sending again because linux-mm address was wrong]
> >
> > On 11/02/2016 21:18, Jason Gunthorpe wrote:
> > > Resubmit those parts under the mm subsystem, or another more
> > > appropriate place.
> >
> > We want the feedback from linux-mm, and they are now Cced.
>
> Resubmit to mm means put this stuff someplace outside
> drivers/infiniband in the tree and don't try and inappropriately send
> memory management stuff through Doug's tree.
>

Jason,
I beg to differ.

1) I see mm as appropriate for real memory, i.e. something that
user-space apps can pass around. This is not totally true for BAR
memory, for instance:
 a) as long as CPU initiated atomic ops are not supported on BAR space
of PCIe devices.
 b) OTOT, CPU reading from BAR is awful (BW being abysmal,~10MB/s),
while high BW writing requires use of vector instructions (at least on
x86_64).
Bottom line is, BAR mappings are not like plain memory.

2) Instead, I see appropriate that two sophisticated devices, like an
IB NIC and a storage/accelerator device, can freely target each other
for I/O, i.e. exchanging peer-to-peer PCIe transactions. And as long
as the existing sophisticated initiators are confined to the RDMA
subsystem, that is where this support belongs to.

On a different note, this reminds me that the current patch set may be
missing a way to disable the use of platform PCIe atomics when the
target is the BAR of a peer device.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
