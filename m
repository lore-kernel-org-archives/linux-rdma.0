From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [UPDATED PATCH] [3/3] support --load-cache
 in iblinkinfo and ibqueryerrors
Date: Sat, 16 Jan 2010 20:40:31 +0200
Message-ID: <20100116184031.GW574@me>
References: <1263579799.15172.168.camel@auk31.llnl.gov>
 <20100116142801.GS574@me>
 <1263659117.14626.12.camel@crazyclimber.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1263659117.14626.12.camel-RLKWKRZIcZkVVsCFsIUZTRy+HRzXvqW9@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08:25 Sat 16 Jan     , Al Chu wrote:
> > > @@ -317,6 +322,11 @@ int main(int argc, char **argv)
> > >  		mad_rpc_set_timeout(ibmad_port, ibd_timeout);
> > >  
> > >  	node_name_map = open_node_name_map(node_name_map_file);
> > > +	
> > > +	if (dr_path && load_cache_file) {
> > > +		fprintf(stderr, "Cannot specify cache and direct route path\n");
> > > +		exit(1);
> > > +	}
> > 
> > Why is this limitation needed really?
> 
> I spoke to Ira about it awhile ago.  I think what we decided was that
> while technically you can do a DR path, b/c you can load a cache from
> anywhere in the cluster, you won't know if the DR path is legal or
> correct at point A vs point B.  In contrast, the node_guid input is
> valid anywhere you are on the cluster.

But OTOH you have "from" field in the cache. Isn't it used to save an
original discovery point?

> I suppose we could just allow it and the user has to understand this
> fact??

First we need to decide about what this would mean - a path from an
original discovery point or path from a current one.

In any case I think that we can start with disabled direct path option
and re-enable later if it would be useful.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
