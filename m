From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Basics of congestion control?
Date: Tue, 31 Jul 2012 14:08:56 +0300
Message-ID: <20120731110856.GD2077@calypso>
References: <5017A740.4020205@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5017A740.4020205-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sebastian,

On 11:37 Tue 31 Jul     , Sebastian Riemer wrote:
> Hi all,
> 
> could someone please explain what I can do with the new congestion control?
> 
> Do I understand it right that I can influence the flow control (e.g.
> amount of credits) with it so that I can avoid disruption (XmitWait,
> XmitDiscardedPackets) caused by congestion?

Congestion control isn't a credit based mechanism. While InfiniBand flow
control is defined between two ports of the same link, congestion control is
working across the fabric between a congestion point (a switch) and a reaction
point (source node). Reaction point implements a Congestion Control Table that
contains an array of values of injection rate delay used to control
congestion. You can find more information in the IBTA LWG Errata document
3Q2010.

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
