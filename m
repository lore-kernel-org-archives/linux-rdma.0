From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 0/4] opensm: dump PathRecords file
Date: Thu, 08 Apr 2010 16:28:42 +0300
Message-ID: <4BBDDA0A.7040901@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schut <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

One of the major bottlenecks of the OpenSM is handling
SA queries storm. In order to allow all-2-all communication,
SA must process N^2 PathRecord queries.
On large clusters this takes way too much time.

Currently, most of the MPI implementations do not query SA
at all in order to avoid this problem, but use predefined
parameters when communicating between fabric nodes.

This works fine as long as MPI doesn't need to use different
parameters for different path, but it's a problem when we're
talking about non-trivial QoS settings or routing engines that
are using IB VLs (such as Torus-2QoS).

The following patch series enables OpenSM to dump core
information from PathRecords that is needed for opening
communication channel: SL, MTU and Rate.

This information is dumped for for all the non-switch-2-non-switch
paths in the subnet in the following way:

    for every non-switch source port
        for every non-switch target LID in the subnet
            dump PR between source port and target LID

This way number of sources is equal to number of physical
non-switch ports in the subnet, and only number of targets
depends on LMC that is used.

Patches:

  [PATCH 1/4] opensm: added function that dumps PathRecords
  [PATCH 2/4] opensm: added 2 options: dump PRs and filename
  [PATCH 3/4] opensm: dump PRs after every heavy sweep and
              after reroute
  [PATCH 4/4] opensm: add command line argument to dump PR file


Signed-off-by:  Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
