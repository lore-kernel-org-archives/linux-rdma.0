From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 05/14] IB/srp: Maintain a single connection per I_T nexus
Date: Fri, 14 Jun 2013 10:07:07 -0700
Message-ID: <51BB4DBB.4070800@mellanox.com>
References: <51B87501.4070005@acm.org> <51B876BF.4070400@acm.org> <51BA0655.6090707@mellanox.com> <51BA0E8F.3030104@acm.org> <51BA555F.9060807@mellanox.com> <51BAE482.1050304@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51BAE482.1050304-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Sebastian,

> On 14.06.2013 01:27, Vu Pham wrote:
>   
>> Bart Van Assche wrote:
>>     
>>> On 06/13/13 19:50, Vu Pham wrote:
>>>       
>>>> Hello Bart,
>>>>
>>>>         
>>>>> +/** + * srp_conn_unique() - check whether the connection to
>>>>> a target is unique + */ +static bool srp_conn_unique(struct
>>>>> srp_host *host, +                struct srp_target_port
>>>>> *target) +{ +    struct srp_target_port *t; +    bool ret =
>>>>> false; + +    if (target->state == SRP_TARGET_REMOVED) +
>>>>> goto out; + +    ret = true; + +
>>>>> spin_lock(&host->target_lock); +    list_for_each_entry(t,
>>>>> &host->target_list, list) { +        if (t != target && +
>>>>> target->id_ext == t->id_ext &&
>>>>>           
>>>> Targets may advertise/expose on different pkeys You can have
>>>> multiple connections  (or paths/scsi hosts) to same target with
>>>> different pkeys. We need extra check to detect the uniqueness: 
>>>> target->path.pkey == t->path.pkey &&
>>>>         
>>> Hello Vu,
>>>
>>> Thanks for the feedback. This is something I have already
>>> thinking about myself. Unfortunately I have not found any
>>> requirements in the T10 SRP standard with regard to InfiniBand
>>> partitions. However, in that document there is a section about
>>> single RDMA channel operation. In that section it is explained
>>> that an SRP target must log out established sessions upon receipt
>>> of a new login request. What I'm not sure about is whether only
>>> sessions with the same P_Key must be logged out or all
>>> established sessions if a new login request is received. I assume
>>> the latter since otherwise that would mean that an SRP target 
>>> would be required to maintain multiple sessions if it allows 
>>> connections with more than one P_Key to a target port ? My
>>> concern about adding a pkey comparison in the function
>>> srp_conn_unique() is that if a target allows an initiator to
>>> choose which partition to use when logging in, that this could
>>> result in the undesired SRP initiator ping-pong effect this patch
>>> tries to avoid.
>>>
>>> Bart.
>>>
>>>       
>> Hello Bart,
>>
>> Yes, you pointed out the unclear/undefined area.
>>
>> If we stick to single RDMA channel per IT Nexus with unique tuple 
>> Initiator Port Identier - Target Port Indentifier then newly
>> created connection with same tuple (I_port_id, T_port_id) but with
>> different P_Key or different DGID is not unique.
>>
>> Sticking to this rule by excluding P_Key and DGID  out of rdma
>> channel indentity, your srp_conn_unique() checking is ok; however,
>> some SRP target implementations may include DGID as part of rdma
>> channel identifier. I'm not sure about different p_key part.
>>
>> -vu
>>     
>
> Hi Vu!
>
> For what do you need the same target with multiple pkeys on the same
> local SRP port?
>   
There is no need, it's just a gray area that you can choose to have 
multiple connections to same target using different pkeys (same as dgid)
> Which other SRP targets exist?
>   

Netapp/LSI/Engenio, DDN, TexasMemorySystem Ramsan (IBM), Nimbus, Violin 
Memory, StreamScale
The last three may be derived from SCST base target.

> I only know SCST, Solaris COMSTAR and that broken LIO stuff.
> Does SCST still not support to set the pkey?
>
>   
Yes, I think so

> Why should we check the dgid?
>
>   
If you want to have multiple connections/qps to same target, but as I 
said above, it's a gray area.

> Doesn't make any sense to me to connect both target ports to the same
> local port. 
What if a target always expose single consistent and unique SRP port 
with tuple <id_ext, ioc_guid>, the ioc_guid part is not derived from any 
of its local HCA's GUID, then you can connect to this target thru 
different HCA ports (different dgid) as different paths to same target.

-vu
> If you do so, the multipath-tools will crash. Note: This
> function is called per local SRP port. Perhaps, a note should be added
> to that function that it only has to be called per local SRP port.
>
> Cheers,
> Sebastian
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>
> iQEcBAEBAgAGBQJRuuSCAAoJEH4DRb7WXajZcFcH+gKsSs64Js/CUqMSyPeFPQ7u
> 7jKHvLr2wqHqSMIg5rEeZxZJpE9rL+wi8k5TMAMBrV+Povdwr8tWHgdq7mh5N1xO
> V517YTgdzrwPIFy9e2uktxx4VYpsFGrV8iw3rdAzXRmcYa5U8feXhiD1VZyKjs4p
> 3//wvGAR0po7Pm0WgU9Q+h0arQos8CmeHkpoaNp/nNINXpXlTX21WVvHjwQrMFhC
> Kr8zoCOTd0Sn+WoSs+CT/7Y4oTknukwR5vh6wfKgz2W74YkMKpD658QZozlafyK/
> rwdajV19YYvi8YRTjUXuY5TN0qshYOGDxJDtNFkRGbx+IxIqFkGyyFCp0LPCfto=
> =nlf2
> -----END PGP SIGNATURE-----
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
