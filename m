From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 for-next 3/5] IB/ipoib: Move to multi-queue device
Date: Sun, 24 Mar 2013 13:12:25 +0200
Message-ID: <514EDF99.7000305@mellanox.com>
References: <1362676288-19906-1-git-send-email-ogerlitz@mellanox.com> <1362676288-19906-4-git-send-email-ogerlitz@mellanox.com> <32E1700B9017364D9B60AED9960492BC0D5C7875@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D5C7875-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/9/2013 4:04 PM, Marciniszyn, Mike wrote:
> This patch will conflict with http://marc.info/?l=linux-rdma&m=136190765729001&w=2.
>
> Mike
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
>> Sent: Thursday, March 07, 2013 12:11 PM
>> To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Shlomo Pongratz
>> Subject: [PATCH V3 for-next 3/5] IB/ipoib: Move to multi-queue device
Hi Mike,

You didn't mentioned but you have changed the order of the call to 
"netif_stop_queue" and the call to "ib_req_notify_cq", by placing the 
"netif_stop_queue" before the call to "ib_req_notify_cq".

IMO you've solved a theoretical bug in which the the handler might be 
called and finish before the call to the call to "netif_stop_queue", 
which would result in a stopped queue.
I guess the same reordering should be done in "ipoib_ib.c::ipoib_send".

Thanks.

S.P.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
