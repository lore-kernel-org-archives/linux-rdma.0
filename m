From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCH v2 00/11] Add network namespace support in the RDMA-CM
Date: Tue, 21 Apr 2015 09:36:25 +0300
Message-ID: <5535EFE9.3000106@mellanox.com>
References: <1429520622-10303-1-git-send-email-haggaie@mellanox.com>
 <553512FA.1040708@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <553512FA.1040708@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, Doug Ledford <dledford@redhat.com>, Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Liran Liss <liranl@mellanox.com>, Guy Shapiro <guysh@mellanox.com>, Shachar Raindel <raindel@mellanox.com>, Yotam Kenneth <yotamke@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 20/04/2015 17:53, Steve Wise wrote:
> 
> Hey Haggai,
> 
> Did you check for changes needed in drivers/infiniband/core/iwcm.c? 

We focused on namespace support for InfiniBand alone in this series. We
didn't handle iWARP, nor did we implement support for RoCE or other
transports.

> I notice that it uses init_net here:
> 
> static int __init iw_cm_init(void)
> {
>         iwcm_wq = create_singlethread_workqueue("iw_cm_wq");
>         if (!iwcm_wq)
>                 return -ENOMEM;
> 
>         iwcm_ctl_table_hdr = register_net_sysctl(&init_net, "net/iw_cm",
>                                                  iwcm_ctl_table);
>         if (!iwcm_ctl_table_hdr) {
>                 pr_err("iw_cm: couldn't register sysctl paths\n");
>                 destroy_workqueue(iwcm_wq);
>                 return -ENOMEM;
>         }
> 
>         return 0;
> }
> 

I see the only thing in the iWARP sysctl registered here is the default
backlog. If you want to control this parameter per namespace, we could
store it per network namespace, and add a namespace parameter to
iw_cm_listen. I'm not sure how important this is though.

Haggai
