From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] Add node/port information to some error messages
Date: Thu, 27 Jan 2011 19:18:53 -0800
Message-ID: <20110127191853.c8e69f23.weiny2@llnl.gov>
References: <20110125171445.0525eb20.weiny2@llnl.gov>
	<4D41E52A.5020403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D41E52A.5020403-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 27 Jan 2011 13:35:38 -0800
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> Ira,
> 
> On 1/25/2011 8:14 PM, Ira Weiny wrote:
> >
> > From: Ira Weiny<weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
> > Date: Tue, 25 Jan 2011 17:09:04 -0800
> > Subject: [PATCH] Add node/port information to some error messages
> >
> >
> > Signed-off-by: Ira Weiny<weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
> > ---
> >   opensm/opensm/osm_sa_path_record.c |  116 +++++++++++++++++++++++++++--------
> >   opensm/opensm/osm_ucast_mgr.c      |    5 +-
> >   2 files changed, 92 insertions(+), 29 deletions(-)
> >
> > diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
> > index 2897c7b..7373875 100644
> > --- a/opensm/opensm/osm_sa_path_record.c

[snip]

> >
> >   	if (dest_lid_min_ho == 0) {
> >   		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F21:"
> > -			"Obtained destination LID of 0. No such LID possible\n");
> > +			"Obtained destination LID of 0. No such LID possible "
> > +			"(%s port %d)\n",
> > +			p_dest_port->p_node->print_desc,
> > +			p_dest_port->p_physp->port_num);
> >   		goto Exit;
> >   	}
> 
> Shouldn't osm_sa_multipath_record.c be updated similarly to this ?

Yes, V2 to follow shortly,
Ira

> 
> -- Hal
> 
> > diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
> > index 37b8741..9120480 100644
> > --- a/opensm/opensm/osm_ucast_mgr.c
> > +++ b/opensm/opensm/osm_ucast_mgr.c
> > @@ -217,9 +217,10 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
> >   	 * the initialization. Don't handle this port. */
> >   	if (min_lid_ho == 0 || max_lid_ho == 0) {
> >   		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 3A04: "
> > -			"Port 0x%" PRIx64 " has LID 0. An initialization "
> > +			"Port 0x%" PRIx64 " (%s) has LID 0. An initialization "
> >   			"error occurred. Ignoring port\n",
> > -			cl_ntoh64(osm_port_get_guid(p_port)));
> > +			cl_ntoh64(osm_port_get_guid(p_port)),
> > +			p_port->p_node->print_desc);
> >   		goto Exit;
> >   	}
> >
> 


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
