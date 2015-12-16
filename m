From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 04/11] xprtrdma: Move struct ib_send_wr off the stack
Date: Wed, 16 Dec 2015 10:06:33 -0500
Message-ID: <F2E992ED-2698-43DE-B7C5-4F02DA75AE42@oracle.com>
References: <20151214211317.16295.70115.stgit@manet.1015granger.net> <20151214211811.16295.47695.stgit@manet.1015granger.net> <56716E6C.4020604@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56716E6C.4020604-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Dec 16, 2015, at 9:00 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
> 
>> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
>> index 4197191..e60d817 100644
>> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
>> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
>> @@ -206,6 +206,8 @@ struct rpcrdma_frmr {
>>  	enum rpcrdma_frmr_state		fr_state;
>>  	struct work_struct		fr_work;
>>  	struct rpcrdma_xprt		*fr_xprt;
>> +	struct ib_reg_wr		fr_regwr;
>> +	struct ib_send_wr		fr_invwr;
> 
> Would it make sense to unionize these as they are guaranteed not to
> execute together? Some people don't like this sort of savings.

I dislike unions because they make the code that uses
them less readable. I can define macros to help that,
but sigh! OK.


--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
