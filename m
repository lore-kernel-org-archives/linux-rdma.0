From: Ira Weiny <weiny2@llnl.gov>
Subject: Re: [ofa-general] [PATCH] infiniband-diags: Fix IB network
	discovery from switch node.
Date: Wed, 23 Sep 2009 17:24:51 -0700
Message-ID: <20090923172451.fb20ab9b.weiny2@llnl.gov>
References: <4A9548AA.4020900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <4A9548AA.4020900@gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, OpenIB <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

Eli,

On Wed, 26 Aug 2009 17:37:30 +0300
"Eli Dorfman (Voltaire)" <dorfman.eli@gmail.com> wrote:

> Subject: [PATCH] Fix IB network discovery from switch node.

Sorry for the late inquiry on this but what exactly was the bug here?

I just found that this change introduced a bug.  The problem is that if you
don't do this query, even when the first found node is a switch, the port you
came into the switch on will not get reported properly.  Here is what I mean.

Running with the current master:

17:19:42 > ./iblinkinfo -S 0x000b8cffff00490c
Switch 0x000b8cffff00490c MT47396 Infiniscale-III Mellanox Technologies:
           8    1[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
...
           8    9[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
           8   10[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>      15   24[  ] "ISR9024D Voltaire" ( )
           8   11[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
           8   12[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>             [  ] "" ( )
           8   13[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
...

The DR path "came in" on port 12 and is reported as Active/LinkUp but has no
information on the other end.  Here is what the output should look like with
your change removed.

17:22:36 > ./iblinkinfo -S 0x000b8cffff00490c
Switch 0x000b8cffff00490c MT47396 Infiniscale-III Mellanox Technologies:
           8    1[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
...
           8    9[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
           8   10[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>      15   24[  ] "ISR9024D Voltaire" ( )
           8   11[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
           8   12[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>       7    8[  ] "Cisco Switch SFS7000D" ( )
           8   13[  ] ==( 4X 2.5 Gbps   Down/ Polling)==>             [  ] "" ( )
...

This properly reports the other end of this link as another switch.

Could you explain the problem a bit more so we can come up with a better
solution?

Thanks,
Ira

> 
> Signed-off-by: Eli Dorfman <elid@voltaire.com>
> ---
>  infiniband-diags/libibnetdisc/src/ibnetdisc.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> index c69467e..779e659 100644
> --- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> +++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
> @@ -590,13 +590,15 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
>  	if (!port)
>  		goto error;
>  
> -	rc = get_remote_node(ibmad_port, fabric, node, port, from,
> -			     mad_get_field(node->info, 0,
> -					   IB_NODE_LOCAL_PORT_F), 0);
> -	if (rc < 0)
> -		goto error;
> -	if (rc > 0)		/* non-fatal error, nothing more to be done */
> -		return ((ibnd_fabric_t *) fabric);
> +	if (node->node.type != IB_NODE_SWITCH) { 
> +		rc = get_remote_node(ibmad_port, fabric, node, port, from,
> +				     mad_get_field(node->info, 0,
> +						   IB_NODE_LOCAL_PORT_F), 0);
> +		if (rc < 0)
> +			goto error;
> +		if (rc > 0)		/* non-fatal error, nothing more to be done */
> +			return ((ibnd_fabric_t *) fabric);
> +	}
>  
>  	for (dist = 0; dist <= max_hops; dist++) {
>  
> -- 
> 1.5.5
> 
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://*lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit http://*openib.org/mailman/listinfo/openib-general
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2@llnl.gov
