From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/core: Expose a device attribute for rdma_read
 access flags
Date: Tue, 10 Nov 2015 14:28:01 +0200
Message-ID: <5641E2D1.8070209@dev.mellanox.co.il>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-2-git-send-email-sagig@mellanox.com>
 <1447156270.7089.3.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447156270.7089.3.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Yann,

>
> Why were those hw providers not modified to
> enforce IB_ACCESS_REMOTE_WRITE when needed, instead of asking users to
> set it for them ?

Do you mean that ULPs will set IB_ACCESS_LOCAL_WRITE and
iWARP providers executing the memory registration will add
IB_ACCESS_REMOTE_WRITE? That's even better I think! Given that
changing the access rights under the user legs is something we'd want
to do. is it?

Given that for IB memory registration is not even needed for rdma_read,
I'd like to move away from code like:

if (rdma_protocol_iwarp())
	register memory for rdma_read
else
	go ahead with ib_sge for rdma_read

I've maid some initial experimentation on trying to abstract this
aspect from ULPs but it's far from being complete and needs more work.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
