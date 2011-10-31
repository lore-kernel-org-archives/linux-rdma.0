From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: REQ GID enforcement in the CM
Date: Mon, 31 Oct 2011 12:19:45 -0600
Message-ID: <20111031181945.GY26974@obsidianresearch.com>
References: <4EA9672F.2010601@mellanox.com>
 <20111027165522.GA16878@obsidianresearch.com>
 <4EAD239A.2050702@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4EAD239A.2050702-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 30, 2011 at 12:14:50PM +0200, Or Gerlitz wrote:
> On 10/27/2011 6:55 PM, Jason Gunthorpe wrote:
> >You can use the CM to establish a connection on another port, eg
> >send CM GMPs to port 1, specify the primary data path is port 2
> >and specify the alternate data path is port 1. Jason
> 
> makes sense, still, maybe the code here could/should be made more
> strict here for the case of a REQ sent with primary path only,
> agree?

I'm not quite sure what you are proposing?

IBA places no requirements on the how the GMP path for CM messages is
related to the data path.

The only validation you can do is to ensure that end port described by
the GID also has the LID as part of its LID/LMC range, which I thought
I saw happening?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
