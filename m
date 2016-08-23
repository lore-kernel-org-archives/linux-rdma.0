From: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.7.0 ib_srpt Regression - 4.6.4 Got failed path rec status -22
 got worse on 4.7.0
Date: Tue, 23 Aug 2016 19:25:04 -0400
Message-ID: <CA+X5Wn74=TkBoUDiED2-ioqgdNPQ3Gvf=uJxO4RYz0p1jN+M7g@mail.gmail.com>
References: <CA+X5Wn46GGnqijVS54A_45_D8g_0cvcZ3iAYbt2J6syiKwqNGA@mail.gmail.com>
 <39412892-aab7-5bf9-7a19-be311dc32050@sandisk.com> <CA+X5Wn7KbG-6Hg2JdOJhteXezgMS5O6DkixOjB3idoWu=UXKJQ@mail.gmail.com>
 <de643a63-7179-4fe6-fef4-4dfa6e733966@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <de643a63-7179-4fe6-fef4-4dfa6e733966-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 23, 2016 at 12:00 PM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On 08/22/2016 05:18 PM, james harvey wrote:
>>
>> On Mon, Aug 22, 2016 at 1:01 PM, Bhttps://mail.google.com/mail/u/1/#sent/156a66555f2a2133art Van Assche
>> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>>>https://mail.google.com/mail/u/1/#sent/156a66555f2a2133
>>> On 08/19/2016 10:21 PM, james harvey wrote:
>>>>
>>>> For those interested:
>>>> * script to mount SRP devices in initramfs, see
>>>> https://github.com/jamespharvey20/srp-boot
>>>
>>>
>>>
>>> I was surprised to see that the "hca" and "port_number" information has
>>> to
>>> be specified as arguments? Have you considered to let the srp-boot script
>>> loop over /sys/class/infiniband_srp/* and try to log in over each port?
>>
>>
>> I like that idea, two questions.
>>
>> First, would you suggest upon success to exit the loop, or would you
>> have it still try all of them?  Haven't worked with or thought much
>> about multipathing.
>>
>> Second, would you suggest having it by default looping over those, but
>> also take optional kernel arguments (or an initrd etc file, not sure
>> which would be preferred) to specify which hca and port_number?  Or,
>> would you suggest ditching the idea of being able to specify?
>
>
> What would be ideal is to keep looping until either a timeout occurs or all
> disks needed by /etc/fstab have been found. If parsing /etc/fstab is too
> hard I propose to try to log in at least three times over each IB port. Even
> if logging in over one IB port succeeds that doesn't mean that that is the
> port to which the root disk has been connected.
>
>

I'll put some more thought into this.

Although I like the idea of it, I'll probably pass on parsing
/etc/fstab.  Without new root being mounted, we won't have direct
access to it, so it would have to be copied elsewhere into the initrd
when its made, and the initrd would need to be remade every time the
fstab changed.  (Granted some changes wouldn't affect what the
srp-boot script needed to do.)  I think the script would have to also
have to determine which mountpoints needed to be brought up.  I think
it would need a good understanding of the device and filesystem types,
to be able to recognize which entries it should strive for.  It would
need to know to ignore nfs, bind, cifs, etc.  Also, there's a small
delay in when a device becomes available and udev shows it in
/dev/disk/by-*.  (Without a delay, my install scripts don't see new
entries there on the command ran after fdisk, mdadm create, mkfs.*,
etc.)

Good point about an IB success doesn't meen new root is connected.

I'm thinking possibly for each /sys/class/infiniband_srp/* retrying 3
times like you mention, or if it matches the sBFT's ib_source_gid
retrying many more times (100 maybe) due to the delay in being able to
use it after iPXE, which as I describe below turns out to be
interaction with opensm, and of course on a success of an
infiniband_srp not retrying that specific one anymore.  Probably only
trying ones where the ports phys_state is PortConfigurationTraining or
LinkUp.


>>>>  The 4.7.1 target logs show:
>>>>
>>>> [ ... ]
>>>> [   95.757202] ib_srpt srpt_queue_response: sending cmd response
>>>> failed for tag 0 (-22)
>>>
>>>
>>> Which HCA model are you using at the target side? Error code -22
>>> (-EINVAL)
>>> comes from the IB HW driver.
>>
>>
>> On both machines, a Mellanox MT26428 which is a ConnectX-2, but lspci
>> shows "[ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE] (rev b0)."
>> Shouldn't be relevant, but both on the most recent Mellanox 2.9.1000
>> firmware.
>>
>> Using the mlx4_core and mlx4_ib modules.
>>
>> Other target InfiniBand programs remain same versions on the 4.6.4
>> test which fails for 10-30 seconds then succeeds, and the 4.7.0 test
>> which permanently fails.  opensm 3.3.20, libibmad 1.3.12, libibumad
>> 1.3.10.2, libibverbs 1.2.1.
>>
>> I also checked target's /var/log/opensm.log, in case there might be
>> something useful.  But, the log with target running 4.6.4 vs 4.7.0 is
>> the same, with the process of iPXE (booting, dhcp, sanhook, sanboot),
>> then the srp-boot script.
>
>
> Did the "srpt_queue_response: sending cmd response failed for tag 0 (-22)"
> error message only occur with the v4.7.0 kernel or also with the v4.7.1
> kernel? The code of which I think that it is most likely that it triggered
> the -EINVAL return code is the (wr->num_sge > qp->sq.max_gs) test in
> mlx4_ib_post_send(). Patch "IB/srpt: Limit the number of SG elements per
> work request" is present in kernel v4.7.1 but not in v4.7.0. That patch
> ensures that num_sge is below the device limits.
>
> Bart.

The "failed for tag 0 (-22)" occurs also with the v4.7.1 kernel.
That's where I first experienced it.  I upgraded straight from v4.6.4
to v4.7.1, only coming back to v4.7.0 to see where the failure
started.

That being said, I just double checked v4.7.1 with hard-drive booting,
and there's no "failed for tag 0 (-22)" error and SRP connections work
fine with it.  But, v4.7.1 still fails with that error with SRP
booting.

Looks like the commit you mentioned, d15cc043 (limit number of SG
elements), didn't make it into 4.7.1, but is in 4.7.2.

SRP booting works with a target on 4.7.2, just like it did on 4.6.4!
No "failed for tag 0 (-22)" errors.

And your earlier comments about the SA/SM led me to seeing that the
delay connecting via SRP after iPXE happening on 4.6.4 & 4.7.2 is due
to the first opensm sweep after kernel boot marking the SM port as
down and entering discovering, and only on the subsequent opensm sweep
marking the SM port as up.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
