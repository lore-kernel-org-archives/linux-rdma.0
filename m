From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_post_send/recv kernel path optimizations
Date: Mon, 27 Dec 2010 15:40:40 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066C547EA@irsmsx503.ger.corp.intel.com>
References: <20101013091312.GB6060@bicker> <20101123071025.GI1522@bicker>
	<adahbf6gytv.fsf@cisco.com> <20101124221845.GH2369@obsidianresearch.com>
	<adad3pugi90.fsf@cisco.com> <20101125041337.GA11049@obsidianresearch.com>
	<4CEE7A22.2040706@voltaire.com>
	<BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
	<4CF60343.7050602@voltaire.com>
	<BE2BFE91933D1B4089447C644860408066ABCF66@irsmsx503.ger.corp.intel.com>
	<20101214181735.GA2506@obsidianresearch.com> <4D1888CB.2010101@Voltaire.com>
 <BE2BFE91933D1B4089447C644860408066C547E0@irsmsx503.ger.corp.intel.com>
 <4D18AF2D.1010109@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D18AF2D.1010109-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Just to clarify, when saying "achieved performance comparable to 
> previous solution" you refer to the approach which bypasses uverbs on 
> the post send path? Also, why enhance only the raw qp flow?

I compare to my previous solution using private device for passing information about packets. Comparing to current approach I see more than 20% of improvement.

This solution introduces a new path for posting buffers using a shared page approach. It works following way:
1. create RAW qp and add it to the raw QP hash list. 
2. user space library mmaps the shared page (it is specific action per device and must implemented separately per each driver)
3. during buffer posting the library puts buffers info into shared page and calls uverbs.
4. uverbs detects the raw qp and inform the driver bypassing current path.

The solution cannot be shared between RDMA drivers because it needs redesign of the driver (share page format is vendor specific).
Now only NES driver implements the RAW QP path through kernel (other vendors uses pure user-space solution) so 
No other vendor  will use this path.

There is possibility to add a new QP capability or attribute that will inform  uverbs that it is a new transmit path used so then the solution could be extended for all drivers.

Mirek



-----Original Message-----
From: Or Gerlitz [mailto:ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org] 
Sent: Monday, December 27, 2010 4:22 PM
To: Walukiewicz, Miroslaw
Cc: Jason Gunthorpe; Roland Dreier; Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: ibv_post_send/recv kernel path optimizations

On 12/27/2010 5:18 PM, Walukiewicz, Miroslaw wrote:
> I implemented the very small hash table and I achieved performance 
> comparable to previous solution.

Just to clarify, when saying "achieved performance comparable to 
previous solution" you refer to the approach which bypasses uverbs on 
the post send path? Also, why enhance only the raw qp flow?

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
