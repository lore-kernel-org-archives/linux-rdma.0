From: Eli Cohen <eli@dev.mellanox.co.il>
Subject: dropped packets when IP forwarding
Date: Mon, 3 May 2010 18:31:54 +0300
Message-ID: <20100503153154.GB5734@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-net-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-net-owner@vger.kernel.org
To: linux-net@vger.kernel.org, Linux RDMA list <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I am trying to check the forwarding rate between two net devices on my
machine. What I see is that when the rate gets higher than some
thresohld, the reception rate can still increase but the trasnmit rate
reaches a maximum. At this point I assume packets get dropped. When
looking at the CPU utilization I see that they're around 50% so the
CPUs can do work. I also see that the trasmit queue is not stopped so
I think that maybe the IP layer drops them (lack of buffers?). Does
anyone have an idea?

