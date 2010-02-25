From: Roman Kononov <roman-63PA5aZBFHTyn80wtf4cgA@public.gmane.org>
Subject: Re: Oops in iscsi_conn_failure()
Date: Thu, 25 Feb 2010 06:48:17 -0600
Message-ID: <4B867191.7000607@binarylife.net>
References: <hm15jb$or7$1@dough.gmane.org> <hm1b44$fa4$1@dough.gmane.org> <4B862F6A.5020800@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B862F6A.5020800-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2010-02-25 02:06 Or Gerlitz said the following:
> Can you elaborate what does it take to reproduce that? 

I am not sure. I am writing custom scripts for a Linux cluster of iSCSI 
targets and initiators. I start and kill (including SIGKILL) iscsid, 
start and kill (including SIGKILL), add and remove targets using tgtadm, 
login and logout using iscsi_adm in some [random] order. Everything is 
done from the user space.

Thanks.

Roman
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
