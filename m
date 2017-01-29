From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D state
Date: Sun, 29 Jan 2017 12:13:03 -0700
Message-ID: <CAANLjFoFocDMFFCSvYsGzYHOoRT-5DD3UDVpf51j9mU--LVL+A@mail.gmail.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
 <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me> <CAANLjFp3Zo_QpR7WCmVOfO0AEDxCXabbenac3KNR-RosCgGx+A@mail.gmail.com>
 <c7f1af87-a846-ed8a-a46e-ab5888ea9b92@mellanox.com> <CAANLjFo1N=1BqY8Vur8jheDP4h9_9Q7Ns7MsgbRJX+TDhJbcOw@mail.gmail.com>
 <21bfa6a7-9199-9341-1193-7d186fd36326@grimberg.me> <CAANLjFpVMMp9kaqmugT0yxoR=0f0gmvxGzhBnW-djXyZgMN-CA@mail.gmail.com>
 <b5beb647-31f1-30d2-1162-2398f654c63d@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b5beb647-31f1-30d2-1162-2398f654c63d-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 29, 2017 at 12:42 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>> OK, I'm using commit bb3d5f95f46dfe19554820dbce620d31504dafb2 from the
>> bvanassche/scsi-target-for-v4.11 tree. I've exported the target with
>> InitialR2T=No
>
>
> Hey Robert, InitialR2T=No means that you are using UnsolicitedDataOut, I
> recommend to not use it.

This doesn't seem to make a difference in regards to hitting the bug,
but I'll set it back to on for all other tests.

>  then I ran
>>
>> echo 4 > /sys/module/ib_isert/parameters/debug_level
>> echo "file target_core_transport.c +p" >
>> /sys/kernel/debug/dynamic_debug/control
>>
>> but it seems there is no new information during the period of the hang.
>
>
> IIRC, pr_debug are not directed to the journal by default, can you
> please check dmesg output?

The first output (without the dates) is from dmesg, the second output
is from journal.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
