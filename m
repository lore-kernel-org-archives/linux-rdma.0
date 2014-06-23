From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: why flipping responder_resources/initiator_depth?
Date: Mon, 23 Jun 2014 20:38:23 +0300
Message-ID: <CAJZOPZJHM1v62kr1_8X2cZXxftNqtC+ngMKNz64eFNFrxyXbAg@mail.gmail.com>
References: <53A688FB.6070600@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823739931CCAD@ORSMSX109.amr.corp.intel.com>
	<CAJZOPZKqYiGpxi8bjDu5TBu0G6EX_DjRLvEVhNDTy9L79h6MbQ@mail.gmail.com>
	<20140623164938.GA23697@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140623164938.GA23697-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 23, 2014 at 7:49 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
[...]
> The swapping and general missing handling of RR negotiating in the
> whole kernel CM API (not just RDMA CM, but IB CM too) is a
> longstanding bug, and I have written user space code that fixes it up
> in the past :(

Jason, the swapping takes place in the IB CM indeed, I just used the
wording from the librdmacm man pages to described the desired
behaviour as I see it. Did you ever repored to the swapping on this
list in the past? when?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
