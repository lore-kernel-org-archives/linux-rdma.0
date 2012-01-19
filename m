From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Solved: IB/iSER problems with Linux 3.0
Date: Thu, 19 Jan 2012 14:56:22 +0100
Message-ID: <4F182106.1040002@profitbricks.com>
References: <CAJZOPZL=bV4SjdD2eakX9MhOhw=91xzCK=BEkirhRQd8oPA6bg@mail.gmail.com> <4F154CF2.7030504@profitbricks.com> <4F158C0D.7070302@mellanox.com> <4F17FE97.6090708@profitbricks.com> <4F1809FC.2020908@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F1809FC.2020908-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19/01/12 13:18, Or Gerlitz wrote:
>> [...]
>> Or Gerlitz (4):
>>       IB/iser: Fix wrong mask when sizeof (dma_addr_t) > sizeof
>> (unsigned long)
>>       IB/iser: Support iSCSI PDU padding
>>       IB/iser: Use separate buffers for the login request/response
>>       IB/iser: DMA unmap TX bufs used for iSCSI/iSER headers
>> [...]
> could you try only the four of them on top of 3.0.15 and then if it
> works okay, find out which one of them does the job?

I've applied them one by one and at the following commit it worked:

IB/iser: Use separate buffers for the login request/response

Then, I've tried to apply that commit only to 3.0.15, but automatic
cherry-picking failed. I had to apply the following commit first:

IB/iser: Support iSCSI PDU padding

So, these two commits are the winners, for our Solaris 11 COMSTAR targets.

Without them I always had to reboot the system because it wasn't
possible to logout or to unload the ib_iser module.

Cheers,

Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
