From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Tue, 30 Jan 2018 10:30:41 -0600
Message-ID: <20180130163041.GA2208@ssaleem-MOBL4.amr.corp.intel.com>
References: <1499970579.7987.8.camel@haakon3.daterainc.com>
 <BN3PR07MB2578E6561CC669922A322245F8A00@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171006224025.GA23364@ssaleem-MOBL4.amr.corp.intel.com>
 <1515992195.24576.156.camel@haakon3.daterainc.com>
 <CY1PR0701MB2012E53C69D1CE3E16BA320B88EB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20180115152236.GA15484@ssaleem-MOBL4.amr.corp.intel.com>
 <1516269522.24576.274.camel@haakon3.daterainc.com>
 <CY1PR0701MB2012C8513D9048FC1CC7011088EF0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <1516780534.24576.335.camel@haakon3.daterainc.com>
 <55569d98-7f8c-7414-ab03-e52e2bfc518b@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55569d98-7f8c-7414-ab03-e52e2bfc518b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Galon, Yoav" <Yoav.Galon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 29, 2018 at 09:17:02PM +0200, Sagi Grimberg wrote:
> 
> > > > First, would it be helpful to limit maximum payload size per I/O for
> > > > consumers based on number of iser-target sq hw sges..?
> > > 
> > > I don't think you need to limit the maximum payload, but instead
> > > initialize the max_wr to be based on the number of supported SGEs
> > > Instead of what is there today:
> > > #define ISERT_QP_MAX_REQ_DTOS   (ISCSI_DEF_XMIT_CMDS_MAX +    \
> > >                                  ISERT_MAX_TX_MISC_PDUS  + \
> > >                                  ISERT_MAX_RX_MISC_PDUS)
> > > Add the maximum number of WQEs per command,
> > > The calculation of number of WQEs per command needs to be something like
> > > "MAX_TRANSFER_SIZE/(numSges*PAGE_SIZE)".
> > > 
> > 
> > Makes sense, MAX_TRANSFER_SIZE would be defined globally by iser-target,
> > right..?
> > 
> > Btw, I'm not sure how this effects usage of ISER_MAX_TX_CQ_LEN +
> > ISER_MAX_CQ_LEN, which currently depend on ISERT_QP_MAX_REQ_DTOS..
> > 
> > Sagi, what are your thoughts wrt changing attr.cap.max_send_wr at
> > runtime vs. exposing a smaller max_data_sg_nents=32 for ib_devices with
> > limited attr.cap.max_send_sge..?
> 
> Sorry for the late reply,
> 
> Can we go back and understand why do we need to limit isert transfer
> size? I would suggest that we handle queue-full scenarios instead
> of limiting the transfered payload size.
> 
> From the trace Shiraz sent, it looks that:
> a) we are too chatty when failing to post a wr on a queue-pair
> (something that can happen by design), and
> b) isert escalates to terminating the connection which means we
> screwed up handling it.
> 
> Shiraz, can you explain these messages:
> [17066.397206] i40iw i40iw_process_aeq ae_id = 0x503 bool qp=1 qp_id = 3
> [17066.397247] i40iw i40iw_process_aeq ae_id = 0x501 bool qp=1 qp_id = 3

These are some device specific Asynchronous Event logging I turned on.
It indicates the QP received a FIN while in RTS and eventually was moved
to CLOSED state.

 
> Who is initiating the connection teardown? the initiator or the target?
> (looks like the initiator gave up on iscsi ping timeout expiration)
> 

Initiator

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
