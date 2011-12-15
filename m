From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V2] opensm: on MAD error call back print DR PATH or LID
 of request MAD
Date: Thu, 15 Dec 2011 17:20:28 -0500
Message-ID: <4EEA72AC.7060103@dev.mellanox.co.il>
References: <20111214191843.35cecd64.weiny2@llnl.gov> <4EEA00F5.7040505@dev.mellanox.co.il> <20111215094956.32f1abad.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111215094956.32f1abad.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/15/2011 12:49 PM, Ira Weiny wrote:
> On Thu, 15 Dec 2011 06:15:17 -0800
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
>> On 12/14/2011 10:18 PM, Ira Weiny wrote:
>>>
>>> In addition print transaction ID of all DR PATH dumps to make sure we know
>>> which MAD's they refer to.
>>
>> A note on this approach is that this splits the logging of send errors
>> between the vendor layer and SM rather than keeping it all at one layer
>> of the implementation. That's the tradeoff to not fixing the bug in
>> umad_receiver in terms of printing the DR path in ERR 5411.
> 
> Yes I guess it could be viewed this way but I really thought of it more as
> adding to the already existing logging in sm_mad_ctrl_send_err_cb and fixing a
> bug in the logging of umad_receiver.
> 
> As I responded in the other thread I did not take out any logging in
> umad_receiver which I think is still valid.  

You left some redundant logging in though and that was what I was
commenting on here.

> In addition I just added logging
> in the error callback regarding the request which timed out.
> 
>>
>>> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
>>> ---
>>>  libvendor/osm_vendor_ibumad.c |    2 --
>>>  opensm/osm_helper.c           |    5 +++--
>>>  opensm/osm_sm_mad_ctrl.c      |   16 ++++++++++++++--
>>>  3 files changed, 17 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
>>> index e2ebd8e..b2872c8 100644
>>> --- a/libvendor/osm_vendor_ibumad.c
>>> +++ b/libvendor/osm_vendor_ibumad.c
>>> @@ -348,8 +348,6 @@ static void *umad_receiver(void *p_ptr)
>>>  					", Hop Ptr: 0x%X\n",
>>>  					mad->method, cl_ntoh16(mad->attr_id),
>>>  					cl_ntoh64(mad->trans_id), smp->hop_ptr);
>>> -				osm_dump_smp_dr_path(p_vend->p_log, smp,
>>> -						     OSM_LOG_ERROR);
>>
>> If you're going this direction, why not remove the logging of error 5411
>> above it which means eliminate the else clause there ? Isn't that
>> redundant with your change below to sm_mad_ctrl_send_err_cb ?
> 
> Technically, yes it is redundant as the "response" is not really a response.
> (I think.) But my intention was not to remove any logging except that which
> was "useless".

If this logging is moved up to the callback, then it should be removed
from here IMO (and also takes care of the cancelled case too at least
for SMPs).

