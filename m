From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 0/5] Indirect memory registration feature
Date: Tue, 09 Jun 2015 11:44:16 +0300
Message-ID: <5576A760.4090004@dev.mellanox.co.il>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com> <20150608132254.GA14773@infradead.org> <55759B0B.8050805@mellanox.com> <20150608135151.GA14021@infradead.org> <5575A9C7.7000409@dev.mellanox.co.il> <20150609062054.GA13011@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150609062054.GA13011-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/9/2015 9:20 AM, Christoph Hellwig wrote:
> On Mon, Jun 08, 2015 at 05:42:15PM +0300, Sagi Grimberg wrote:
>> I wouldn't say this is about offloading bounce buffering to silicon.
>> The RDMA stack always imposed the alignment limitation as we can only
>> give a page lists to the devices. Other drivers (qlogic/emulex FC
>> drivers for example), use an _arbitrary_ SG lists where each element can
>> point to any {addr, len}.
>
> Those are drivers for protocols that support real SG lists.   It seems
> only Infiniband and NVMe expose this silly limit.

I agree this is indeed a limitation and that's why SG_GAPS was added
in the first place. I think the next gen of nvme devices will support 
real SG lists. This feature enables existing Infiniband devices that can 
handle SG lists to receive them via the RDMA stack (ib_core).

If the memory registration process wasn't such a big fiasco in the
first place, wouldn't this way makes the most sense?

>
>>> So please fix it in the proper layers
>>> first,
>>
>> I agree that we can take care of bounce buffering in the block layer
>> (or scsi for SG_IO) if the driver doesn't want to see any type of
>> unaligned SG lists.
>>
>> But do you think that it should come before the stack can support this?
>
> Yes, absolutely.  The other thing that needs to come first is a proper
> abstraction for MRs instead of hacking another type into all drivers.
>

I'm very much open to the idea of consolidating the memory registration
code instead of doing it in every ULP (srp, iser, xprtrdma, svcrdma,
rds, more to come...) using a general memory registration API. The main
challenge is to abstract the different methods (and considerations) of
memory registration behind an API. Do we completely mask out the way we
are doing it? I'm worried that we might end up either compromising on
performance or trying to understand too much what the caller is trying
to achieve.

For example:
- frwr requires a queue-pair for the post (and it must be the ULP
   queue-pair to ensure the registration is done before the data-transfer
   begins). While fmrs does not need the queue-pair.

- the ULP would probably always initiate data transfer after the
   registration (send a request or do the rdma r/w). It is useful to
   link the frwr post with the next wr in a single post_send call.
   I wander how would an API allow such a thing (while other registration
   methods don't use work request interface).

- There is the fmr_pool API which tries to tackle the disadvantages of
   fmrs (very slow unmap) by delaying the fmr unmap until some dirty
   watermark of remapping is met. I'm not sure how this can be done.

- How would the API choose the method to register memory?

- If there is an alignment issue, do we fail? do we bounce?

- There is the whole T10-DIF support...

...

CC'ing Bart & Chuck who share the suffer of memory registration.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
