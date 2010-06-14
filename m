From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] support diffing lids and nodedesc on
 remoteports in ibnetdiscover
Date: Mon, 14 Jun 2010 14:34:37 +0300
Message-ID: <20100614113437.GS20172@me>
References: <1271802640.17987.230.camel@auk31.llnl.gov>
 <1271873984.17987.244.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1271873984.17987.244.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11:19 Wed 21 Apr     , Al Chu wrote:
> Hey Sasha,
> 
> A slight tweak to the patch.  Support diffing lids and node descriptions
> on remote ports (previously it diffed only "local" lids and node
> descriptions).  Also add appropriate manpage notes.
> 
> Al
> 
> On Tue, 2010-04-20 at 15:30 -0700, Al Chu wrote:
> > Hey Sasha,
> > 
> > This patch supports diffing node descriptions on remote ports
> > (previously diffing of just the "local" node description was supported).
> > 
> > Al
> > 
> > email message attachment
> > > -------- Forwarded Message --------
> > > From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> > > Subject: [PATCH] support diffing nodedesc on remoteports in
> > > ibnetdiscover
> > > Date: Tue, 20 Apr 2010 15:09:59 -0700
> > > 
> > > Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> > > ---
> > >  infiniband-diags/src/ibnetdiscover.c |   11 +++++++++++
> > >  1 files changed, 11 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
> > > index 57f9625..eeb1b9f 100644
> > > --- a/infiniband-diags/src/ibnetdiscover.c
> > > +++ b/infiniband-diags/src/ibnetdiscover.c
> > > @@ -720,6 +720,17 @@ static void diff_ports(ibnd_node_t * fabric1_node, ibnd_node_t * fabric2_node,
> > >  			fabric2_out++;
> > >  		}
> > >  
> > > +		if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION
> > > +		    && data->diff_flags & DIFF_FLAG_NODE_DESCRIPTION
> > > +		    && fabric1_port && fabric2_port
> > > +		    && fabric1_port->remoteport && fabric2_port->remoteport
> > > +		    && memcmp(fabric1_port->remoteport->node->nodedesc,
> > > +			      fabric2_port->remoteport->node->nodedesc,
> > > +			      IB_SMP_DATA_SIZE)) {
> > > +			fabric1_out++;
> > > +			fabric2_out++;
> > > +		}
> > > +
> > >  		if (fabric1_out) {
> > >  			diff_iter_out_header(fabric1_node, data,
> > >  					     out_header_flag);
> -- 
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory

> Date: Tue, 20 Apr 2010 15:09:59 -0700
> From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> Subject: [PATCH] support diffing lids and nodedesc on remoteports in
> 	ibnetdiscover
> Message-Id: <1271873984.17987.245.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
> Mime-Version: 1.0
> Content-Transfer-Encoding: 7bit
> 
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Both applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
