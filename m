From: Evgenii Smirnov <evgenii.smirnov-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: ib_post_send execution time
Date: Thu, 23 Oct 2014 19:21:24 +0200
Message-ID: <CAEv+Kc1mioxX+pUky3a9Wfd8HzzOTAqyjw0tgdf4Qu2956hOaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

I am trying to achieve high packet per second throughput with 2-byte
messages over Infiniband from kernel using IB_SEND verb. The most I
can get so far is 3.5 Mpps. However, ib_send_bw utility from perftest
package is able to send 2-byte packets with rate of 9 Mpps.
After some profiling I found that execution of ib_post_send function
in kernel takes about 213 ns in average, for the user-space function
ibv_post_send takes only about 57 ns.
As I understand, these functions do almost same operations. The work
request fields and queue pair parameters are also the same. Why do
they have such big difference in execution times?

I'm using:
Debian Jessie
kernel 3.16-2-amd64
libibverbs1 (1.1.8-1)
libmlx4-1 (1.0.6-1)
perftest (2.3+0.12.gcb5b746-1)
ConnectX-3 VPI adapter MT_1090110018 fw_ver: 2.32.5100
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
