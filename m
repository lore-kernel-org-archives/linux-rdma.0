From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 09/13] ib/core: Enforce PKey security when
 modifying QPs
Date: Thu, 7 Apr 2016 17:03:50 +0000
Message-ID: <DB5PR05MB111169883324ADC42E52C4D6C4900@DB5PR05MB1111.eurprd05.prod.outlook.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-10-git-send-email-danielj@mellanox.com>
 <20160407163100.GA5808@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Content-Language: en-US
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/7/2016 11:31 AM, Leon Romanovsky wrote:
> On Thu, Apr 07, 2016 at 02:33:54AM +0300, Dan Jurgens wrote:
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>  drivers/infiniband/core/core_priv.h     |   41 ++++
>>  drivers/infiniband/core/core_security.c |  331 +++++++++++++++++++++++++++++++
> 
> We are already in core, there is no need to call files core_XXX.

I can change core_security.c to security.c.  core_priv.h already existed
so I won't change that in this patch.

>> +int ib_security_create_qp_security(struct ib_qp *qp);
> 
> Why do we need xx_SECURITY_xxxxx_SECURITY in name?

I had called it ib_security_create_qp. Eli thought that implied more
work that it actually does.  All the none static functions are named
ib_security_xxx, which I kind of liked as a convention, but I can
abandon that and go with ib_create_qp_security.

>> +	return check_pkey && (qp->qp_num != IB_QPT_SMI &&
>> +			      qp->qp_num != IB_QPT_GSI);
> 
> IB_QPT_SMI and IB_QPT_GSI are declared as struct ib_qp_type and setted
> in qp->qp_type and not in qp->qp_num.
>> +}
>> +
>> +static int check_alt_pkey(const struct ib_qp *qp,
>> +			  const struct ib_qp_attr *qp_attr,
>> +			  int qp_attr_mask)
>> +{
>> +	bool check_alt_pkey = !!(qp_attr_mask & IB_QP_ALT_PATH);
>> +
>> +	return check_alt_pkey && (qp->qp_num != IB_QPT_SMI &&
>> +				  qp->qp_num != IB_QPT_GSI);
>> +}
> 
> The same as above.

I'll fix this.

>> +		kfree(qp->qp_sec);
>> +
>> +	return err;
>> +}
>> +EXPORT_SYMBOL(ib_security_create_qp_security);
>> +
>> +void ib_security_destroy_qp(struct ib_qp_security *sec)
>> +{
>> +	security_ib_qp_free_security(sec);
>> +	kfree(sec);
>> +}
> 
> Did you want to EXPORT_SYMBOL here too?
> 

It's not called from outside ib_core, I only exported the functions that
are. ib_security_modify_qp and ib_security_create_qp security are called
from ib_core and ib_uverbs.  ib_security_enforce_mad_agent_pkey_access
is called from ib_mad.



_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
