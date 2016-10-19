From: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
Date: Wed, 19 Oct 2016 12:48:14 -0600
Message-ID: <20161019184814.GC16550@cgy1-donard.priv.deltatee.com>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, jim.macdonald-FgSLVYC75IpWk0Htik3J/w@public.gmane.org, sbates-Rgftl6RXld5BDgjK7y7TUQ@public.gmane.org, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 18, 2016 at 08:51:15PM -0700, Dan Williams wrote:
> [ adding Ashok and David for potential iommu comments ]
>

Hi Dan

Thanks for adding Ashok and David!

>
> I agree with the motivation and the need for a solution, but I have
> some questions about this implementation.
>
> >
> > Consumers
> > ---------
> >
> > We provide a PCIe device driver in an accompanying patch that can be
> > used to map any PCIe BAR into a DAX capable block device. For
> > non-persistent BARs this simply serves as an alternative to using
> > system memory bounce buffers. For persistent BARs this can serve as an
> > additional storage device in the system.
>
> Why block devices?  I wonder if iopmem was initially designed back
> when we were considering enabling DAX for raw block devices.  However,
> that support has since been ripped out / abandoned.  You currently
> need a filesystem on top of a block-device to get DAX operation.
> Putting xfs or ext4 on top of PCI-E memory mapped range seems awkward
> if all you want is a way to map the bar for another PCI-E device in
> the topology.
>
> If you're only using the block-device as a entry-point to create
> dax-mappings then a device-dax (drivers/dax/) character-device might
> be a better fit.
>

We chose a block device because we felt it was intuitive for users to
carve up a memory region but putting a DAX filesystem on it and creating
files on that DAX aware FS. It seemed like a convenient way to
partition up the region and to be easily able to get the DMA address
for the memory backing the device.

That said I would be very keen to get other peoples thoughts on how
they would like to see this done. And I know some people have had some
reservations about using DAX mounted FS to do this in the past.

>
> > 2. Memory Segment Spacing. This patch has the same limitations that
> > ZONE_DEVICE does in that memory regions must be spaces at least
> > SECTION_SIZE bytes part. On x86 this is 128MB and there are cases where
> > BARs can be placed closer together than this. Thus ZONE_DEVICE would not
> > be usable on neighboring BARs. For our purposes, this is not an issue as
> > we'd only be looking at enabling a single BAR in a given PCIe device.
> > More exotic use cases may have problems with this.
>
> I'm working on patches for 4.10 to allow mixing multiple
> devm_memremap_pages() allocations within the same physical section.
> Hopefully this won't be a problem going forward.
>

Thanks Dan. Your patches will help address the problem of how to
partition a /dev/dax device but they don't help the case then BARs
themselves are small, closely spaced and non-segment aligned. However
I think most people using iopmem will want to use reasonbly large
BARs so I am not sure item 2 is that big of an issue.

> I haven't yet grokked the motivation for this, but I'll go comment on
> that separately.

Thanks Dan!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
