From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: intel iommu causing performance drop in mlx4 ipoib
Date: Mon, 16 May 2016 13:39:03 +0300
Message-ID: <5739A347.20807@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello, 

I've been testing various infiniband cards for performance and one of 
them is the a ConnectX-3: Mellanox Technologies MT27500 Family [ConnectX-3]. 

I've observed a strange performance pathology with it when running ipoib 
and using a naive iperf test. My setup has multiple machines with a mix 
of qlogic/mellanox cards, connected via an QLogic 12300 switch. All of 
the nodes are running on 4x 10Gbps. When I run  a performance test and 
the mellanox card is a server i.e it is receiving data I get very bad 
performance. By this I mean I cannot get more than 4 gigabits per 
second - very low. 'perf top' clearly shows that the culprit is 
intel_map_page which is being called form the receive path 
of the mellanox adapter: 

84.26%     0.04%  ksoftirqd/0  [kernel.kallsyms]  [k] intel_map_page                            
            |
            --- intel_map_page
               |          
               |--98.38%-- ipoib_cm_alloc_rx_skb
               |          ipoib_cm_handle_rx_wc
               |          ipoib_poll
               |          net_rx_action
               |          __do_softirq
               |          run_ksoftirqd
               |          smpboot_thread_fn
               |          kthread
               |          ret_from_fork


When I disable intel_iommu support (By defualt the iommu is not 
turned on, just compiled, with this performance profile I have 
compiled out the code altogether) things look very differently:

         86.76%     0.16%  ksoftirqd/0  [kernel.kallsyms]  [k] ipoib_poll                                
            |
            --- ipoib_poll
                net_rx_action
                __do_softirq



Essentially the majority is spent in just receiving the packets and the 
sustained rate is 26Gbps. So the question why does compiling in (but not 
enabling intel_iommu=on kills performance) only on the receive side, e.g. if 
the machine which exhibits poor performance with the mlx card is a client, 
that is the mellanox driver is sending data the performance is not affected. 
So far the only workaround is to remove intel iommu support in the kernel 
altogether. 

Regards, 
Nikolay
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
