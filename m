From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Sat, 22 Jul 2017 15:27:06 -0600
Message-ID: <20170722212706.GA14714@obsidianresearch.com>
References: <VI1PR0502MB30089271EB542493AA58060CD1C20@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <fb11f261-b80b-f71a-8076-204706267798@talpey.com>
 <VI1PR0502MB3008D488FEE8A7104A7B0A7CD1A60@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <142c2fed-baa5-1295-1458-be765c94b957@talpey.com>
 <VI1PR0502MB300886ED1B5B1363B55F53F0D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <e5cee768-586c-516a-6056-ea4a44f89134@talpey.com>
 <VI1PR0502MB30089915EB792CD20CA9D179D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <4444a96a-c1e6-ad33-204a-680982e19bfe@talpey.com>
 <20170722160939.GA30007@obsidianresearch.com>
 <VI1PR0502MB3008E483BB36F944C2E212ACD1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB3008E483BB36F944C2E212ACD1A50-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jul 22, 2017 at 05:32:05PM +0000, Parav Pandit wrote:
> > 
> > Eg
> > 
> >  RDMA-W VA=0 Data=1
> >  RDMA-R VA=0
> >  RDMA-W VA=0 Data=2
> > 
> > What does the read return? Spec says 1, but it sounds like this relaxed ordering
> > could return 2.
> > 
> Spec says Data=1 on RDMA-R only if Fence is set on read operation in Table-76.
> Otherwise duplicate read request after executing RDMA-W2 of Data=2 can return Data=2 on read request.

Erm, I should have written it like this

 Initial Condition VA=0 Data = 0
 RDMA-W VA=0 Data=1
 RDMA-R VA=0

Spec says 1 must be returned, but sounds like this relaxed version
could return 0. So RDMA Write -> RDMA Read degrades to a F

Similarly,

 RDMA-W VA=0 Data=1
 RDMA-W VA=0 Data=2
 SEND

Sounds like with the relaxed version the app could see 1 at SEND CQ
time.

So RDMA-W -> RDMA-W degrades to a F

> > Whta about
> > 
> >  RDMA-W VA=0 Data=1
> >  SEND WITH INVALIDATE VA=0
> >  RDMA-W VA=0 Data=2
> > 
> > Spec says the second RDMA-W must fail, 
> Right.
> 
> > but it sounds like this relaxed ordering would allow it to happen.

> No. Table 76 is followed in this case.
> 1st operation Write.
> 2nd operation send.
> There is implicit fence defined by '#' in Table, which is followed.
> So 2nd RDMA-W continue to fail.

So, I expect what is happening here is that the SEND RCQ is delayed
until the sequence numbers catch up, eg guarenteeing that all
packets prior to the SEND have been seen and committed to memory.
Which is what table 76 is primarily talking about.

However, SEND WITH INVALIDATE is a special cases that impacts the
processing of work itself, not just the CPU observation, which is a
bit outside what table 76 is talking about.

I'd advocate for allowing this to be out of order (but documented as
such), as impliclty fencing SEND WITH INVALIDATE is not acceptable for
performance and most workloads using that feature do not care about
this strict ordering.

The requirement is really that by the time the SEND RCQ is seen that
the INVALIDATE has taken effect.

Atomic are basically similar, sounds like Atomic Op -> RDMA Read should
degrade to a F as well. I'd say that is desired as well.

The point is we want a definition for this feature that is broad
enough to allow future hardware optimization, and not just some some
narrow defintion that follows what mlx5 happened to implement.

> I completely understand and agree that storage protocols who depend
> on RDMA-CM would like to have this.  But again, unavailability of
> this bit in RDMA-CM is not a blocker for user land apps and let them
> start using it.  Once RDMA-CM has it, storage kernel ULPs can also
> be enabled.

If there is no path to get this into the RDMA CM then it is just
another vendor feature and it does not belong in the common API.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
