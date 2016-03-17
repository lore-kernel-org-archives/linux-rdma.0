From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] svcrdma: add IPv6 support
Date: Thu, 17 Mar 2016 10:01:50 -0400
Message-ID: <9D93B217-3044-4404-8EB4-6CD0DD759642@oracle.com>
References: <56E9A8DD.8030308@oracle.com> <20160317084210.GE25216@leon.nu>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160317084210.GE25216-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-2ukJVAZIZ/Y@public.gmane.org
Cc: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Server-side patch; cc-ing Bruce.

> On Mar 17, 2016, at 4:42 AM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> 
> On Wed, Mar 16, 2016 at 11:41:33AM -0700, Shirley Ma wrote:
>> Add rdma6 option to support NFS/RDMA IPv6.
>> Allow both IPv4 and IPv6 to bind same port at the same time,
>> restricts use of the IPv6 socket to IPv6 communication.
>> 
>> Changes from v1:
>> - Check rdma_set_afonly return value (suggested by Leon Romanovsky)
> 
> Looks good to me.
> Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Thanks.
> 
>> 
>> Signed-off-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> ---
>> 
>> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
>> @@ -869,7 +869,7 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
>> 	int ret;
>> 
>> 	dprintk("svcrdma: Creating RDMA socket\n");
>> -	if (sa->sa_family != AF_INET) {
>> +	if ((sa->sa_family != AF_INET) && (sa->sa_family != AF_INET6)) {
> 
>> 		dprintk("svcrdma: Address family %d is not supported.\n", sa->sa_family);
>> 		return ERR_PTR(-EAFNOSUPPORT);
>> 	}
>> @@ -885,6 +885,16 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
>> 		goto err0;
>> 	}
>> 
>> +	/* Allow both IPv4 and IPv6 sockets to bind a single port
>> +	 * at the same time.
>> +	 */
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +	ret = rdma_set_afonly(listen_id, 1);
>> +	if (ret) {
>> +		dprintk("svcrdma: rdma_set_afonly failed = %d\n", ret);
>> +		goto err1;
>> +	}
>> +#endif
>> 	ret = rdma_bind_addr(listen_id, sa);
>> 	if (ret) {
>> 		dprintk("svcrdma: rdma_bind_addr failed = %d\n", ret);
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
