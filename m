From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH fixed] libibmad: Add MKey support to SMP requests via
 smp_mkey_get/set()
Date: Fri, 9 Mar 2012 11:04:59 -0700
Message-ID: <20120309180459.GB29961@obsidianresearch.com>
References: <1331064594.10889.8.camel@auk75.llnl.gov>
 <1331071949.17729.11.camel@auk75.llnl.gov>
 <4F59FECE.4030107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F59FECE.4030107-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 09, 2012 at 07:59:58AM -0500, Hal Rosenstock wrote:

> What mkey model is being proposed here ? It looks to me like it is a
> single mkey for all ports in the subnet which is the simplest but least
> flexible model. If so, I think we need something more flexible as IBA
> allows each port to have it's own different mkey.

I would like to see some general agreement on a generator for mkey,
something like:

  MKey = HMAC(Subnet_KEY,PortGUID)

This blinds the mkey incase a port is compromised but still lets
privileged entities compute it from a single key.

-- 
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>        (780)4406067x832
Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
