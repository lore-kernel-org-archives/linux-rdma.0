From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 04/18] xprtrdma: Prevent inline overflow
Date: Tue, 26 Apr 2016 23:42:27 +0300
Message-ID: <571FD2B3.1010505@grimberg.me>
References: <20160425185956.3566.64142.stgit@manet.1015granger.net>
 <20160425192120.3566.99978.stgit@manet.1015granger.net>
 <571FC7A3.2010407@grimberg.me>
 <B6501EE8-870B-40C6-8F44-FA74308EC6E5@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B6501EE8-870B-40C6-8F44-FA74308EC6E5-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> When deciding whether to send a Call inline, rpcrdma_marshal_req
>>> doesn't take into account header bytes consumed by chunk lists.
>>> This results in Call messages on the wire that are sometimes larger
>>> than the inline threshold.
>>
>> I'm not sure I understand why you need to account the chunk list size
>> when deciding on the inline data size., aren't chunk lists for remote
>> access only?
>
> The chunk lists and RPC message payload effectively
> share the same 1024-byte buffer (it's two buffers
> gathered, but the sum of the two buffer sizes has to
> be less than 1025).
>
> If the chunk lists are large, the RPC message size is
> reduced.
>

I'm effectively asking when will a chunk list and inline data
would appear in the same message?

Is it when we want to send the first X bytes inline and have the
remote read the rest Y-X bytes?

Sorry if this is completely basic, just trying to understand if you
really need that upper limit...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
