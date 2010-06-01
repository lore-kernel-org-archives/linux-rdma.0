From: Tziporet Koren <tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] libibverbs without an HCA
Date: Tue, 01 Jun 2010 16:28:04 +0300
Message-ID: <4C050AE4.1090706@mellanox.co.il>
References: <AANLkTim2sAHqCZtYvVXlARt2bqi40nSQ0dncl0KRy0KL@mail.gmail.com>
Reply-To: tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim2sAHqCZtYvVXlARt2bqi40nSQ0dncl0KRy0KL-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/1/2010 2:39 PM, Albert Strasheim wrote:
> Hello all
>
> Having just reviewed the various on-host shared memory mechanisms
> available in Linux and being quite unimpressed, I have the following
> question:
>
> Has anyone considered making a kernel and userspace driver so that
> libibverbs can be used on a single machine without any Infiniband
> hardware?
>
> The Verbs API seems like a very nice way to handle shared memory
> between processes where the number of shared buffers can vary in size
> and quantity.
>
> Regards
>
> Albert
>
>    
These kind of questions should be addressed by the Linux RDMA List 
(already CC)

Tziporet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
