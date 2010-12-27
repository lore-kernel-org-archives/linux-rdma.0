From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: ibv_post_send/recv kernel path optimizations
Date: Mon, 27 Dec 2010 17:22:21 +0200
Message-ID: <4D18AF2D.1010109@voltaire.com>
References: <20101013091312.GB6060@bicker> <20101123071025.GI1522@bicker>	<adahbf6gytv.fsf@cisco.com> <20101124221845.GH2369@obsidianresearch.com>	<adad3pugi90.fsf@cisco.com> <20101125041337.GA11049@obsidianresearch.com>	<4CEE7A22.2040706@voltaire.com>	<BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>	<4CF60343.7050602@voltaire.com>	<BE2BFE91933D1B4089447C644860408066ABCF66@irsmsx503.ger.corp.intel.com>	<20101214181735.GA2506@obsidianresearch.com> <4D1888CB.2010101@Voltaire.com> <BE2BFE91933D1B4089447C644860408066C547E0@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408066C547E0-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
