From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Wed, 26 Apr 2017 17:45:09 +0300
Message-ID: <c2a1436f-48a6-bdea-c910-168fc6031364@grimberg.me>
References: <08131a05-1f56-ef61-990a-7fff04eea095@gmail.com>
 <1848296658.37025722.1487782361271.JavaMail.zimbra@redhat.com>
 <1554c1d1-6bf4-9ca2-12d4-a0125d8c5715@gmail.com>
 <DE927C68B458BE418D582EC97927A92854655137@ORSMSX112.amr.corp.intel.com>
 <3eb5814f-14cb-2b94-adf8-335d4b2eb7e9@grimberg.me>
 <26912d0c-578f-26e9-490d-94fc95bdf259@mellanox.com>
 <DE927C68B458BE418D582EC97927A92855031724@ORSMSX113.amr.corp.intel.com>
 <809f87ab-b787-9d40-5840-07500d12e81a@mellanox.com>
 <1948057100.362217696.1491824459274.JavaMail.zimbra@kalray.eu>
 <33e2cc35-f147-d4a4-9a42-8f1245e35842@mellanox.com>
 <517fb6d2-a010-1926-b4cb-0e6041722c28@grimberg.me>
 <af9044c2-fb7c-e8b3-d8fc-4874cfd1bb67@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <af9044c2-fb7c-e8b3-d8fc-4874cfd1bb67-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> Can we get it to 4.12 please (we need you to send it out today).
>
> Sagi,
> we are preparing a cap bit for it.
> I'll send it as soon as it will be ready (otherwise we'll add fence for
> devices that can handle without it - such as ConnectX5).

Why? can't you just get what you have as a fix and incrementally add the
optimization for CX5?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
