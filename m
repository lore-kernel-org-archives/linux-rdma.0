From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] svcrdma: Fix NFS server crash triggered by 1MB NFS WRITE
Date: Mon, 5 Oct 2015 21:47:29 -0400
Message-ID: <6998D6F7-ECD3-4CF6-9DF1-C47551ABA9F2@oracle.com>
References: <20151005025022.5074.89318.stgit@klimt.1015granger.net> <001801d0ffa5$ebd3aff0$c37b0fd0$@opengridcomputing.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <001801d0ffa5$ebd3aff0$c37b0fd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Oct 5, 2015, at 3:42 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> 
> 
> 
>> -----Original Message-----
>> From: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Chuck Lever
>> Sent: Sunday, October 04, 2015 10:03 PM
>> To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: [PATCH] svcrdma: Fix NFS server crash triggered by 1MB NFS WRITE
>> 
>> Now that the NFS server advertises a maximum payload size of 1MB
>> for RPC/RDMA again, it crashes in svc_process_common() when NFS
>> client sends a 1MB NFS WRITE on an NFS/RDMA mount.
>> 
>> The server has set up a 259 element array of struct page pointers
>> in rq_pages[] for each incoming request. The last element of the
>> array is NULL.
>> 
>> When an incoming request has been completely received,
>> rdma_read_complete() attempts to set the starting page of the
>> incoming page vector:
>> 
>>  rqstp->rq_arg.pages = &rqstp->rq_pages[head->hdr_count];
>> 
>> and the page to use for the reply:
>> 
>>  rqstp->rq_respages = &rqstp->rq_arg.pages[page_no];
>> 
>> But the value of page_no has already accounted for head->hdr_count.
>> Thus rq_respages now points past the end of the incoming pages. For
>> NFS WRITE operations smaller than the maximum, this is harmless.
>> 
>> But when the NFS WRITE operation is as large as the server's max
>> payload size, rq_respages now points at the last entry in rq_pages,
>> which is NULL.
>> 
>> Fixes: cc9a903d915c ('svcrdma: Change maximum server payload . . .')
>> BugLink: https://bugzilla.linux-nfs.org/show_bug.cgi?id=270
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> 
>> This fixes a 4.3-rc regression. Please apply to 4.3-rc when this
>> patch passes review.
>> 
>> It could also be appropriate for stable kernels which do not have
>> commit 7e5be28827bf ("svcrdma: advertise the correct max payload"),
>> though I have not tested them with this patch.
>> 
>> net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> index cb51742..37b4341 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> @@ -531,7 +531,7 @@ static int rdma_read_complete(struct svc_rqst *rqstp,
>>    rqstp->rq_arg.page_base = head->arg.page_base;
>> 
>>    /* rq_respages starts after the last arg page */
>> -    rqstp->rq_respages = &rqstp->rq_arg.pages[page_no];
>> +    rqstp->rq_respages = &rqstp->rq_pages[page_no];
>>    rqstp->rq_next_page = rqstp->rq_respages + 1;
>> 
>>    /* Rebuild rq_arg head and tail. */
>> 
> 
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