>>
>> Also, shouldn't another related change to umad_receiver be done:
>>
>> Where it is:
>> 	if (mad->mgmt_class != IB_MCLASS_SUBN_DIR) {
>> it should now be:
>> 	if ((mad->mgmt_class != IB_MCLASS_SUBN_DIR) &&
>> 	    (mad->mgmt_class != IB_MCLASS_SUBN_LID)) {
>>
>> to go along with SM class being logged in the SM send_err callback
>> rather than at umad layer.
> 
> I am not sure I follow here.  

Since the callback is made for both DR and LR SMPs, the logging at the
vendor layer isn't needed for those. It's still needed for GMPs though
(like PerfMgr).

> Why would you care about the other classes which
> timeout?  Wouldn't they have the same issue of a response which is "fake"?

No; the issue is only with DR path. Isn't LID fine ?

> If we want to remove the logging at this layer I think we should consider
> this.
> 
> diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c           
> index b2872c8..b352cef 100644
> --- a/libvendor/osm_vendor_ibumad.c
> +++ b/libvendor/osm_vendor_ibumad.c
> @@ -327,29 +327,6 @@ static void *umad_receiver(void *p_ptr)
>                 /* if status != 0 then we are handling recv timeout on send */
>                 if (umad_status(p_madw->vend_wrap.umad)) {
> 
> -                       if (mad->mgmt_class != IB_MCLASS_SUBN_DIR) {
> -                               /* LID routed */
> -                               OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5410: "
> -                                       "Send completed with error -- dropping\n"
> -                                       "\t\t\tClass 0x%x, Method 0x%X, Attr 0x%X, "
> -                                       "TID 0x%" PRIx64 ", LID %u\n",
> -                                       mad->mgmt_class, mad->method,
> -                                       cl_ntoh16(mad->attr_id),
> -                                       cl_ntoh64(mad->trans_id),
> -                                       cl_ntoh16(ib_mad_addr->lid));
> -                       } else {
> -                               ib_smp_t *smp;
> -
> -                               /* Direct routed SMP */
> -                               smp = (ib_smp_t *) mad;
> -                               OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5411: "
> -                                       "DR SMP Send completed with error -- dropping\n"
> -                                       "\t\t\tMethod 0x%X, Attr 0x%X, TID 0x%" PRIx64
> -                                       ", Hop Ptr: 0x%X\n",
> -                                       mad->method, cl_ntoh16(mad->attr_id),
> -                                       cl_ntoh64(mad->trans_id), smp->hop_ptr);
> -                       }
> -
>                         if (!(p_req_madw = get_madw(p_vend, &mad->trans_id))) {
>                                 OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
>                                         "ERR 5412: "
> 
> 
> But I felt that was a bit draconian, and it was not my initial intent.

Yes that's overkill. I think it is more like the below:

                /* if status != 0 and GMP then we are handling recv
timeout on send */
                if (umad_status(p_madw->vend_wrap.umad)) {

                        if ((mad->mgmt_class != IB_MCLASS_SUBN_DIR) &&
			    (mad->mgmt_class != IB_MCLASS_SUBN_LID)) {
                                /* LID routed */
                                OSM_LOG(p_vend->p_log, OSM_LOG_ERROR,
"ERR 5410: "
                                        "Send completed with error --
dropping\n"
                                        "\t\t\tClass 0x%x, Method 0x%X,
Attr 0x%X, "
                                        "TID 0x%" PRIx64 ", LID %u\n",
                                        mad->mgmt_class, mad->method,
                                        cl_ntoh16(mad->attr_id),
                                        cl_ntoh64(mad->trans_id),
                                        cl_ntoh16(ib_mad_addr->lid));
                        }

removing the else clause totally.

-- Hal

> Ira
> 
>>
>> -- Hal
>>
>>>  			}
>>>  
>>>  			if (!(p_req_madw = get_madw(p_vend, &mad->trans_id))) {
>>> diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
>>> index f9f3d9d..b968679 100644
>>> --- a/opensm/osm_helper.c
>>> +++ b/opensm/osm_helper.c
>>> @@ -2059,8 +2059,9 @@ void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
>>>  		char buf[BUF_SIZE];
>>>  		unsigned n;
>>>  
>>> -		n = sprintf(buf, "Received SMP on a %u hop path: "
>>> -			    "Initial path = ", p_smp->hop_count);
>>> +		n = sprintf(buf, "   DR SMP (TID 0x%" PRIx64 ") on a %u hop path: "
>>> +			    "Initial path = ",
>>> +			    cl_ntoh64(p_smp->trans_id), p_smp->hop_count);
>>>  		n += sprint_uint8_arr(buf + n, sizeof(buf) - n,
>>>  				      p_smp->initial_path,
>>>  				      p_smp->hop_count + 1);
>>> diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
>>> index ee92c66..a3b444a 100644
>>> --- a/opensm/osm_sm_mad_ctrl.c
>>> +++ b/opensm/osm_sm_mad_ctrl.c
>>> @@ -704,6 +704,7 @@ Exit:
>>>   */
>>>  static void (IN void *context, IN osm_madw_t * p_madw)
>>>  {
>>> +	char lidstr[8];
>>>  	osm_sm_mad_ctrl_t *p_ctrl = context;
>>>  	ib_api_status_t status;
>>>  	ib_smp_t *p_smp;
>>> @@ -713,13 +714,24 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
>>>  	CL_ASSERT(p_madw);
>>>  
>>>  	p_smp = osm_madw_get_smp_ptr(p_madw);
>>> +
>>> +	if (p_smp->mgmt_class == IB_MCLASS_SUBN_DIR)
>>> +		lidstr[0] = '\0';
>>> +	else
>>> +		snprintf(lidstr, 8, " DLID %u",
>>> +			cl_ntoh16(p_madw->mad_addr.dest_lid));
>>> +
>>>  	OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3113: "
>>>  		"MAD completed in error (%s): "
>>> -		"%s(%s), attr_mod 0x%x, TID 0x%" PRIx64 "\n",
>>> +		"%s(%s), attr_mod 0x%x, TID 0x%" PRIx64 " %s\n",
>>>  		ib_get_err_str(p_madw->status),
>>>  		ib_get_sm_method_str(p_smp->method),
>>>  		ib_get_sm_attr_str(p_smp->attr_id), cl_ntoh32(p_smp->attr_mod),
>>> -		cl_ntoh64(p_smp->trans_id));
>>> +		cl_ntoh64(p_smp->trans_id),
>>> +		lidstr);
>>> +
>>> +	if (p_smp->mgmt_class == IB_MCLASS_SUBN_DIR)
>>> +		osm_dump_smp_dr_path(p_ctrl->p_log, p_smp, OSM_LOG_ERROR);
>>>  
>>>  	/*
>>>  	   If this was a SubnSet MAD, then this error might indicate a problem
>>
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
