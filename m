From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_post_send/recv kernel path optimizations
Date: Tue, 14 Dec 2010 14:12:56 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066ABCF66@irsmsx503.ger.corp.intel.com>
References: <20101007161649.GD21206@obsidianresearch.com>
	<20101007165947.GD11681@bicker>
	<20101009231607.GA24649@obsidianresearch.com> <20101012113117.GB6742@bicker>
	<20101012210118.GR24268@obsidianresearch.com> <20101013091312.GB6060@bicker>
	<20101123071025.GI1522@bicker> <adahbf6gytv.fsf@cisco.com>
	<20101124221845.GH2369@obsidianresearch.com> <adad3pugi90.fsf@cisco.com>
	<20101125041337.GA11049@obsidianresearch.com>
	<4CEE7A22.2040706@voltaire.com>
 <BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
 <4CF60343.7050602@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF60343.7050602-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or,

I looked into shared page approach of passing post_send/post_recv info. I still have some concerns.

The shared page must be allocated per QP and there should be a common way to allocate such page for each driver.

As Jason and Roland said, the best way to pass this parameter through mmap is offset. There is no common way how the 
Offset is used per driver and it is driver specific parameter.

The next problem is how many shared pages should driver allocate to share with user-space. They should contain place for each posted buffer by application. It is a big concern to post_recv where large number of buffers are posted.
Current implementation has no such limit. 

Even the common offset definition would be defined and accepted, the shared page must be stored in ib_qp structure. 
When a post_send is called for many QPs, there is a single entry point to ib_uverbs_post_send using write to /dev/infiniband/uverbsX. In that case there is a lookup to QP store (idr_read_qp) necessary to find a correct ibv_qp 
 Structure, what is a big time consumer on the path. 

The NES IMA kernel path also has such QP lookup but the QP number format is designed to make such lookup very quickly.
The QP numbers in OFED are not defined so generic lookup functions like idr_read_qp() must be use.

Regards,

Mirek


-----Original Message-----
From: Or Gerlitz [mailto:ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org] 
Sent: Wednesday, December 01, 2010 9:12 AM
To: Walukiewicz, Miroslaw; Jason Gunthorpe; Roland Dreier
Cc: Roland Dreier; Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: ibv_post_send/recv kernel path optimizations

On 11/26/2010 1:56 PM, Walukiewicz, Miroslaw wrote:
> Form the trace it looks like the __up_read() - 11% wastes most of time. It is called from idr_read_qp when a  put_uobj_read is called. if (copy_from_user(&cmd, buf, sizeof cmd))  - 5% it is called twice from ib_uverbs_post_send() for IMA and once in ib_uverbs_write() per each frame... and __kmalloc/kfree - 5% is the third function that has a big meaning. It is called twice for each frame transmitted. It is about 20% of performance loss comparing to nes_ud_sksq path which we miss when we use a OFED path.
>
> What I can modify is a kmalloc/kfree optimization - it is possible to make allocation only at start and use pre-allocated buffers. I don't see any way for optimalization of idr_read_qp usage or copy_user. In current approach we use a shared page and a separate nes_ud_sksq handle for each created QP so there is no need for any user space data copy or QP lookup.
As was mentioned earlier on this thread, and repeated here, the 
kmalloc/kfree can be removed, as or the 2nd copy_from_user, I don't see 
why the ib uverbs flow (BTW - the data path has nothing to do with the 
rdma_cm, you're working with /dev/infiniband/uverbsX), can't be enhanced 
e.g to support shared-page which is allocated && mmaped from uverbs to 
user space and used in the same manner your implementation does. The 1st 
copy_from_user should add pretty nothing and if it does, it can be 
replaced with different user/kernel IPC mechanism which costs less. So 
we're basically remained with the idr_read_qp, I wonder what other 
people think if/how this can be optimized?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
