From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Slow performance of IPoIB on Qlogic card
Date: Thu, 12 May 2016 15:03:57 +0300
Message-ID: <5734712D.5010507@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,


I have 2 machines which are connected via an infiniband switch and are
using the QLogic 12300 switch and InfiniPath_QLE7340 adapter. I'm
running a very naive iperf test between the 2 machines. When running an
upstream elrepo kernel 4.4.4-1.el6.elrepo.x86_64 I can do around
15-18gbit which is sort of the max in my setup. At the same time I'm
also seeing a lot of sdmaP interrupts being served.

When I boot the client iperf machine with my custom built machine I'm
barely able to get more than 4gbit/s. At the same time I'm seeing a lot
of sdmaI interrupts being served.

After some investigation it turned out that changing CONFIG_HZ to 1000
(from 100) put the performance of my custom built kernel on par with the
elrepo one. Despite iperf showing a 4x increase in bandwidth I still see
a lot of sdmaI interrupt and not much sdmaP.

Another interesting this is the output of 'perf top -g'. With
CONFIG_HZ=100 the profile is dominated by 'cpuidle_enter' while iperf is
running i.e. that my machine is almost idle. With CONFIG_HZ=1000 the
profile is dominated by qib_verbs_send/qib_do_send/worker_thread which I
believe is the expected behavior.

Given that I have the following questions:

1. What does the sdmaI/sdmaP interrupts mean. Looking around the code
and ML it seems they I stands for Idle and P for progress. But other
than that this doesn't mean much to me, can you expand on their meaning?

2. Is it bad that more sdmaI interrupts are coming rather than sdmaP.
Currently they seem to be on the same core(0)

3. Why does changing the timer tick-rate have such a tremendous impact
on the performance?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
