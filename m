From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: ibv_post_send/recv kernel path optimizations
Date: Mon, 10 Jan 2011 12:38:25 -0800
Message-ID: <adawrmc7av2.fsf@cisco.com>
References: <20101013091312.GB6060@bicker> <20101123071025.GI1522@bicker>
	<adahbf6gytv.fsf@cisco.com>
	<20101124221845.GH2369@obsidianresearch.com>
	<adad3pugi90.fsf@cisco.com>
	<20101125041337.GA11049@obsidianresearch.com>
	<4CEE7A22.2040706@voltaire.com>
	<BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
	<4CF60343.7050602@voltaire.com>
	<BE2BFE91933D1B4089447C644860408066ABCF66@irsmsx503.ger.corp.intel.com>
	<20101214181735.GA2506@obsidianresearch.com>
	<4D1888CB.2010101@Voltaire.com>
	<BE2BFE91933D1B4089447C644860408066C547E0@irsmsx503.ger.corp.intel.com>
	<ada4o9nfc6e.fsf@cisco.com>
	<BE2BFE91933D1B4089447C644860408066DDDF31@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408066DDDF31-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
	(Miroslaw Walukiewicz's message of "Mon, 10 Jan 2011 14:15:46 +0000")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > You are right that the most of the speed-up is coming from avoid semaphores, but not only.
 > 
 > From the oprof traces, the semaphores made half of difference.
 > 
 > The next one was copy_from_user and kmalloc/kfree usage (in my proposal - shared page method is used instead)

OK, but in any case the switch from idr to hash table seems to be
insignificant.  I agree that using a shared page is a good idea, but
removing locking needed for correctness is not a good optimization.

 > In my opinion, the responsibility for cases like protection of QP
 > against destroy during buffer post (and other similar cases) should
 > be moved to vendor driver. The OFED code should move only the code
 > path to driver.

Not sure what OFED code you're talking about.  We're discussing the
kernel uverbs code, right?

In any case I'd be interested in seeing how it looks if you move the
protection into the individual drivers.  I'd be worried about having to
duplicate the same code everywhere (which leads to bugs in individual
drivers) -- I guess this could be resolved by having the code be a
library that individual drivers call into.  But also I'm not sure if I
see how you could make such a scheme work -- you need to make sure that
the data structures used in the uverbs dispatch to drivers remain
consistent.

In the end I don't think we should go too far optimizing the
non-kernel-bypass case of verbs -- the main thing we're designing for is
kernel bypass hardware, after all.  Perhaps you could make your case go
faster by using a different file descriptor for each QP or something
(you could pass the fd back as part of the driver-specific create QP path)?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
