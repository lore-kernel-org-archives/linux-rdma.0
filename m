From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 04/18] xprtrdma: Prevent inline overflow
Date: Tue, 26 Apr 2016 16:04:59 -0400
Message-ID: <B6501EE8-870B-40C6-8F44-FA74308EC6E5@oracle.com>
References: <20160425185956.3566.64142.stgit@manet.1015granger.net> <20160425192120.3566.99978.stgit@manet.1015granger.net> <571FC7A3.2010407@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571FC7A3.2010407-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Apr 26, 2016, at 3:55 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>> When deciding whether to send a Call inline, rpcrdma_marshal_req
>> doesn't take into account header bytes consumed by chunk lists.
>> This results in Call messages on the wire that are sometimes larger
>> than the inline threshold.
> 
> I'm not sure I understand why you need to account the chunk list size
> when deciding on the inline data size., aren't chunk lists for remote
> access only?

The chunk lists and RPC message payload effectively
share the same 1024-byte buffer (it's two buffers
gathered, but the sum of the two buffer sizes has to
be less than 1025).

If the chunk lists are large, the RPC message size is
reduced.


> Is this a first-burst kind of functionality?
> 
>> Likewise, when a Write list or Reply chunk is in play, the server's
>> reply has to emit an RDMA Send that includes a larger-than-minimal
>> RPC-over-RDMA header.
>> 
>> The actual size of a Call message cannot be estimated until after
>> the chunk lists have been registered. Thus the size of each
>> RPC-over-RDMA header can be estimated only after chunks are
>> registered; but the decision to register chunks is based on the size
>> of that header. Chicken, meet egg.
> 
> :)
> 
>> The best a client can do is estimate header size based on the
>> largest header that might occur, and then ensure that inline content
>> is always smaller than that.
> 
> Isn't that a big loss?

For FRWR, the maximum header size is adjusted based on
the HCA's capabilities. If the HCA can send the whole
payload in one chunk, then the maximum header size is
about 64 bytes.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
