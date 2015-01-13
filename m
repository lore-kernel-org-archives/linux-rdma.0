From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 10/10] svcrdma: Handle additional inline content
Date: Tue, 13 Jan 2015 12:11:41 +0200
Message-ID: <54B4EF5D.3040201@dev.mellanox.co.il>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net> <20150109192319.4901.89444.stgit@klimt.1015granger.net> <54B2BA77.20101@dev.mellanox.co.il> <46D2849E-39D7-4290-91CE-FD66E3F96B21@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <46D2849E-39D7-4290-91CE-FD66E3F96B21-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/12/2015 3:13 AM, Chuck Lever wrote:
>
> On Jan 11, 2015, at 1:01 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
>
>> On 1/9/2015 9:23 PM, Chuck Lever wrote:
>>> Most NFS RPCs place large payload arguments at the end of the RPC
>>> header (eg, NFSv3 WRITE). For NFSv3 WRITE and SYMLINK, RPC/RDMA
>>> sends the complete RPC header inline, and the payload argument in a
>>> read list.
>>>
>>> One important case is not like this, however. NFSv4 WRITE compounds
>>> can have an operation after the WRITE operation. The proper way to
>>> convey an NFSv4 WRITE is to place the GETATTR inline, but _after_
>>> the read list position. (Note Linux clients currently do not do
>>> this, but they will be changed to do it in the future).
>>>
>>> The receiver could put trailing inline content in the XDR tail
>>> buffer. But the Linux server's NFSv4 compound processing does not
>>> consider the XDR tail buffer.
>>>
>>> So, move trailing inline content to the end of the page list. This
>>> presents the incoming compound to upper layers the same way the
>>> socket code does.
>>>
>>
>> Would this memcpy be saved if you just posted a larger receive buffe=
r
>> and the client would used it "really inline" as part of it's post_se=
nd?
>
> The receive buffer doesn=92t need to be larger. Clients already shoul=
d
> construct this trailing inline content in their SEND buffers.
>
> Not that the  Linux client doesn=92t yet send the extra inline via RD=
MA
> SEND, it uses a separate RDMA READ to move the extra bytes, and that=92=
s
> a bug.
>
> If the client does send this inline as it=92s supposed to, the server
> would receive it in its pre-posted RECV buffer. This patch simply
> moves that content into the XDR buffer page list, where the server=92=
s
> XDR decoder can find it.

Would it make more sense to manipulate pointers instead of copying data=
?
But if this is only 16 bytes than maybe it's not worth the trouble...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
