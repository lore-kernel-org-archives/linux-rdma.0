From: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>
Subject: QOS setup issue with opensm
Date: Tue, 24 Nov 2009 10:01:32 +0100
Message-ID: <4B0BA0EC.3050202@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I'm running into trouble when trying to configure QoS on opensm 3.3.2. I
tried several QoS setups, but unfortunately without any luck.
Could someone please tell me what I'm doing wrong ?

The different combinations I tried are listed below:

###############################################################

qos-policy.conf:

qos-ulps
    default          : 0 # default SL
    ipoib            : 4 # TCP tests over IB
end-qos-ulps

Nov 24 09:26:01 065823 [96B5D910] 0x01 -> __qos_policy_validate_pkey:
ERR AC15: pkey 0x7FFF in match rule - overriding partition SL (0) with
QoS Level SL (4)

###############################################################

qos-policy.conf:

qos-ulps
    default               : 0 # default SL
    ipoib, pkey 0x0001    : 4 # TCP tests over IB
end-qos-ulps

partitions.conf:

default=0x7fff,ipoib                    : ALL=full;
backbone=0x0001,ipoib,defmember=full    : 0x2c9000100d000679,
0x2c9000100d00056d;

Nov 24 09:21:43 526886 [C85A1910] 0x01 -> __qos_policy_validate_pkey:
ERR AC15: pkey 0x0001 in match rule - overriding partition SL (0) with
QoS Level SL (4)

###############################################################

qos-policy.conf

qos-ulps
    default          : 0 # default SL
    ipoib            : 4 # TCP tests over IB
end-qos-ulps

partitions.conf:

default=0x7fff                          : ALL=full;
backbone=0x0001,ipoib,defmember=full    : 0x2c9000100d000679,
0x2c9000100d00056d;

Nov 24 09:46:36 576946 [640C7910] 0x01 -> __qos_policy_validate_pkey:
ERR AC15: pkey 0x7FFF in match rule - overriding partition SL (0) with
QoS Level SL (4)

###############################################################

qos-policy.conf

qos-ulps
    default          : 0 # default SL
    ipoib            : 4 # TCP tests over IB
end-qos-ulps

default=0x7fff                        : ALL=full;
backbone=0x0001,defmember=full        : 0x2c9000100d000679,
0x2c9000100d00056d;

Nov 24 09:51:23 666860 [6EA6B910] 0x01 -> __qos_policy_validate_pkey:
ERR AC15: pkey 0x7FFF in match rule - overriding partition SL (0) with
QoS Level SL (4)

###############################################################

Did I make a mistake, or does that sound like an opensm bug ?

Thanks for your help,

Vincent


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
