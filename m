From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5 RFC] IB/MAD: add send path trace points
Date: Thu, 1 Oct 2015 14:34:27 +0800
Message-ID: <201510011455.a7LAn2jp%fengguang.wu@intel.com>
References: <1443675089-11786-2-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443675089-11786-2-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be64
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be64
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be64
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be64
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be64
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be64
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be64
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be64
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be64
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be64
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be32
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be32
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be32
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be32
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be32
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be32
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: cast to restricted __be16
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be64
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be64
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be64
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be64
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be64
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be64
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be64
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be64
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be64
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be64
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be16
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be16
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be16
   include/trace/events/ib_mad.h:131:1: sparse: cast to restricted __be16
>> include/trace/events/ib_mad.h:43:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:43:1:    expected unsigned short [unsigned] [usertype] status
   include/trace/events/ib_mad.h:43:1:    got restricted __be16 [usertype] status
>> include/trace/events/ib_mad.h:43:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:43:1:    expected unsigned short [unsigned] [usertype] class_specific
   include/trace/events/ib_mad.h:43:1:    got restricted __be16 [usertype] class_specific
>> include/trace/events/ib_mad.h:43:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:43:1:    expected unsigned long long [unsigned] [usertype] tid
   include/trace/events/ib_mad.h:43:1:    got restricted __be64 [usertype] tid
>> include/trace/events/ib_mad.h:43:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:43:1:    expected unsigned short [unsigned] [usertype] attr_id
   include/trace/events/ib_mad.h:43:1:    got restricted __be16 [usertype] attr_id
>> include/trace/events/ib_mad.h:43:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:43:1:    expected unsigned int [unsigned] [usertype] attr_mod
   include/trace/events/ib_mad.h:43:1:    got restricted __be32 [usertype] attr_mod
>> include/trace/events/ib_mad.h:131:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:131:1:    expected unsigned long long [unsigned] [usertype] atid
   include/trace/events/ib_mad.h:131:1:    got restricted __be64 [usertype] tid
   include/trace/events/ib_mad.h:131:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:131:1:    expected unsigned short [unsigned] [usertype] status
   include/trace/events/ib_mad.h:131:1:    got restricted __be16 [usertype] status
>> include/trace/events/ib_mad.h:43:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:43:1:    expected unsigned short [unsigned] [usertype] status
   include/trace/events/ib_mad.h:43:1:    got restricted __be16 [usertype] status
>> include/trace/events/ib_mad.h:43:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:43:1:    expected unsigned short [unsigned] [usertype] class_specific
   include/trace/events/ib_mad.h:43:1:    got restricted __be16 [usertype] class_specific
>> include/trace/events/ib_mad.h:43:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:43:1:    expected unsigned long long [unsigned] [usertype] tid
   include/trace/events/ib_mad.h:43:1:    got restricted __be64 [usertype] tid
>> include/trace/events/ib_mad.h:43:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:43:1:    expected unsigned short [unsigned] [usertype] attr_id
   include/trace/events/ib_mad.h:43:1:    got restricted __be16 [usertype] attr_id
>> include/trace/events/ib_mad.h:43:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:43:1:    expected unsigned int [unsigned] [usertype] attr_mod
   include/trace/events/ib_mad.h:43:1:    got restricted __be32 [usertype] attr_mod
>> include/trace/events/ib_mad.h:131:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:131:1:    expected unsigned long long [unsigned] [usertype] atid
   include/trace/events/ib_mad.h:131:1:    got restricted __be64 [usertype] tid
   include/trace/events/ib_mad.h:131:1: sparse: incorrect type in assignment (different base types)
   include/trace/events/ib_mad.h:131:1:    expected unsigned short [unsigned] [usertype] status
   include/trace/events/ib_mad.h:131:1:    got restricted __be16 [usertype] status

