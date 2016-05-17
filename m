From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Tue, 17 May 2016 11:06:10 -0500
Message-ID: <004001d1b056$0778d350$166a79f0$@opengridcomputing.com>
References: <20160315155441.222586021@linux.com> <20160315155455.173645653@linux.com> <057c8ac8-1d34-e7b9-c0ad-91d805c81139@redhat.com> <alpine.DEB.2.20.1605160851370.23895@east.gentwo.org> <041c6da0-e022-2bd1-5f00-e569c077e154@redhat.com> <alpine.DEB.2.20.1605161203010.26453@east.gentwo.org> <db1bf3dd-20b1-3f2f-eaa3-25e5e8aff35b@redhat.com> <alpine.DEB.2.20.1605161238560.10085@east.gentwo.org> <102cd100-55f7-fa85-cd75-ba0db5b9fa34@redhat.com> <alpine.DEB.2.20.1605170918080.9956@east.gentwo.org> <3e9a3e19-58cb-c25f-89a1-f0e51df562d8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e9a3e19-58cb-c25f-89a1-f0e51df562d8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Christoph Lameter' <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
> Sent: Tuesday, May 17, 2016 11:01 AM
> To: Christoph Lameter
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Mark Bloch; Jason Gunthorpe; Steve Wise; Majd
> Dibbiny; alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
> 
> On 05/17/2016 10:19 AM, Christoph Lameter wrote:
> >
> > On Mon, 16 May 2016, Doug Ledford wrote:
> >>
> >> Thanks, this looks good now.  When the other two patches come through
> >
> > The patch can stand on its own and there has been the expectation
> > expressed by Mellanox that they want to see this merged first. Guess this
> > is to reduce the amount of rewrite they would have to do if things change.
> > Then also the team from Mellanox can directly merge the driver changes
> > without my involvement.
> >
> 
> OK.  There are comments from Jason outstanding, and I found one thing
> that I missed in my earlier reviews.  I think we need to refactor how we
> pull out the stats, or at least consider doing so.  In particular, look
> at how many stats the cxgb3 driver fills in:
> 
> +	stats->dirname = "iw_stats";
> +	stats->name = names;
> +
> +	stats->value[IPINRECEIVES] = ((u64)m.ipInReceive_hi << 32) +
> m.ipInReceive_lo;
> +	stats->value[IPINHDRERRORS] = ((u64)m.ipInHdrErrors_hi << 32) +
> m.ipInHdrErrors_lo;
> +	stats->value[IPINADDRERRORS] = ((u64)m.ipInAddrErrors_hi << 32) +
> m.ipInAddrErrors_lo;
> +	stats->value[IPINUNKNOWNPROTOS] = ((u64)m.ipInUnknownProtos_hi <<
> 32)
> + m.ipInUnknownProtos_lo;
> +	stats->value[IPINDISCARDS] = ((u64)m.ipInDiscards_hi << 32) +
> m.ipInDiscards_lo;
> +	stats->value[IPINDELIVERS] = ((u64)m.ipInDelivers_hi << 32) +
> m.ipInDelivers_lo;
> +	stats->value[IPOUTREQUESTS] = ((u64)m.ipOutRequests_hi << 32) +
> m.ipOutRequests_lo;
> +	stats->value[IPOUTDISCARDS] = ((u64)m.ipOutDiscards_hi << 32) +
> m.ipOutDiscards_lo;
> +	stats->value[IPOUTNOROUTES] = ((u64)m.ipOutNoRoutes_hi << 32) +
> m.ipOutNoRoutes_lo;
> +	stats->value[IPREASMTIMEOUT] = 	m.ipReasmTimeout;
> +	stats->value[IPREASMREQDS] = m.ipReasmReqds;
> +	stats->value[IPREASMOKS] = m.ipReasmOKs;
> +	stats->value[IPREASMFAILS] = m.ipReasmFails;
> +	stats->value[TCPACTIVEOPENS] =	m.tcpActiveOpens;
> +	stats->value[TCPPASSIVEOPENS] =	m.tcpPassiveOpens;
> +	stats->value[TCPATTEMPTFAILS] = m.tcpAttemptFails;
> +	stats->value[TCPESTABRESETS] = m.tcpEstabResets;
> +	stats->value[TCPCURRESTAB] = m.tcpOutRsts;
> +	stats->value[TCPINSEGS] = m.tcpCurrEstab;
> +	stats->value[TCPOUTSEGS] = ((u64)m.tcpInSegs_hi << 32) + m.tcpInSegs_lo;
> +	stats->value[TCPRETRANSSEGS] = ((u64)m.tcpOutSegs_hi << 32) +
> m.tcpOutSegs_lo;
> +	stats->value[TCPINERRS] = ((u64)m.tcpRetransSeg_hi << 32) +
> m.tcpRetransSeg_lo,
> +	stats->value[TCPOUTRSTS] = ((u64)m.tcpInErrs_hi << 32) + m.tcpInErrs_lo;
> +	stats->value[TCPRTOMIN] = m.tcpRtoMin;
> +	stats->value[TCPRTOMAX] = m.tcpRtoMax;
> 
> That's a lot of copies, and shifts, and everything else.  Then look at
> what it does to get them:
> 
>  	ret = dev->rdev.t3cdev_p->ctl(dev->rdev.t3cdev_p, RDMA_GET_MIB, &m);
> 
> I didn't dig too deep, but that looks suspiciously like it might be an
> actual mailbox command to the card.  That can be rather expensive.
>

It is not a mailbox command, but indirect register reads (ie a write_reg +
read_reg operation).  See
cxgb_rdma_ctl(RDMA_GIT_MIB)->t3_tp_get_mib_stats()->t3_read_indirect().
 
> Then look at how we get the stats to print them to user space:
> 
> +static ssize_t show_protocol_stats(struct ib_device *dev, int index,
> +				   u8 port, char *buf)
> +{
> +	struct rdma_protocol_stats stats = {0};
> +	ssize_t ret;
> +
> +	ret = dev->get_protocol_stats(dev, &stats, port);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%llu\n", stats.value[index]);
> +}
> 
> In a nutshell, we go through the effort of a suspected mailbox command,
> then we fill in all of the stats including all of the copies and shifts
> and everything else, then we print out precisely one and only one stat
> before we throw the rest of them away.  If someone goes into the stats
> directory for a card and does cat * or for i in *; do echo -ne "$i:\t";
> cat $i; done, then we will issue 25 mailbox commands, and fill out all
> 25 stats structs 25 times, just to print out one complete set of stats.
> For cxgb4 this isn't so bad, it's only got 4 items.  But the longer the
> list gets, the worst this is because it makes our efficiency of
> operation O(n^2).  Since we can't break out mailbox commands to only
> provide part of the data, I think we need to consider using a cached
> struct for each device.  If the cached data is less than a certain age
> on subsequent reads, we use the cached data.  If it's too old, we
> discard it and get new data.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
