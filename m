From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: ibv_post_send/recv kernel path optimizations
Date: Mon, 27 Dec 2010 14:38:35 +0200
Message-ID: <4D1888CB.2010101@Voltaire.com>
References: <20101013091312.GB6060@bicker> <20101123071025.GI1522@bicker>	<adahbf6gytv.fsf@cisco.com> <20101124221845.GH2369@obsidianresearch.com>	<adad3pugi90.fsf@cisco.com> <20101125041337.GA11049@obsidianresearch.com>	<4CEE7A22.2040706@voltaire.com>	<BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>	<4CF60343.7050602@voltaire.com>	<BE2BFE91933D1B4089447C644860408066ABCF66@irsmsx503.ger.corp.intel.com> <20101214181735.GA2506@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101214181735.GA2506-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> Walukiewicz, Miroslaw wrote:

>> called for many QPs, there is a single entry point to
>> ib_uverbs_post_send using write to /dev/infiniband/uverbsX. In that
>> case there is a lookup to QP store (idr_read_qp) necessary to find a
>> correct ibv_qp Structure, what is a big time consumer on the path.

> I don't think this should be such a big problem. The simplest solution
> would be to front the idr_read_qp with a small learning hashing table.

yes, there must be a few ways (e.g as Jason suggested) to do this house-keeping
much more efficient, in a manner that fits fast path - which maybe wasn't the mindset 
when this code was written as its primary use was to invoke control plane commands.

>> The NES IMA kernel path also has such QP lookup but the QP number
>> format is designed to make such lookup very quickly.  The QP numbers in
>> OFED are not defined so generic lookup functions like idr_read_qp() must be use.

> Maybe look at moving the QPN to ibv_qp translation into the driver
> then - or better yet, move allocation out of the driver, if Mellanox
> could change their FW.. You are right that we could do this much
> faster if the QPN was structured in some way

I think there should be some validation on the uverbs level, as the caller is untrusted
user space application, e.g in a similar way for each system call done on a file-descriptor

Or.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
