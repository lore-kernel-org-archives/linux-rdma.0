From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [Bug 176901] New: Running ib_rdma_bw over rxe loopback triggers a
 kernel oops
Date: Fri, 7 Oct 2016 09:49:07 -0700
Message-ID: <9822c558-91d0-8d6a-8f64-07949d9fdaf7@sandisk.com>
References: <bug-176901-11804@https.bugzilla.kernel.org/>
 <CAG53R5X-=b1RFR87ieL4e=ANTV0JfjO6qm8_AdXWeudQQ17oSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5X-=b1RFR87ieL4e=ANTV0JfjO6qm8_AdXWeudQQ17oSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/06/16 20:28, Parav Pandit wrote:
> On Fri, Oct 7, 2016 at 4:53 AM,  <bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=176901
> This bug is fixed with my patch [1] and Doug ack also about merging fix.
>
> [1] https://patchwork.kernel.org/patch/9354863/

Hello Parav,

Thank you for the feedback. Do you perhaps know which branch Doug will 
send to Linus? I haven't found any post-v4.8 rxe changes in Doug's 
for-4.9-good branch:

$ git log --format=oneline v4.8..dledford/k.o/for-4.9-good 
drivers/infiniband/sw include/uapi/rdma/*rxe*
60747ef4d173c2747bf7f0377fb22846cb422195 Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net

Something else I was wondering about is whether or not the rdma_rxe 
driver should allow being attached to a bridge interface? Apparently the 
rdma_rxe driver allows attaching to both the non-bridged and the bridged 
interfaces, resulting in duplicate GIDs:

# modprobe rdma_rxe
# brctl addbr virbr0
# brctl addif virbr0 eth1
# rxe_cfg add eth1
# rxe_cfg add virbr0
# rxe_cfg
   Name    Link  Driver      Speed  NMTU  IPv4_addr      RDEV  RMTU
   eth0    yes   virtio_net         1500  192.168.1.123
   eth1    no    virtio_net         1500                 rxe0
   virbr0  no    bridge             1500                 rxe1
# (cd /sys/class/infiniband && grep -aH '' */ports/*/gids/0)
rxe0/ports/1/gids/0:fe80:0000:0000:0000:5054:00ff:fefd:2e4e
rxe1/ports/1/gids/0:fe80:0000:0000:0000:5054:00ff:fefd:2e4e

Should it ever be allowed that two different ports have the same GID?

Thanks,

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
