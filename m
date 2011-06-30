From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: kernel space rdma client, reg_mr issue
Date: Thu, 30 Jun 2011 18:34:09 +0200
Message-ID: <OF20DF8848.8939F082-ONC12578BF.005A6103-C12578BF.005B04E0@ch.ibm.com>
References: <BANLkTi=+mFMHzoS9A=M1mW5pSjy8qdoV7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=+mFMHzoS9A=M1mW5pSjy8qdoV7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-noel.gonzalez.de.linares-y6kNeMnOB+c@public.gmane.org, john stewart <john.stewart.kz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 06/30/2011 04:19:01 PM:

> Hi,
>

maybe i misread your last email - are you trying to use reg_user_mr()
as a kernel client? If yes - that will not work. You should use the
interface as
described by Wendy (get_dma_mr() etc.), since you are dealing with kernel
memory. I can add a check to siw to prevent that call into
siw_reg_user_mr() to be executed for kernel clients.

thanks,
Bernard.


> We are working to create a RDMA client within the kernel which will
> connect to a working RDMA userspace server.
> We are using the userspace code  for testing purpose , in the final
> version all the communication will be done within the kernel space.
>

<snip>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
