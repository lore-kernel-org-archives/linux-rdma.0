From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: SoftRoCE V1
Date: Thu, 31 Dec 2015 10:48:29 +0200
Message-ID: <5684EBDD.8070204@mellanox.com>
References: <CAEnvTt1KBHXYzjfHKmWkQtUs1J-ABhY_maQibR5LE9t+F25sYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEnvTt1KBHXYzjfHKmWkQtUs1J-ABhY_maQibR5LE9t+F25sYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wenda Ni <wonda.ni-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 29/12/2015 18:01, Wenda Ni wrote:
> Hi experts,
> 
> We have several Mellanox RoCE V1 NIC cards, and would like to try
> communicating with SoftRoCE V1.
> 
> We are using branch rxe-3.0 from https://github.com/SoftRoCE/rxe-dev
> according to the Soft-RoCE README Rev 1.0 issued from Mellanox last
> year.
> 
> 
> Testing using pingpong examples from libibverbs (hardware RoCE <->
> SoftRoCE) already shows a bug in Ethernet CRC generation. We expect
> further bugs along the way.
> 
> So we would like to know for SoftRoCE V1, are we using the latest
> branch? Also, is it still tied to SLES11 SP3 OS?
Kamal can correct me if I'm wrong, but I think the updated branch is rxe_submission-v2.
However it doesn't support RoCE v1, only RoCE v2.

> There are very few documentations we can find, so we hope this is the
> right place to ask such questions.
I can't think of a better place.

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
