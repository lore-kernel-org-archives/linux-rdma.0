From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: IB_CQ_VECTOR_LEAST_ATTACHED
Date: Sun, 7 Dec 2014 18:58:12 +0200
Message-ID: <54848724.4020908@mellanox.com>
References: <54809030.6090107@oracle.com> <5480AB49.1080209@acm.org>
 <5480B8CE.3080704@oracle.com> <54842A05.9070207@dev.mellanox.co.il>
 <54844690.4040501@mellanox.com> <54844F44.1010604@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54844F44.1010604-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/7/2014 2:59 PM, Or Gerlitz wrote:
> On 12/7/2014 2:22 PM, Matan Barak wrote:
>> Applications might want to create a CQ on n different cores
>
> You mean like an IRQ can flush on a mask potentially made of multiple CPUs?

Sort of. In both cases you try to spread the resources such that you'll 
get best performance (that should be done by the device driver itself). 
The user needs to somehow get n different least-used resources. 
Hopefully, if the device driver does a decent job - the user would get 
his resources potentially on multiple cpus.

Matan

>
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
