From: Jesus Camacho Villanueva <jesus.camacho-CZJJ9ELfIp3ZJqsBc5GL+g@public.gmane.org>
Subject: Re: out of order packets when querying all ports in a switch through OpenSM
Date: Wed, 27 May 2015 16:16:15 +0200
Message-ID: <CAGNdY=6RQS9F4Or+fEudpVj0iRKJ_95LiG0O2+n=GG3WqzKP6w@mail.gmail.com>
References: <CAGNdY=4ox_P_XB+gaFoQvec=j9qp4RKOxrM9vsL_FAXAE3oYow@mail.gmail.com>
	<5565CCB8.8060600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5565CCB8.8060600-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

Thanks for your quick response :)

What you say here makes sense. I have seen this behaviour in one of
the switches, but I don't discard that this problem can arise in other
switches.

The switch is: Infiniscale-IV Mellanox Technologies 4xQDR

Jesus

On Wed, May 27, 2015 at 3:55 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Hi Jesus,
>
> On 5/27/2015 8:56 AM, Jesus Camacho Villanueva wrote:
>> Hello,
>>
>> I am trying to send a port info request to all the ports in a switch,
>> one after the other.
>>
>> I am sending all requests to the same switch in sequence through the
>> same directed routing path:
>>
>> Request port number 1
>> Request port number 2
>> Request port number 3
>> Request port number 4
>>
>> But sometimes I get responses out of order:
>>
>> Response port number 2
>> Response port number 1
>> Response port number 3
>> Response port number 4
>>
>> Is it possible that the switch is processing port requests out of
>> order (or maybe I am doing something wrong)?
>
> One way this could occur is that request to switch for port number 1
> either does not make it to switch or response does not make it back and
> it times out and is retransmitted by kernel. This depends on how umad is
> setup in terms of retries and timeout.
>
> Is it always the same switch or switch type ? What switch is it ?
>
> -- Hal
>
>> Best regards,
>> Jesus
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
