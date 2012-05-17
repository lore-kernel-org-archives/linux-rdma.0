From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 4/7] IB/core: Add RSS and TSS QP groups
Date: Thu, 17 May 2012 11:19:53 +0300
Message-ID: <4FB4B4A9.6060802@mellanox.com>
References: <1336494151-31050-1-git-send-email-ogerlitz@mellanox.com> <1336494151-31050-5-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336494151-31050-5-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Ken Strandberg <ken-gYl/eZtt0eRHU/oTnqaCTwC/G2K4zDHf@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/8/2012 7:22 PM, Or Gerlitz wrote:
> From: Shlomo Pongratz<shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> RSS (Receive Side Scaling) TSS (Transmit Side Scaling, better known as
> MQ/Multi-Queue) are common networking techniques which allow to use
> contemporary NICs that support multiple receive and transmit descriptor
> queues (multi-queue), see also Documentation/networking/scaling.txt
>
> This patch introduces the concept of RSS and TSS QP groups which
> allows for implementing them by low level drivers and using it
> by IPoIB and later also by user space ULPs.

Hi Roland, Sean - word had reached me tonight that the unbelievable 
happened and OFA now opened their site for all without requiring 
subscription! The concept of QP groups for TSS/RSS was introduced in the 
last OFA conference, maybe you want to take a look on the user mode 
ethernet session slides 10-14, the author was maybe worried from the MS 
mob, and hence didn't use the terms
RSS/TSS but that's the intention...

https://openfabrics.org/resources/document-downloads/presentations/cat_view/57-ofa-documents/23-presentations/81-openfabrics-international-workshops/104-2012-ofa-international-workshop/107-2012-ofa-intl-workshop-wednesday.html


Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
