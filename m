From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2.6.37] RDMA/cxgb3: When a user QP is marked in error,
 also mark the CQs in error.
Date: Wed, 20 Oct 2010 18:34:24 -0500
Message-ID: <4CBF7C80.3080400@opengridcomputing.com>
References: <20101020214432.4869.50981.stgit@build.ogc.int> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801FC1F@orsmsx501.amr.corp.intel.com> <4CBF6F3F.10507@opengridcomputing.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801FCA3@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B801FCA3-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/20/2010 5:41 PM, Hefty, Sean wrote:
> You have this check:
>
>>>> +		if (udata->outlen<   sizeof uresp) {
>>>> +			if (!warned++)
>>>> +				printk(KERN_WARNING MOD "Warning - "
>>>> +				       "downlevel libcxgb3 (non-fatal).\n");
>>>> +			mm->len = PAGE_ALIGN((1UL<<   uresp.size_log2) *
>>>> +					     sizeof(struct t3_cqe));
> then fall through to here:
>
>>>>    		if (ib_copy_to_udata(udata,&uresp, sizeof (uresp))) {
>
>> The only way it can be less is if the library is using the ABI 0 version
>> of the response struct.  Or am I missing something?
> To me, this looks like the buffer referenced by udata will be smaller than the size of the data being copied, which I expect would either fail, or the kernel will overwrite some unsuspecting user memory.

You're right: the ib_copy_to_udata() size needs to be adjusted 
accordingly.  Good catch.  Although the testing didn't cause any faults.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
