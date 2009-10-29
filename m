From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: [Scst-devel] Adjusting minimum packet size or "wait to merge
 requests" in SRP
Date: Thu, 29 Oct 2009 21:30:41 +0300
Message-ID: <4AE9DF51.9020707@vlnb.net>
References: <f3177b9e0910281147u5a47f75ao8bbe156d5b04969c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e0910281147u5a47f75ao8bbe156d5b04969c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Chris Worley, on 10/28/2009 09:47 PM wrote:
> It appears that SRP tries to coalesce and fragment initiator I/O
> requests into 64KB packets, as that looks to be the size requested
> to/from the device on the target side (and the I/O scheduler is
> disabled on the target).
> 
> Is there a way to control this, where no coalescing occurs when
> latency is an issue and requests are small, and no fragmentation
> occurs when requests are large?
> 
> Or, am I totally wrong in my assumption that SRP is coalescing/fragmenting data?

You can at any time see size of requests you are receiving on the target 
side by either enabling "scsi" logging (hopefully, you know how to do 
it) or by looking in /proc/scsi_tgt/sgv. In the latter file you will see 
general statistics for power of 2 allocations, i.e. request for 10K will 
increase 16K row.

Vlad

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
