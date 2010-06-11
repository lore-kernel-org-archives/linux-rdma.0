From: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: A strange problem when using IB to transfer things
Date: Fri, 11 Jun 2010 17:30:31 +0200
Message-ID: <4C125697.1000508@gmail.com>
References: <AANLkTiml1Q7sD9MFsg_q1nQx5091rNnzhK8oh1aUnxwT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTiml1Q7sD9MFsg_q1nQx5091rNnzhK8oh1aUnxwT-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi.

On 11/06/2010 10:51, Ding Dinghua wrote:
> Hi all:
>           I'm using RDMA to do fs-metadata mirror between nodes. I
> encountered a strange problem when the program was running:
> Complete queue handler reported that the  RDMA-Write operation failed,
>   the status of  corresponding "struct ib_wc" is "IB_WC_RETRY_EXC_ERR".
> The problem is encountered randomly. I don't know the meaning of this
> error code as well as what to do next. Would anyone give me some tips?
> thanks a lot.
>    

Do you sync between the sides before closing the QPs?

Retry exceeded mans that a message was sent without a response
(maybe you need to increase the timeout in the QP attributes:  timeout 
or retry_cnt).

I hope this helped you ..

Dotan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
