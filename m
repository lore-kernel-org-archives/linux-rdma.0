From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: 4.7.0 ib_srpt Regression - 4.6.4 Got failed path rec status -22
 got worse on 4.7.0
Date: Mon, 22 Aug 2016 10:01:09 -0700
Message-ID: <39412892-aab7-5bf9-7a19-be311dc32050@sandisk.com>
References: <CA+X5Wn46GGnqijVS54A_45_D8g_0cvcZ3iAYbt2J6syiKwqNGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn46GGnqijVS54A_45_D8g_0cvcZ3iAYbt2J6syiKwqNGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/19/2016 10:21 PM, james harvey wrote:
> I have booting over SRP working.

Congratulated!

> For those interested:
> * script to mount SRP devices in initramfs, see
> https://github.com/jamespharvey20/srp-boot

I was surprised to see that the "hca" and "port_number" information has 
to be specified as arguments? Have you considered to let the srp-boot 
script loop over /sys/class/infiniband_srp/* and try to log in over each 
port?

> Through ib_srpt 4.6.4, linux's SRP connection initially errors with:
> =====
> scsi host7: ib_srp: Got failed path rec status -22
> scsi host7: ib_srp: Path record query failed
> scsi host7: ib_srp: Connection 0/4 failed
> scsi host7: ib_srp: Sending CM DREQ failed
> =====
>
> I believe this error is coming from
> linux/drivers/infiniband/ulp/srp/ib_srp.c::srp_path_rec_completion()
>
> The only reference I can find to status -22 is an Oracle document,
> saying this can happen if the I/O path to the active target is
> interrupted via a link failure or cluster takeover.  Sounds similar to
> what's going on here, with the original iPXE SRP connection being
> hijacked by the (second) linux connection.

I think that error code comes from the recv_handler() function in 
drivers/infiniband/core/sa_query.c. I have seen this before that the 
first two path look up attempts fail. Since path look up occurs by 
exchanging datagrams between initiator and SA it is expected that no 
information about these path lookup failures occurs in the target log.

>  The 4.7.1 target logs show:
>
> [ ... ]
> [   95.757202] ib_srpt srpt_queue_response: sending cmd response
> failed for tag 0 (-22)

Which HCA model are you using at the target side? Error code -22 
(-EINVAL) comes from the IB HW driver.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
