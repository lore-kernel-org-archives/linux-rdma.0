From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 04/13] selinux: Allocate and free infiniband
 security hooks
Date: Mon, 11 Apr 2016 20:41:59 +0000
Message-ID: <DB5PR05MB1111F40371D0B7558486F863C4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-5-git-send-email-danielj@mellanox.com>
 <570BC1C9.701@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/11/2016 10:25 AM, Casey Schaufler wrote:
> On 4/6/2016 4:33 PM, Dan Jurgens wrote:
>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>  include/rdma/ib_verbs.h           |    5 +++
> 
> The ib_qp_security structure is defined here, but
> referenced in 01/13. You should defined the structure
> before you use it.
> 

OK, the pointer wasn't accessed by field until this series, but I can
pull this back to 01/13 in the next version of the series.  Most likely
sometime tomorrow.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
