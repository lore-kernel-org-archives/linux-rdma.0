From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH fixed] libibmad: Add MKey support to SMP requests via
 smp_mkey_get/set()
Date: Fri, 9 Mar 2012 12:14:34 -0800
Message-ID: <20120309121434.251950f0.weiny2@llnl.gov>
References: <1331064594.10889.8.camel@auk75.llnl.gov>
	<1331071949.17729.11.camel@auk75.llnl.gov>
	<4F59FECE.4030107@dev.mellanox.co.il>
	<20120309180459.GB29961@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120309180459.GB29961-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 9 Mar 2012 11:04:59 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Fri, Mar 09, 2012 at 07:59:58AM -0500, Hal Rosenstock wrote:
> 
> > What mkey model is being proposed here ? It looks to me like it is a
> > single mkey for all ports in the subnet which is the simplest but least
> > flexible model. If so, I think we need something more flexible as IBA
> > allows each port to have it's own different mkey.
> 
> I would like to see some general agreement on a generator for mkey,
> something like:
> 
>   MKey = HMAC(Subnet_KEY,PortGUID)
> 
> This blinds the mkey incase a port is compromised but still lets
> privileged entities compute it from a single key.

Jim already discussed that and we would like to do that but for now this will allow the diags to function with the current OpenSM model.

Ira

> 
> -- 
> Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
> Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
