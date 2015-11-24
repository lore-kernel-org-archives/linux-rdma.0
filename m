From: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: Re: [PATCH v1 2/8] svcrdma: Define maximum number of backchannel requests
Date: Mon, 23 Nov 2015 20:36:01 -0500
Message-ID: <CAHQdGtTWkCoaehHbYwHSOQg0zn96dT7S0W3pERALvVy3d7uyZw@mail.gmail.com>
References: <20151123221738.13040.26277.stgit@klimt.1015granger.net>
	<20151123222030.13040.19373.stgit@klimt.1015granger.net>
	<5653B1A6.3010707@talpey.com>
	<BABDB763-B4D6-4538-82FB-11F494BAC27C@oracle.com>
	<5653BB2C.4040209@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5653BB2C.4040209-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2015 at 8:19 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
> On 11/23/2015 8:09 PM, Chuck Lever wrote:
>>
>>
>>> On Nov 23, 2015, at 7:39 PM, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>> On 11/23/2015 5:20 PM, Chuck Lever wrote:
>>>>
>>>> Extra resources for handling backchannel requests have to be
>>>> pre-allocated when a transport instance is created. Set a limit.
>>>>
>>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>>   include/linux/sunrpc/svc_rdma.h          |    5 +++++
>>>>   net/sunrpc/xprtrdma/svc_rdma_transport.c |    6 +++++-
>>>>   2 files changed, 10 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/linux/sunrpc/svc_rdma.h
>>>> b/include/linux/sunrpc/svc_rdma.h
>>>> index f869807..478aa30 100644
>>>> --- a/include/linux/sunrpc/svc_rdma.h
>>>> +++ b/include/linux/sunrpc/svc_rdma.h
>>>> @@ -178,6 +178,11 @@ struct svcxprt_rdma {
>>>>   #define RPCRDMA_SQ_DEPTH_MULT   8
>>>>   #define RPCRDMA_MAX_REQUESTS    32
>>>>   #define RPCRDMA_MAX_REQ_SIZE    4096
>>>> +#if defined(CONFIG_SUNRPC_BACKCHANNEL)
>>>
>>>
>>> Why is this a config option? Why wouldn't you always want
>>> this? It's needed for any post-1990 NFS dialect.
>>
>>
>> I think some distros want to be able to compile out NFSv4.x
>> on small systems, and take all the backchannel cruft with it.
>
>
> So shouldn't it follow the NFSv4.x config options then?

It does. Why the question?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
