From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Bug 176901] New: Running ib_rdma_bw over rxe loopback triggers a
 kernel oops
Date: Sat, 8 Oct 2016 04:54:31 +0530
Message-ID: <CAG53R5WZh2NTQ_FPE0RQ-vuSb11LVhgyFpSLsgLtP04qQOkyLQ@mail.gmail.com>
References: <bug-176901-11804@https.bugzilla.kernel.org/> <CAG53R5X-=b1RFR87ieL4e=ANTV0JfjO6qm8_AdXWeudQQ17oSA@mail.gmail.com>
 <9822c558-91d0-8d6a-8f64-07949d9fdaf7@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9822c558-91d0-8d6a-8f64-07949d9fdaf7-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On Fri, Oct 7, 2016 at 10:19 PM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> Hello Parav,
>
>
> Something else I was wondering about is whether or not the rdma_rxe driver
> should allow being attached to a bridge interface?

My take is it should not to avoid mis configurations.
Below fix is required, which I tested to not allow on bridge type devices.
I will send formal patch.

diff --git a/drivers/infiniband/sw/rxe/rxe_sysfs.c
b/drivers/infiniband/sw/rxe/rxe_sysfs.c
index cf8e778..7f4e0f3 100644
--- a/drivers/infiniband/sw/rxe/rxe_sysfs.c
+++ b/drivers/infiniband/sw/rxe/rxe_sysfs.c
@@ -90,7 +90,11 @@ static int rxe_param_set_add(const char *val, const
struct kernel_param *kp)
                err = -EINVAL;
                goto err;
        }
-
+       if (netif_is_bridge_master(ndev)) {
+               pr_err("bridge device %s is unsupported\n", intf);
+               err = -EINVAL;
+               goto err;
+       }
        if (net_to_rxe(ndev)) {
                pr_err("rxe: already configured on %s\n", intf);
                err = -EINVAL;

> Apparently the rdma_rxe
> driver allows attaching to both the non-bridged and the bridged interfaces,
> resulting in duplicate GIDs:
>
> # modprobe rdma_rxe
> # brctl addbr virbr0
> # brctl addif virbr0 eth1
> # rxe_cfg add eth1
> # rxe_cfg add virbr0
> # rxe_cfg
>   Name    Link  Driver      Speed  NMTU  IPv4_addr      RDEV  RMTU
>   eth0    yes   virtio_net         1500  192.168.1.123
>   eth1    no    virtio_net         1500                 rxe0
>   virbr0  no    bridge             1500                 rxe1
> # (cd /sys/class/infiniband && grep -aH '' */ports/*/gids/0)
> rxe0/ports/1/gids/0:fe80:0000:0000:0000:5054:00ff:fefd:2e4e
> rxe1/ports/1/gids/0:fe80:0000:0000:0000:5054:00ff:fefd:2e4e
>
> Should it ever be allowed that two different ports have the same GID?
>
Not sure. It might be allowed LAG mode (at least IP based GID).
I am not upto date of recent LAG updates from Leon.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
