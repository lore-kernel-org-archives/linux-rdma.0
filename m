From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Some question about the switch ports' LinkSpeed
Date: Tue, 05 Jan 2010 10:02:23 +0200
Message-ID: <4B42F20F.5030505@dev.mellanox.co.il>
References: <91fe68d51001040558w5f79e6adw8d0af15758e4d9fc@mail.gmail.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <91fe68d51001040558w5f79e6adw8d0af15758e4d9fc-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?546L5YWB5b2s?= <acceptany-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

On 04/Jan/10 15:58, =E7=8E=8B=E5=85=81=E5=BD=AC wrote:
> Now I have a Infiniband switch with the rate of a port 20Gb/s.
> But my experiment can only work below the LinkSpeed of 1Gb/s.
> Is there some methods to limit the rate of the switch.

The lowest possible rate in IB is 1x SDR, which is 2.5 Gb/s.
What exactly do you want to limit? What is the test doing?
Do you have control over that code that generates the traffic?

> Can QoS work out ?

QoS (i.e. VL arbitration) kicks in only when the link is
saturated. QoS doesn't have an ability to limit the BW.
It can only limit relative BW part among several streams.

-- Yevgeny

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
