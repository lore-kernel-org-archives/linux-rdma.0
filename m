From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: mlx4 catas_reset hangs when using the CM
Date: Thu, 29 Mar 2012 13:41:10 +0200
Message-ID: <20120329134110.0683d873@b012350-ux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vincent <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>, Celine <Celine.Bourde-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hi,

  when the mlx4 FW generate an internal error, the driver's catas code tries to
reset the HCA and restart the stack. However if the CM is in use at that moment,
the stack shutdown never completes and hangs in the CM waiting for a refcount
that never reaches 0.

  I've not much knowledge of how the CM works, but I have the following stack:

crash> ps mlx4
   PID    PPID  CPU       TASK        ST  %MEM     VSZ    RSS  COMM
   5166      2   0  ffff88033c779040  UN   0.0       0      0  [mlx4]
crash> bt 5166
PID: 5166   TASK: ffff88033c779040  CPU: 0   COMMAND: "mlx4"
 #0 [ffff880336113a30] schedule at ffffffff8147dddc
 #1 [ffff880336113af8] schedule_timeout at ffffffff8147eb25
 #2 [ffff880336113ba8] wait_for_common at ffffffff8147e767
 #3 [ffff880336113c38] wait_for_completion at ffffffff8147e8cd
 #4 [ffff880336113c48] cma_remove_one at ffffffffa03ada3e [rdma_cm]
 #5 [ffff880336113ce8] ib_unregister_device at ffffffffa01f7677 [ib_core]
 #6 [ffff880336113d28] mlx4_ib_remove at ffffffffa036a0b9 [mlx4_ib]
 #7 [ffff880336113d58] mlx4_remove_device at ffffffffa0340fb4 [mlx4_core]
 #8 [ffff880336113d88] mlx4_unregister_device at ffffffffa034100b [mlx4_core]
 #9 [ffff880336113da8] mlx4_remove_one at ffffffffa034180e [mlx4_core]
#10 [ffff880336113dd8] mlx4_restart_one at ffffffffa0344c46 [mlx4_core]
#11 [ffff880336113df8] catas_reset at ffffffffa033b115 [mlx4_core]
#12 [ffff880336113e38] worker_thread at ffffffff810749a0
#13 [ffff880336113ee8] kthread at ffffffff81079f36
#14 [ffff880336113f48] kernel_thread at ffffffff810041aa


  and the following cma_device data:

crash> cma_device 0xffff88033c04f1c0
struct cma_device {
  list = {
    next = 0xdead000000100100, 
    prev = 0xdead000000200200
  }, 
  device = 0xffff8802e06b0000, 
  comp = {
    done = 0, 
    wait = {
      lock = {
        raw_lock = {
          slock = 65537
        }
      }, 
      task_list = {
        next = 0xffff880336113be8, 
        prev = 0xffff880336113be8
      }
    }
  }, 
  refcount = {
    counter = 1
  }, 
  id_list = {
    next = 0xffff88033c04f200, 
    prev = 0xffff88033c04f200
  }
}


  So it looks like that cma_process_remove() did all it's job cleaning up
but is hung waiting for the client refcount to reach 0, which never happens.

  This happens with OFED from 1.5.3 to 1.5.4.1.


  The steps to reproduce:

  1. start a qperf using the CM between 2 nodes (client and victim):

victim$ qperf
client$ qperf victim -cm 1 -t 10000 rc_bw

  2. trigger a catas reset on the victim node by writing something <> 0 at the
     HEAD of the mlx4 error buffer:

victim# mstmwrite mlx4_0 0x1f020 1


  Sebastien.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
