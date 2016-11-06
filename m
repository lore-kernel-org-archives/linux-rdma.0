From: "Stephen Bates" <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] iopmem : A block device for PCIe memory
Date: Sun, 6 Nov 2016 08:05:59 -0600
Message-ID: <b714bf30ee6577c5006f347b12b4f2fe.squirrel@webmail.raithlin.com>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
    <CAPcyv4gJ_c-6s2BUjsu6okR1EF53R+KNuXnOc5jv0fuwJaa3cQ@mail.gmail.com>
    <20161019184814.GC16550@cgy1-donard.priv.deltatee.com>
    <20161020232239.GQ23194@dastard> <20161021095714.GA12209@infradead.org>
    <20161021111253.GQ14023@dastard>
    <20161025115043.GA14986@cgy1-donard.priv.deltatee.com>
    <20161025211903.GD14023@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161025211903.GD14023@dastard>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, jim.macdonald-FgSLVYC75IpWk0Htik3J/w@public.gmane.org, sbates-Rgftl6RXld5BDgjK7y7TUQ@public.gmane.org, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, October 25, 2016 3:19 pm, Dave Chinner wrote:
> On Tue, Oct 25, 2016 at 05:50:43AM -0600, Stephen Bates wrote:
>>
>> Dave are you saying that even for local mappings of files on a DAX
>> capable system it is possible for the mappings to move on you unless the
>> FS supports locking?
>>
>
> Yes.
>
>
>> Does that not mean DAX on such FS is
>> inherently broken?
>
> No. DAX is accessed through a virtual mapping layer that abstracts
> the physical location from userspace applications.
>
> Example: think copy-on-write overwrites. It occurs atomically from
> the perspective of userspace and starts by invalidating any current
> mappings userspace has of that physical location. The location is changes,
> the data copied in, and then when the locks are released userspace can
> fault in a new page table mapping on the next access....

Dave

Thanks for the good input and for correcting some of my DAX
misconceptions! We will certainly be taking this into account as we
consider v1.

>
>>>> And at least for XFS we have such a mechanism :)  E.g. I have a
>>>> prototype of a pNFS layout that uses XFS+DAX to allow clients to do
>>>> RDMA directly to XFS files, with the same locking mechanism we use
>>>> for the current block and scsi layout in xfs_pnfs.c.
>>
>> Thanks for fixing this issue on XFS Christoph! I assume this problem
>> continues to exist on the other DAX capable FS?
>
> Yes, but it they implement the exportfs API that supplies this
> capability, they'll be able to use pNFS, too.
>
>> One more reason to consider a move to /dev/dax I guess ;-)...
>>
>
> That doesn't get rid of the need for sane access control arbitration
> across all machines that are directly accessing the storage. That's the
> problem pNFS solves, regardless of whether your direct access target is a
> filesystem, a block device or object storage...

Fair point. I am still hoping for a bit more discussion on the best choice
of user-space interface for this work. If/When that happens we will take
it into account when we look at spinning the patchset.


Stephen

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
