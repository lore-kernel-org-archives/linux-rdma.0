From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 13/15] IB/srpt: Detect session shutdown reliably
Date: Wed, 6 Jan 2016 15:46:34 +0100
Message-ID: <568D28CA.8010804@sandisk.com>
References: <568BD0FC.70207@sandisk.com> <568BD2A9.6070600@sandisk.com>
 <568D2707.9020309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568D2707.9020309-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/06/2016 03:39 PM, Sagi Grimberg wrote:
> On 05/01/2016 16:26, Bart Van Assche wrote:
>> The Last WQE Reached event is only generated after one or more work
>> requests have been queued on the QP associated with a session. Since
>> session shutdown can start before any work requests have been queued,
>> use a zero-length RDMA write to wait until a QP has been drained.
>
> Is it just me or is there (a lot) more going on here other than
> this patch description?

Hello Sagi,

I will make the patch description more detailed. Sorry if some of this 
code is hard to follow but that's because of the high level of 
concurrency in the SRP target driver. Some time ago I documented how 
session management in the SCST ib_srpt driver works. This driver follows 
the same model. These notes can be found here: 
http://sourceforge.net/p/scst/svn/HEAD/tree/trunk/srpt/session-management.txt.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
