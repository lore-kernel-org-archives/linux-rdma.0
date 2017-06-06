From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] libibverbs IB Device Memory support
Date: Tue, 6 Jun 2017 10:30:14 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1706061022270.16819@east.gentwo.org>
References: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com> <alpine.DEB.2.20.1706051141230.26831@east.gentwo.org> <20170605170825.GP6868@mtr-leonro.local> <20170605171749.GA20477@obsidianresearch.com> <20170605174151.GR6868@mtr-leonro.local>
 <alpine.DEB.2.20.1706051705350.886@east.gentwo.org> <AM4PR0501MB1956B596450F3BC38806E775C4CB0@AM4PR0501MB1956.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR0501MB1956B596450F3BC38806E775C4CB0-dp/nxUn679ggcKT3UpMsY8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 6 Jun 2017, Ahmad Omary wrote:

> In the above use case device, we can have only 64 processes per node which
> Is critical for HPC.

You can have 64 pages that are mapped by any number of processes. You can
map a single page to multiple processes which maybe a requirement if you
want to implement your own synchronization primitives as the mention of
semaphores suggests.

> Vendor driver still allocates and map 4KB pages granularity. But in case th=
> e
> HW device supports less than 4KB, then the HW must provide the required pro=
> tection.


The OS needs to provide the protection if that is the case and then it
probably is not a HPC device. We are talking about RDMA high end devices
here. The design here is for performance and low latency. I dont know of
any devices in use in HPC or in HFT that have these tiny memory sizes.
Mostly these devices are already engineeded for mmapping.

Is this for some kind of embedded device?

> Note that the device memory does not necessary have to be mapped to the CPU=
> .
> i.e. is not necessary accessible by PCI, and can only be accessed by RDMA.
> This is why we can't use MMAP for all cases  and a dedicated allocation and
>  copy functions are needed.

Can we come up with some sort of ioctl API then to write to the devices
inaccessible memory? There must be other drives outside of the RDMA tree
that have similar requirements and that may already have implemented some
version of it.

This seems to be a very specialized application that may be device
specific. ioctls are usually used then.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
