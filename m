From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] opensm/osm_state_mgr.c: Don't rely on
 PortInfo:PortState for base SP0
Date: Thu, 21 Apr 2011 15:22:43 +0300
Message-ID: <20110421122243.GA2137@calypso.voltaire.com>
References: <4DAC3CCC.4090101@dev.mellanox.co.il>
 <20110420141713.GD28761@calypso.voltaire.com>
 <4DAEF103.1000706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DAEF103.1000706-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:43 Wed 20 Apr     , Hal Rosenstock wrote:
> Hi Alex,
> 
> On 4/20/2011 10:17 AM, Alex Netes wrote:
> > Hi Hal,
> > 
> > On 09:29 Mon 18 Apr     , Hal Rosenstock wrote:
> >>
> >> For base SP0, PortState in SM PortInfo attribute is not used and base SP0
> >> is always "active". 
> > 
> > How SM can be attached to base SP0?
> 
> What precludes this ? AFAIK SM can run on any switch port 0 whether
> enhanced or base.
> 

I'm probably missing something. Base Switch Port 0 - A Switch Port 0 which is
not an Endport (IBTA p71). 
If you look further, Endport defined as a Port which can be a destination of 
LID-routed communication within the same Subnet as the sender.

How can SM be attached to a port which isn't an Endport?

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
