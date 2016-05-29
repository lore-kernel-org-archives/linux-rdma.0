From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: MLX5 iSER issue on 4.6?
Date: Sun, 29 May 2016 20:32:35 +0300
Message-ID: <574B27B3.707@mellanox.com>
References: <CAANLjFpPoynQeBiQjZ=2RA1YHaNp3jZKtavZ5URWcsJu+x85vA@mail.gmail.com>
 <574A930E.6030507@grimberg.me> <574ADB25.8080903@mellanox.com>
 <574AE1AB.9050501@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <574AE1AB.9050501-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> Can you report if Mellanox plans to fix it in FW or should we work
> around in the driver?

I investigated it today, and the bug isn't in the FW.
there is a bug in the casting of device caps.
I have a patch that I'll send tomorrow.
Thanks for reporting and helping with this issue,
Max.

>
> Thanks,
> Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
