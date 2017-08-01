From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Tue, 1 Aug 2017 13:00:52 -0600
Message-ID: <20170801190052.GA31205@obsidianresearch.com>
References: <VI1PR0502MB3008D488FEE8A7104A7B0A7CD1A60@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <142c2fed-baa5-1295-1458-be765c94b957@talpey.com>
 <VI1PR0502MB300886ED1B5B1363B55F53F0D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <e5cee768-586c-516a-6056-ea4a44f89134@talpey.com>
 <VI1PR0502MB30089915EB792CD20CA9D179D1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <4444a96a-c1e6-ad33-204a-680982e19bfe@talpey.com>
 <20170722160939.GA30007@obsidianresearch.com>
 <VI1PR0502MB3008E483BB36F944C2E212ACD1A50@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170722212706.GA14714@obsidianresearch.com>
 <VI1PR0502MB300871C35E1CC06EB378D6C8D1B30@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB300871C35E1CC06EB378D6C8D1B30-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 01, 2017 at 06:14:08PM +0000, Parav Pandit wrote:

> >  Initial Condition VA=0 Data = 0
> >  RDMA-W VA=0 Data=1
> >  RDMA-R VA=0
> > 
> > Spec says 1 must be returned, but sounds like this relaxed version could return 0.

> No. Table 76 stays as is as described before.

How is this possible?

> >  RDMA-W VA=0 Data=1
> >  RDMA-W VA=0 Data=2
> >  SEND
> > 
> > Sounds like with the relaxed version the app could see 1 at SEND CQ time.
> > 
> > So RDMA-W -> RDMA-W degrades to a F

> No. Table-76 is based on  how requester sees the execution.
> So it stays as '#'.

How is this possible?

You've clearly stated this feature allows out of order execution
across packet boundaries, there is no way to know at the responder
what the missed packets where, so ineventiably, both of these cases
must be possible. Or you are wrong about the statement on out of
order.

Frankly, I still don't think you know what this feature actually does
and consequently cannot document it properly, which is not
acceptable for a common verbs feature.

> > However, SEND WITH INVALIDATE is a special cases that impacts the processing
> > of work itself, not just the CPU observation, which is a bit outside what table 76
> > is talking about.
 
> SEND, SEND WITH IMM, SEND WITH INVALIDATE falls in same category as send as first column in Table76.

Not really, I don't think you understand how this all fits together..

> > I'd advocate for allowing this to be out of order (but documented as such), as
> > impliclty fencing SEND WITH INVALIDATE is not acceptable for
> > performance and

> It is as per first column of Table-76.

Dn't understand you remark, it is clearly ordered..

> > most workloads using that feature do not care about this strict ordering.
> > 
> nvme fabrics do care.
> nvme fabrics target does RDMA-W, RDMA_S_INV sequence on the same memory key that is being used in RDMA-W without waiting for RDMA-W completion for good reason.
> I recall SMB doing the same as well.
> RDMA-S_INV after RDMA-W cannot break the order.

They don't care, because RDMA_WRITE, SEND_WITH_INVALIDATE on the same
rkey does not try to write to the rkey memory twice, which is the only
case where adding out of order execution really matters.

They only care that the invalidate guarentees no DMA is possible once
it reaches the receiver's CQ.

> > The requirement is really that by the time the SEND RCQ is seen that the
> > INVALIDATE has taken effect.
> > 
> Current Table-76 requirement already relaxes for 
> RDMA-R-> RDMA_S_INV.
> However most users won't do above sequence because users would not like to fail duplicate read requests.
> So let's continue with Table-76 for SEND as 2nd operation as defined today. (first column stays as is)

As I said, table 76 does not really capture the full behavior of
INVALIDATE.

The spec requires WRITE,INV,WRITE to fail, but it would be just a fine
for storage protocols if WRITE,INV,WRITE could succeed, so long as
delivering the INV to the CQ fences the DMA, which can be done in a
high performance way. Fencing the WRITE,INV,WRITE can not be done
with high performance.

> > Atomic are basically similar, sounds like Atomic Op -> RDMA Read should
> > degrade to a F as well. I'd say that is desired as well.
> 
> No. Table-76 stays as is.
> Atomic->Atomic is already 'F'.
> Atomic->RDMA_R is continues as '#'. (Similar to RDMA_W->RDMA_R).

Same argument as above, many apps will tolerate out of order for
atomics, thee default for an out of order mode should be to allow it,
and let apps request in order with fence.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
