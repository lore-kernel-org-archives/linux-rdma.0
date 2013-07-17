From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 11/13] IB/srp: Make HCA completion vector configurable
Date: Wed, 17 Jul 2013 12:27:54 +0300
Message-ID: <51E6639A.1070108@mellanox.com>
References: <51D41C03.4020607@acm.org> <51D41FFC.6070105@acm.org> <51E272A4.5030707@mellanox.com> <51E56296.2000403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51E56296.2000403-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/16/2013 6:11 PM, Bart Van Assche wrote:
> On 14/07/2013 3:43, Sagi Grimberg wrote:
>> Just wrote a small patch to allow srp_daemon spread connection across
>> HCA's completion vectors.
>
> Hello Sagi,
>
> How about the following approach:
> - Add support for reading the completion vector from srp_daemon.conf,
>   similar to how several other parameters are already read from that
>   file.

Here We need to take into consideration that we are changing the 
functionality of srp_daemon.conf.
Now instead of simply allowing/dis-allowing targets of specific 
attributes, we are also defining configuration attributes of allowed 
targets.
This might be uncomfortable for the user to explicitly write N target 
strings in srp_daemon.conf just for completion vectors assignment.

Perhaps srp_daemon.conf can contain a list (comma separated) of reserved 
completion vectors for srp_daemon to spread CQs among them.
If this line won't exist - srp_daemon will spread assignment on all HCAs 
completion vectors.

> - If the completion vector parameter has not been set in
>   srp_daemon.conf, let srp_daemon assign a completion vector such that
>   IB interrupts for different SRP hosts use different completion
>   vectors.
>
> Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
