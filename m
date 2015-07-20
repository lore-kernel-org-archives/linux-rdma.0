From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC] svcrdma: Fix possible over population
 fast_reg_page_list
Date: Mon, 20 Jul 2015 20:19:58 +0300
Message-ID: <55AD2DBE.7090006@dev.mellanox.co.il>
References: <1437411614-29722-1-git-send-email-sagig@mellanox.com>
 <C3FCF5F9-07D6-4A6D-8114-CB700038797E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C3FCF5F9-07D6-4A6D-8114-CB700038797E-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/20/2015 8:13 PM, Chuck Lever wrote:
>
> On Jul 20, 2015, at 1:00 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
>> When accounting the needed_pages, we need to look into
>> the page_list->max_page_list_len and not the global
>> context xprt->sc_frmr_pg_list_len.
>>
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    3 ++-
>> 1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> index 2e1348b..b19ffd3 100644
>> --- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>> @@ -244,7 +244,8 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
>>
>> 	ctxt->direction = DMA_FROM_DEVICE;
>> 	ctxt->frmr = frmr;
>> -	pages_needed = min_t(int, pages_needed, xprt->sc_frmr_pg_list_len);
>> +	pages_needed = min_t(int, pages_needed,
>> +			     frmr->page_list->max_page_list_len);
>
> This is the last user of sc_frmr_pg_list_len. If Steve thinks this is
> a good change, then why not remove it.
>
> The client uses ib_device_attr::max_fast_reg_page_list_len too.
> Should it be fixed?

I've actually been playing around with this as part of the porting
to the new fast registration API which makes fast_reg_page_list go away.
xprtrdma and svcrdma are switched to use scatterlists instead and
the drivers handle the page lists internally.

So we can remove it, but I think this whole section will go away
eventually.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
