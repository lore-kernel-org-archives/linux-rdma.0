From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/2] Add support for reporting LSO
 capabilities
Date: Thu, 28 Apr 2016 10:57:52 +0300
Message-ID: <5721C280.3070007@mellanox.com>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <20160427164230.GB11617@obsidianresearch.com>
 <20160427170903.GA11554@leon.nu>
 <20160427171451.GA17172@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160427171451.GA17172-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 27/04/2016 20:14, Jason Gunthorpe wrote:
> On Wed, Apr 27, 2016 at 08:09:03PM +0300, Leon Romanovsky wrote:
>> On Wed, Apr 27, 2016 at 10:42:30AM -0600, Jason Gunthorpe wrote:
>>> On Wed, Apr 27, 2016 at 05:04:50PM +0300, Matan Barak wrote:
>>>
>>>> This patch series enables hardware to report Large Segment Offload(LSO)
>>>> capabilities from kernel to user space. LSO enabled NIC will accept big chuck of
>>>> data with size greater than MTU. The LSO engine will split them into
>>>> separate packets and insert the headers automatically. With LSO, CPU is
>>>> offloaded from dealing with much less throughput of data.
>>>
>>> I also feel like we should stop changing the current uAPI until we get
>>> the new one in place.
>>
>> This functionality doesn't relate to ABI change and don't change
>> current/future interfaces.
>
> What do you mean it doesn't change current interfaces? That is all
> this patch does.
>

This patch indeed changes the ABI, but as far as I understand, we want 
to keep libibverbs API. If so, all current libibverbs API's features 
should somehow go through this new uAPI/uABI and LSO should probably be 
one of these features as well. Do we want to halt all progress in the 
RDMA world before we stabilize a new uAPI?


>> There is no need to stop changes like this.
>
> Why do we need to keep churning the uAPI now that we are committed to
> deprecating it?
>

Will there be another libibverbs release before this uAPI change is 
completed? We all want to see this new uAPI change landing ASAP and 
we're all committed to this, but being realistic, it probably won't go 
into 4.7 kernel cycle, while small changes like this could.

> It seems like the discussion is closing on something implementable.
>
> And again, we discussed at the Collab Summit that ABI patches like
> this would be OK'd by a multi-vendor group - that hasn't happened yet
> for this patch either.
>

We're always open for discussions regarding features like this.

> Jason
>

Matan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
