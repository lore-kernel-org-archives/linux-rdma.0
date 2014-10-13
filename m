From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 1/2] IB/core: Introduce Fast Indirect Memory Registration
 verbs API
Date: Mon, 13 Oct 2014 10:57:43 +0300
Message-ID: <543B85F7.1060000@dev.mellanox.co.il>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com> <1412693281-6161-2-git-send-email-sagig@mellanox.com> <54342D0C.6050103@opengridcomputing.com> <5434D037.4040208@dev.mellanox.co.il> <000b01cfe2ff$69195740$3b4c05c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000b01cfe2ff$69195740$3b4c05c0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bvanassche-HInyCGIudOg@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/8/2014 4:54 PM, Steve Wise wrote:
>>>> @@ -1056,6 +1067,14 @@ struct ib_send_wr {
>>>>                int            access_flags;
>>>>                struct ib_sge           *prot;
>>>>            } sig_handover;
>>>> +        struct {
>>>> +            u64                iova_start;
>>>> +            struct ib_indir_reg_list       *indir_list;
>>>> +            unsigned int            indir_list_len;
>>>> +            u64                length;
>>>> +            unsigned int            access_flags;
>>>> +            u32                mkey;
>>>> +        } indir_reg;
>>>
>>> What is mkey?  Shouldn't this be an rkey?
>>
>> mkey means memory key. I can change it to rkey if that
>> is clearer.
>
> Is it valid to use an lkey here?  Or is an rkey required?  If an rkey is required, then I'd say it is clearer to name it rkey (and
> that aligns with the fastreg struct).
>

It is valid. The memory key depends on the use case.
In case a client want to send an rkey to a peer, it will register using
rkey. In case a server wants to transfer data from it's local buffer
it will register using lkey.

So I didn't impose a specific key here - this is why I chose mkey.

I can modify it to rkey to mimic the well known fastreg, but its not
a must.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
