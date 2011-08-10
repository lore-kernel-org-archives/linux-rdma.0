From: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ibsim: fix non-debug path in run_opensm.sh script
Date: Wed, 10 Aug 2011 10:08:09 -0600
Message-ID: <4E42ACE9.4060106@obsidianresearch.com>
References: <E1QpTpr-00026L-B8@rvml.edm.orcorp.ca> <20110809145727.GB2056@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110809145727.GB2056-iQai9MGU/dze+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Alex,

On 11-08-09 08:57 AM, Alex Netes wrote
> This is what I get, when running the commands in the old way:
>
> ...
I get:

time: cannot run LD_PRELOAD=scripts/../umad2sim/libumad2sim.so: No such 
file or directory
Command exited with non-zero status 127
0.00user 0.00system 0:00.00elapsed ?%CPU (0avgtext+0avgdata 
1344maxresident)k
0inputs+0outputs (0major+70minor)pagefaults 0swaps


     Rolf
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
