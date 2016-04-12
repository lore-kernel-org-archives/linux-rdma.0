From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 02/18] xprtrdma: Bound the inline threshold values
Date: Tue, 12 Apr 2016 15:12:23 -0400
Message-ID: <EB3272A1-F8A1-4226-8D8D-F77EF3133302@oracle.com>
References: <20160411200323.20531.8893.stgit@manet.1015granger.net> <20160411201024.20531.77252.stgit@manet.1015granger.net> <570D38B6.30005@Netapp.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <570D38B6.30005-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Apr 12, 2016, at 2:04 PM, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org> wrote:
> 
> On 04/11/2016 04:10 PM, Chuck Lever wrote:
>> Currently the sysctls that allow setting the inline threshold allow
>> any value to be set.
>> 
>> Small values only make the transport run slower. The default 1KB
>> setting is as low as is reasonable. And the logic that decides how
>> to divide a Send buffer buffer between RPC-over-RDMA header and RPC
>                   ^^^^^^^^^^^^^
> I'm guessing you don't mean a buffer of buffers? :)
> 
>> message assumes (but does not check) that the lower bound is not
>> crazy (say, 57 bytes).
>> 
>> Send and receive buffers share a page with some control information.
>> Values larger than about 3KB can't be supported, currently.
>> 
>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> include/linux/sunrpc/xprtrdma.h |    4 +++-
>> net/sunrpc/xprtrdma/transport.c |    6 ++++++
>> 2 files changed, 9 insertions(+), 1 deletion(-)
>> 
>> diff --git a/include/linux/sunrpc/xprtrdma.h b/include/linux/sunrpc/xprtrdma.h
>> index 767190b..39267dc 100644
>> --- a/include/linux/sunrpc/xprtrdma.h
>> +++ b/include/linux/sunrpc/xprtrdma.h
>> @@ -52,7 +52,9 @@
>> #define RPCRDMA_DEF_SLOT_TABLE	(128U)
>> #define RPCRDMA_MAX_SLOT_TABLE	(256U)
>> 
>> -#define RPCRDMA_DEF_INLINE  (1024)	/* default inline max */
>> +#define RPCRDMA_MIN_INLINE  (1024)	/* min inline thresh */
>> +#define RPCRDMA_DEF_INLINE  (1024)	/* default inline thresh */
>> +#define RPCRDMA_MAX_INLINE  (3068)	/* max inline thresh */
> 
> It looks like RPCRDMA_DEF_INLINE is used to set xprt_rdma_max_inline_{read,write}. Are we keeping DEF_INLINE around so we can set these values separately from the minimum and maximum amounts?

Yes, the default and the minimum happen to be the same
at the moment, but that may not always be the case.


> Thanks,
> Anna
> 
>> 
>> /* Memory registration strategies, by number.
>>  * This is part of a kernel / user space API. Do not remove. */
>> diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
>> index 9954342..16595ff 100644
>> --- a/net/sunrpc/xprtrdma/transport.c
>> +++ b/net/sunrpc/xprtrdma/transport.c
>> @@ -73,6 +73,8 @@ static unsigned int xprt_rdma_memreg_strategy = RPCRDMA_FRMR;
>> 
>> static unsigned int min_slot_table_size = RPCRDMA_MIN_SLOT_TABLE;
>> static unsigned int max_slot_table_size = RPCRDMA_MAX_SLOT_TABLE;
>> +static unsigned int min_inline_size = RPCRDMA_MIN_INLINE;
>> +static unsigned int max_inline_size = RPCRDMA_MAX_INLINE;
>> static unsigned int zero;
>> static unsigned int max_padding = PAGE_SIZE;
>> static unsigned int min_memreg = RPCRDMA_BOUNCEBUFFERS;
>> @@ -96,6 +98,8 @@ static struct ctl_table xr_tunables_table[] = {
>> 		.maxlen		= sizeof(unsigned int),
>> 		.mode		= 0644,
>> 		.proc_handler	= proc_dointvec,
>> +		.extra1		= &min_inline_size,
>> +		.extra2		= &max_inline_size,
>> 	},
>> 	{
>> 		.procname	= "rdma_max_inline_write",
>> @@ -103,6 +107,8 @@ static struct ctl_table xr_tunables_table[] = {
>> 		.maxlen		= sizeof(unsigned int),
>> 		.mode		= 0644,
>> 		.proc_handler	= proc_dointvec,
>> +		.extra1		= &min_inline_size,
>> +		.extra2		= &max_inline_size,
>> 	},
>> 	{
>> 		.procname	= "rdma_inline_write_padding",
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
