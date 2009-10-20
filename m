From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Tue, 20 Oct 2009 14:29:02 -0600
Message-ID: <20091020202902.GJ14520@obsidianresearch.com>
References: <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com> <4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com> <20091020183132.GE14520@obsidianresearch.com> <A47D2FC6B143436DB87704307B0E715D@amr.corp.intel.com> <20091020191821.GI14520@obsidianresearch.com> <8D09997BDBC5482C86EAD338F19C8030@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8D09997BDBC5482C86EAD338F19C8030-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Or Gerlitz' <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2009 at 01:05:15PM -0700, Sean Hefty wrote:
> >> I agree.  But we can still support AF_IB/PS_TCP by simply assigning
> >> the service ID correctly.  rdma_bind_addr only needs to fill in a
> >> service id if one is not given.  This should enable
> >
> >'one is not given' == 0 service ID?
> 
> yes
> 
> I'm guessing PS_IB would need to assign from the IB CM assigned range starting
> at 0x020::0 to avoid conflicts.

Something like that..

Ok, this seems sensible to me. So to recap the main differences:

Private data:
- AF_IB/PS_TCP - the kernel munges the private data to be compatible
  with AF_INET/PS_TCP, but otherwise is the same.
- AF_IB/PS_IB - the kernel doesn't touch the private data.

Service ID for bind or connect:
 - AF_IB/PS_TCP - the service ID passed in through the sockaddr_ib
   must be 0 or correctly formed as a IP RDMA CM service ID indicating
   a port number. This is true in the bind or connect case.
 - AF_IB/PS_IB - the service ID is just a service ID. No restrictions
   or alteration are done. The bind'd service ID is ignored on connect

0 Service ID on bind:
 - AF_IB/PS_TCP - a new random unused port is allocated and converted to a
   service ID
 - AF_IB/PS_IB - a new random unused service ID within the proper prefix is
   allocated (usefull!)

What about the service_mask feature of IB CM?

How are the IP source and dest IPs going to be picked in for PS_TCP
mode?

I guess user space does that and passes it through to the kernel?
Another bit of binary blob data from rdma_getaddrinfo I guess. I
suppose rdma_getaddrinfo could return an array of option blobs that
must be copied to the kernel to setup the connection, or something
like that.

> >What functional difference are you imagining compared to listening on
> >AF_INET/PS_TCP?
> 
> I hadn't thought about this, but making stuff up, I guess this could allow using
> the rdma_cm without ipoib running...?  From IB's perspective, PS_TCP is just a
> specific subset of the service ID range.

Plus the IP addies in the REQ private data.. 

I think it would be fine to EINVAL on AF_IB/PS_TCP listen().

> >> Even once PS_IB is added, we need to make sure that it doesn't collide with
> >> PS_TCP at the IB service ID level, or IB will be in the same situation that
> >> iWarp is in with space collisions.
> >
> >I thought there was already a single service ID registration list that was
> >shared between RDMA CM and IB CM?
> 
> Not really - the rdma cm constructs the service id, and the ib cm checks that
> it's usable, but not until listen is called.

Oh I see, well, a 'bind' api into the IB CM should take care of that? 

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
