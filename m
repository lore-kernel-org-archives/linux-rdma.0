From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: RFC: Immediate data support for SRP
Date: Mon, 20 Jul 2015 16:49:57 -0700
Message-ID: <55AD8925.6060306@sandisk.com>
References: <55A7CCF1.3080201@sandisk.com>
 <55ABCB34.1000506@dev.mellanox.co.il>
 <CACaajQu9QBo7robmrFF7hev-xS=c3VD9qQTn5DKuuObk5aU_Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQu9QBo7robmrFF7hev-xS=c3VD9qQTn5DKuuObk5aU_Kg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/19/2015 02:25 PM, Vasiliy Tolstov wrote:
>  > On 7/16/2015 6:25 PM, Bart Van Assche wrote:
>  >> it is easy to add to the SRP initiator and target drivers.
>  >> Implementations exist in the ib_srp-backport initiator driver and the
>  >> SCST SRP target driver (see also
>  >> https://github.com/bvanassche/ib_srp-backport and
>  >> http://sourceforge.net/p/scst/svn/HEAD/tree/trunk/srpt/). These
>  >> implementations are available since considerable time, work reliably,
>  >> are backwards compatible and support zero-copy. Since using immediate
>  >> data provides a measurable performance improvement I'm wondering whether
>  >> it would be acceptable to add support for immediate data to the SRP
>  >> drivers in the Linux kernel tree (ib_srp and ib_srpt) ?
>
> Does this possible in userspace? I'm working on software defined storage
> with rdma support,and I think this is usable.

Hello Vasiliy,

The feature of the RDMA API that was used to implement sending inline 
data, namely passing a scatterlist to ib_post_send() with more than one 
element, is also available in the user space RDMA API. I think it would 
be easy to add inline data support in a user space implementation of 
SRP. Not that it really matters, but your e-mail made me wonder whether 
the source code of the user space SRP initiator implementation you are 
working is available somewhere, and if so, under which license ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
