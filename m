From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/core: Fix use workqueue without
 WQ_MEM_RECLAIM
Date: Wed, 18 Oct 2017 12:58:20 +0300
Message-ID: <3c717580-d1fe-943d-8df2-5d4858244e9b@grimberg.me>
References: <20171016054517.30643-1-leon@kernel.org>
 <20171016054517.30643-5-leon@kernel.org>
 <4f08314e-fd5d-c108-438a-d9e83821e4b3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4f08314e-fd5d-c108-438a-d9e83821e4b3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> This looks like a -stable patch candidate. Once accepted this should
> probably be queued for v4.9+.

AFAICT, this was broken forever because single threaded workqueues are
set with MEM_RECLAIM. If anything the Fixes tag is incorrect.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
