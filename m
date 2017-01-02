From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/2 v2] srp/srpt - some useful patches
Date: Mon, 2 Jan 2017 15:14:03 +0200
Message-ID: <0d854009-8d94-cd4d-e430-f5037d3945de@mellanox.com>
References: <1483280232-13826-1-git-send-email-maxg@mellanox.com>
 <1483347736.3592.10.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483347736.3592.10.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "bvanassche-HInyCGIudOg@public.gmane.org" <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ok.
just wanted to align to all other ULPs and simplify the code.
you can ignore these patches.

Max.

On 1/2/2017 11:02 AM, Bart Van Assche wrote:
> On Sun, 2017-01-01 at 16:17 +0200, Max Gurtovoy wrote:
>> No bug fixes, but few improvements that might help.
>
> Hello Max,
>
> These patches are not useful to anyone so please drop these patches. More in
> detail:
> - Linux kernel patches should either be useful to Linux users or make the job
>   of kernel maintainers easier. Your patches realize neither of these goals.
> - You write that using kmalloc() / kfree() may increase memory fragmentation
>   compared to stack allocation. I do not agree with this. And even if your
>   claim would be correct, this shouldn't be fixed by modifying the SRP
>   initiator and target drivers but this should be fixed by modifying the slab
>   allocators.
>
> Bart.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
