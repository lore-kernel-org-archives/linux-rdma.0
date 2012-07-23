From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 5/8] opensm: Signal subnet init errors on SubnGet
	timeouts
Date: Mon, 23 Jul 2012 15:19:49 -0700
Message-ID: <1343081989.29792.12.camel@auk75.llnl.gov>
References: <1340672058.5218.97.camel@auk75.llnl.gov>
	 <1340672104-18039-1-git-send-email-foraker1@llnl.gov>
	 <1340672104-18039-5-git-send-email-foraker1@llnl.gov>
	 <20120723154357.GA2064@calypso>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120723154357.GA2064@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Mon, 2012-07-23 at 08:43 -0700, Alex Netes wrote:
> Hi Jim,
> 
> On 17:55 Mon 25 Jun     , Jim Foraker wrote:
> > A subnet should not be listed as cleanly initialized if CAs
> > fail to respond to SubnGet requests.
> > 
> > Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  opensm/osm_sm_mad_ctrl.c |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
> > index f0bcff2..464b6b0 100644
> > --- a/opensm/osm_sm_mad_ctrl.c
> > +++ b/opensm/osm_sm_mad_ctrl.c
> > @@ -741,6 +741,15 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
> >  			cl_ntoh16(p_smp->attr_id),
> >  			ib_get_sm_attr_str(p_smp->attr_id));
> >  		p_ctrl->p_subn->subnet_initialization_error = TRUE;
> > +	} else if (p_madw->status == IB_TIMEOUT &&
> > +		   p_smp->method == IB_MAD_METHOD_GET) {
> 
> It's pretty common to see timeouts in fabrics without m_key support (e.g.
> switch reboots) and it's not desirable to start another heavy sweep because
> of that. So I guess it would be better if we could initiate heavy sweep only
> when m_key is set and protection level is 2 or 3.
     This was done primarily to ensure that "SUBNET UP" doesn't get
displayed/logged while there are unconfigured HCAs due to misset mkeys.
I'm reasonably sure (I will re-test to verify) that future light sweeps
will catch HCAs whos mkeys timeout, presuming the timeout is set.  So we
could also just log the error and not worry about setting
subnet_initialization_error.

     Jim

> > +		/* Timeouts on SubnGet may be an indication of an mkey
> > +	 	   error at protection levels 2/3 */
> > +		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3120 "
> > +			"Timeout while getting attribute 0x%X (%s)\n",
> > +			cl_ntoh16(p_smp->attr_id),
> > +			ib_get_sm_attr_str(p_smp->attr_id));
> > +		p_ctrl->p_subn->subnet_initialization_error = TRUE;
> >  	}
> >  
> >  	osm_dump_dr_smp(p_ctrl->p_log, p_smp, OSM_LOG_VERBOSE);
> > -- 
> > 1.7.9.2
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
