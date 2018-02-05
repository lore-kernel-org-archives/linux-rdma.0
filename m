From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] mlx5: fix mlx5_get_vector_affinity to start from
 completion vector 0
Date: Mon, 5 Feb 2018 17:28:14 +0200
Message-ID: <1aaa6382-f6db-29c1-0158-5662fdc0d0cf@grimberg.me>
References: <20180205142452.7630-1-sagi@grimberg.me>
 <64670132-9662-9bbe-9979-fd02260a7fb3@grimberg.me>
 <1517844212.3936.64.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517844212.3936.64.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> Sorry, now my .gitaliases updated with Jason's correct email.
> 
> Jason prefers jgg-uk2M96/98Pc@public.gmane.org for his upstream work, so might need to
> update again ;-)

Updated ;)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
