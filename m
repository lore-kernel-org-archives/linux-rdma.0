From: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: P
Date: Sat, 12 Jun 2010 11:10:20 +0200
Message-ID: <4C134EFC.5010207@gmail.com>
References: <AANLkTiml1Q7sD9MFsg_q1nQx5091rNnzhK8oh1aUnxwT@mail.gmail.com>	<4C125697.1000508@gmail.com> <AANLkTilhV8JJTKxc4OpudTUgKqMyJ5mzcxt6XdSMurDS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTilhV8JJTKxc4OpudTUgKqMyJ5mzcxt6XdSMurDS-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/06/2010 03:22, Ding Dinghua wrote:
> 2010/6/11 Dotan Barak<dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>    
>> Hi.
>>
>> On 11/06/2010 10:51, Ding Dinghua wrote:
>>      
>>> Hi all:
>>>           I'm using RDMA to do fs-metadata mirror between nodes. I
>>> encountered a strange problem when the program was running:
>>> Complete queue handler reported that the  RDMA-Write operation failed,
>>>   the status of  corresponding "struct ib_wc" is "IB_WC_RETRY_EXC_ERR".
>>> The problem is encountered randomly. I don't know the meaning of this
>>> error code as well as what to do next. Would anyone give me some tips?
>>> thanks a lot.
>>>
>>>        
>> Do you sync between the sides before closing the QPs?
>>      
> Can you say it more detail? thanks.
>    
If you try to send a message from local QP to a remote QP before the 
remote QP is in RTR state (or after it was closed/transferred to the 
ERROR state),
you may get RETRY EXCEEDED, because there isn't any QP in the remote 
side that can accept your message (and send a response).

How do you connect the QPs? (And how do you close the connection between 
them)

Dotan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
