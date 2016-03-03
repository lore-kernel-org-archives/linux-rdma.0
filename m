From: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] rds-tools user space part of change for rds-stress -D
 option failure
Date: Wed, 2 Mar 2016 16:15:00 -0800
Message-ID: <56D78204.2040008@oracle.com>
References: <1456796846-8596-1-git-send-email-zdai@linux.vnet.ibm.com>
 <1456796846-8596-2-git-send-email-zdai@linux.vnet.ibm.com>
 <56D5E764.3050006@oracle.com>
 <1456963464.4878.6.camel@dhcp-9-53-106-245.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456963464.4878.6.camel-zveeff//G6j74LnEdpXOr9eZKA5ZF4aE9RDcMeEix6s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dai <zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/2/2016 4:04 PM, David Dai wrote:
> Hi, Santosh:
>     Pardon me, just check the mail box today.
>     I used rds-tools-2.0.6-3.el6.src.rpm from RHEL 6,7 GA'ed source rpm.
>
No worries. That rpm seems to have stale sources. I will try to get the
external git tree updated in near future.

For now, you can fetch the source RPM from below location. They
should work for you with upstream kernels.

http://public-yum.oracle.com/repo/OracleLinux/OL6/ofed_UEK/x86_64//getPackageSource/rds-tools-2.0.7-1.12.el6.src.rpm

Regards,
Santosh

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
