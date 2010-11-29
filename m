From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: =?windows-1256?Q?Re=3A_Subnet_management_on_non_pure_?=
 =?windows-1256?Q?fat-tree_network=FE?=
Date: Mon, 29 Nov 2010 11:48:57 +0200
Message-ID: <4CF37709.3010008@dev.mellanox.co.il>
References: <SNT140-w638ED9C5E0455EBAEBC0FEF1230@phx.gbl>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1256
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SNT140-w638ED9C5E0455EBAEBC0FEF1230-MsuGFMq8XAE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Reid O <hpc_reid-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 29-Nov-10 12:18 AM, Reid O wrote:
> 
> Hello,
>    We have an Infiniband cluster in a fat tree configuration with 8 core switches and
> 12 leaf switches.  The compute nodes are all in enclosures connected to the 12
> leaf switches.  However, we have a number of non-compute nodes (admin,
> login and storage nodes) that we have connected directly to the core
> switches.  Initially, we were getting credit-loop issues so we switched
> from Min Hop to UPDN routing.  However, now 90% of our IB traffic seems
> to be routed through a single core switch.  I have tried adding a root
> guid file with the -a option, but that results in us getting this error:
> 
> Nov
> 28 16:47:19 319442 [45007960] 0x01 ->  __osm_pr_rcv_get_path_parms:
> ERR 1F07: Dead end on path to LID 0x6F from switch for GUID
> 0x00066a00d9000ac8
> Nov 28 16:47:22 319469 [43C05960] 0x01 ->
> __osm_pr_rcv_get_path_parms: ERR 1F07: Dead end on path to LID 0x6F
> from switch for GUID 0x00066a00d9000ac8
> 
> Is there any way we can handle this hardware config via subnet management?

I'm only guessing, but here's what I understand from your description:
You have 8 spine switches, and 12 leaf switches.
ANY of the spine switches is connected to ALL the leaf switches.
You have compute nodes connected to ALL the leaf switches.
You have some management/IO nodes connected to SEVERAL spine switches.

Am I right so far?

You get credit loops because of the traffic between management/IO nodes.
Up/Down routing with root nodes list doesn't solve you problem - it
prevents credit loops, but this is only because it doesn't connect
those management/IO nodes (hence the error that you see in the OSM log).

The real solution would be changing the topology.

If it's not an option, you can select a SINGLE leaf switch as a root
node, and run Up/Down routing with root guid list with this leaf switch
as a root. This is bad for BW, but it will solve the problem.

-- Yevgeny

> Thanks,
> 
> Reid O. 		 	   		
>   		 	   		
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
