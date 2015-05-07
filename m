From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 03/14] xprtrdma: Replace rpcrdma_rep::rr_buffer with rr_rxprt
Date: Thu, 7 May 2015 09:25:55 -0400
Message-ID: <11CFA1BF-9502-45A0-B0A5-F7BD7049F6A9@oracle.com>
References: <20150504174626.3483.97639.stgit@manet.1015granger.net> <20150504175711.3483.17222.stgit@manet.1015granger.net> <554B328B.9040804@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <554B328B.9040804-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 7, 2015, at 5:38 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 5/4/2015 8:57 PM, Chuck Lever wrote:
>> Clean up: Instead of carrying a pointer to the buffer pool and
>> the rpc_xprt, carry a pointer to the controlling rpcrdma_xprt.
>> 
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>>  net/sunrpc/xprtrdma/rpc_rdma.c  |    4 ++--
>>  net/sunrpc/xprtrdma/transport.c |    7 ++-----
>>  net/sunrpc/xprtrdma/verbs.c     |    8 +++++---
>>  net/sunrpc/xprtrdma/xprt_rdma.h |    3 +--
>>  4 files changed, 10 insertions(+), 12 deletions(-)
>> 
>> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
>> index 2c53ea9..98a3b95 100644
>> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
>> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
>> @@ -732,8 +732,8 @@ rpcrdma_reply_handler(struct rpcrdma_rep *rep)
>>  	struct rpcrdma_msg *headerp;
>>  	struct rpcrdma_req *req;
>>  	struct rpc_rqst *rqst;
>> -	struct rpc_xprt *xprt = rep->rr_xprt;
>> -	struct rpcrdma_xprt *r_xprt = rpcx_to_rdmax(xprt);
>> +	struct rpcrdma_xprt *r_xprt = rep->rr_rxprt;
>> +	struct rpc_xprt *xprt = &r_xprt->rx_xprt;
>>  	__be32 *iptr;
>>  	int rdmalen, status;
>>  	unsigned long cwnd;
>> diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
>> index fdcb2c7..ed70551 100644
>> --- a/net/sunrpc/xprtrdma/transport.c
>> +++ b/net/sunrpc/xprtrdma/transport.c
>> @@ -650,12 +650,9 @@ xprt_rdma_send_request(struct rpc_task *task)
>> 
>>  	if (req->rl_reply == NULL) 		/* e.g. reconnection */
>>  		rpcrdma_recv_buffer_get(req);
>> -
>> -	if (req->rl_reply) {
>> +	/* rpcrdma_recv_buffer_get may have set rl_reply, so check again */
>> +	if (req->rl_reply)
>>  		req->rl_reply->rr_func = rpcrdma_reply_handler;
>> -		/* this need only be done once, but... */
>> -		req->rl_reply->rr_xprt = xprt;
>> -	}
> 
> Can't you just fold that into rpcrdma_recv_buffer_get() instead of
> checking what it did?

rr_func is going away in an upcoming merge window.


> Other than that,
> 
> Looks good,
> 
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
