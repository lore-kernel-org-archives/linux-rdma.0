From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: LID reconfiguration
Date: Mon, 9 Nov 2009 16:45:47 -0700
Message-ID: <20091109234547.GH6188@obsidianresearch.com>
References: <alpine.BSF.2.00.0911091324150.1226@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.BSF.2.00.0911091324150.1226@desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Roberson <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2009 at 01:30:09PM -1000, Jeff Roberson wrote:

> Is there anything I can do other than restart the discovery and 
> connection process?  Shouldn't we have enough information with the GID to 
> retain and reroute the connection?

With a GID you can go back to the SM and get an updated set of
path records with the new LID data.

I'm not sure exactly what you are doing, but IPoIB arps in the linux
kernel do result in PR query's done by the kernel, so you must also
consider what happens to that cache if the LID changes.

Common advice is to rig things so that a LID change is very
unlikely. OpenSM has ways to make the GUID to LID mapping persistent
and distributed to all backup SMs.

> One more question;  I saw librdmacm which looked nice but it does not  
> support multi-path connections.  It would eliminate a lot of code if we  
> could use this, are there plans for it?  Did I miss some functionality?

Sean and I have been talking about creating AF_IB as a way to let
rdmacm deal with native IB addressing, that should let you do whatever
you want. active/active multipath is definately something that would
be helped by this kind of new API.

rdmacm when combined with IPoIB bonding will give you a kind of
active/passive HA type multi-path.

What are you using to setup connections now? libibcm? nothing?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
