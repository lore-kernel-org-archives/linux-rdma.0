From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 10/10] svcrdma: Handle additional inline content
Date: Tue, 13 Jan 2015 09:35:54 -0500
Message-ID: <FDA9AF43-0F4F-4887-AE23-EEE8979AF8BA@oracle.com>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net> <20150109192319.4901.89444.stgit@klimt.1015granger.net> <54B2BA77.20101@dev.mellanox.co.il> <46D2849E-39D7-4290-91CE-FD66E3F96B21@oracle.com> <54B4EF5D.3040201@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B4EF5D.3040201-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jan 13, 2015, at 5:11 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> w=
rote:

> On 1/12/2015 3:13 AM, Chuck Lever wrote:
>>=20
>> On Jan 11, 2015, at 1:01 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org=
> wrote:
>>=20
>>> On 1/9/2015 9:23 PM, Chuck Lever wrote:
>>>> Most NFS RPCs place large payload arguments at the end of the RPC
>>>> header (eg, NFSv3 WRITE). For NFSv3 WRITE and SYMLINK, RPC/RDMA
>>>> sends the complete RPC header inline, and the payload argument in =
a
>>>> read list.
>>>>=20
>>>> One important case is not like this, however. NFSv4 WRITE compound=
s
>>>> can have an operation after the WRITE operation. The proper way to
>>>> convey an NFSv4 WRITE is to place the GETATTR inline, but _after_
>>>> the read list position. (Note Linux clients currently do not do
>>>> this, but they will be changed to do it in the future).
>>>>=20
>>>> The receiver could put trailing inline content in the XDR tail
>>>> buffer. But the Linux server's NFSv4 compound processing does not
>>>> consider the XDR tail buffer.
>>>>=20
>>>> So, move trailing inline content to the end of the page list. This
>>>> presents the incoming compound to upper layers the same way the
>>>> socket code does.
>>>>=20
>>>=20
>>> Would this memcpy be saved if you just posted a larger receive buff=
er
>>> and the client would used it "really inline" as part of it's post_s=
end?
>>=20
>> The receive buffer doesn=92t need to be larger. Clients already shou=
ld
>> construct this trailing inline content in their SEND buffers.
>>=20
>> Not that the  Linux client doesn=92t yet send the extra inline via R=
DMA
>> SEND, it uses a separate RDMA READ to move the extra bytes, and that=
=92s
>> a bug.
>>=20
>> If the client does send this inline as it=92s supposed to, the serve=
r
>> would receive it in its pre-posted RECV buffer. This patch simply
>> moves that content into the XDR buffer page list, where the server=92=
s
>> XDR decoder can find it.
>=20
> Would it make more sense to manipulate pointers instead of copying da=
ta?

It would. My first approach was to use the tail iovec in xdr_buf.
Simply point the tail=92s iov_addr at trailing inline content in the
RECV buffer.

But as mentioned, the server=92s XDR decoders don=92t look at the tail
iovec.

The socket transport delivers this little piece of data at the end of
the xdr_buf page list, because all it has to do is read data off the
socket and stick it in pages.

So svcrdma can do that too. It=92s a little more awkward, but the upper
layer code stays the same.

> But if this is only 16 bytes than maybe it's not worth the trouble=85

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
