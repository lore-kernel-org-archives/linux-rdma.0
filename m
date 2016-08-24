From: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.7.0 ib_srpt Regression - 4.6.4 Got failed path rec status -22
 got worse on 4.7.0
Date: Wed, 24 Aug 2016 06:39:27 -0400
Message-ID: <CA+X5Wn4=BpK-uzF5JHNPP+ZUcuYz54c1PpPsWJPe5sSetr-5cw@mail.gmail.com>
References: <CA+X5Wn46GGnqijVS54A_45_D8g_0cvcZ3iAYbt2J6syiKwqNGA@mail.gmail.com>
 <39412892-aab7-5bf9-7a19-be311dc32050@sandisk.com> <CA+X5Wn7KbG-6Hg2JdOJhteXezgMS5O6DkixOjB3idoWu=UXKJQ@mail.gmail.com>
 <de643a63-7179-4fe6-fef4-4dfa6e733966@sandisk.com> <CA+X5Wn74=TkBoUDiED2-ioqgdNPQ3Gvf=uJxO4RYz0p1jN+M7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn74=TkBoUDiED2-ioqgdNPQ3Gvf=uJxO4RYz0p1jN+M7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 23, 2016 at 7:25 PM, james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Aug 23, 2016 at 12:00 PM, Bart Van Assche
> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>> What would be ideal is to keep looping until either a timeout occurs or all
>> disks needed by /etc/fstab have been found. If parsing /etc/fstab is too
>> hard I propose to try to log in at least three times over each IB port. Even
>> if logging in over one IB port succeeds that doesn't mean that that is the
>> port to which the root disk has been connected.
>>
>>
> I'm thinking possibly for each /sys/class/infiniband_srp/* retrying 3
> times like you mention, or if it matches the sBFT's ib_source_gid
> retrying many more times (100 maybe) due to the delay in being able to
> use it after iPXE, which as I describe below turns out to be
> interaction with opensm, and of course on a success of an
> infiniband_srp not retrying that specific one anymore.  Probably only
> trying ones where the ports phys_state is PortConfigurationTraining or
> LinkUp.

My intention with this script was to only get new root mounted, and
allow something on the new root to handle the rest if there is any,
such as srptools, or a yet to be developed systemd service if srptools
for any reason won't work.  And, all we have at this point is the
sBFT, which the current specifications only support one set of
initiator/target port identifier, source/destination GID, service id,
and partition key.  So, if the bootloader/kernel/initrd start, the
only information we have is guaranteed to lead to the LUN with /boot.
As long as that LUN or another between the same initiator/target has
new root, we'll have that as well.

Supporting more than one target would complicate things further,
basically needing to duplicate part of srptools including an
equivalent to srp_daemon.conf.  So, I think I'll leave it at one
target.  This gives the limitation that it won't support new root
being on another target than /boot.  (Separate LUNs on the same target
is certainly OK, and is how I'm running.)  I think that's a reasonable
limitation.

Updated the github srp-boot script.

Both kernel arguments are now optional, and probably will never need
to be given.  It searches "/sys/class/infiniband_srp/*" for an entry
whose hca and port_number lead to a gids/0 that matches the sBFT's
ib_source_gid.

It waits for state to be "4: ACTIVE" before writing to add_target,
avoiding the remaining rec status -22 occurring before the SM
connection is made.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
