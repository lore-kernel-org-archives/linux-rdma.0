From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Make queue size configurable
Date: Mon, 16 Sep 2013 16:25:28 +0200
Message-ID: <523714D8.3020104@acm.org>
References: <521363EA.8080906@acm.org> <52136609.3090406@acm.org>  <1378782080.3794.6.camel@feather.ornl.gov> <522F5A81.8040101@acm.org> <1378937796.6649.5.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378937796.6649.5.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: David Dillow <dad-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konrad Grzybowski <konradg-XLFqaoR9dsI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/12/13 00:16, David Dillow wrote:
> On Tue, 2013-09-10 at 19:44 +0200, Bart Van Assche wrote:
>> If this name was not yet in use in any interface that is visible in user
>> space, I would agree that we should come up with a better name. However,
>> the SCSI mid-layer already uses that name today to export the queue
>> size. To me this looks like a good reason to use the name "can_queue" ?
>> An example:
>>
>> $ cat /sys/class/scsi_host/host93/can_queue
>> 62
>
> Yes, I know it has been used before, but I'm torn between not furthering
> a bad naming choice and consistency. Foolish consistency and all that...
>
> I really don't like "can_queue", but I'll not complain if Roland decides
> to take it as-is.

The merge window has been closed early which means that I'll have to 
resend this patch series anyway. How about using the name "queue_size" 
instead ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
