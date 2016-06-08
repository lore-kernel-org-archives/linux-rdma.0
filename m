From: Sagi Grimberg <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Wed, 8 Jun 2016 15:27:57 +0300
Message-ID: <57580F4D.10802@lightbits.io>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <20160603052539.GB31196@infradead.org>
 <CAG9sBKN9HQKhRgXWZ8JJwwUdEBaP9VnGwr790C=q4w0XDxkbtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKN9HQKhRgXWZ8JJwwUdEBaP9VnGwr790C=q4w0XDxkbtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> - Moved from drivers/staging/rdma/rxe to drivers/infiniband/hw/rxe
> - Rebase to newer kernel (was 4.4-rc6)
> - Removed support in phys. MR
> - Removed memory window codes (buggy)
> - Mind  IS_ENABLED(CONFIG_IPV6)
> - Dispatch IB event on port UP/DOWN
> - Validate ICRC in receive
> - Validate dgid in receive
> - Scatter IPv4 header to right place for UD QP
> - Other bug fixes
> - Copyright dates were updated in file headers
>
>
>> How well do FRWRs work, does this include Sagi's work in that area?
> FRWR is not supported yet

FWIW I implemented FR support so I can run nvme over fabrics in the lack
of RDMA devices,

can be found in:
git-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org:sagigrimberg/linux.git rxe-fr.1

With this I could run nvmf and iser on two VMs on my laptop.

Note that fenced local invalidation (strong fence after rdma read)
is not implemented yet.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
