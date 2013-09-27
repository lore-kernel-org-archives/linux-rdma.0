From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH]SRP: fix task management handle in srp
Date: Fri, 27 Sep 2013 12:11:10 -0700
Message-ID: <1380309070.31806.43.camel@haakon3.risingtidesystems.com>
References: <52454DED.6020309@profitbricks.com> <52455E5E.3060405@acm.org>
	 <52456429.3040505@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52456429.3040505-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-09-27 at 12:55 +0200, Jack Wang wrote:
> On 09/27/2013 12:30 PM, Bart Van Assche wrote:
> > On 09/27/13 11:20, Jack Wang wrote:
> >> Hi all,
> >>
> >> Currently handle of srp_rsp for task management is broken.
> >>
> >> in 6.9
> >> T10/1415-D revision 16a
> >> SRP_RSP responses that contain either
> >> RESPONSE DATA or SENSE DATA shall be sent as the minimum length message
> >> containing those fields.
> >> LENGTH field specify the number of bytes in the RESPONSE DATA field.
> >> RSPVALID set to one also indicates that the
> >> contents of the STATUS field shall be ignored by the SRP initiator port.
> >>
> >> If response data is provided, RSPVALID shall be set to one and the
> >> RESPONSE DATA LIST LENGTH field shall specify
> >> the number of bytes in the RESPONSE DATA field (see table 23). The
> >> RESPONSE DATA LIST LENGTH field shall
> >> contain the value four. Other lengths are reserved for future
> >> standardization.
> >> If no response data is provided, RSPVALID shall be set to zero. The SRP
> >> initiator port shall ignore the RESPONSE
> >> DATA LIST LENGTH field and shall assume a length of zero.
> >> Response data shall be provided in any SRP_RSP response that is sent in
> >> response to an SRP_TSK_MGMT
> >> request (see 6.7). The information in the RSP_CODE field (see table 24)
> >> shall indicate the completion status of
> >> the task management function.
> >> Response data shall not be provided in any SRP_RSP response that returns
> >> a non-zero status code in the
> >> STATUS field.
> >> The STATUS field contains the status of a task that completes.
> >>
> >> Patch made against v3.12-rc1
> >>
> >>> From 5f5af6de8dd72e37448841b7d7735d3eea4d3d83 Mon Sep 17 00:00:00 2001
> >> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> >> Date: Fri, 27 Sep 2013 11:10:05 +0200
> >> Subject: [PATCH] IB/srp: fix task management handle in srp
> >>
> >> Currently the srp driver process task manamgement command in wrong way
> >> it just ignore the return srp_rsp for successful case eg rsp->status is
> >> success, fix this.
> >>
> >> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> >> Reviewed-by: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> >> ---
> >>   drivers/infiniband/ulp/srp/ib_srp.c | 12 ++++++------
> >>   1 file changed, 6 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
> >> b/drivers/infiniband/ulp/srp/ib_srp.c
> >> index f93baf8..5e1f1bf 100644
> >> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> >> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> >> @@ -1145,9 +1145,11 @@ static void srp_process_rsp(struct
> >> srp_target_port *target, struct srp_rsp *rsp)
> >>           target->req_lim += be32_to_cpu(rsp->req_lim_delta);
> >>           spin_unlock_irqrestore(&target->lock, flags);
> >>
> >> -        target->tsk_mgmt_status = -1;
> >> -        if (be32_to_cpu(rsp->resp_data_len) >= 4)
> >> -            target->tsk_mgmt_status = rsp->data[3];
> >> +        target->tsk_mgmt_status = rsp->status;
> >> +        if (rsp->flags & SRP_RSP_FLAG_RSPVALID) {
> >> +            if (be32_to_cpu(rsp->resp_data_len) >= 4)
> >> +                target->tsk_mgmt_status = rsp->data[3];
> >> +        }
> >>           complete(&target->tsk_mgmt_done);
> >>       } else {
> >>           req = &target->req_ring[rsp->tag];
> >> @@ -1739,7 +1741,7 @@ static int srp_send_tsk_mgmt(struct
> >> srp_target_port *target,
> >>                        msecs_to_jiffies(SRP_ABORT_TIMEOUT_MS)))
> >>           return -1;
> >>
> >> -    return 0;
> >> +    return target->tsk_mgmt_status;
> >>   }
> >>
> >>   static int srp_abort(struct scsi_cmnd *scmnd)
> >> @@ -1776,8 +1778,6 @@ static int srp_reset_device(struct scsi_cmnd
> >> *scmnd)
> >>       if (srp_send_tsk_mgmt(target, SRP_TAG_NO_REQ, scmnd->device->lun,
> >>                     SRP_TSK_LUN_RESET))
> >>           return FAILED;
> >> -    if (target->tsk_mgmt_status)
> >> -        return FAILED;
> >>
> >>       for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
> >>           struct srp_request *req = &target->req_ring[i];
> >>
> > 
> > Good catch, however:
> > - I think the STATUS field only has a meaning in replies to regular SCSI
> > commands but not in SRP_TSK_MGMT replies.
> > - If the spec says that a target driver should always provide response
> > data in response to a SRP_TSK_MGMT request, isn't it the target that
> > should be modified instead of the initiator ?
> > 
> > Bart.
> 
> Hello Bart,
> 
> It's a little vague in the srp spec about status definition(as it only a
> draft version several years old without any update), I think it is quite
> efficient to also use status for succesful task management commands too.
> SAS has similar usage for that as I know.
> 
> But it will be great if you could fix srpt in SCST:)

It would be even better if someone sent a patch for srpt in mainline as
well, so I don't have to fish out bug fixes from an out of tree codebase
months (or years) after the fact.

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
