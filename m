From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Tue, 26 Apr 2016 10:54:50 -0600
Message-ID: <20160426165450.GA3962@obsidianresearch.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
 <AM3PR05MB141161876D5CA05B1993D20CB1610@AM3PR05MB1411.eurprd05.prod.outlook.com>
 <571F78F9.8010401@redhat.com>
 <20160426145813.GB24104@obsidianresearch.com>
 <571F9968.3080501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571F9968.3080501-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 26, 2016 at 12:38:00PM -0400, Doug Ledford wrote:
> We're talking about two different things.  I had the actual user space
> API on my mind when I wrote what I wrote (aka, libibverbs).

This will become very confusing if we don't focus on one thing..

How to fix libibverbs's API is a totally different problem, only very
loosely related to fixing the uAPI. Whatever new uAPI we come up with
must support current libibverbs with no loss during translation.

Tackling a verbs 2.0 along with the uAPI project is too big, IMHO.

It is pretty obvious to me we don't want to retain the current near
1:1 mapping of libverbs calls and kernel calls.

> There are only a few options for how to expose these things to user
> space (using the example I gave as a further talking point):

AFAIK Mellanox is working on benchmarking these options, so perhaps we
will have some data someday.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
