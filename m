From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: SRP Q's: 1) When is asynchronous I/O complete, 2) Is sequential
 	I/O coalesced, and 3) why is iSCSI faster than SRP in some instances
Date: Mon, 11 Jan 2010 21:44:01 +0300
Message-ID: <4B4B7171.4020000@vlnb.net>
References: <f3177b9e1001061616v4f0015d1h843ba19c8cdd83d@mail.gmail.com>	 <1262829441.29991.10.camel@obelisk.thedillows.org>	 <f3177b9e1001081340r323c53cela2fb22907212fc2b@mail.gmail.com>	 <1262989053.14204.21.camel@obelisk.thedillows.org> <f3177b9e1001081439j3730acefrbfcf523b0da06306@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e1001081439j3730acefrbfcf523b0da06306-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Chris Worley, on 01/09/2010 01:39 AM wrote:
>>> I thought if the device was opened with the O_DIRECT flag, then the
>>> scheduler should have nothing to coalesce.
>> Depends on how many I/Os your application has in flight at once,
>> assuming it is using AIO or threads. If you have more requests in flight
>> than can be queued, the block layer will coalesce if possible.
> 
> I do use AIO, always 64 threads, each w/ 64 outstanding I/O's.  Local
> or iSER initiator based, I never see any coalescing.  Only w/ SRP.

SRP initiator seems to be not too well optimized for the best 
performance. ISER initiator is noticeably better in this area.

> There is the scst_vdisk "Direct I/O" option that's been commented out
> of the code, as it's not supposed to work... maybe direct I/O doesn't
> work... but that would be the target side.

O_DIRECT for vdisk is supposed to work. It's a matter of a small patch 
for the kernel, see http://scst.sourceforge.net/contributing.html#O_DIRECT.

Meanwhile, you can use fileio_tgt handler, with which O_DIRECT works well.

Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
