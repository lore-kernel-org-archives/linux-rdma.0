From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 07/12] xprtrdma: Don't provide a reply chunk when
 expecting a short reply
Date: Sun, 12 Jul 2015 17:58:36 +0300
Message-ID: <55A2809C.7020106@dev.mellanox.co.il>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
 <20150709204246.26247.10367.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709204246.26247.10367.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 11:42 PM, Chuck Lever wrote:
> Currently Linux always offers a reply chunk, even for small replies
> (unless a read or write list is needed for the RPC operation).
>
> A comment in rpcrdma_marshal_req() reads:
>
>> Currently we try to not actually use read inline.
>> Reply chunks have the desirable property that
>> they land, packed, directly in the target buffers
>> without headers, so they require no fixup. The
>> additional RDMA Write op sends the same amount
>> of data, streams on-the-wire and adds no overhead
>> on receive. Therefore, we request a reply chunk
>> for non-writes wherever feasible and efficient.
>
> This considers only the network bandwidth cost of sending the RPC
> reply. For replies which are only a few dozen bytes, this is
> typically not a good trade-off.
>
> If the server chooses to return the reply inline:
>
>   - The client has registered and invalidated a memory region to
>     catch the reply, which is then not used
>
> If the server chooses to use the reply chunk:
>
>   - The server sends a few bytes using a heavyweight RDMA WRITE for
>     operation. The entire RPC reply is conveyed in two RDMA
>     operations (WRITE_ONLY, SEND) instead of one.

Pipelined WRITE+SEND operations are hardly an overhead compared to
copying chunks of data.

>
> Note that both the server and client have to prepare or copy the
> reply data anyway to construct these replies. There's no benefit to
> using an RDMA transfer since the host CPU has to be involved.

I think that preparation (posting 1 or 2 WQEs) and copying
chunks of data of say 8K-16K might be different.

I understand that you probably see better performance scaling. But this
might be HW dependent. Also, this might backfire on you if your
configuration is one-to-many. Then, data copy CPU cycles might become
more expensive.

I don't really know what is better, but just thought I'd present
another side to this.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
