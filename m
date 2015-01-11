From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 10/10] svcrdma: Handle additional inline content
Date: Sun, 11 Jan 2015 20:01:27 +0200
Message-ID: <54B2BA77.20101@dev.mellanox.co.il>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net> <20150109192319.4901.89444.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150109192319.4901.89444.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/9/2015 9:23 PM, Chuck Lever wrote:
> Most NFS RPCs place large payload arguments at the end of the RPC
> header (eg, NFSv3 WRITE). For NFSv3 WRITE and SYMLINK, RPC/RDMA
> sends the complete RPC header inline, and the payload argument in a
> read list.
>
> One important case is not like this, however. NFSv4 WRITE compounds
> can have an operation after the WRITE operation. The proper way to
> convey an NFSv4 WRITE is to place the GETATTR inline, but _after_
> the read list position. (Note Linux clients currently do not do
> this, but they will be changed to do it in the future).
>
> The receiver could put trailing inline content in the XDR tail
> buffer. But the Linux server's NFSv4 compound processing does not
> consider the XDR tail buffer.
>
> So, move trailing inline content to the end of the page list. This
> presents the incoming compound to upper layers the same way the
> socket code does.
>

Would this memcpy be saved if you just posted a larger receive buffer
and the client would used it "really inline" as part of it's post_send?

I'm just trying to understand if this complicated logic is worth the
extra bytes of a larger recv buffer you are saving...

Will this code path happen a lot? If so you might get some overhead
you may want to avoid.

I may not see the full picture here... Just thought I'd ask...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
