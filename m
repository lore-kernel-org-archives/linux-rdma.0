From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] SELinux support for Infiniband RDMA
Date: Tue, 5 Apr 2016 14:04:40 +0000
Message-ID: <DB5PR05MB111189C7DA2031DA58CA33AAC49E0@DB5PR05MB1111.eurprd05.prod.outlook.com>
References: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
 <alpine.LRH.2.20.1604051110390.9906@namei.org>
 <DB5PR05MB111126C8AB59CDA4674A068BC49E0@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <alpine.LRH.2.20.1604051154500.16241@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/4/2016 8:55 PM, James Morris wrote:
> On Tue, 5 Apr 2016, Daniel Jurgens wrote:
> 
>> On 4/4/2016 8:13 PM, James Morris wrote:
>>> On Tue, 5 Apr 2016, Dan Jurgens wrote:
>>>
>>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> Currently there is no way to provide granular access control to an Infiniband
>>>> fabric.  By providing an ability to restrict user access to specific virtual
>>>> subfabrics administrators can limit access to bandwidth and isolate users on
>>>> the fabric.
>>>
>>> Where are the LSM hooks placed?
>>>
>>>
>>>
>> The LSM hooks are defined in patch 1/7 of this series.  There are 4 that
>> will be called from ib_core, and one that's implemented by ib_core to be
>> called by a security module if the policy or enforcement setting change
>> (infiniband_flush).  That call from SELinux is added in patch 3/7 of
>> this series.
> 
> Can you post the ib_core patches, too?
> 
> 
Yes, I'll post them soon.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
