From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 6/6] RDMA CM: Netlink Client
Date: Mon, 20 Dec 2010 09:24:06 +0200
Message-ID: <4D0F0496.9010502@Voltaire.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>	 <1292257370-24391-7-git-send-email-nirm@voltaire.com>	 <20101214184514.GE2506@obsidianresearch.com> <1292770052.2369.2157.camel@nirm-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292770052.2369.2157.camel@nirm-desktop>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Nir Muchtar wrote:
>> struct rdma_cm_id_stats {
>>   u32 bound_dev_if;
>>   u32 resereved_for_ib_bound_dev_ib;

I guess we want ...for_ib_bound_dev_if and not _ib

> Do you mean the file descriptor which is associated with the
> rdma_event_channel? The event channel is created using ucma and not cma.

indeed, we can't assume that the ID was created through ucma

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
