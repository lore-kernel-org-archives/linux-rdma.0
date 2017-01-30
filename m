From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D state
Date: Mon, 30 Jan 2017 12:36:03 -0700
Message-ID: <CAANLjFqNu2EjkWJGtRx=kjcgSq5SmyJJ2xnvMsgrJEu7Un0CzA@mail.gmail.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
 <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me> <CAANLjFp3Zo_QpR7WCmVOfO0AEDxCXabbenac3KNR-RosCgGx+A@mail.gmail.com>
 <c7f1af87-a846-ed8a-a46e-ab5888ea9b92@mellanox.com> <CAANLjFo1N=1BqY8Vur8jheDP4h9_9Q7Ns7MsgbRJX+TDhJbcOw@mail.gmail.com>
 <21bfa6a7-9199-9341-1193-7d186fd36326@grimberg.me> <CAANLjFpVMMp9kaqmugT0yxoR=0f0gmvxGzhBnW-djXyZgMN-CA@mail.gmail.com>
 <b5beb647-31f1-30d2-1162-2398f654c63d@grimberg.me> <CAANLjFoFocDMFFCSvYsGzYHOoRT-5DD3UDVpf51j9mU--LVL+A@mail.gmail.com>
 <4be8cfd7-c50c-18a2-347a-745e4a70113a@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4be8cfd7-c50c-18a2-347a-745e4a70113a-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 30, 2017 at 12:39 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>> The first output (without the dates) is from dmesg, the second output
>> is from journal.
>
>
> Hey Robert,
>
> I'm still having a hard time understanding the traces.
> How about you reproduce the error and attach a full dmesg
> output? I suggest to reproduce once with debug_level=2 (to
> cleanup some noise) and once with debug_level=4 and hopefully
> we can understand what is getting lost.
>
> Also, please wait for the hang timeout watchdog traces, they
> can give us confirmation that we are stuck waiting for a final
> reference on some command.

I left the capture of dmesg run for ~20 minutes after iSER failed.
2017-01-30_11:37:28_dmesg.log is level 2 and
2017-01-30_12:04:47_dmesg.log is level 4. The log files can be found
at [1].

[1] http://mirrors.betterservers.com/trace/dmesg_logs.txz
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
