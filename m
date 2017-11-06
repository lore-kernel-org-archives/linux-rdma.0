From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/5] IB/srpt: Post receive work requests after qp
 transition to INIT state
Date: Mon, 6 Nov 2017 17:28:10 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC6267A572@fmsmsx120.amr.corp.intel.com>
References: <20171103232056.30614-1-bart.vanassche@wdc.com>
 <20171103232056.30614-2-bart.vanassche@wdc.com>
 <20171106171523.GA18802@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171106171523.GA18802-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Not all HCAs support posting receive work requests in the RESET
> > state. Postpone posting receive work requests until after the
> > transition to the INIT state.
> 
> IBA spec even says submitting a WR to a RESET QP is an error.
> 

C10-97.2.1: If the QP is not associated with an SRQ, the QP shall process Work Requests submitted to the Receive Queue as described in the
rules that follow:
* Return an immediate error if the QP is in the Reset state.

So are other implementations not doing this?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
