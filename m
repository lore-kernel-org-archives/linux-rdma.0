From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCHv4]Checks for Null value in function *get_skub
Date: Mon, 16 Jun 2014 12:18:45 -0500
Message-ID: <539F26F5.8030702@opengridcomputing.com>
References: <1402932328-3732-1-git-send-email-xerofoify@gmail.com>	<539F0DAF.1020802@opengridcomputing.com>	<CAPDOMVjd9J=Kz4d88==UsbfjH13mhGzzmbc2NnxSOfqJs_aGpQ@mail.gmail.com> <CAPDOMVh4iBhWe50LZtiotpgWBn3fhX1jofyeAeYW4kHxx+Q4FQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPDOMVh4iBhWe50LZtiotpgWBn3fhX1jofyeAeYW4kHxx+Q4FQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nick Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/16/2014 10:45 AM, Nick Krause wrote:
> Can we close this bug or is it still a issue as we can'
> return NULL from kfree or kfree_skb. Here is the bug
> ID 44631 I would close it if we are done with the bug
> otherwise I think there are no other issues with
> allocating a skb,
>

In what database is this bug ID 44631?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
