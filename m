From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add huge page support to ibv_madvise_range()
Date: Thu, 13 May 2010 17:04:15 -0700
Message-ID: <4BEC937F.5000808@linux.vnet.ibm.com>
References: <4B12AA78.7090401@gmail.com> <ada8wbzi490.fsf@roland-alpha.cisco.com> <4BCFFC48.4060401@gmail.com> <adazl0c92kp.fsf@roland-alpha.cisco.com> <4BEC06DB.30505@gmail.com> <adapr0zsswc.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adapr0zsswc.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org, roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > Maybe we should use the /proc/pid/pagemap and /proc/kpageflags files?
>  > These files let a userspace process find out which physical frame
>  > each virtual page is mapped to and to get the properties of each page
>  > frame including the page size.
> 
> Sounds interesting... the only problem is that /proc/kpageflags is
> root-only, so we can't use that.  But does /proc/pid/pagemap give enough
> information to be useful?

The most useful information that /proc/pid/pagemap provides the PFN (if the
page is not swapped out). In fact there is very useful tool called 
Documentation/vm/page-types.c which gives a lot of the information that we 
need. Again the caveat is that it uses /proc/kpageflags.

/proc/pid/pagemap also provided "page shift". I am not sure what that is
in the context of huge pages.
> 
>  > The disadvantage of this method is, that it applicable on kernel >=
>  > 2.6.25, since this interface is supported starting from the kernel
>  > 2.6.25.
> 
> I think that's OK

Pradeep

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
