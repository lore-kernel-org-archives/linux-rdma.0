From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Sun, 12 Jul 2015 14:15:56 -0400
Message-ID: <96901C8F-D916-4ECF-8DA4-C5C67FB8539E@oracle.com>
References: <559F8BD1.9080308@dev.mellanox.co.il> <20150711103920.GE14741@infradead.org> <55A21DF6.6090909@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A21DF6.6090909-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jul 12, 2015, at 3:57 AM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> w=
rote:

> On 7/11/2015 1:39 PM, Christoph Hellwig wrote:
>> On Fri, Jul 10, 2015 at 12:09:37PM +0300, Sagi Grimberg wrote:
>>> And then provide helpers to populate the MR with generic kernel
>>> structures such as struct scatterlist (for scsi and other ULPs),
>>> struct page (for NFS) or struct bio_vec (for block ULPs later on).
>>=20
>> Please stick to struct scatterlist for now.  Future block ULPs
>> will use that as well as the only way you can do a multi-page
>> DMA mapping is the scatterlist.
>=20
> I see.
>=20
>> A page is just a subset of an SGL, and we can map a page using a one=
 element SGL trivial,
>> as we do in lots of places.
>>=20
>=20
> But won't that make sunrpc rdma consumers to hold an extra scatterlis=
t
> just for memory registration?

Yes. xprtrdma=92s FMR implementation already has a physaddrs array
for this purpose, and it=92s FRWR implementation keeps an
ib_fast_reg_page_list array for each MR.=20


> Chuck, Would a scatterlist API make life easier for you?

No benefit for me.

The NFS upper layer already slices and dices I/O until it is a
stream of contiguous single I/O requests for the server.

It passes down a vector of struct page pointers which xprtrdma=92s
memory registration logic has to walk through and convert into
something the provider can deal with.

See fmr_op_map and frwr_op_map. The loop in there becomes costly
as the number of pages involved in an I/O request increases.

I suppose an s/g list wouldn=92t be much different from the current
arrangement. And if NFS and SunRPC are the only users that deal
with struct page, then there=92s no code sharing benefit to
providing a provider API based on struct page.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
