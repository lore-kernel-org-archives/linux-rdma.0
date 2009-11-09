From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: QoS in local SA entity
Date: Sun, 8 Nov 2009 17:56:08 -0700
Message-ID: <20091109005607.GV1966@obsidianresearch.com>
References: <4AF2C00A.4040808@voltaire.com> <9BF1CEFA7F6F44F5B5641065C4914EB5@amr.corp.intel.com> <4AF66473.2050303@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AF66473.2050303-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 08, 2009 at 08:25:55AM +0200, Or Gerlitz wrote:

> >ACM is intended to be a service that's used by the librdmacm to resolve 
> >address mappings and routes.  Trying to have ACM use the librdmacm ends up 
> >with a circular dependency.  That's the part I'm trying to avoid.
> 
> fail-enough, I believe that my suggestion is doable also without 
> circular dependency, e.g as you indicated below or with a fairly small 
> enhancement of librdmacm, see next

The entire point of the rdma_getaddrinfo + AF_IB is to avoid hacking
up librdmacm for every address lookup/cache scheme someone invents.

The desired flow would be:

rdma_getaddrinfo("User-Specified-Host-String","User-Specified-Port-String",
                 &hints,&res);

// Server flow (hints.af_flags |= AI_PASSIVE)
rdma_bind(res[0].bind_addr);
rmda_listen(res[0].listen_addr);

// Client Flow
rdma_bind(res[0].bind_addr); // Optional
rdma_resolve_addr2(res[0].bind_addr,res[0].dest_addr,res[0].extra_info);

And under rdma_getaddrinfo we could have any number of modules, like
glibc does.

Well written apps should already be using normal getaddrinfo, so we
can design an upgrade to rdma_getaddrinfo to be very minor, source
wise. Un upgraded apps don't get the new functionality.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
