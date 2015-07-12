From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Sun, 12 Jul 2015 10:57:42 +0300
Message-ID: <55A21DF6.6090909@dev.mellanox.co.il>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150711103920.GE14741@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150711103920.GE14741-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/11/2015 1:39 PM, Christoph Hellwig wrote:
> On Fri, Jul 10, 2015 at 12:09:37PM +0300, Sagi Grimberg wrote:
>> And then provide helpers to populate the MR with generic kernel
>> structures such as struct scatterlist (for scsi and other ULPs),
>> struct page (for NFS) or struct bio_vec (for block ULPs later on).
>
> Please stick to struct scatterlist for now.  Future block ULPs
> will use that as well as the only way you can do a multi-page
> DMA mapping is the scatterlist.

I see.

> A page is just a subset of an SGL, and we can map a page using a one element SGL trivial,
> as we do in lots of places.
>

But won't that make sunrpc rdma consumers to hold an extra scatterlist
just for memory registration?

Chuck, Would a scatterlist API make life easier for you?

>> We can consider moving the iova and length to the population helpers.
>> Wasn't sure what is better...
>
> Move it to the population helpers.  The walk done in them is used to
> generate those values anyway, so there is no need to expose them in
> any sort of public API.

Yea, makes sense.

>  I'd also move the access_flags initialization to the helpers,
> leaving post to do just that:  post an alredy initialized mr structure.

I can do that, but it's not really related to the sg.

Say a consumer wants to register an SG for peer X and then change
access permissions for peer Y. There is no real reason to re-init
the mappings right?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
