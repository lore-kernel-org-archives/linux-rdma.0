From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: ibv_post_send/recv kernel path optimizations
Date: Wed, 08 Dec 2010 11:04:52 -0800
Message-ID: <adaei9sjdbf.fsf@cisco.com>
References: <20101007161649.GD21206@obsidianresearch.com>
	<20101007165947.GD11681@bicker>
	<20101009231607.GA24649@obsidianresearch.com>
	<20101012113117.GB6742@bicker>
	<20101012210118.GR24268@obsidianresearch.com>
	<20101013091312.GB6060@bicker> <20101123071025.GI1522@bicker>
	<adahbf6gytv.fsf@cisco.com>
	<20101124221845.GH2369@obsidianresearch.com>
	<adad3pugi90.fsf@cisco.com>
	<20101125041337.GA11049@obsidianresearch.com>
	<4CEE7A22.2040706@voltaire.com>
	<BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
	<4CF60343.7050602@voltaire.com>
	<BE2BFE91933D1B4089447C64486040806673CF38@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040806673CF38-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
	(Miroslaw Walukiewicz's message of "Wed, 8 Dec 2010 12:14:51 +0000")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > The problem that I see is that the mmap is currently used for mapping
 > of doorbell page in different drivers.

The driver can use different offsets into the file to map different
things.  For example I believe ehca, ipath and qib already do this.

 > I cannot find a specific code for /dev/infiniband/uverbsX. Is this
 > device driver sharing the same functions like /dev/infiniband/rdmacm
 > or it has own implementation.

it is in drivers/infiniband/core/uverbs_main.c.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
