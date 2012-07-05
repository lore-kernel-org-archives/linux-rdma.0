From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ibnetdiscover: fix not showing FDR10 speeds
Date: Thu, 05 Jul 2012 15:01:54 -0400
Message-ID: <4FF5E4A2.4020506@dev.mellanox.co.il>
References: <4FF5C40D.7020209@dev.mellanox.co.il> <CAJZOPZJBFkyemvnK12-NxF7L+MkWnop79=6NZk=NonmztRKHNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJBFkyemvnK12-NxF7L+MkWnop79=6NZk=NonmztRKHNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/5/2012 2:40 PM, Or Gerlitz wrote:
>> ibnetdiscover shows FDR10 speeds as QDR due to bug in setting
>> default parameters
> 
> How old is this bug?

Since commit d8648e9d603e469d0fbd90d18b4c99e725d05812 which provided
option to disable FDR10 MADs (in case of kernel issue which was
subsequently fixed).

-- Hal

> 
> Or.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
