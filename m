From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RFC: Immediate data support for SRP
Date: Tue, 21 Jul 2015 12:25:02 +0300
Message-ID: <55AE0FEE.7060500@dev.mellanox.co.il>
References: <55A7CCF1.3080201@sandisk.com>
 <55ABCB34.1000506@dev.mellanox.co.il>
 <CAJ3xEMiz=n_uP9TQ6YsGN+omzsN3Zrz5skDEq00+fE188z0erA@mail.gmail.com>
 <55ACC2FA.8030202@dev.mellanox.co.il> <55AD133D.2040204@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55AD133D.2040204-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>
> So you have 140% better IOPS with immediate-data vs. non immediate
> data?! numberz?

No, the improvement was to avoid memory copy from the pre-posted recieve
buffer (with immediate-data) to an allocated buffer. Instead the receive
buffer is handed to the backend to do IO.

This shows up to 40% improvement (vs. immediate data with copy on the
target side).

I'll post numbers with the patches.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
