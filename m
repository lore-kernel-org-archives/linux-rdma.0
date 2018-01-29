From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Mon, 29 Jan 2018 21:17:02 +0200
Message-ID: <55569d98-7f8c-7414-ab03-e52e2bfc518b@grimberg.me>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <210f538f-8c98-f480-64fc-f2124ed6d01b@grimberg.me>
 <BN3PR07MB25786338EADC77A369A6D493F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <1499970579.7987.8.camel@haakon3.daterainc.com>
 <BN3PR07MB2578E6561CC669922A322245F8A00@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171006224025.GA23364@ssaleem-MOBL4.amr.corp.intel.com>
 <1515992195.24576.156.camel@haakon3.daterainc.com>
 <CY1PR0701MB2012E53C69D1CE3E16BA320B88EB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20180115152236.GA15484@ssaleem-MOBL4.amr.corp.intel.com>
 <1516269522.24576.274.camel@haakon3.daterainc.com>
 <CY1PR0701MB2012C8513D9048FC1CC7011088EF0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <1516780534.24576.335.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516780534.24576.335.camel-XoQW25Eq2zs8TOCF0fvnoXxStJ4P+DSV@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Galon, Yoav" <Yoav.Galon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> First, would it be helpful to limit maximum payload size per I/O for
>>> consumers based on number of iser-target sq hw sges..?
>>
>> I don't think you need to limit the maximum payload, but instead
>> initialize the max_wr to be based on the number of supported SGEs
>> Instead of what is there today:
>> #define ISERT_QP_MAX_REQ_DTOS   (ISCSI_DEF_XMIT_CMDS_MAX +    \
>>                                  ISERT_MAX_TX_MISC_PDUS  + \
>>                                  ISERT_MAX_RX_MISC_PDUS)
>> Add the maximum number of WQEs per command,
>> The calculation of number of WQEs per command needs to be something like
>> "MAX_TRANSFER_SIZE/(numSges*PAGE_SIZE)".
>>
> 
> Makes sense, MAX_TRANSFER_SIZE would be defined globally by iser-target,
> right..?
> 
> Btw, I'm not sure how this effects usage of ISER_MAX_TX_CQ_LEN +
> ISER_MAX_CQ_LEN, which currently depend on ISERT_QP_MAX_REQ_DTOS..
> 
> Sagi, what are your thoughts wrt changing attr.cap.max_send_wr at
> runtime vs. exposing a smaller max_data_sg_nents=32 for ib_devices with
> limited attr.cap.max_send_sge..?

Sorry for the late reply,

Can we go back and understand why do we need to limit isert transfer
size? I would suggest that we handle queue-full scenarios instead
of limiting the transfered payload size.

 From the trace Shiraz sent, it looks that:
a) we are too chatty when failing to post a wr on a queue-pair
(something that can happen by design), and
b) isert escalates to terminating the connection which means we
screwed up handling it.

Shiraz, can you explain these messages:
[17066.397206] i40iw i40iw_process_aeq ae_id = 0x503 bool qp=1 qp_id = 3
[17066.397247] i40iw i40iw_process_aeq ae_id = 0x501 bool qp=1 qp_id = 3

Who is initiating the connection teardown? the initiator or the target?
(looks like the initiator gave up on iscsi ping timeout expiration)

Nic,
Currently, what I see is that queue-full handler simply schedules qf
work to re-issue the I/O again. The issue is that the only way that
a new send queue entry becomes available again is that isert process
one or more send completions. If at all, this work is interfering with
the isert_send_done handler.

Will it be possible that some transports will be able to schedule
qf_work_queue themselves? I guess It would also hold if iscsit were to
use non-blocking sockets and continue at .write_space()?

Something like transport_process_wait_list() that would be triggered
from the transport completion handler (or from centralize place like
target_sess_put_cmd or something...)?

Also, I see that this wait list is singular accross the se_device. Maybe
it would be a better idea to have it per se_session as it maps to iscsi
connection (or srp channel for that matter)? For large I/O sizes this
should happen quite a lot so its a bit of a shame that we need will
to compete over the list_empty check...

If we prefer to make this go away by limiting the transfer size then its
fine I guess, but maybe we can do better? (although it can take some
extra work...)

>> For some devices like ours, breaking the IO into multiple WRs according to supported
>> number of SGEs doesn't necessarily means performance penalty.
>>
> 
> AFAICT ading max_data_sg_nents for iser-target is safe enough
> work-around to include for stable, assuming we agree on what the
> max_send_sg cut-off is for setting max_data_sg_nents=32 usage from a
> larger default.  I don't have a string preference either way, as long as
> it can be picked up for 4.x stable. >
> Sagi, WDYT..?

I think its an easier fix for sure. What I don't know, is weather this
introduces a regression for devices that can handle more sges on large
I/O sizes. I very much doubt it will though...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
