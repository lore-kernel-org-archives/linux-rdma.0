From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: ibv_post_send/recv kernel path optimizations
Date: Wed, 01 Dec 2010 10:11:47 +0200
Message-ID: <4CF60343.7050602@voltaire.com>
References: <20101007161649.GD21206@obsidianresearch.com>	<20101007165947.GD11681@bicker>	<20101009231607.GA24649@obsidianresearch.com> <20101012113117.GB6742@bicker>	<20101012210118.GR24268@obsidianresearch.com> <20101013091312.GB6060@bicker>	<20101123071025.GI1522@bicker> <adahbf6gytv.fsf@cisco.com>	<20101124221845.GH2369@obsidianresearch.com> <adad3pugi90.fsf@cisco.com>	<20101125041337.GA11049@obsidianresearch.com>	<4CEE7A22.2040706@voltaire.com> <BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408064B44854-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
