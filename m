From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] Clear out stuck ops to prevent iSER from going init D
 state
Date: Tue, 24 Jan 2017 22:26:59 +0000
Message-ID: <1485296806.2715.5.camel@sandisk.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
         <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me>
         <CAANLjFp3Zo_QpR7WCmVOfO0AEDxCXabbenac3KNR-RosCgGx+A@mail.gmail.com>
         <c7f1af87-a846-ed8a-a46e-ab5888ea9b92@mellanox.com>
         <CAANLjFo1N=1BqY8Vur8jheDP4h9_9Q7Ns7MsgbRJX+TDhJbcOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFo1N=1BqY8Vur8jheDP4h9_9Q7Ns7MsgbRJX+TDhJbcOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <98A17F2671FCA94DB57CCA6028F7F592-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-01-24 at 14:59 -0700, Robert LeBlanc wrote:
> It is getting stuck in target_wait_for_sess_cmds. ib_drain_qp is
> returning just fine. I put in a bunch of debug statements and here is
> a clip of them from a previous test.

The same code works fine with iSCSI/TCP, ib_srpt and qla2xxx. I would
appreciate it if an iSER could have a closer look at this.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
