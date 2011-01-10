From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_post_send/recv kernel path optimizations
Date: Mon, 10 Jan 2011 14:15:46 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066DDDF31@irsmsx503.ger.corp.intel.com>
References: <20101013091312.GB6060@bicker> <20101123071025.GI1522@bicker>
	<adahbf6gytv.fsf@cisco.com>	<20101124221845.GH2369@obsidianresearch.com>
	<adad3pugi90.fsf@cisco.com>	<20101125041337.GA11049@obsidianresearch.com>
	<4CEE7A22.2040706@voltaire.com>
	<BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
	<4CF60343.7050602@voltaire.com>
	<BE2BFE91933D1B4089447C644860408066ABCF66@irsmsx503.ger.corp.intel.com>
	<20101214181735.GA2506@obsidianresearch.com>	<4D1888CB.2010101@Voltaire.com>
	<BE2BFE91933D1B4089447C644860408066C547E0@irsmsx503.ger.corp.intel.com>
 <ada4o9nfc6e.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada4o9nfc6e.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

You are right that the most of the speed-up is coming from avoid semaphores, but not only.

>From the oprof traces, the semaphores made half of difference.

The next one was copy_from_user and kmalloc/kfree usage (in my proposal - shared page method is used instead)

In my opinion, the responsibility for cases like protection of QP against destroy during buffer post (and other similar cases) should be moved to vendor driver. The OFED code should move only the code path to driver. 

Mirek

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Roland Dreier
Sent: Wednesday, January 05, 2011 7:17 PM
To: Walukiewicz, Miroslaw
Cc: Or Gerlitz; Jason Gunthorpe; Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: ibv_post_send/recv kernel path optimizations

 > The patch for ofed-1.5.3 looks like below. I will try to push it to kernel.org after porting.
 > 
 >     Now an uverbs  post_send/post_recv path is modified to make pre-lookup
 >     for RAW_ETH QPs. When a RAW_ETH QP is found the driver specific path
 >     is used for posting buffers. for example using a shared page approach in
 >     cooperation with user-space library

I don't quite see why a hash table helps performance much vs. an IDR.
Is the actual IDR lookup a significant part of the cost?  (By the way,
instead of list_head you could use hlist_head to make your hash table
denser and save cache footprint -- that way an 8-entry table on 64-bit
systems fits in one cacheline)

Also it seems that you get rid of all the locking on QPs when you look
them up in your hash table.  What protects against userspace posting a
send in one thread and destroying the QP in another thread, and ending
up having the destroy complete before the send is posted (leading to
use-after-free in the kernel)?

I would guess that your speedup is really coming from getting rid of
locking that is actually required for correctness.  Maybe I'm wrong
though, I'm just guessing here.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
