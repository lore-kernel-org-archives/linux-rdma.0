From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/src/ibqueryerrors.c: Remove --all
 option and replace it with --switch, --ca, --router
Date: Tue, 29 Sep 2009 10:46:24 -0700
Message-ID: <20090929104624.7cb664fe.weiny2@llnl.gov>
References: <20090923150923.a5281107.weiny2@llnl.gov>
	<20090929154949.GB9465@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090929154949.GB9465@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: OpenFabrics <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 29 Sep 2009 17:49:49 +0200
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> Hi Ira,
> 
> On 15:09 Wed 23 Sep     , Ira Weiny wrote:
> > 
> > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > Date: Wed, 23 Sep 2009 11:38:11 -0700
> > Subject: [PATCH] infiniband-diags/src/ibqueryerrors.c: Remove --all option and replace it with --switch, --ca, --router
> > 
> > 	By default ibqueryerrors should print errors for all node types.
> > 	Adding the other options allows for the limitation of this output.
> > 
> > 	Also change the --switch option to be --node-guid which is really more
> > 	accurate and use "-G" for better compliance with other utilities.  "-S"
> > 	is left in for backward compatibility for the time being.
> > 
> > 	Update the man page
> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> 
> Applied with comments below. Thanks.
> 
> > ---
> >  infiniband-diags/man/ibqueryerrors.8 |   62 +++++++++++++++++++-----------
> >  infiniband-diags/src/ibqueryerrors.c |   70 +++++++++++++++++++++++++---------
> >  2 files changed, 92 insertions(+), 40 deletions(-)
> > 
> > diff --git a/infiniband-diags/man/ibqueryerrors.8 b/infiniband-diags/man/ibqueryerrors.8
> > index a327f3b..8f83a7b 100644
> > --- a/infiniband-diags/man/ibqueryerrors.8
> > +++ b/infiniband-diags/man/ibqueryerrors.8
> > @@ -5,7 +5,7 @@ ibqueryerrors.pl \- query and report non-zero IB port counters
> >  
> >  .SH SYNOPSIS
> >  .B ibqueryerrors.pl
> > -[-a -c -r -R -C <ca_name> -P <ca_port> -s <err1,err2,...> -S <switch_guid>
> > +[-s <err1,err2,...> -c -r -C <ca_name> -P <ca_port> -s <err1,err2,...> -G <node_guid>
> 
> '-s' is listed twice. I'm fixing this.

Thanks.

[snip]

> >  
> > -	if (!all_nodes && node->type != IB_NODE_SWITCH)
> > +	if ((type & node_type_to_print) == 0)
> >  		return;
> >  
> >  	if (node->type == IB_NODE_SWITCH && node->smaenhsp0)
> > @@ -361,11 +379,24 @@ static int process_opt(void *context, int ch, char *optarg)
> >  		data_counters++;
> >  		break;
> >  	case 3:
> > -		all_nodes++;
> > +		if (node_type_to_print == PRINT_ALL)
> > +			node_type_to_print = 0;
> > +		node_type_to_print |= PRINT_SWITCH;
> > +		break;
> > +	case 4:
> > +		if (node_type_to_print == PRINT_ALL)
> > +			node_type_to_print = 0;
> > +		node_type_to_print |= PRINT_CA;
> > +		break;
> > +	case 5:
> > +		if (node_type_to_print == PRINT_ALL)
> > +			node_type_to_print = 0;
> > +		node_type_to_print |= PRINT_ROUTER;
> 
> Instead of repeating 'node_type_to_print' check its setup could be done
> as:
> 
> 	node_type_to_print = 0;
> 	process_options()...
> 	if (!node_type_to_print)
> 		node_type_to_print = ALL;
> 
> Adding this as separate patch.

Yes that patch is better.  Thanks,

> 
> >  		break;
> > +	case 'G':
> >  	case 'S':
> > -		switch_guid_str = optarg;
> > -		switch_guid = strtoull(optarg, 0, 0);
> > +		node_guid_str = optarg;
> > +		node_guid = strtoull(optarg, 0, 0);
> >  		break;
> >  	case 'D':
> >  		dr_path = strdup(optarg);
> 
> Some generic thoughts.
> 
> When -D, -S, -G and port cannot be resolved should this be an error
> instead of full fabric discovery and errors querying?

No this is not good for 2 reasons.

   1) if the SA is down the tool will still work by searching (slower but
      works)  This is really important because diags are used when things are
      not working.  So the SA being down or slow is a real possibility.[*]
   2) See below about link information...

[*] of course this does not apply to the -D option but it will never fail to
resolve.

> 
> When such port was resolved shouldn't we skip even partial discover as
> useless?

It is not useless.  The link information is printed if the "-r" option is
specified, like so...

