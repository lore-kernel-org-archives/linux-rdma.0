From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: Found one reason libibnetdisc is slower than subnet_discover
Date: Mon, 25 Jan 2010 09:09:58 -0800
Message-ID: <20100125090958.fa63adb6.weiny2@llnl.gov>
References: <20100121181418.a9e955bb.weiny2@llnl.gov>
	<20100125151928.GN13519@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100125151928.GN13519@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Sasha,

On Mon, 25 Jan 2010 17:19:28 +0200
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> On 18:14 Thu 21 Jan     , Ira Weiny wrote:
> > From: Ira Weiny <weiny2-ig7AzVSIIG5IWGcSWN6Auu1ftBKYq+Ku@public.gmane.org>
> > Date: Thu, 21 Jan 2010 17:13:37 -0800
> > Subject: [PATCH] optimize query_node
> > 
> >    recognize when we have found a switch we have already processed and skip the
> >    SwitchInfo and NodeDescription queries.

[snip]

> > 
> >  static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
> >  		      ibnd_node_t * node, ibnd_port_t * port,
> >  		      ib_portid_t * portid)
> >  {
> >  	int rc = 0;
> >  	void *nd = node->nodedesc;
> > +	ibnd_node_t *existing;
> >  
> >  	if ((rc = query_node_info(ibmad_port, fabric, node, portid)) != 0)
> >  		return rc;
> >  
> > -	if (!smp_query_via(nd, portid, IB_ATTR_NODE_DESC, 0, 0, ibmad_port))
> > -		return -1;
> > -
> >  	if ((rc = query_port_info(ibmad_port, portid, 0, port)) != 0)
> >  		return rc;
> >  
> > @@ -121,7 +132,7 @@ static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
> >  	port->guid = mad_get_field64(node->info, 0, IB_NODE_PORT_GUID_F);
> >  
> >  	if (node->type != IB_NODE_SWITCH)
> > -		return 0;
> > +		goto query_nd;
> 
> Is this change related to the patch?

No, and it really should be ignored.

> 
> In any case why should we repeat NodeDesription query for non switch
> nodes?

This is a side affect of the way the algorithm is.  It is hard to explain but
I will try.  The current algorithm queries port 0 on the node first.  Then
later if it is a switch it queries the actual port number.  I did this to keep
the flow of the function simple.

I could have put another check (find_existing_node) at the end of the
function, or checked for "new node" and made a flag and bailed at the correct
time.  But I was just hacking to remove a few of the MADs to see where the
differences were.  On Hyperion most nodes only have 1 port so it did not
really affect the testing much.

I did not pursue this further because all this code is changed with your
algorithm.  So I did not clean this patch up further.  As I said above this is
only test code to show where the differences I found lie.

Ira

> 
> Sasha
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
