From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH V6 6/9] isert: Rename IO functions to more descriptive
 names
Date: Sun, 26 Jul 2015 15:15:34 -0500
Message-ID: <55B53FE6.1030509@opengridcomputing.com>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161848.25617.26092.stgit@build2.ogc.int>
 <55B4B190.7070305@dev.mellanox.co.il> <20150726104328.GB18944@infradead.org>
 <55B4BDE3.8040801@dev.mellanox.co.il>
 <55B519C6.2030205@opengridcomputing.com>
 <55B51B7A.8030008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B51B7A.8030008-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/26/2015 12:40 PM, Sagi Grimberg wrote:
>
>>> Ideally, the post contains a chain of all 4 registrations and the
>>> rdma_read (and an opportunistic good scsi response).
>>
>> Just to be clear: This example is for IB only, correct?  IW would
>> require rkeys with REMOTE_WRITE and 4 read wrs.
>
> My assumption is that it would depend on max_sge_rd.
>

yea.

> IB only? iWARP by definition isn't capable of doing rdma_read to
> more than one scatter? Anyway, we'll need to calculate the number
> of RDMA_READs.
>

The wire protocol limits the destination to a single stg/to/len (aka 
rkey/addr/len).  Devices/fw/sw could implement some magic to support a 
single stg/to/len that maps to a scatter gather list of stags/tos/lens.

>> And you're ignoring invalidation wrs (or read-with-inv) in the 
>> example...
>
> Yes, didn't want to inflate the example too much...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
