From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v2 11/13] ib/core: Enforce Infiniband device SMI
 security
Date: Thu, 7 Apr 2016 21:55:48 +0000
Message-ID: <DB5PR05MB11113536C2E232E4F44B128BC4900@DB5PR05MB1111.eurprd05.prod.outlook.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-12-git-send-email-danielj@mellanox.com>
 <20160407204456.GB12844@leon.nu>
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

On 4/7/2016 3:54 PM, Leon Romanovsky wrote:
> On Thu, Apr 07, 2016 at 02:33:56AM +0300, Dan Jurgens wrote:
>> +			dev_err(&device->dev,
>> +				"%s: Access Denied. Err: %d\n",
> 
> Please convert it to lower case.
> Can malicious user flood the system with this print?
>

>> +			dev_err(&device->dev,
>> +				"%s: Access Denied. Err: %d\n",
> 
> The same as above.
> 

I will just remove the prints unless you object.  The denial will be
captured in the audit log.

_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
