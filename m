From: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/5] i40iw: Do not retransmit MPA request after it is
 ACKed
Date: Tue, 3 Oct 2017 03:34:26 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB3C63DE69@fmsmsx104.amr.corp.intel.com>
References: <20170930012942.9128-1-shiraz.saleem@intel.com>
 <20170930012942.9128-2-shiraz.saleem@intel.com>
 <20171001061609.GC2031@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171001061609.GC2031-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> Sent: Sunday, October 01, 2017 1:16 AM
> To: Saleem, Shiraz <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; e1000-
> rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Nikolova, Tatyana E
> <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: Re: [PATCH 1/5] i40iw: Do not retransmit MPA request after it is
> ACKed
> 
> On Fri, Sep 29, 2017 at 08:29:38PM -0500, Shiraz Saleem wrote:
> > From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > The ACK packets for an MPA request are ignored and the MPA request is
> > retransmitted if the MPA reply is late or missing. Fix this by
> > checking ack_rcvd variable before retransmitting a packet.
> >
> > Fixes: f27b4746f378 ("i40iw: add connection management code")
> > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/i40iw/i40iw_cm.c | 13 ++++++++++---
> > drivers/infiniband/hw/i40iw/i40iw_cm.h |  1 +
> >  2 files changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> > b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> > index 5230dd3..5dbf9f1 100644
> > --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> > +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> > @@ -1267,13 +1267,16 @@ static void i40iw_cm_timer_tick(unsigned long
> pass)
> >  			spin_lock_irqsave(&cm_node->retrans_list_lock,
> flags);
> >  			goto done;
> >  		}
> > -		cm_node->cm_core->stats_pkt_retrans++;
> >  		spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
> >
> >  		vsi = &cm_node->iwdev->vsi;
> >  		dev = cm_node->dev;
> > -		atomic_inc(&send_entry->sqbuf->refcount);
> > -		i40iw_puda_send_buf(vsi->ilq, send_entry->sqbuf);
> > +
> > +		if (!atomic_read(&cm_node->ack_rcvd)) {
> > +			atomic_inc(&send_entry->sqbuf->refcount);
> > +			i40iw_puda_send_buf(vsi->ilq, send_entry->sqbuf);
> > +			cm_node->cm_core->stats_pkt_retrans++;
> > +		}
> >  		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
> >  		if (send_entry->send_retrans) {
> >  			send_entry->retranscount--;
> > @@ -2181,6 +2184,7 @@ static struct i40iw_cm_node
> *i40iw_make_cm_node(
> >  	cm_node->cm_id = cm_info->cm_id;
> >  	ether_addr_copy(cm_node->loc_mac, netdev->dev_addr);
> >  	spin_lock_init(&cm_node->retrans_list_lock);
> > +	atomic_set(&cm_node->ack_rcvd, 0);
> >
> >  	atomic_set(&cm_node->ref_count, 1);
> >  	/* associate our parent CM core */
> > @@ -2719,7 +2723,10 @@ static int i40iw_handle_ack_pkt(struct
> i40iw_cm_node *cm_node,
> >  		cm_node->tcp_cntxt.rem_ack_num = ntohl(tcph->ack_seq);
> >  		if (datasize) {
> >  			cm_node->tcp_cntxt.rcv_nxt = inc_sequence +
> datasize;
> > +			atomic_set(&cm_node->ack_rcvd, 0);
> >  			i40iw_handle_rcv_mpa(cm_node, rbuf);
> > +		} else {
> > +			atomic_set(&cm_node->ack_rcvd, 1);
> 
> Sorry, for my lame question, but why do you need atomic to set bool
> variable?
> Atomic doesn't ensure correctness and doesn't replace lock, just ensure that
> there is no intermediate result in the memory.
> 
> Or proper locking is needed here, or regular bool will do the same trick.
> 
> Thanks

Hi Leon,

Thank you for the feedback. A regular bool is sufficient in this case. We are going to send a V2 patch.

Tatyana
> 
> >  		}
> >  		break;
> >  	case I40IW_CM_STATE_LISTENING:
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.h
> > b/drivers/infiniband/hw/i40iw/i40iw_cm.h
> > index 45abef7..7e86b64 100644
> > --- a/drivers/infiniband/hw/i40iw/i40iw_cm.h
> > +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.h
> > @@ -360,6 +360,7 @@ struct i40iw_cm_node {
> >
> >  	u8 pdata_buf[IETF_MAX_PRIV_DATA_LEN];
> >  	struct i40iw_kmem_info mpa_hdr;
> > +	atomic_t ack_rcvd;
> >  };
> >
> >  /* structure for client or CM to fill when making CM api calls. */
> > --
> > 2.8.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
