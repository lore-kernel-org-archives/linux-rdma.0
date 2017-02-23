From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] sunrpc: flag transports as using IETF approved
 congestion control protocols
Date: Thu, 23 Feb 2017 15:33:53 -0500
Message-ID: <18ef37c3-95db-9a2c-dbcb-f579672065d6@talpey.com>
References: <20170223170337.10686-1-jlayton@redhat.com>
 <20170223170337.10686-2-jlayton@redhat.com>
 <2152dfdf-f847-2511-1600-6499b6ea9708@talpey.com>
 <1487880034.3448.8.camel@redhat.com>
 <65056db6-f30a-c44d-b01c-b549887c4895@talpey.com>
 <20170223201109.GC11882@fieldses.org>
 <20170223202609.GC26301@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170223202609.GC26301-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, schumaker.anna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/23/2017 3:26 PM, Jason Gunthorpe wrote:
> On Thu, Feb 23, 2017 at 03:11:09PM -0500, J. Bruce Fields wrote:
>
>> (And if we really shouldn't be doing NFSv4 over some RDMA transports--is
>> it worth supporting them at all, if the only support we can get is
>> NFSv3-only?)
>
> This seems like a strange comment - NFSv4 should be supported on all
> RDMA transports, surely?
>
> Largely RDMA lives in its own congestion management world. If a site
> is running RDMA they have done something to mitigate interactions with
> TCP style congestion control on the same wire.

The key words are "IETF-approved". Mitigation and Interaction are
operational decisions, not protocol design.

We could argue that the requirement is bogus, or that all RDMA transports
comply, or that the RPCRDMA layer provides it, but none of these arguments
would grant IETF approval. That said, I think there's a lot of
room for interpretation here.

Tom.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
