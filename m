From: "Pavel Shamis (Pasha)" <pashash-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMAoE verbs questions
Date: Thu, 26 Nov 2009 11:00:42 +0200
Message-ID: <4B0E43BA.6070700@dev.mellanox.co.il>
References: <209ECE49-3AB9-4E62-B825-54E474321FA6@cisco.com>	<4B0CDBEC.1030203@voltaire.com>	<10904370-1D66-4013-BB3F-0F4B5EE581EE@cisco.com>	<4B0D4660.5060701@voltaire.com> <4B0D8FD2.9000702@dev.mellanox.co.il> <4B0E2DA7.7060809@voltaire.com>
Reply-To: pasha-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0E2DA7.7060809-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz wrote:
> Pavel Shamis (Pasha) wrote:
>> The patch is attached
> Thanks, this patch basically replaces checks for the device transport 
> type to be IB to a check that makes sure either the former happens or 
> the port transport type is rdmaoe. As Jason, Tziporet and noted, the 
> port transport type seems to be bad and non-comapatible/operable idea, 
> so it should and probably could be avoided.
The only reason for this changes is the fact that for IB devices we 
prefer to use our own open mpi connection managers. In case if we will 
decide to use RDMA-CM for all devices the number of changes will be zero...
>
> I see another patch @ 
> http://www.open-mpi.org/community/lists/devel/2009/11/7063.php
> can you send that one as well. The you sent patch isn't signed so I 
> can't address the author in further replies (unless you are the 
> author), also it wasn't generated with the -p option of diff which 
> would show for each change what is the effected function, doing so 
> would help in the review.
Ohh. It was our first patch. Some of iwarp devices have the "first 
packet" issue. So the RDMACM code in Ompi have bunch of work-around code 
that try to resolve the issue on MPI level. We don't have such problems 
with IB, so we tried to disable the work-around flow for IB devices, but 
it did not work well. So we decided to use the current ompi code as is, 
in future maybe we will implement own ompi rdmacm code that will not 
have all this work around flows.

Regards,

Pasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
