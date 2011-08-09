From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ibsim: fix non-debug path in run_opensm.sh script
Date: Tue, 9 Aug 2011 17:57:27 +0300
Message-ID: <20110809145727.GB2056@calypso.mtl.com>
References: <E1QpTpr-00026L-B8@rvml.edm.orcorp.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E1QpTpr-00026L-B8-nLM+XIojDeH72zTlGHhC+rDks+cytr/Z@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Rolf,

On 17:29 Fri 05 Aug     , Rolf Manderscheid wrote:
> 
> Signed-off-by: Rolf Manderscheid <rvm-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  scripts/run_opensm.sh |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/run_opensm.sh b/scripts/run_opensm.sh
> index a225d81..a299dc0 100755
> --- a/scripts/run_opensm.sh
> +++ b/scripts/run_opensm.sh
> @@ -29,7 +29,7 @@ if [ -z "$debug" ] ; then
>  	export SIM_HOST
>  	export OSM_TMP_DIR
>  	export OSM_CACHE_DIR
> -	time LD_PRELOAD=${umad2sim} ${cmd} ${cmd_args}
> +	LD_PRELOAD=${umad2sim} time ${cmd} ${cmd_args}
>  	rc=$?
>  	exit $rc
>  else
> -- 

This is what I get, when running the commands in the old way:

$ time LD_PRELOAD=/home/ibsim/umad2sim/libumad2sim.so smpquery nd -D 0
ibwarn: [18137] sim_connect: attached as client 0 at node "S-0008f10500650bfe"
Node Description:.Voltaire sLB-4018    Line 8  Chip 1 4700 #4700-A368

real	0m0.016s
user	0m0.002s
sys	0m0.013s


This what I get, when running the commands in the new way:

$ LD_PRELOAD=/home/ibsim/umad2sim/libumad2sim.so time smpquery nd -D 0
ibwarn: [18139] sim_connect: attached as client 0 at node "S-0008f10500650bfe"
Node Description:.Voltaire sLB-4018    Line 8  Chip 1 4700 #4700-A368
0.00user 0.01system 0:00.02elapsed 80%CPU (0avgtext+0avgdata 876maxresident)k
0inputs+416outputs (0major+322minor)pagefaults 0swaps


-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