vim +43 include/trace/events/ib_mad.h

    37	#if !defined(_TRACE_IB_MAD_H) || defined(TRACE_HEADER_MULTI_READ)
    38	#define _TRACE_IB_MAD_H
    39	
    40	#include <linux/tracepoint.h>
    41	#include <rdma/ib_mad.h>
    42	
  > 43	DECLARE_EVENT_CLASS(ib_mad_send_template,
    44		TP_PROTO(struct ib_mad_send_wr_private *wr, struct ib_mad_addr *addr),
    45		TP_ARGS(wr, addr),
    46	
    47		TP_STRUCT__entry(
    48			__array(char,           dev_name, IB_DEVICE_NAME_MAX )
    49			__field(u8,             port_num                     )
    50			__field(u32,            qp_num                       )
    51			__field(void *,         agent_priv                   )
    52			__field(u64,            atid                         )
    53			__field(int,            retries_left                 )
    54			__field(int,            max_retries                  )
    55			__field(int,            retry                        )
    56			__field(unsigned long,  timeout                      )
    57			__field(u32,            length                       )
    58			__field(u8,             base_version                 )
    59			__field(u8,             mgmt_class                   )
    60			__field(u8,             class_version                )
    61			__field(u8,             method                       )
    62			__field(u16,            status                       )
    63			__field(u16,            class_specific               )
    64			__field(u64,            tid                          )
    65			__field(u16,            attr_id                      )
    66			__field(u32,            attr_mod                     )
    67			__field(u16,            dlid                         )
    68			__field(u8,             sl                           )
    69			__field(u16,            pkey                         )
    70			__field(u32,            rqpn                         )
    71			__field(u32,            rqkey                        )
    72		),
    73	
    74		TP_fast_assign(
    75			memcpy(__entry->dev_name, wr->mad_agent_priv->agent.device->name, IB_DEVICE_NAME_MAX);
    76			__entry->port_num = wr->mad_agent_priv->agent.port_num;
    77			__entry->qp_num = wr->mad_agent_priv->qp_info->qp->qp_num;
    78			__entry->agent_priv = wr->mad_agent_priv;
    79			__entry->atid = be64_to_cpu(wr->tid);
    80			__entry->max_retries = wr->max_retries;
    81			__entry->retries_left = wr->retries_left;
    82			__entry->retry = wr->retry;
    83			__entry->timeout = wr->timeout;
    84			__entry->length = wr->send_buf.hdr_len +
    85					  wr->send_buf.data_len;
    86			__entry->base_version = ((struct ib_mad_hdr *)wr->send_buf.mad)->base_version;
    87			__entry->mgmt_class = ((struct ib_mad_hdr *)wr->send_buf.mad)->mgmt_class;
    88			__entry->class_version = ((struct ib_mad_hdr *)wr->send_buf.mad)->class_version;
    89			__entry->method = ((struct ib_mad_hdr *)wr->send_buf.mad)->method;
    90			__entry->status = ((struct ib_mad_hdr *)wr->send_buf.mad)->status;
    91			__entry->class_specific = ((struct ib_mad_hdr *)wr->send_buf.mad)->class_specific;
    92			__entry->tid = ((struct ib_mad_hdr *)wr->send_buf.mad)->tid;
    93			__entry->attr_id = ((struct ib_mad_hdr *)wr->send_buf.mad)->attr_id;
    94			__entry->attr_mod = ((struct ib_mad_hdr *)wr->send_buf.mad)->attr_mod;
    95			__entry->dlid = addr->dlid;
    96			__entry->sl = addr->sl;
    97			__entry->pkey = addr->pkey;
    98			__entry->rqpn = addr->rqpn;
    99			__entry->rqkey = addr->rqkey;
   100		),
   101	
   102		TP_printk("%s:%d QP%d agent %p: " \
   103			  "atid 0x%llx; %d/%d retries(%d); timeout %lu length %d : " \
   104			  "base_ver 0x%x class 0x%x class_ver 0x%x method 0x%x " \
   105			  "status 0x%x class_specific 0x%x tid 0x%llx attr_id 0x%x attr_mod 0x%x " \
   106			  " => dlid 0x%x sl %d pkey 0x%x rpqn 0x%x rqpkey 0x%x",
   107			__entry->dev_name, __entry->port_num, __entry->qp_num,
   108			__entry->agent_priv, __entry->atid,
   109			__entry->retries_left, __entry->max_retries,
   110			__entry->retry, __entry->timeout, __entry->length,
   111			__entry->base_version, __entry->mgmt_class, __entry->class_version,
   112			__entry->method, be16_to_cpu(__entry->status),
   113			be16_to_cpu(__entry->class_specific),
   114			be64_to_cpu(__entry->tid), be16_to_cpu(__entry->attr_id),
   115			be32_to_cpu(__entry->attr_mod),
   116			be16_to_cpu(__entry->dlid), __entry->sl, __entry->pkey, __entry->rqpn,
   117			__entry->rqkey
   118		)
   119	);
   120	
   121	DEFINE_EVENT(ib_mad_send_template, ib_mad_mad_error_handler,
   122		TP_PROTO(struct ib_mad_send_wr_private *wr, struct ib_mad_addr *addr),
   123		TP_ARGS(wr, addr));
   124	DEFINE_EVENT(ib_mad_send_template, ib_mad_ib_send_mad,
   125		TP_PROTO(struct ib_mad_send_wr_private *wr, struct ib_mad_addr *addr),
   126		TP_ARGS(wr, addr));
   127	DEFINE_EVENT(ib_mad_send_template, ib_mad_send_done_resend,
   128		TP_PROTO(struct ib_mad_send_wr_private *wr, struct ib_mad_addr *addr),
   129		TP_ARGS(wr, addr));
   130	
 > 131	TRACE_EVENT(ib_mad_send_done_handler,
   132		TP_PROTO(struct ib_mad_send_wr_private *wr, struct ib_wc *wc),
   133		TP_ARGS(wr, wc),
   134	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
