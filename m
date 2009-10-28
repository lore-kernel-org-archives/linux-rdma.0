From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases
	for RDMA CM
Date: Wed, 28 Oct 2009 11:32:29 -0600
Message-ID: <20091028173229.GI14520@obsidianresearch.com>
References: <20091028054253.GA22882@obsidianresearch.com> <4AE859F8.2030708@Voltaire.com> <20091028164615.GC1966@obsidianresearch.com> <D775590A8D92454491BD2034E85B2B36@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D775590A8D92454491BD2034E85B2B36-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, leo.tominna-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 10:05:19AM -0700, Sean Hefty wrote:
> >Can you explain how rdma_resolve_addr is used in conjunction with
> >multicast? I do not understand what the dest would be. Is it just a man
> >page typo?
> 
> A UD endpoint can communicate using multicast and to other UD
> endpoints.  A user could resolve a UD endpoint before joining a
> multicast group.

So the IP world analog would be:

fd = socket(AF_INET,SOCK_DGRAM);
connect(fd,'Some Unicast Address');
setsockopt(fd,IP_MULITCAST_ADD_MEMBERSHIP,'Some Multicast Address');
sendto(fd,...,'Some Multicast Address');

?

I think that is still OK. The routines still bind the rdma cm_id to
the devices via rdma_translate_ip pretty much like they did before.

There is no support for Linux IP multicast routing though..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
