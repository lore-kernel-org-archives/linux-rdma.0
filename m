From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 8/8] svcrdma: Remove svc_rdma_fastreg_mr::access_flags field
Date: Tue, 24 Nov 2015 09:08:21 -0500
Message-ID: <7B9388F8-3A88-4F61-AB87-A1E6DB9902FE@oracle.com>
References: <20151123221738.13040.26277.stgit@klimt.1015granger.net> <20151123222118.13040.24258.stgit@klimt.1015granger.net> <5653B4CA.5050806@talpey.com> <92B143FC-0F2C-48E4-9042-189883D76403@oracle.com> <20151124063903.GA12300@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151124063903.GA12300-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Nov 24, 2015, at 1:39 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wr=
ote:
>=20
> On Mon, Nov 23, 2015 at 07:53:04PM -0500, Chuck Lever wrote:
>>> Wait, the REMOTE_WRITE is there to support iWARP, but it isn't
>>> needed for IB or RoCE. Shouldn't this be updated to peek at those
>>> new attributes to decide, instead of remaining unconditional?
>>=20
>> That???s coming in another patch from Christoph.
>=20
> Can you drop this patch so that we have less conflicts with that one,
> assuming this series goes in through the NFS tree, and the memory
> registration changes go in through the RDMA tree?

Why don=E2=80=99t you fold my change into yours?


--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
