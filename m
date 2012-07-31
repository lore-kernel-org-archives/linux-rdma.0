From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: Basics of congestion control?
Date: Tue, 31 Jul 2012 13:53:51 +0200
Message-ID: <5017C74F.6010207@profitbricks.com>
References: <5017A740.4020205@profitbricks.com> <20120731110856.GD2077@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120731110856.GD2077@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 31.07.2012 13:08, Alex Netes wrote:
> Congestion control isn't a credit based mechanism. While InfiniBand flow
> control is defined between two ports of the same link, congestion control is
> working across the fabric between a congestion point (a switch) and a reaction
> point (source node). Reaction point implements a Congestion Control Table that
> contains an array of values of injection rate delay used to control
> congestion. You can find more information in the IBTA LWG Errata document
> 3Q2010.

Nice, thank you very much!

I've found the IBTA spec and the errata.

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
