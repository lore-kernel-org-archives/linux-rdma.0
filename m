From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RFC: Immediate data support for SRP
Date: Mon, 20 Jul 2015 12:44:26 +0300
Message-ID: <55ACC2FA.8030202@dev.mellanox.co.il>
References: <55A7CCF1.3080201@sandisk.com>
 <55ABCB34.1000506@dev.mellanox.co.il>
 <CAJ3xEMiz=n_uP9TQ6YsGN+omzsN3Zrz5skDEq00+fE188z0erA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiz=n_uP9TQ6YsGN+omzsN3Zrz5skDEq00+fE188z0erA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/20/2015 12:43 AM, Or Gerlitz wrote:
> On Sun, Jul 19, 2015 at 7:07 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> On 7/16/2015 6:25 PM, Bart Van Assche wrote:
>
>> I agree it would definitely help as the lack of immediate data
>> emphasizes the additional latency of doing rdma reads.
>
> Sagi, do we have black box evidence from iSER showing notable
> (results? setup?) IO latency improvement from using immediate data vs.
> RDMA read?

I've seen it. The LIO target has a better write performance due to
ImmediateData. I also have a patch in the pipe that optimize the
this flow at the target side which improves up to 40% for 512B-8K IOs.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
