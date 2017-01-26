From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D state
Date: Thu, 26 Jan 2017 12:52:04 +0200
Message-ID: <21bfa6a7-9199-9341-1193-7d186fd36326@grimberg.me>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
 <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me>
 <CAANLjFp3Zo_QpR7WCmVOfO0AEDxCXabbenac3KNR-RosCgGx+A@mail.gmail.com>
 <c7f1af87-a846-ed8a-a46e-ab5888ea9b92@mellanox.com>
 <CAANLjFo1N=1BqY8Vur8jheDP4h9_9Q7Ns7MsgbRJX+TDhJbcOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFo1N=1BqY8Vur8jheDP4h9_9Q7Ns7MsgbRJX+TDhJbcOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> Robert,
>> can you please try replacing the ib_drain_qp with ib_drain_rq ? or make sure
>> ib_drain_qp don't stuck.
>> in the past (before v4.6) we sent "recv_beacon" on the isert disconnect
>> flow.
>> I suspect that area.
>>
>> Max.
>
> It is getting stuck in target_wait_for_sess_cmds. ib_drain_qp is
> returning just fine. I put in a bunch of debug statements and here is
> a clip of them from a previous test.

It won't make a difference, and we need both the rq and the sq drained
before we continue with session teardown.

Robert,

I'm still missing the information of which commands are pending without
a completion.

Please activate target_wait_for_sess_cmds() debug logging.

You can turn on the whole file with:
echo "file target_core_transport.c +p" > 
/sys/kernel/debug/dynamic_debug/control

Cheers,
Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
