From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [opensm] RFC: new routing options (repost)
Date: Wed, 06 Jul 2011 09:54:34 -0700
Message-ID: <1309971274.11479.53.camel@auk59.llnl.gov>
References: <1297388014.18394.302.camel@auk59.llnl.gov>
	 <1300915898.3128.168.camel@auk59.llnl.gov>
	 <20110406140929.GA21920@calypso.voltaire.com>
	 <1302113667.4906.336.camel@auk59.llnl.gov>
	 <1302137816.4906.403.camel@auk59.llnl.gov>
	 <20110704105259.GA6084@calypso.voltaire.com>
	 <1309884814.11479.29.camel@auk59.llnl.gov>
	 <20110705170738.GC18903@calypso.voltaire.com>
	 <1309887969.11479.48.camel@auk59.llnl.gov>
	 <20110706080736.GD18903@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110706080736.GD18903-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jared Carr <jared.carr-Y2zl/4KMd60@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On Wed, 2011-07-06 at 01:07 -0700, Alex Netes wrote:
> Hi Al,
> 
> On 10:46 Tue 05 Jul     , Albert Chu wrote:
> > Hi Alex,
> > 
> > On Tue, 2011-07-05 at 10:07 -0700, Alex Netes wrote:
> > > Hi Al,
> > > 
> > > On 09:53 Tue 05 Jul     , Albert Chu wrote:
> > > > Hi Alex,
> > > > 
> > > > Thanks.  Are you still reviewing the remote_guid_sorting patch (the 2/4
> > > > patch)?  Or do you feel there is work there that needs to be done?
> > > > 
> > > 
> > > I thought we agreed that same goal could be achieved using
> > > route_port_ordering_file (dimn_ports_file) parameter, which is more general
> > > than remote_guid_sorting.
> > 
> > The route_port_ordering_file is capable of doing it, however the
> > complexity of setting it up would be far past the knowledge base for the
> > average system administrator.  It would be far more difficult than
> > setting up the 'guid_routing_order' file or 'dimn_ports_file' for DOR.
> > 
> > To me, the generic 'route_port_ordering_file' is an option most useful
> > for special cases.
> > 
> > We've been using 'remote_guid_sorting' for almost a year now on multiple
> > clusters.  Without much effort, it gives all the clusters a nice 5-7%
> > speedup.
> > 
> 
> I understand that using guid_routing_order, improves performance. I just
> think, that 'guid_routing_order' can bring benefit in a rear cases. What if
> someone would think that reverse guid routing or any other function on peers
> node GUIDs ports will improve its' performance, should we keep all of these
> options?

Good point.  I suppose we have to draw the line somewhere on cutting off
options.  We'll just keep the patch in-house b/c it'll be easier for the
staff.

Al

> I created a simple script, that prepares route_port_ordering file from
> ibnetdiscover. It sorts switches ports, based on a remote peer GUIDs.
> It's pretty nit, but it does the job.
> 
> #!/bin/bash
> 
> IBNET_OUT="/tmp/port_ordering_ibnetdisocver"
> TMP_FILE="/tmp/port_order_tmp"
> 
> switch=0
> skip=0
> 
> `ibnetdiscover > $IBNET_OUT`
> while read line
> do
> 	is_switch_header=`echo $line | grep -c ^Switch`
> 	if [ $is_switch_header -eq 1 ]; then
> 		guid=`echo $line | awk '{ print "0x" substr($3, 4, 16)}'`
> 		switch=1
> 		skip=0
> 	elif [ $switch -eq 1 -a "$line" == "" ]; then
> 		switch=0
> 		skip=1
> 		echo $guid `sort $TMP_FILE | awk '{print $2}' | xargs`
> 		rm -fr $TMP_FILE
> 	elif [ $switch -eq 1 ]; then
> 		echo $line | grep "S-" | awk '{print "0x" substr($2, 4, 16) " " substr($1,2,match($1,"]")-2)}' >> $TMP_FILE
> 	fi
> done < $IBNET_OUT
> 
> rm -fr $IBNET_OUT
> 
> -- Alex
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
