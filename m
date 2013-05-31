From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] Add trap details to notice log message
Date: Fri, 31 May 2013 10:23:00 +0200
Message-ID: <51A85DE4.2000506@oracle.com>
References: <a889a33d-2f26-4432-b912-3d531a60e019@default> <1828884A29C6694DAF28B7E6B8A823736FD2C024@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD2C024-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/30/13 20:24, Hefty, Sean wrote:
>> diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
>> index d5cf287..5c238ae 100644
>> --- a/include/iba/ib_types.h
>> +++ b/include/iba/ib_types.h
>> @@ -3,6 +3,7 @@
>>    * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
>>    * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>>    * Copyright (c) 2009 HNR Consulting. All rights reserved.
>> + * Copyright (c) 2013 Oracle and/or its affiliates. All rights reserved.
>>    *
>>    * This software is available to you under a choice of one of two
>>    * licenses.  You may choose to be licensed under the terms of the GNU
>> @@ -7619,6 +7620,23 @@ ib_member_set_join_state(IN OUT ib_member_rec_t *
>> p_mc_rec,
>>   #define IB_NOTICE_TYPE_INFO				0x04
>>   #define IB_NOTICE_TYPE_EMPTY				0x7F
>>
>> +#define SM_GID_IN_SERVICE_TRAP				64
>> +#define SM_GID_OUT_OF_SERVICE_TRAP			65
>> +#define SM_MGID_CREATED_TRAP				66
>> +#define SM_MGID_DESTROYED_TRAP				67
>> +#define SM_UNPATH_TRAP					68
>> +#define SM_REPATH_TRAP					69
>> +#define SM_LINK_STATE_CHANGED_TRAP			128
>> +#define SM_LINK_INTEGRITY_THRESHOLD_TRAP		129
>> +#define SM_BUFFER_OVERRUN_THRESHOLD_TRAP		130
>> +#define SM_WATCHDOG_TIMER_EXPIRED_TRAP			131
>> +#define SM_LOCAL_CHANGES_TRAP				144
>> +#define SM_SYS_IMG_GUID_CHANGED_TRAP			145
>> +#define SM_BAD_MKEY_TRAP				256
>> +#define SM_BAD_PKEY_TRAP				257
>> +#define SM_BAD_QKEY_TRAP				258
>> +#define SM_BAD_SWITCH_PKEY_TRAP				259
> These definitions could go into libubmad/include/infiniband/umad_sm.h.
Are you suggesting to do this in addition to ib_types.h or instead of ?
umad_sm.h seems to hold only a small subset of what's found in ib_types.h.

Line

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
