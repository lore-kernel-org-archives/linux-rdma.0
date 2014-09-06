From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: RE: [PATCH v2 4/4] rsockets: acknowledge completion queue events in
 batch
Date: Sat, 06 Sep 2014 07:52:39 +0530
Message-ID: <d52658b2f68bc014103e655857096b4a@imap.linux.ibm.com>
References: <c144abfe27bd0bf36ff1e3c9c912d7c3@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DC1B64@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DC1B64-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2014-09-05 23:31, Hefty, Sean wrote:
>>      Expose '/unackcqe_default' variable so completion event
>>      acknowledgment can be done in batch instead of singles
>>      to minimize locking overheads.
>> 
>>      The default value of this variable is 1 so the existing
>>      functionality is preserved.  Having a higher value delays
>>      acknowledging until the specified limit is reached for
>>      retrieved completion events.
> 
> I would rather just change the default behavior, rather than introduce
> more checks and options into the code.

Hi Sean,

That's indeed a good approach.  But, we need to have an upper limit
before a batch of events is flushed.  Can we decide limit based on
completion event queue size?

Thank You.

- Sreedhar

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
