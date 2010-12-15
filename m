From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: opensm configuration question
Date: Wed, 15 Dec 2010 08:53:58 -0800
Message-ID: <20101215085358.7e981a67.weiny2@llnl.gov>
References: <4D07F2D8.4080602@utah.edu>
	<20101214161227.0db1eb1d.weiny2@llnl.gov>
	<4D08E8FE.6090703@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D08E8FE.6090703-wbocuHtxKic@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Samuel Taylor Liston <sam.liston-wbocuHtxKic@public.gmane.org>, Brian Haymore <brian.haymore-wbocuHtxKic@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 15 Dec 2010 08:12:46 -0800
Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org> wrote:

> Ira,
> 
> Thanks! I misunderstood up/down, thanks for clearing that up. That helps 
> a lot.
> 
> I set the console to local, and then tried telnetting to localhost port 
> 10000 but got a connection refused. Should I set it to socket instead?

loopback is best as it should limit access to the local node.  You can also set
your hosts.[allow|deny] to limit access.

Ira

> 
> Tom
> 
> On 12/14/2010 05:12 PM, Ira Weiny wrote:
> > On Tue, 14 Dec 2010 14:42:32 -0800
> > Tom Ammon<tom.ammon-wbocuHtxKic@public.gmane.org>  wrote:
> >
> >    
> >> Hi,
> >>
> >> I've got an opensm question.
> >>
> >> With opensm running, I run opensm --help, and it tells me what I am
> >> expecting from the configuration I have given it. I configured it for
> >> updn routing with /etc/opensm/rootguids.conf as the root guids file:
> >>
> >>
> >> -------------------------------------------------
> >> OpenSM 3.3.7
> >>    Reading Cached Option File: /etc/opensm/opensm.conf
> >>    Loading Cached Option:guid = 0x0002c9030009714d
> >>    Loading Cached Option:routing_engine = updn
> >>    Loading Cached Option:root_guid_file = /etc/opensm/rootguids.conf
> >>    Loading Cached Option:sm_priority = 15
> >>    Loading Cached Option:log_flags = 4
> >>    Loading Cached Option:console = local
> >> Command Line Arguments:
> >>
> >>
> >> However, when I do an ibtracert between two nodes on different leaf
> >> switches, it appears to be using minhop routing (the root guids I
> >> specified are not in the path):
> >>      
> > Up/Down does not mean that everything will be routed through your spine
> > switches.  Up/Down only requires that your path can't go "up" after starting
> > "down".  From the trace below it appears that the path from em001 to em056
> > only required 3 hops through the line board.  A node farther away might
> > require routing through the spine board.
> >
> > Here's an example:
> >
> >       S
> >      / \
> >    L1   L2
> >   / \  / \
> > E1  E2  E3
> > |    |   |
> > N1  N2   N3
> >
> > Min Hop == Up/Down when routing from N1 to N2 (3 hops).
> >
> > But when routing N1 to N3 Min Hop can choose either E1,L1,S,L2,E3 OR
> > E1,L1,E2,L2,E3 (both 5 hops) but Up/Down can only chose the former through the
> > Spine.
> >
> >    
> >> [root@sm2 ~]# ibtracert 24 69
> >>   From ca {0x0002c903000bb5d8} portnum 1 lid 24-24 "em001 HCA-1"
> >> [1] ->  switch port {0x0008f10500201d8c}[1] lid 15-15 "Voltaire 4036 #
> >> komas-is-a1-1"
> >> [36] ->  switch port {0x0008f105006515ca}[19] lid 9-9 "Voltaire sLB-4018
> >>      Line 8  Chip 1 4200 #komas-is-a6-1"
> >> [20] ->  switch port {0x0008f10500201b32}[36] lid 18-18 "Voltaire 4036 #
> >> komas-is-a2-1"
> >> [28] ->  ca port {0x0002c903000bb5f9}[1] lid 69-69 "em056 HCA-1"
> >> To ca {0x0002c903000bb5f8} portnum 1 lid 69-69 "em056 HCA-1"
> >>
> >> Looking in the opensm log file, I see this over and over:
> >>
> >> OpenSM $ OpenSM $ OpenSM $ Dec : Command not found
> >>
> >> Supported commands and syntax:
> >> help [<command>]
> >> quit (not valid in local mode; use ctl-c)
> >> loglevel [<log-level>]
> >> priority [<sm-priority>]
> >> resweep [heavy|light]
> >> reroute
> >> sweep [on|off]
> >> status [loop]
> >> logflush -- flush the opensm.log file
> >> querylid lid -- print internal information about the lid specified
> >> portstatus [ca|switch|router]
> >> switchbalance [verbose] [guid]
> >> lidbalance [switchguid]
> >> dump_conf
> >> update_desc
> >> version -- print the OSM version
> >> dump_portguid [file filename] regexp1 [regexp2 [regexp3 ...]] -- Dump
> >> port GUID matching a regexp
> >> OpenSM $
> >>
> >>
> >> Any ideas?
> >>      
> > In the log file???  Not sure.
> >
> >    
> >> Also, how can I use the console? I noticed a couple of config options
> >> for it, but I don't understand how to actually attach to the console to
> >> try things out.
> >>      
> > What options do you have set for the console?
> >
> > 16:08:54>  opensm -h | grep console
> > --console, -q [off|local|socket|loopback]
> >            This option activates the OpenSM console (default off).
> > --console-port, -C<port>
> >            Specify an alternate telnet port for the console (default 10000).
> >
> > Ira
> >
> >    
> >> Thanks,
> >>
> >> Tom
> >>
> >>
> >>
> >> -- 
> >> Tom Ammon
> >> Network Engineer
> >> Office: 801.587.0976
> >> Mobile: 801.674.9273
> >>
> >> Center for High Performance Computing
> >> University of Utah
> >> http://www.chpc.utah.edu
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>      
> >
> >    
> 
> -- 
> --------------------------------------------------------------------
> Tom Ammon
> Network Engineer
> Office: 801.587.0976
> Mobile: 801.674.9273
> 
> Center for High Performance Computing
> University of Utah
> http://www.chpc.utah.edu
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
