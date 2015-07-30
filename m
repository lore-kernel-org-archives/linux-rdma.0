From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Demux IB CM requests in the rdma_cm module
Date: Thu, 30 Jul 2015 12:03:04 +0300
Message-ID: <55B9E848.6040907@mellanox.com>
References: <1438167991-17211-1-git-send-email-haggaie@mellanox.com>
 <55B8E7F6.2030603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B8E7F6.2030603-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 29/07/2015 17:49, Doug Ledford wrote:
> This doesn't apply on to a clean 4.2-rc4 kernel tree.  Can you please
> rebase against either that or my to-be-rebase/for-4.3 branch of my
> github repo?

Sure. Keep in mind that this patchset also depends on the patch from
Matan's series to protected the device and client list with a rwsem [2].
Do you want me to add it to this series?

Haggai

>> [2] [PATCH for-next V5 02/12] IB/core: Add rwsem to allow reading device list or client list
>>     http://www.spinics.net/lists/linux-rdma/msg25931.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
