From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 39/49] IB/hfi1: add sysfs routines
Date: Mon, 15 Jun 2015 22:20:21 +0300
Message-ID: <CAJ3xEMiJ_0pFUvPJN7ov50v0hOZVsN7qC27ZbG5+pfmVuZQuMw@mail.gmail.com>
References: <20150615132434.29741.35258.stgit@phlsvslse11.ph.intel.com>
	<20150615132929.29741.87559.stgit@phlsvslse11.ph.intel.com>
	<CAJ3xEMiiqY04q4pnjRSm=7UBnS_jQJP-KhAkYEvu7FAu-F98sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiiqY04q4pnjRSm=7UBnS_jQJP-KhAkYEvu7FAu-F98sA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 15, 2015 at 10:14 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Jun 15, 2015 at 4:29 PM, Mike Marciniszyn
> <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> 58K LOC with a single non-empty change log line saying "This patch
> series adds the OPA gen1 driver" is surely a nice candidate for all
> times record of how not to submit upstream drivers. Why not sparing
>> +struct hfi1_sc2vl_attr {

what's SC and what's SC-to-VL? aren't you using SM to do such
mappings? if this and the below sysfs work-around/s for the maybe
current lack of SM to configure the port? why do the upstream kernel
has to carry ~hundreds of sysfs entries forever for such
non-documented things?




>> +HFI1_SL2SC_ATTR(0);

same comment on SL2SC

>> +HFI1_VL2MTU_ATTR(0);

same comment on VL2MTU, why in sysfs?!

>> +HFI1_DIAGC_ATTR(rc_resends);
>> +HFI1_DIAGC_ATTR_PCPU(rc_acks, C_SW_CPU_RC_ACKS, CNTR_INVALID_VL);
>> +HFI1_DIAGC_ATTR_PCPU(rc_qacks, C_SW_CPU_RC_QACKS, CNTR_INVALID_VL);
>> +HFI1_DIAGC_ATTR_PCPU(rc_delayed_comp, C_SW_CPU_RC_DELAYED_COMP,
>> +       CNTR_INVALID_VL);
>> +HFI1_DIAGC_ATTR(seq_naks);
>> +HFI1_DIAGC_ATTR(rdma_seq);
>> +HFI1_DIAGC_ATTR(rnr_naks);
>> +HFI1_DIAGC_ATTR(other_naks);
>> +HFI1_DIAGC_ATTR(rc_timeouts);
>> +HFI1_DIAGC_ATTR(loop_pkts);
>> +HFI1_DIAGC_ATTR(pkt_drops);
>> +HFI1_DIAGC_ATTR(dmawait);
>> +HFI1_DIAGC_ATTR(unaligned);
>> +HFI1_DIAGC_ATTR(rc_dupreq);
>> +HFI1_DIAGC_ATTR(rc_seqnak);

this belongs to the IB core, in a similar manner for the iWARP
counters which are reported from there.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
