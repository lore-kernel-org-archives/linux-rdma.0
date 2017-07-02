From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Allow ib_clients to nullify .add but still get
 .remove events reliably
Date: Sun, 2 Jul 2017 12:14:31 +0300
Message-ID: <8927ea7d-c6ba-4f32-4ede-0897e83bcda2@mellanox.com>
References: <1498983652-18250-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498983652-18250-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 7/2/2017 11:20 AM, Sagi Grimberg wrote:
> Some ULPs are just interested in device removal notification with no specific
> association because they work over RDMA_CM so no need for detecting appearance
> of the devices. That wasn't the because the corresponding ib_client_data
> was never added to the device clients list when the ib_client registers,
> Patch 1 fixes it. Patches 2-3 just removes the empty .add callout nvme(t)-rdma set.
>
> Changes from v1:
> - reword patch 1 change log title
> - collected review tags
>
> Note that this will create a conflict with jens's for-4.13 which we added
> ib_client registration to nvmet-rdma.
>
> Sagi Grimberg (3):
>   RDMA/core: make ib_device.add method optional
>   nvme-rdma: remove redundant empty device add callout
>   nvmet-rdma: remove redundant empty device add callout

All these patches looks fine to me,

Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
