From: Jesus Camacho Villanueva <jecavil-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: Re: missing port number(s) in trap 128?
Date: Thu, 8 May 2014 16:05:53 +0200
Message-ID: <CAA8OkbvsSZr8OFZ+HgZ29rSNrQt715jGNM=wL_PK+a2W0BPYyA@mail.gmail.com>
References: <CAA8OkbuY4F9N1RkNQFgDCYveWkzDVzcRmqK4F=CBdSC+Hv5APg@mail.gmail.com>
	<536B8483.1050502@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <536B8483.1050502-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hal,

thanks for your quick and clear response.

Jesus


On 8 May 2014 15:20, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>
> On 5/8/2014 7:51 AM, Jesus Camacho Villanueva wrote:
> > Hello Everyone,
> >
> > When OpenSM receives a trap 128 indicating a "Link state of at least
> > one port of switch at <LIDADDR> has changed", it seems there is not
> > any information about the port number(s) of the affected link(s).
> >
> > Do you know if there is any chance to retrieve this information from
> > this trap or through other incoming MAD(s)?
> >
> > Any ideas or suggestions would be greatly appreciated.
>
> Per current IBTA spec, port number is not included in link state change
> trap 128. It would need to include a set of ports which changed state
> and not just single port.
>
> Once SM receives trap 128 from some switch, SM is responsible for
> querying that switch and determining which ports changed state from
> "last" time it queried them. It can do this via querying PortInfo MAD
> for all the ports on that switch. PortInfo MAD contains the PortState.
> SM also resets the PortStateChange bit in SwitchInfo MAD for that switch.
>
> -- Hal
>
> >
> > Kind regards,
> > Jesus Camacho
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
