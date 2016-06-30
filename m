From: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Subject: Re: [PATCH 04/12] selinux: Allocate and free infiniband security
 hooks
Date: Thu, 30 Jun 2016 14:06:24 -0700
Message-ID: <6662b3b0-6897-8775-dc30-2757387428e4@schaufler-ca.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-5-git-send-email-danielj@mellanox.com>
 <CAGH-KgvtN8T7e5bKq0jJZvSzrGfFwA2VpmPf5gJuqdLZi6odEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGH-KgvtN8T7e5bKq0jJZvSzrGfFwA2VpmPf5gJuqdLZi6odEw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/30/2016 1:42 PM, Paul Moore wrote:
> On Thu, Jun 23, 2016 at 3:52 PM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Implement and attach hooks to allocate and free Infiniband QP and MAD
>> agent security structures.
>>
>> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  include/rdma/ib_mad.h             |  1 +
>>  include/rdma/ib_verbs.h           |  1 +
>>  security/selinux/hooks.c          | 53 +++++++++++++++++++++++++++++++++++++++
>>  security/selinux/include/objsec.h |  5 ++++
>>  4 files changed, 60 insertions(+)
>>
>> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
>> index c8a773f..a1ed025 100644
>> --- a/include/rdma/ib_mad.h
>> +++ b/include/rdma/ib_mad.h
>> @@ -537,6 +537,7 @@ struct ib_mad_agent {
>>         u32                     flags;
>>         u8                      port_num;
>>         u8                      rmpp_version;
>> +       void                    *m_security;
> General convention is to just call the LSM blobs "security" unless
> there is already a field with that name.

Not that it really matters all that much, but an unadorned "security"
makes it unnecessarily difficult to match "p->security" to the data
involved when you're looking at keys, creds and ipc. I like having
the prefix. I think the other fields in the structure should have it,
too, but as I'm not an acknowledged authority on good style I hesitate
to suggest it in general.

>
>>  };
>>
>>  /**
>> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> index 3f6780b..e522acb 100644
>> --- a/include/rdma/ib_verbs.h
>> +++ b/include/rdma/ib_verbs.h
>> @@ -1454,6 +1454,7 @@ struct ib_qp {
>>         void                   *qp_context;
>>         u32                     qp_num;
>>         enum ib_qp_type         qp_type;
>> +       struct ib_qp_security  *qp_sec;
> See my earlier question/comment about just using a void pointer here.

I think that this is in response to my comments to the
effect that I would like to see the LSM infrastructure
using the inode like (inode->i_security) to the xfrm
(void *) approach. I haven't been looking at the IB patches
too carefully to date. It's possible I have not been clear.

>
>>  };
>>
>>  struct ib_mr {
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index 6a8841d..4f13ea4 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -17,6 +17,7 @@
>>   *     Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
>>   *  Copyright (C) 2007 Hitachi Software Engineering Co., Ltd.
>>   *                    Yuichi Nakamura <ynakam-FkO1umbPgv4fag7Bw7Dlfw@public.gmane.org>
>> + *  Copyright (C) 2016 Mellanox Technologies
>>   *
>>   *     This program is free software; you can redistribute it and/or modify
>>   *     it under the terms of the GNU General Public License version 2,
>> @@ -83,6 +84,8 @@
>>  #include <linux/export.h>
>>  #include <linux/msg.h>
>>  #include <linux/shm.h>
>> +#include <rdma/ib_verbs.h>
>> +#include <rdma/ib_mad.h>
>>
>>  #include "avc.h"
>>  #include "objsec.h"
>> @@ -6015,6 +6018,47 @@ static void selinux_unregister_ib_flush_callback(void)
>>         mutex_unlock(&ib_flush_mutex);
>>  }
>>
>> +static int selinux_ib_qp_alloc_security(struct ib_qp_security *qp_sec)
>> +{
>> +       struct ib_security_struct *sec;
>> +
>> +       sec = kzalloc(sizeof(*sec), GFP_ATOMIC);
>> +       if (!sec)
>> +               return -ENOMEM;
>> +       sec->sid = current_sid();
>> +
>> +       qp_sec->q_security = sec;
>> +       return 0;
>> +}
> If you get rid of the ip_qp_security struct, you can just return the
> blob instead of an int (NULL on error).  Same with the MAD allocator
> below.
>
> Also, and this may be more important for the MAD allocator below (I'm
> still pretty IB-ignorant), can you forsee the need/desire to have the
> QP/MAD label different from the process which creates them?  How often
> will other SELinux domains need to interact with these objects?
>
>> +static void selinux_ib_qp_free_security(struct ib_qp_security *qp_sec)
>> +{
>> +       struct ib_security_struct *sec = qp_sec->q_security;
>> +
>> +       qp_sec->q_security = NULL;
>> +       kfree(sec);
>> +}
>> +
>> +static int selinux_ib_mad_agent_alloc_security(struct ib_mad_agent *mad_agent)
>> +{
>> +       struct ib_security_struct *sec;
>> +
>> +       sec = kzalloc(sizeof(*sec), GFP_ATOMIC);
>> +       if (!sec)
>> +               return -ENOMEM;
>> +       sec->sid = current_sid();
>> +
>> +       mad_agent->m_security = sec;
>> +       return 0;
>> +}
>> +
>> +static void selinux_ib_mad_agent_free_security(struct ib_mad_agent *mad_agent)
>> +{
>> +       struct ib_security_struct *sec = mad_agent->m_security;
>> +
>> +       mad_agent->m_security = NULL;
>> +       kfree(sec);
>> +}
>>  #endif

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
