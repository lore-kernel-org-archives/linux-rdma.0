From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: LID reconfiguration
Date: Mon, 9 Nov 2009 17:20:47 -0700
Message-ID: <20091110002047.GJ6188@obsidianresearch.com>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <20091109234547.GH6188@obsidianresearch.com> <alpine.BSF.2.00.0911091348360.1226@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.BSF.2.00.0911091348360.1226@desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Roberson <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2009 at 01:56:49PM -1000, Jeff Roberson wrote:
>>> Is there anything I can do other than restart the discovery and
>>> connection process?  Shouldn't we have enough information with the GID to
>>> retain and reroute the connection?
>>
>> With a GID you can go back to the SM and get an updated set of
>> path records with the new LID data.
>
> Ok, so the QPs will be held in an error state but I can restart them once 
> I re-initialize the paths right?  I can query the path using umad and get 
> path record?  So we'll have a minor hicup in communication but previously 
> buffered data will be sent as soon as the QP is valid again?

I've never heard of someone recovering QPs once they reach the error
state, I think they are pretty much done at that point. You have to
start again.

To get hitless switching to the passive backup pass you need to use
the IB APM feature.

Otherwse, you could detect failure of the QP and issue a new PR query
for the GID using umad and then try again to connect - depending on
how your home grown connection process works I guess..

> We are not using IPoIB at the moment.  This is for an appliance type  
> device and the customers will be responsible for their own switches.  At  
> present everything simply stops working when we re-lid so I just need to  
> add the correct failure handling code.

Detect failure and start again from stratch is what pretty much
everyone does today, AFAIK.

>> rdmacm when combined with IPoIB bonding will give you a kind of
>> active/passive HA type multi-path.
>
> That is essentially what we're looking for.  We discover the devices  
> automatically but transparent multi-path would've saved a lot of work.

Yes, you probably could have used the bonding feature, but note it
does not save you from errored QPs in the failover case and I've had
problems with IPoIB PR caching in LID-change cases in the past..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
