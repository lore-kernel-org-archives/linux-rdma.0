From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] svcrdma: Fix NFS server crash triggered by 1MB NFS WRITE
Date: Mon, 5 Oct 2015 18:03:07 +0300
Message-ID: <5612912B.7080105@dev.mellanox.co.il>
References: <20151005025022.5074.89318.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151005025022.5074.89318.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/5/2015 6:03 AM, Chuck Lever wrote:
> Now that the NFS server advertises a maximum payload size of 1MB
> for RPC/RDMA again, it crashes in svc_process_common() when NFS
> client sends a 1MB NFS WRITE on an NFS/RDMA mount.
>
> The server has set up a 259 element array of struct page pointers
> in rq_pages[] for each incoming request. The last element of the
> array is NULL.
>
> When an incoming request has been completely received,
> rdma_read_complete() attempts to set the starting page of the
> incoming page vector:
>
>    rqstp->rq_arg.pages = &rqstp->rq_pages[head->hdr_count];
>
> and the page to use for the reply:
>
>    rqstp->rq_respages = &rqstp->rq_arg.pages[page_no];
>
> But the value of page_no has already accounted for head->hdr_count.
> Thus rq_respages now points past the end of the incoming pages. For
> NFS WRITE operations smaller than the maximum, this is harmless.
>
> But when the NFS WRITE operation is as large as the server's max
> payload size, rq_respages now points at the last entry in rq_pages,
> which is NULL.
>
> Fixes: cc9a903d915c ('svcrdma: Change maximum server payload . . .')
> BugLink: https://bugzilla.linux-nfs.org/show_bug.cgi?id=270
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---

Looks correct,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
