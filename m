From: Jeff Roberson <jroberson-gUAg20sWgfgcWVvVuXF20w@public.gmane.org>
Subject: Re: LID reconfiguration
Date: Mon, 16 Nov 2009 18:38:40 -1000 (HST)
Message-ID: <alpine.BSF.2.00.0911161835230.1226@desktop>
References: <alpine.BSF.2.00.0911091324150.1226@desktop> <20091109234547.GH6188@obsidianresearch.com> <alpine.BSF.2.00.0911091348360.1226@desktop> <20091110002047.GJ6188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091110002047.GJ6188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 9 Nov 2009, Jason Gunthorpe wrote:

> On Mon, Nov 09, 2009 at 01:56:49PM -1000, Jeff Roberson wrote:
>>>> Is there anything I can do other than restart the discovery and
>>>> connection process?  Shouldn't we have enough information with the GID to
>>>> retain and reroute the connection?
>>>
>>> With a GID you can go back to the SM and get an updated set of
>>> path records with the new LID data.
>>
>> Ok, so the QPs will be held in an error state but I can restart them once
>> I re-initialize the paths right?  I can query the path using umad and get
>> path record?  So we'll have a minor hicup in communication but previously
>> buffered data will be sent as soon as the QP is valid again?
>
> I've never heard of someone recovering QPs once they reach the error
> state, I think they are pretty much done at that point. You have to
> start again.
>
> To get hitless switching to the passive backup pass you need to use
> the IB APM feature.

Is there an opensource example of using APM?  When I call ib_cm_send_lap() 
the QP goes to some error state and my connections die.  Do I need to set 
some QP attributes first?  I found a paper that describes the process but 
does not contain sample code or any real details.

Thanks,
Jeff

>
> Otherwse, you could detect failure of the QP and issue a new PR query
> for the GID using umad and then try again to connect - depending on
> how your home grown connection process works I guess..
>
>> We are not using IPoIB at the moment.  This is for an appliance type
>> device and the customers will be responsible for their own switches.  At
>> present everything simply stops working when we re-lid so I just need to
>> add the correct failure handling code.
>
> Detect failure and start again from stratch is what pretty much
> everyone does today, AFAIK.
>
>>> rdmacm when combined with IPoIB bonding will give you a kind of
>>> active/passive HA type multi-path.
>>
>> That is essentially what we're looking for.  We discover the devices
>> automatically but transparent multi-path would've saved a lot of work.
>
> Yes, you probably could have used the bonding feature, but note it
> does not save you from errored QPs in the failover case and I've had
> problems with IPoIB PR caching in LID-change cases in the past..
>
> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
