From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [opensm] [PATCH] do not use the dimn_ports_file if not using
	dor routing
Date: Wed, 27 Apr 2011 10:07:55 -0700
Message-ID: <1303924075.21002.273.camel@auk59.llnl.gov>
References: <1303322533.21002.121.camel@auk59.llnl.gov>
	 <20110427105005.GA2410@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110427105005.GA2410-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Alex,

On Wed, 2011-04-27 at 03:50 -0700, Alex Netes wrote:
> Hi Al,
> 
> On 11:02 Wed 20 Apr     , Albert Chu wrote:
> > Do not use the dimn_ports_file if not using dor routing. If the
> > dimn_ports_file is specified, it currently will be utilized regardless
> > of the routing algorithm actually being used.
> > 
> > Al
> > 
> > -- 
> 
> I guess that dimn_ports_file option was designed to be used with DOR, however
> it got me thinking whether this option could be useful for other cases too.
> For instance, can you use dimn_ports_file to manually sort ports instead of
> using Support-remote-guid-sorting patch you recently suggested?

I think the dimn_ports_file could feasibly do what the
remote_guid_sorting parth does.  It's more complicated to setup than
something like the --guid_routing_order_file or --dimn_ports_file files,
since a fair amount of calculating would have to be done in addition to
"finding" the switch guids.  But it's definitely doable.

Perhaps we'd rename the option to something more generic too, like
'port_search_ordering_file'???

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
