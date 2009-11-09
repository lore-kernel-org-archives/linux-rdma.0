From: Jeff Roberson <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Subject: Re: LID reconfiguration
Date: Mon, 9 Nov 2009 13:56:49 -1000 (HST)
Message-ID: <alpine.BSF.2.00.0911091348360.1226@desktop>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <20091109234547.GH6188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091109234547.GH6188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 9 Nov 2009, Jason Gunthorpe wrote:

> On Mon, Nov 09, 2009 at 01:30:09PM -1000, Jeff Roberson wrote:
>
>> Is there anything I can do other than restart the discovery and
>> connection process?  Shouldn't we have enough information with the GID to
>> retain and reroute the connection?
>
> With a GID you can go back to the SM and get an updated set of
> path records with the new LID data.

Ok, so the QPs will be held in an error state but I can restart them once 
I re-initialize the paths right?  I can query the path using umad and get 
path record?  So we'll have a minor hicup in communication but previously 
buffered data will be sent as soon as the QP is valid again?

>
> I'm not sure exactly what you are doing, but IPoIB arps in the linux
> kernel do result in PR query's done by the kernel, so you must also
> consider what happens to that cache if the LID changes.
>
> Common advice is to rig things so that a LID change is very
> unlikely. OpenSM has ways to make the GUID to LID mapping persistent
> and distributed to all backup SMs.

We are not using IPoIB at the moment.  This is for an appliance type 
device and the customers will be responsible for their own switches.  At 
present everything simply stops working when we re-lid so I just need to 
add the correct failure handling code.

>
>> One more question;  I saw librdmacm which looked nice but it does not
>> support multi-path connections.  It would eliminate a lot of code if we
>> could use this, are there plans for it?  Did I miss some functionality?
>
> Sean and I have been talking about creating AF_IB as a way to let
> rdmacm deal with native IB addressing, that should let you do whatever
> you want. active/active multipath is definately something that would
> be helped by this kind of new API.
>
> rdmacm when combined with IPoIB bonding will give you a kind of
> active/passive HA type multi-path.

That is essentially what we're looking for.  We discover the devices 
automatically but transparent multi-path would've saved a lot of work.

>
> What are you using to setup connections now? libibcm? nothing?

Nothing, it's all verbs.  It was written by someone else and I'm just 
cleaning it up and adding features.

Thanks,
Jeff

> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
