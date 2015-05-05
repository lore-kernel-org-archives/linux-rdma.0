From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/16] NFS/RDMA patches proposed for 4.1
Date: Tue, 5 May 2015 12:04:00 -0400
Message-ID: <5E1B32EA-9803-49AA-856D-BF0E1A5DFFF4@oracle.com>
References: <20150313211124.22471.14517.stgit@manet.1015granger.net> <20150505154411.GA16729@infradead.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150505154411.GA16729-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On May 5, 2015, at 11:44 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrot=
e:

> On Fri, Mar 13, 2015 at 05:21:17PM -0400, Chuck Lever wrote:
>> This is a series of client-side patches for NFS/RDMA. In preparation
>> for increasing the transport credit limit and maximum rsize/wsize,
>> I've re-factored the memory registration logic into separate files,
>> invoked via a method API.
>=20
> Just curious if you ever though of moving this into the generic
> rdma layer?

Not really. The new files are really just shims that adapt the RPC/RDMA
transport to memory registration verbs. There=92s only a few hundred li=
nes
per registration mode, and it=92s all fairly specific to RPC/RDMA.

> I've been working on a rdma based storage driver recently, and the
> various different memory registration methods are a complete pain in =
the
> ass, and impossible to test in and ULD without havin access to all ki=
nds
> of different hardware.

Agree that the test matrix grows exponentially in complexity and
expense as more MR modes are introduced. We have strategies for
managing this when there=92s a community involved, but when there=92s
just one developer it=92s a challenge.

> And from I see we litterly dont use them much different from the gene=
ric
> dma mapping API helpers (at a very high level) so it seems it should
> be easy to move a slightly expanded version of your API to the core
> code.

IMO FRWR is the only registration mode that has legs for the long term,
and is specifically designed for storage.

If you are not working on a legacy piece of code that has to support
older HCAs, why not stay with FRWR?

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
