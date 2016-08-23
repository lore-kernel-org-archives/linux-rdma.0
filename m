From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: 4.7.0 ib_srpt Regression - 4.6.4 Got failed path rec status -22
 got worse on 4.7.0
Date: Tue, 23 Aug 2016 09:00:20 -0700
Message-ID: <de643a63-7179-4fe6-fef4-4dfa6e733966@sandisk.com>
References: <CA+X5Wn46GGnqijVS54A_45_D8g_0cvcZ3iAYbt2J6syiKwqNGA@mail.gmail.com>
 <39412892-aab7-5bf9-7a19-be311dc32050@sandisk.com>
 <CA+X5Wn7KbG-6Hg2JdOJhteXezgMS5O6DkixOjB3idoWu=UXKJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn7KbG-6Hg2JdOJhteXezgMS5O6DkixOjB3idoWu=UXKJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/22/2016 05:18 PM, james harvey wrote:
> On Mon, Aug 22, 2016 at 1:01 PM, Bart Van Assche
> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>> On 08/19/2016 10:21 PM, james harvey wrote:
>>> For those interested:
>>> * script to mount SRP devices in initramfs, see
>>> https://github.com/jamespharvey20/srp-boot
>>
>>
>> I was surprised to see that the "hca" and "port_number" information has to
>> be specified as arguments? Have you considered to let the srp-boot script
>> loop over /sys/class/infiniband_srp/* and try to log in over each port?
>
> I like that idea, two questions.
>
> First, would you suggest upon success to exit the loop, or would you
> have it still try all of them?  Haven't worked with or thought much
> about multipathing.
>
> Second, would you suggest having it by default looping over those, but
> also take optional kernel arguments (or an initrd etc file, not sure
> which would be preferred) to specify which hca and port_number?  Or,
> would you suggest ditching the idea of being able to specify?

What would be ideal is to keep looping until either a timeout occurs or 
all disks needed by /etc/fstab have been found. If parsing /etc/fstab is 
too hard I propose to try to log in at least three times over each IB 
port. Even if logging in over one IB port succeeds that doesn't mean 
that that is the port to which the root disk has been connected.

>>>  The 4.7.1 target logs show:
>>>
>>> [ ... ]
>>> [   95.757202] ib_srpt srpt_queue_response: sending cmd response
>>> failed for tag 0 (-22)
>>
>> Which HCA model are you using at the target side? Error code -22 (-EINVAL)
>> comes from the IB HW driver.
>
> On both machines, a Mellanox MT26428 which is a ConnectX-2, but lspci
> shows "[ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE] (rev b0)."
> Shouldn't be relevant, but both on the most recent Mellanox 2.9.1000
> firmware.
>
> Using the mlx4_core and mlx4_ib modules.
>
> Other target InfiniBand programs remain same versions on the 4.6.4
> test which fails for 10-30 seconds then succeeds, and the 4.7.0 test
> which permanently fails.  opensm 3.3.20, libibmad 1.3.12, libibumad
> 1.3.10.2, libibverbs 1.2.1.
>
> I also checked target's /var/log/opensm.log, in case there might be
> something useful.  But, the log with target running 4.6.4 vs 4.7.0 is
> the same, with the process of iPXE (booting, dhcp, sanhook, sanboot),
> then the srp-boot script.

Did the "srpt_queue_response: sending cmd response failed for tag 0 
(-22)" error message only occur with the v4.7.0 kernel or also with the 
v4.7.1 kernel? The code of which I think that it is most likely that it 
triggered the -EINVAL return code is the (wr->num_sge > qp->sq.max_gs) 
test in mlx4_ib_post_send(). Patch "IB/srpt: Limit the number of SG 
elements per work request" is present in kernel v4.7.1 but not in 
v4.7.0. That patch ensures that num_sge is below the device limits.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
