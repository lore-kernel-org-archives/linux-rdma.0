From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: on MAD error call back print DR PATH or LID of
 request MAD
Date: Thu, 15 Dec 2011 14:54:30 -0800
Message-ID: <20111215145430.20f6adee.weiny2@llnl.gov>
References: <20111213210918.9cf79850.weiny2@llnl.gov>
	<4EE959A8.3000409@dev.mellanox.co.il>
	<20111214191840.a3a80cf3.weiny2@llnl.gov>
	<4EEA00ED.2080609@dev.mellanox.co.il>
	<20111215094006.8aa8f198.weiny2@llnl.gov>
	<4EEA72A5.8080602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EEA72A5.8080602-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 15 Dec 2011 14:20:21 -0800
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 12/15/2011 12:40 PM, Ira Weiny wrote:
> > On Thu, 15 Dec 2011 06:15:09 -0800
> > Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> > 
> >> On 12/14/2011 10:18 PM, Ira Weiny wrote:
> >>> On Wed, 14 Dec 2011 18:21:28 -0800
> >>> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> >>>
> >>>> On 12/14/2011 12:09 AM, Ira Weiny wrote:
> >>>>>
> >>>>> In addition print transaction ID of all DR PATH dumps to make sure we know
> >>>>> which MAD's they refer to.
> >>>>>
> >>>>> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> >>>>> ---
> >>>>>  opensm/osm_helper.c      |    5 +++--
> >>>>>  opensm/osm_sm_mad_ctrl.c |    7 +++++++
> >>>>>  2 files changed, 10 insertions(+), 2 deletions(-)
> >>>>>
> >>>>> diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
> >>>>> index f9f3d9d..b6591c4 100644
> >>>>> --- a/opensm/osm_helper.c
> >>>>> +++ b/opensm/osm_helper.c
> >>>>> @@ -2059,8 +2059,9 @@ void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
> >>>>>  		char buf[BUF_SIZE];
> >>>>>  		unsigned n;
> >>>>>  
> >>>>> -		n = sprintf(buf, "Received SMP on a %u hop path: "
> >>>>> -			    "Initial path = ", p_smp->hop_count);
> >>>>> +		n = sprintf(buf, "Received SMP (TID 0x%" PRIx64 ") on a %u hop path: "
> >>>>> +			    "Initial path = ",
> >>>>> +			    cl_ntoh64(p_smp->trans_id), p_smp->hop_count);
> >>>>>  		n += sprint_uint8_arr(buf + n, sizeof(buf) - n,
> >>>>>  				      p_smp->initial_path,
> >>>>>  				      p_smp->hop_count + 1);
> >>>>> diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
> >>>>> index ee92c66..6abf8b8 100644
> >>>>> --- a/opensm/osm_sm_mad_ctrl.c
> >>>>> +++ b/opensm/osm_sm_mad_ctrl.c
> >>>>> @@ -721,6 +721,13 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
> >>>>>  		ib_get_sm_attr_str(p_smp->attr_id), cl_ntoh32(p_smp->attr_mod),
> >>>>>  		cl_ntoh64(p_smp->trans_id));
> >>>>>  
> >>>>> +	if (p_smp->mgmt_class == IB_MCLASS_SUBN_DIR) {
> >>>>> +		osm_dump_smp_dr_path(p_ctrl->p_log, p_smp, OSM_LOG_ERROR);
> >>>>
> >>>> Rather than here, should this be in osm_vendor_ibumad.c ? There's
> >>>> already one similar log there but looks like evicted entry logging was
> >>>> not done. If not, then do any logs there need to be removed as redundant ?
> >>>
> >>> Yes looking a bit closer I see that is redundant with the current umad_status
> >>> implementation.  
> >>
> >> Well, not quite. That logs on any send error and osm_dump_smp_dr_path is
> >> only currently called for NodeInfo. That's one reason why it's down at
> >> that layer right now. I can see your v2 patch addresses this.
> >>
> >>> IE the message you get is:
> >>>
> >>> 	Dec 14 18:31:54 137584 [AEB0C700] 0x01 -> Received SMP on a 4 hop path: Initial path = 0,0,0,0,0, Return path  = 0,0,0,0,0
> >>>
> >>> That is useless.  I can alter the patch to remove that as well.
> >>
> >> Another alternative is that if it's a bug, why not just fix that ?
> > 
> > I was not sure if it was a bug (but I did not dig through the umad and kernel
> > layers to verify that).  It looks to me like umad_status only returns TIMEOUT
> > as an error.  Furthermore, I think the "response" MAD returned (and printed in
> > the above logs) does not include a DR path since it is not really a response
> > but just a place holder.
> 
> I thought that the sent MAD is returned in the timeout case. That would
> include the DR paths in the SMP case. It seems to work only some of the
> time though and I'm not sure why that is.

I did not see this in umad_recv but the man page for umad_send does say.

     "If  reply is not received within the specified value [TIMEOUT], the original
     buffer is returned in the read channel with the status field set (to non
     zero)."

So I guess this is a bug.  :-(

> 
> > Does the kernel/umad layer copy the request MAD into the "response" MAD on
> > timeout?[*]
> 
> See above and below under [*]
> 
> >  (It looks to me like only some of the data is copied into the
> > "response" MAD; method, attr_id, and transaction ID).  
> 
> That's certainly the observation in some but not all cases...

I am not dead set against leaving the DR path print in if you think it might
be valid.  I was unsure of the behaviour in this area.

> 
> > If the entire request
> > is to be copied then the above might be bug.  
> 
> I thought the request MAD is supposed to be returned on a send error
> (including timeout). Maybe some shortcut/optimization was taken here
> in some cases.
> 
> > If not then the print statement
> > I removed is useless but the other one at least confirms the "fake" MAD is
> > equivalent to the one printed in the error call back.
> 
> Yes, but why have the extra log message just for that ?

I guess for the reason above.  To check the response MAD.

> 
> > If you want to keep the error printing at the vendor layer then I guess the
> > appropriate place to print the error would be on the request mad like this...
> > 
> > 			} else {
> > 				p_req_madw->status = IB_TIMEOUT;
> > 				/* cb frees req_madw */
> > 				pthread_mutex_lock(&p_vend->cb_mutex);
> > 				pthread_cleanup_push(unlock_mutex,
> > 						     &p_vend->cb_mutex);
> > // dump p_req_madw here before callback
> > 				(*p_bind->send_err_callback) (p_bind->
> > 							      client_context,
> > 							      p_req_madw);
> > 				pthread_cleanup_pop(1);
> > 			}
> 
> There's also the cancelled case too that calls send_err_callback.

Isn't this more reason to print the address information in the error callback?

> 
> > Or you are correct we could just remove all the logging in the vendor layer
> > here.  
> >
> > Alex, any opinions?
> > 
> > Ira
> > 
> > [*] I don't think the request MAD should be copied except for the TID as is
> > documented so you can find the request MAD.
> 
> What documentation are you referring to ?

man page for umad_status.  It does not mention anything other than the TID.
After reading the umad_send man page I guess we could assume the other fields
are also valid.

	"ETIMEDOUT means that the packet had a send-timeout indication. In this case, the transaction ID will be set to the TID of the original request."

Ira

> 
> -- Hal
> 
> >>
> >>>>
> >>>> Also, does this log every timeout (at error level) ? If so, that might
> >>>> not be a good thing in all subnets as timeouts are common.
> >>>
> >>> Why would you say that?  I think it is very valid to know what nodes are
> >>> timeing out.  When would you not want to know the destination of what is
> >>> timing out?
> >>
> >> Yes, but I'm concerned about spamming the log. Timeouts are "normal" in
> >> many subnets; maybe not yours.
> >>
> >> I was just saying level might be reduced but I can see 5411 is error
> >> level too.
> >>
> >>>>
> >>>>> +	} else {
> >>>>> +		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "LID %u\n",
> >>>>> +			cl_ntoh16(p_madw->mad_addr.dest_lid));
> >>>>
> >>>> Log the TID here too ?
> >>>
> >>> Actually I think moving that into the error print above is better.
> >>
> >> Sure; that's another way of accomplishing the same thing.
> >>
> >> -- Hal
> >>
> >>> Sending V2 now,
> >>> Ira
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
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
