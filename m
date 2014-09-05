From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 4/4] rsockets: acknowledge completion queue events in
 batch
Date: Fri, 5 Sep 2014 18:01:49 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DC1B64@ORSMSX109.amr.corp.intel.com>
References: <c144abfe27bd0bf36ff1e3c9c912d7c3@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c144abfe27bd0bf36ff1e3c9c912d7c3-FJGp5E75HVmZamtmwQBW5tBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>      Expose '/unackcqe_default' variable so completion event
>      acknowledgment can be done in batch instead of singles
>      to minimize locking overheads.
> 
>      The default value of this variable is 1 so the existing
>      functionality is preserved.  Having a higher value delays
>      acknowledging until the specified limit is reached for
>      retrieved completion events.

I would rather just change the default behavior, rather than introduce more checks and options into the code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