10:32:43 > ./ibqueryerrors -S 0xb8cffff00490c -r
Errors for 0xb8cffff00490c "MT47396 Infiniscale-III Mellanox Technologies"
   GUID 0xb8cffff00490c port 10: [LinkDowned == 1]
       Link info:      8  10[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>  0x0008f10400411b18     15   24[  ] "ISR9024D Voltaire" ( )
   GUID 0xb8cffff00490c port 12: [RcvSwRelayErrors == 19] [XmtDiscards == 1]
       Link info:      8  12[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>             [  ] "" ( )
   GUID 0xb8cffff00490c port 20: [RcvSwRelayErrors == 5]
       Link info:      8  20[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>  0x0002c902002268c4     10    2[  ] "woprjr4" ( )

The partial discover gives us this information.

> 
> What about unifying -G, -D, -L options (target address type) usage with
> other intiniband-diags tools (implemented already with ibdiag_common)?

Well...  At the risk of being flamed...  I personally do not like the way
these options are implemented.  For example:

10:37:13 > smpquery -G 0xb8cffff00490c nodeinfo
smpquery: iberror: failed: operation '0xb8cffff00490c' not supported

WTF?  Ah, here is the "correct" syntax

10:37:21 > smpquery -G nodeinfo 0xb8cffff00490c
# Node info: Lid 8
BaseVers:........................1
...

This "correct" syntax is weird to me.  Why is the GUID being specified as
"nodeinfo"?  I admit it might be the way I process commands but I find myself
skipping around the command line to get the syntax right.

Another minor difference is that iblinkinfo and ibqueryerrors have default
behaviors if run without any address.  So it seems to make sense for the -G to
be an option with a parameter.  I will admit it can be made to work either
way, and I can "fix" it if you like.

Ira

> 
> Sasha
> 
> > @@ -399,8 +430,9 @@ int main(int argc, char **argv)
> >  		{"suppress-common", 'c', 0, NULL,
> >  		 "suppress some of the common counters"},
> >  		{"node-name-map", 1, 1, "<file>", "node name map file"},
> > -		{"switch", 'S', 1, "<switch_guid>",
> > -		 "query only <switch_guid> (hex format)"},
> > +		{"node-guid", 'G', 1, "<node_guid>", "query only <node_guid>"},
> > +		{"", 'S', 1, "<node_guid>",
> > +		 "Same as \"-G\" for backward compatibility"},
> >  		{"Direct", 'D', 1, "<dr_path>",
> >  		 "query only switch specified by <dr_path>"},
> >  		{"report-port", 'r', 0, NULL,
> > @@ -408,7 +440,9 @@ int main(int argc, char **argv)
> >  		{"GNDN", 'R', 0, NULL,
> >  		 "(This option is obsolete and does nothing)"},
> >  		{"data", 2, 0, NULL, "include the data counters in the output"},
> > -		{"all", 3, 0, NULL, "output all nodes (not just switches)"},
> > +		{"switch", 3, 0, NULL, "print data for switches only"},
> > +		{"ca", 4, 0, NULL, "print data for CA's only"},
> > +		{"router", 5, 0, NULL, "print data for routers only"},
> >  		{0}
> >  	};
> >  	char usage_args[] = "";
> > @@ -438,13 +472,13 @@ int main(int argc, char **argv)
> >  					       NULL, ibmad_port)) < 0)
> >  			IBWARN("Failed to resolve %s; attempting full scan\n",
> >  			       dr_path);
> > -	} else if (switch_guid_str) {
> > +	} else if (node_guid_str) {
> >  		if ((resolved =
> > -		     ib_resolve_portid_str_via(&portid, switch_guid_str,
> > +		     ib_resolve_portid_str_via(&portid, node_guid_str,
> >  					       IB_DEST_GUID, ibd_sm_id,
> >  					       ibmad_port)) >= 0)
> >  			IBWARN("Failed to resolve %s; attempting full scan\n",
> > -			       switch_guid_str);
> > +			       node_guid_str);
> >  	}
> >  
> >  	if (resolved >= 0)
> > @@ -463,13 +497,13 @@ int main(int argc, char **argv)
> >  
> >  	report_suppressed();
> >  
> > -	if (switch_guid_str) {
> > -		ibnd_node_t *node = ibnd_find_node_guid(fabric, switch_guid);
> > +	if (node_guid_str) {
> > +		ibnd_node_t *node = ibnd_find_node_guid(fabric, node_guid);
> >  		if (node)
> >  			print_node(node, NULL);
> >  		else
> >  			fprintf(stderr, "Failed to find node: %s\n",
> > -				switch_guid_str);
> > +				node_guid_str);
> >  	} else if (dr_path) {
> >  		ibnd_node_t *node = ibnd_find_node_dr(fabric, dr_path);
> >  		uint8_t ni[IB_SMP_DATA_SIZE];
> > @@ -477,9 +511,9 @@ int main(int argc, char **argv)
> >  		if (!smp_query_via(ni, &portid, IB_ATTR_NODE_INFO, 0,
> >  				   ibd_timeout, ibmad_port))
> >  			return -1;
> > -		mad_decode_field(ni, IB_NODE_GUID_F, &(switch_guid));
> > +		mad_decode_field(ni, IB_NODE_GUID_F, &(node_guid));
> >  
> > -		node = ibnd_find_node_guid(fabric, switch_guid);
> > +		node = ibnd_find_node_guid(fabric, node_guid);
> >  		if (node)
> >  			print_node(node, NULL);
> >  		else
> > -- 
> > 1.5.4.5
> > 


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
