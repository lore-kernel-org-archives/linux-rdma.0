From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] OpenSM - The DnUp routing algorithm.
Date: Wed, 13 Apr 2011 16:40:44 +0300
Message-ID: <20110413134044.GD1529@calypso.voltaire.com>
References: <20110324170633.55C82451A77@cu0login3.emsl.pnl.gov>
 <20110327160612.GD23892@calypso.voltaire.com>
 <FEA39410-2F14-4484-86C8-EEBA42704F6E@pnl.gov>
 <75EE638CB68A864F90627D3D06A189A874B0B8@MTRCASDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <75EE638CB68A864F90627D3D06A189A874B0B8-FXD4EHQYOQ+layAChLZOBkEOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ken Schmidt <kenneth.schmidt-Y2zl/4KMd60@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Ken,

On 13:29 Wed 13 Apr     , Alex Netes wrote:
> 
> 
> -----Original Message-----
> From: Schmidt, Kenneth P [mailto:kenneth.schmidt-Y2zl/4KMd60@public.gmane.org] 
> Sent: Monday, March 28, 2011 3:49 AM
> To: Alex Netes
> Cc: Sasha Khapyorsky; Carr, Jared F
> Subject: Re: [PATCH] OpenSM - The DnUp routing algorithm.
> 
> Alex,
> 
> On 03/27/2011, at 09:06, Alex Netes wrote:
> 
> > Ken,
> > 
> > On 16:04 Wed 23 Mar     , Ken Schmidt wrote:
> >> This routing algorithm operates in a very similar fashion to UpDn, 
> >> but is modified to allow optimal routing on certain network 
> >> structures in which uplinks and CA nodes are connected to the same 
> >> switch nodes. (For example Chinook at EMSL and RoadRunner at LANL.) 
> >> In these networks the optimal paths between nodes connected to a 
> >> single chassis would remain within the chassis.  However due to the 
> >> uplinks being connected at the same level of the network as the CA 
> >> nodes UpDn will not allow these paths to be used for communication between the CA nodes.
> >> 
> >> DnUp follows the same procedure as UpDn with a few differences.  
> >> Ranking is based solely on the relative distance from CA nodes, any 
> >> switch node with a CA node directly attached is assigned a rank of 0 
> >> any switch node without a CA node attached is assigned a rank of one 
> >> greater than the minimum rank of their neighbors. Transitions are 
> >> also reversed; The initial direction is down and only one transition 
> >> to up is allowed.  There is also an option which relaxes this 
> >> restriction to allow communication with switches nodes similar to the 
> >> functionality of connect_roots in UpDn.
> >> 
> >> ---
> > 
> > I have few general questions.
> > How can you assure that all the routes between the hosts on the same 
> > chassis will go strictly through the chassis (spines) and not other lines?
> I am not positive we can be assured that there won't ever be a time when it decides to pick a route through the external lines instead of the chassis connections.  However, because there are more connections going to the rest of the subnet, osm_switch_recommend_path() should try to balance the routes to all the LID's connected through the same chassis through the internal ports because they will have fewer number of paths going through those links.

I guess, you can use --hop_weights_file option. The default port weight is 1,
so you can define weight of ports going from line to another line to be 2, so
that way for hosts connected to the same chassis, the local route through the
spine would be always chosen as it would be min_hop route.

> 
> > Is it possible to assign routes between switches/switches 
> > hosts/switches in different chassises (I guess it's more complicate than connect_roots in UPDN)?
> I was working on an algorithm that would build the routes automatically to allow routes that would violate the DnUp rules, but we came up with an easier solution.  I am not entirely sure it is better, but it was considerably easier to implement.  Basically, instead of setting the all routes that violate the rules to OSM_NO_PATH, and skip everything beyond it in the breadth first search, we add a configured constant weight (prune_weight) to them which should be greater than the number of hops in the network.  In our case, we set it to 32.  This allows the minhop to use the paths that would normally be denied, but only if it can't use one of the paths that doesn't break the rules.
> 
> ____________________________________________
> Ken Schmidt
> Research Scientist, Molecular Science Computing Operations
> EMSL: Environmental Molecular Sciences Laboratory
> 
> Pacific Northwest National Laboratory
> 902 Battelle Boulevard
> P.O. Box 999, MSIN K8-84
> Richland, WA  99352 USA
> Tel:  509-371-6107
> Fax: 509-371-6110
> Kenneth.schmidt-Y2zl/4KMd60@public.gmane.org
> www.emsl.pnl.gov
> 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
