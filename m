From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 0/4] Sockperf: Initial multi-threaded throughput client
Date: Mon, 18 Dec 2017 10:26:42 -0500
Message-ID: <cover.1513609601.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During testing, it has become painfully clear that a single threaded UDP
test client can not exercise a 100Gig link due to issues related to
single core maximum throughput.  This patchset implements a
multi-threaded throughput test in sockperf.  This is just an initial
implementation, there is still more work to be done.  In particular:

1) Although the speed improved with this change, it did not improve
drastically.  As soon as the client send bottleneck was removed, it
became clear there is another bottleneck on the server.  When sending to
a server from one client, all data is received on a single queue pair,
and due to how interrupts are spread in the RDMA stack (namely that each
queue pair goes to a single interrupt and we rely on multiple queue
pairs being in use to balance interrupts across different cores), we
take all interrupts from a specific host on a single core and the
receiving side then becomes the bottleneck with single core IPoIB
receive processing being the limiting factor.  On a slower machine, I
clocked 30GBit/s throughput.  On a faster machine as the server, I was
able to get up to 70GBit/s throughput.

2) I thought I might try an experiment to get around the queue pair is
on one CPU issue.  We use P_Keys in our internal lab setup, and so on
the specific link in question, I actually have a total of three
different IP interfaces on different P_Keys.  I tried to open tests on
multiple of these interfaces to see how that would impact performance
(so a multithreaded server listening on ports on three different P_Key
interfaces all on the same physical link, which should use three
different queue pairs, and a multithreaded client sending to those three
different P_Key interfaces from three different P_Key interfaces of its
own).  It tanked it.  Like less than gigabit ethernet speeds.  This
warrants some investigation moving forward I think.

3) I thought I might try sending from two clients to the server at once
and summing their throughput.  That was fun.  With UDP the clients are
able to send enough data that flow control on the link kicks in, at
which point each client starts dropping packets on the floor (they're
UDP after all), and so the net result is that one client claimed
200GBit/s and the other about 175GBit/s.  Meanwhile, the server thought
we were just kidding and didn't actually run a test at all.

4) I reran the test using TCP instead of UDP.  That's a non-starter.
Whether due to my changes, or just because it is the way it is, the TCP
tests all failed.  For larger message sizes, they failed instantly.  For
smaller message sizes the test might run for a few seconds, but would
eventually fail too.  Always the failure was that the server would get a
message it deemed too large and would forcibly close all of the TCP
connections, at which point the client just bails.

I should point out that I don't program C++.  Issues with me not doing
these patches in a C++ typical manner are related to that.

Doug Ledford (4):
  Rename a few variables
  Move num-threads and cpu-affinity to common opts
  Move server thread handler to SockPerf.cpp
  Initial implementation of threaded throughput client

 src/Client.cpp   | 140 +++++++++++++++---------
 src/Client.h     |   3 +-
 src/Defs.h       |  10 +-
 src/Server.cpp   | 137 +----------------------
 src/SockPerf.cpp | 324 ++++++++++++++++++++++++++++++++++++++++++-------------
 5 files changed, 357 insertions(+), 257 deletions(-)

-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
