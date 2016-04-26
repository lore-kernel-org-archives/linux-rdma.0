From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 04/18] xprtrdma: Prevent inline overflow
Date: Tue, 26 Apr 2016 16:56:38 -0400
Message-ID: <928930E0-0767-4BF4-A704-B4E46788820F@oracle.com>
References: <20160425185956.3566.64142.stgit@manet.1015granger.net> <20160425192120.3566.99978.stgit@manet.1015granger.net> <571FC7A3.2010407@grimberg.me> <B6501EE8-870B-40C6-8F44-FA74308EC6E5@oracle.com> <571FD2B3.1010505@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571FD2B3.1010505-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Apr 26, 2016, at 4:42 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>>>> When deciding whether to send a Call inline, rpcrdma_marshal_req
>>>> doesn't take into account header bytes consumed by chunk lists.
>>>> This results in Call messages on the wire that are sometimes larger
>>>> than the inline threshold.
>>> 
>>> I'm not sure I understand why you need to account the chunk list size
>>> when deciding on the inline data size., aren't chunk lists for remote
>>> access only?
>> 
>> The chunk lists and RPC message payload effectively
>> share the same 1024-byte buffer (it's two buffers
>> gathered, but the sum of the two buffer sizes has to
>> be less than 1025).
>> 
>> If the chunk lists are large, the RPC message size is
>> reduced.
>> 
> 
> I'm effectively asking when will a chunk list and inline data
> would appear in the same message?
> 
> Is it when we want to send the first X bytes inline and have the
> remote read the rest Y-X bytes?
> 
> Sorry if this is completely basic, just trying to understand if you
> really need that upper limit...

It's kind of subtle, actually.

Consider the case when the ULP operation expects a
large reply.

When there is a Reply chunk or Write list, the client
provides those via chunk lists in the header of the
Call message. Thus those chunk lists share the 1024
bytes with the RPC Call message.

If the chunk lists plus the Call message don't fit
inline, then the client will have to send the Call
message in a Read chunk (RDMA_NOMSG).


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
