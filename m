From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 09/13] ib/core: Enforce PKey security when
 modifying QPs
Date: Thu, 7 Apr 2016 17:44:33 +0000
Message-ID: <DB5PR05MB11110D54B1903809091D5FBEC4900@DB5PR05MB1111.eurprd05.prod.outlook.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-10-git-send-email-danielj@mellanox.com>
 <20160407163100.GA5808@leon.nu>
 <DB5PR05MB111169883324ADC42E52C4D6C4900@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <20160407173953.GB5808@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/7/2016 12:40 PM, leon-2ukJVAZIZ/Y@public.gmane.org wrote:
> On Thu, Apr 07, 2016 at 05:03:50PM +0000, Daniel Jurgens wrote:
>> On 4/7/2016 11:31 AM, Leon Romanovsky wrote:
>>> On Thu, Apr 07, 2016 at 02:33:54AM +0300, Dan Jurgens wrote:
>>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> +		kfree(qp->qp_sec);
>>>> +
>>>> +	return err;
>>>> +}
>>>> +EXPORT_SYMBOL(ib_security_create_qp_security);
>>>> +
>>>> +void ib_security_destroy_qp(struct ib_qp_security *sec)
>>>> +{
>>>> +	security_ib_qp_free_security(sec);
>>>> +	kfree(sec);
>>>> +}
>>>
>>> Did you want to EXPORT_SYMBOL here too?
>>>
>>
>> It's not called from outside ib_core, I only exported the functions that
>> are. ib_security_modify_qp and ib_security_create_qp security are called
>> from ib_core and ib_uverbs.  ib_security_enforce_mad_agent_pkey_access
>> is called from ib_mad.
> 
> So, how are you releasing the memory which is taken by
> ib_security_create_qp_security ?

It is freed in ib_security_destroy_qp, which is called by ib_destroy_qp
after the QP is destroyed successfully.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
