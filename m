From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ibv_post_send/recv kernel path optimizations
Date: Tue, 14 Dec 2010 11:17:35 -0700
Message-ID: <20101214181735.GA2506@obsidianresearch.com>
References: <20101013091312.GB6060@bicker>
 <20101123071025.GI1522@bicker>
 <adahbf6gytv.fsf@cisco.com>
 <20101124221845.GH2369@obsidianresearch.com>
 <adad3pugi90.fsf@cisco.com>
 <20101125041337.GA11049@obsidianresearch.com>
 <4CEE7A22.2040706@voltaire.com>
 <BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
 <4CF60343.7050602@voltaire.com>
 <BE2BFE91933D1B4089447C644860408066ABCF66@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BE2BFE91933D1B4089447C644860408066ABCF66-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 14, 2010 at 02:12:56PM +0000, Walukiewicz, Miroslaw wrote:
> Or,
> 
> I looked into shared page approach of passing post_send/post_recv
> info. I still have some concerns.
> 
> The shared page must be allocated per QP and there should be a
> common way to allocate such page for each driver.

Why must it be common?

Aren't these pages just hidden away in your driver library or is
something visible to the app? I get that they are somehow used to
insert/remove the extra header information that the hardware cannot
stuff, but how?

> As Jason and Roland said, the best way to pass this parameter
> through mmap is offset. There is no common way how the Offset is
> used per driver and it is driver specific parameter.

Right, offset is driver specific, it is only used between your
userspace driver library and your kernel driver. You can define
whatever you want.

So use something like QPN*4096 + 1

> The next problem is how many shared pages should driver allocate to
> share with user-space. They should contain place for each posted
> buffer by application. It is a big concern to post_recv where large
> number of buffers are posted.  Current implementation has no such
> limit.

I don't see the problem. mmap also has a length argument. So
mmap(0,16*4096,PROT_READ|PROT_WRITE,MAP_SHARED,fd,QPN*4096+1)

Means map 16 pages associated with QPN. You don't have to have the
offset and length 'make sense' they are just parameters.

> Even the common offset definition would be defined and accepted, the
> shared page must be stored in ib_qp structure.  When a post_send is

You don't need a common definition, it is driver specific.

> called for many QPs, there is a single entry point to
> ib_uverbs_post_send using write to /dev/infiniband/uverbsX. In that
> case there is a lookup to QP store (idr_read_qp) necessary to find a
> correct ibv_qp Structure, what is a big time consumer on the path.

I don't think this should be such a big problem. The simplest solution
would be to front the idr_read_qp with a small learning hashing table.
If you have only one active QP per verbs instance then you avoid the
idr calls. I'm guessing your raw ethernet app uses one QP?

> The NES IMA kernel path also has such QP lookup but the QP number
> format is designed to make such lookup very quickly.  The QP numbers
> in OFED are not defined so generic lookup functions like
> idr_read_qp() must be use.

Maybe look at moving the QPN to ibv_qp translation into the driver
then - or better yet, move allocation out of the driver, if Mellanox
could change their FW.. You are right that we could do this much
faster if the QPN was structured in some way

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
