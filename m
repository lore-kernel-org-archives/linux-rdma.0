From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: RE: [PATCH v2 2/4] rsockets: retry for completion events upon
 interruption
Date: Thu, 18 Sep 2014 16:30:16 +0530
Message-ID: <48fb4ca4b15cb79bb2ec9a01793212f7@imap.linux.ibm.com>
References: <66c7c361d03a72de6a216fd1d6ffa0bc@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DD4395@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DD4395-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2014-09-17 21:57, Hefty, Sean wrote:
>> +resume_get_cq_event:
>>   	ret = ibv_get_cq_event(rs->cm_id->recv_cq_channel, &cq, &context);
>>   	if (!ret) {
>>   		ibv_ack_cq_events(rs->cm_id->recv_cq, 1);
>>   		rs->cq_armed = 0;
>> +	} else if (restart_onintr == 1 && errno == EINTR) {
>> +		errno = 0;
>> +		goto resume_get_cq_event;
> 
> I'm not convinced that this is desirable behavior.  If the thread
> waiting for an event was interrupted, why does it make sense to ignore
> the interrupt and return to waiting?  Couldn't the app detect the
> return code and call back into rsockets in this case?
> 
> If this is desired behavior, why add a config option?
> 
> - Sean

Hi Sean,

I have reworked the patch by dropping config option.  Also, we no
longer resume event listening on interruption.  Instead, we desist
from changing state to error upon interruption so the caller can
choose appropriate action.  Please see v5 of the patch.

Thank You.

- Sreedhar

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
