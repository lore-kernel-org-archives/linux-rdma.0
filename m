From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel space rdma client, reg_mr issue
Date: Thu, 30 Jun 2011 08:48:23 -0700
Message-ID: <BANLkTimq+YmMpRrL2GF8+2u7T7LdVSamLw@mail.gmail.com>
References: <BANLkTi=+mFMHzoS9A=M1mW5pSjy8qdoV7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=+mFMHzoS9A=M1mW5pSjy8qdoV7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john stewart <john.stewart.kz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, jean-noel.gonzalez.de.linares-y6kNeMnOB+c@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 30, 2011 at 7:19 AM, Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
> Hi,
>
> We are working to create a RDMA client within the kernel which will
> connect to a working RDMA userspace server.
> We are using the userspace code =A0for testing purpose , in the final
> version all the communication will be done within the kernel space.
>
 [snip]
>
>  basically the question boils down to how to allcoate and registr
> buffer for RDMA communication from inside a kernel module?
>

I happen to have a similar setup ..The original intent was to have a
kernel mode RDMA application that took the kernel data and sent it
over to the peer node's memory for temporary storage. It had to be
able to get read back later. As it didn't matter whether the temporary
storage was in kernel or user address space, I re-used my colleague's
existing user mode program (to run as an user space daemon on the peer
node). This allowed the focus being on the new kernel application
development (run on the primary node). After the code was up and
running, I see no reason to change the setup and it has been running
fine since.

The code runs on RHEL 5.5 with OFED-1.5.2 using Mellanox card.

The user mode daemon is in a forever receiving loop that follows the
standard the RDMA user mode programming logic.

The kernel code invokes the ib_xxx set of APIs (vs. user mode
ibv_xxx(s)). The kernel memory registration are done by the APIs such
as kzalloc(), ib_get_dma_mr(), ib_dma_map_single(), ib_dma_map_page(),
etc.

Check out the driver code in drivers/infiniband/ulp/iser directory. It
has a sample logic to register kernel memory.

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
