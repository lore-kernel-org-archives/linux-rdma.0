From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 05/14] IB/srp: Maintain a single connection per I_T nexus
Date: Thu, 13 Jun 2013 20:25:19 +0200
Message-ID: <51BA0E8F.3030104@acm.org>
References: <51B87501.4070005@acm.org> <51B876BF.4070400@acm.org> <51BA0655.6090707@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51BA0655.6090707-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/13/13 19:50, Vu Pham wrote:
> Hello Bart,
>
>> +/**
>> + * srp_conn_unique() - check whether the connection to a target is
>> unique
>> + */
>> +static bool srp_conn_unique(struct srp_host *host,
>> +                struct srp_target_port *target)
>> +{
>> +    struct srp_target_port *t;
>> +    bool ret = false;
>> +
>> +    if (target->state == SRP_TARGET_REMOVED)
>> +        goto out;
>> +
>> +    ret = true;
>> +
>> +    spin_lock(&host->target_lock);
>> +    list_for_each_entry(t, &host->target_list, list) {
>> +        if (t != target &&
>> +            target->id_ext == t->id_ext &&
>
> Targets may advertise/expose on different pkeys
> You can have multiple connections  (or paths/scsi hosts) to same target
> with different pkeys.
> We need extra check to detect the uniqueness:
>                                              target->path.pkey ==
> t->path.pkey &&

Hello Vu,

Thanks for the feedback. This is something I have already thinking about 
myself. Unfortunately I have not found any requirements in the T10 SRP 
standard with regard to InfiniBand partitions. However, in that document 
there is a section about single RDMA channel operation. In that section 
it is explained that an SRP target must log out established sessions 
upon receipt of a new login request. What I'm not sure about is whether 
only sessions with the same P_Key must be logged out or all established 
sessions if a new login request is received. I assume the latter since 
otherwise that would mean that an SRP target would be required to 
maintain multiple sessions if it allows connections with more than one 
P_Key to a target port ? My concern about adding a pkey comparison in 
the function srp_conn_unique() is that if a target allows an initiator 
to choose which partition to use when logging in, that this could result 
in the undesired SRP initiator ping-pong effect this patch tries to avoid.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
