From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add huge page support to ibv_madvise_range()
Date: Mon, 17 May 2010 22:29:30 -0700
Message-ID: <4BF225BA.6060005@linux.vnet.ibm.com>
References: <4B12AA78.7090401@gmail.com> <ada8wbzi490.fsf@roland-alpha.cisco.com> <4BCFFC48.4060401@gmail.com> <adazl0c92kp.fsf@roland-alpha.cisco.com> <4BEC06DB.30505@gmail.com> <adapr0zsswc.fsf@roland-alpha.cisco.com> <4BEC937F.5000808@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BEC937F.5000808-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Pradeep Satyanarayana wrote:
> Roland Dreier wrote:
>>  > Maybe we should use the /proc/pid/pagemap and /proc/kpageflags files?
>>  > These files let a userspace process find out which physical frame
>>  > each virtual page is mapped to and to get the properties of each page
>>  > frame including the page size.
>>
>> Sounds interesting... the only problem is that /proc/kpageflags is
>> root-only, so we can't use that.  But does /proc/pid/pagemap give enough
>> information to be useful?
> 
> The most useful information that /proc/pid/pagemap provides the PFN (if the
> page is not swapped out). In fact there is very useful tool called 
> Documentation/vm/page-types.c which gives a lot of the information that we 
> need. Again the caveat is that it uses /proc/kpageflags.

Roland,

Documentation/vm/page-types didn't turn out to be as interesting as expected.
It does show the usage of huge pages, but it seems to provide system information
and not process specific.

The possible alternatives and their limitations are:

1. /proc/pid/maps - usable only with libhugetlfs
2. page-type and friends -/proc/kpageflgs is readable by root only (plus additional
limitations described above).
3. /proc/pid/smaps -this provides KernelPageSize/MMUPageSize information 
(on recent kernels) with and without libhugetlbfs. Parsing this may be slow, 
but how often would it be used?

Given the above, I see /proc/pid/smaps as one alternative that provides a complete
solution. Are there others? What are your thoughts?

Pradeep


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
