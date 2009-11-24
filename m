From: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
Subject: Re: QOS setup issue with opensm
Date: Tue, 24 Nov 2009 11:38:23 +0100
Message-ID: <4B0BB79F.9080806@bull.net>
References: <4B0BA0EC.3050202@bull.net> <4B0BAF21.1020401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B0BAF21.1020401-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Yevgeny,

> Vincent Ficet wrote:
>> Hello,
>>
>> I'm running into trouble when trying to configure QoS on opensm 3.3.2. I
>> tried several QoS setups, but unfortunately without any luck.
>> Could someone please tell me what I'm doing wrong ?
>>
>> The different combinations I tried are listed below:
>>
>> ###############################################################
>>
>> qos-policy.conf:
>>
>> qos-ulps
>>     default          : 0 # default SL
>>     ipoib            : 4 # TCP tests over IB
>> end-qos-ulps
>>
>> Nov 24 09:26:01 065823 [96B5D910] 0x01 -> __qos_policy_validate_pkey:
>> ERR AC15: pkey 0x7FFF in match rule - overriding partition SL (0) with
>> QoS Level SL (4)
>>
>> ###############################################################
>>
>> qos-policy.conf:
>>
>> qos-ulps
>>     default               : 0 # default SL
>>     ipoib, pkey 0x0001    : 4 # TCP tests over IB
>> end-qos-ulps
>>
>> partitions.conf:
>>
>> default=0x7fff,ipoib                    : ALL=full;
>> backbone=0x0001,ipoib,defmember=full    : 0x2c9000100d000679,
>> 0x2c9000100d00056d;
>>
>> Nov 24 09:21:43 526886 [C85A1910] 0x01 -> __qos_policy_validate_pkey:
>> ERR AC15: pkey 0x0001 in match rule - overriding partition SL (0) with
>> QoS Level SL (4)
>>
>> ###############################################################
>>
>> qos-policy.conf
>>
>> qos-ulps
>>     default          : 0 # default SL
>>     ipoib            : 4 # TCP tests over IB
>> end-qos-ulps
>>
>> partitions.conf:
>>
>> default=0x7fff                          : ALL=full;
>> backbone=0x0001,ipoib,defmember=full    : 0x2c9000100d000679,
>> 0x2c9000100d00056d;
>>
>> Nov 24 09:46:36 576946 [640C7910] 0x01 -> __qos_policy_validate_pkey:
>> ERR AC15: pkey 0x7FFF in match rule - overriding partition SL (0) with
>> QoS Level SL (4)
>>
>> ###############################################################
>>
>> qos-policy.conf
>>
>> qos-ulps
>>     default          : 0 # default SL
>>     ipoib            : 4 # TCP tests over IB
>> end-qos-ulps
>>
>> default=0x7fff                        : ALL=full;
>> backbone=0x0001,defmember=full        : 0x2c9000100d000679,
>> 0x2c9000100d00056d;
>>
>> Nov 24 09:51:23 666860 [6EA6B910] 0x01 -> __qos_policy_validate_pkey:
>> ERR AC15: pkey 0x7FFF in match rule - overriding partition SL (0) with
>> QoS Level SL (4)
>>
>> ###############################################################
>>
>> Did I make a mistake, or does that sound like an opensm bug ?
>
> It's neither. It's an outcome of OSM being not very user
> friendly in QoS configuration :(
>
> You're trying to assign a certain SL to IPoIB, so you
> define a partition with a certain pkey, and add a rule
> for this pkey in the QoS policy file. So far everything
> is OK.
> The problem is that SL is part of partition's parameters,
> so when you defined the partition as follows:
>
>  default=0x7fff,ipoib       : ALL=full;
>
> you didn't specify SL, and SM used default SL for this
> partition. In short, it is as if you defined the partition
> as follows:
>
>  default=0x7fff,ipoib,sl=0  : ALL=full;
>
> Now comes the QoS policy rule that says the following:
>
>  ipoib            : 4 # TCP tests over IB
>
> So you have a mismatch between SLs from partition
> configuration and QoS policy. SM is aware if this
> and uses SL from QoS policy to overwrite the one
> that is stored in the partition structure.
>
> So bottom line - your configuration is correct.
Just to make sure I understand correctly. What you are saying is that
the following configuration (among the 4 alternatives I listed above) is
correct, although opensm reports an error ?

partitions.conf:

default=0x7fff,ipoib            : ALL=full;
backbone=0x0001,ipoib,defmember=full    : 0x2c9000100d000679,
0x2c9000100d00056d;

qos-ulps
        default            : 0 # default SL
    ipoib            : 4 # TCP tests over IB
end-qos-ulps

Thanks for your help,

Vincent

>
> -- Yevgeny
>
>
>> Thanks for your help,
>>
>> Vincent
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
