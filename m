From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5 for rdma-core] Five rxe_cfg patches
Date: Sat, 8 Oct 2016 03:12:45 +0530
Message-ID: <CAG53R5XMwgs6rj9cMnniHk8xvYqk9zxOv1Nuhog3CJfNCpmDFg@mail.gmail.com>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
 <20161007190224.GB27537@obsidianresearch.com> <c1901fd9-3620-50ec-0db3-9b271fd1e90b@sandisk.com>
 <20161007210038.GA9810@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161007210038.GA9810-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason, Bart,

On Sat, Oct 8, 2016 at 2:30 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Fri, Oct 07, 2016 at 01:51:59PM -0700, Bart Van Assche wrote:
>
>> Do you think the names of the network interfaces to which the rdma_rxe
>> driver should bind should be stored in a separate file? To me this looks
>> like a suboptimal approach. Shouldn't we drop the /var/rxe/rxe file
>> completely and add a new boolean to the files in which other network
>> interface parameters are already stored, e.g.
>> /etc/NetworkManager/system-connections/* ?
>
> I honestly don't know much about how rxe works, I was just looking
> at the bogus path.
>
> In today's world this should probably be handled by adding systemd unit
> files to set up rxe.. ??
>
> Something with network manager also seems to make some kind of sense
> on the surface.
>

Instead of relying on user land to do configuration of different OS
flavors, I am considering to auto create rxe interfaces via netdev
notifier for all the network interfaces which gets newly added.
May be through some sort of attach()/detach() ops().
netdev driver will have choice to reject/accept such calls. So that
mlx4_ib is already loaded, it can reject his call from rdma_rxe.
Since the ratio of netdev devices which support RDMA to devices which
doesn't support RDMA is much large, I do not intent to add _ops() to
netdev but rather to have API through which this can be done.
Need to think little more to comeup with RFC.
Other than dev envionrments its unlikely that users want to play with
PMTU configuration. So I was thinking to do do least amount of
configuration using rxe_cfg going forward.




> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
