From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Sun, 25 Oct 2009 12:32:45 -0600
Message-ID: <20091025183245.GL26003@obsidianresearch.com>
References: <15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com> <9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com> <0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com> <15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com> <859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com> <4ADD8F5F.3010008@voltaire.com> <9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com> <4AE07D41.7040300@voltaire.com> <9574E625AB3C48E6A7DF1A2760882363@amr.corp.intel.com> <4AE435A1.6040309@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AE435A1.6040309-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 25, 2009 at 01:25:21PM +0200, Or Gerlitz wrote:

> well, you didn't address some of my comments (not the ice-cream 
> ones...), which come to say that this wouldn't be inter-operable if for 
> one side you convert INET/TCP to IB/IB and for the other side you don't 
> (e.g userA/userB user/kernel kernel/user etc schemes). 

I don't think there will be any compatability issues. Most IP CM
active side requirements are trivially met through user space
generation of the private data.

> Also the functionality added under the bonding scheme is lost, etc.

Considering that ACM gets rid of the ND process I don't see how full
bonding functionality could have ever been maintained. That said, I
think within what Sean has designed there could be something analogous
to IP bonding within ACM - features like this are why it is important
the name resolution have control over source device selection, not
just outgoing route.

> I am asking you to have INET/TCP apps enjoy both ACM's DGID and route 
> resolution without being converted to IB/IB, simple as that. If needed 
> I'd be happy to assist in making this flow happen.

If they are 100% interoperable, and the conversion is transparent to
apps that use this new rdma_getaddrinfo thingy, why do you care at all?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
