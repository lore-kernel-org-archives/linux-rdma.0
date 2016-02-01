From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [LSF/MM TOPIC/ATTEND] RDMA passive target
Date: Mon, 1 Feb 2016 12:36:06 +0200
Message-ID: <56AF3516.8000909@dev.mellanox.co.il>
References: <06414D5A-0632-4C74-B76C-038093E8AED3@oracle.com>
 <56A8F646.5020003@plexistor.com> <56A8FE10.7000309@dev.mellanox.co.il>
 <56AE181A.8030908@plexistor.com>
 <CACTTzNaOChdWN2eS9_kzv6HO_LVib-JVdkmeUn0LDe2eKxPEgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACTTzNaOChdWN2eS9_kzv6HO_LVib-JVdkmeUn0LDe2eKxPEgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>, Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>>> The almost is because:
>>>> 1. If the target is over a /dev/pmemX then all is fine we have 2M contiguous
>>>>      memory blocks.
>>>> 2. If the target is over an FS, we have a proposal pending for an falloc_2M_flag
>>>>      to ask the FS for a contiguous 2M allocations only. If any of the 2M allocations
>>>>      fail then return ENOSPC from falloc. This way we guaranty that each 2M block can be
>>>>      mapped by a single RDAM handle.
>>>
>>> Umm, you don't need the 2M to be contiguous in order to represent them
>>> as a single RDMA handle. If that was true iSER would have never worked.
>>> Or I misunderstood what you meant...
>>>
>>
>> OK I will let our RDMA guy Yigal Korman answer that, I guess you might be right.
>
> When Boaz says 'RDMA handle', he means the pair [rkey,remote_addr].
> AFAIK the remote_addr describes a continuous memory space on the target.
> So if you want to write to this 'handle' - it must be continuous.
> Please correct me if I'm wrong.

OK, this is definitely wrong. But let's defer this discussion to another
thread as it's not relevant to lsf folks...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
