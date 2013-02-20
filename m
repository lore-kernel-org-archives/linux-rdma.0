From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH]: infiniband-diags/ibqueryerrors.c: obtain destination
 sl before perf query
Date: Wed, 20 Feb 2013 10:46:43 -0800
Message-ID: <20130220104643.4b94e69075641d13a91ca3c8@llnl.gov>
References: <20130220115807.GC20018@r-ufm5-17.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130220115807.GC20018-Kyg1NGsloJ/nXW+7WiO5SxL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

First off thanks, this is really needed.

On Wed, 20 Feb 2013 13:58:07 +0200
Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

>    1) if use -G or -D option : by default we obtain sl before doing perf query.
>    2) if no destination is given : we don't obtain sl,for every pair
> source-destination we use sl=0.
>    3) if no destination is given and use -W option : we obtain sl to all nodes
> in the fabric, then we use the right sl for each pair source-destination.

I think the default should be to query the SA for both 1 and 2.  3 should be an option to _skip_ the query.  Skipping the query could also allow a full SMP scan which your previous patch removed.  This allows for operation in a degraded mode when the SM is either broken or crippled.  This is particularly compounded when you may be fighting hardware errors which you would be using ibqueryerrors to identify.

Could you rework the patch with the above requirements?  Also update the documentation for the new option.

Thanks,
Ira

> 
>     Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  src/ibqueryerrors.c |   84 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 82 insertions(+), 2 deletions(-)
> 
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 6320972..01bbb5a 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -55,11 +55,14 @@
>  #include <infiniband/mad.h>
>  
>  #include "ibdiag_common.h"
> +#include "ibdiag_sa.h"
>  
>  struct ibmad_port *ibmad_port;
>  static char *node_name_map_file = NULL;
>  static nn_map_t *node_name_map = NULL;
>  static char *load_cache_file = NULL;
> +static uint16_t lid2sl_table[sizeof(uint8_t) * 1024 * 48] = { 0 };
> +static int half_world_query = 0;
>  
>  int data_counters = 0;
>  int data_counters_only = 0;
> @@ -78,6 +81,8 @@ unsigned clear_errors = 0, clear_counts = 0, details = 0;
>  #define PRINT_ROUTER 0x4
>  #define PRINT_ALL 0xFF		/* all nodes default flag */
>  
> +#define DEFAULT_HALF_WORLD_PR_TIMEOUT (3000)
> +
>  struct {
>  	int nodes_checked;
>  	int bad_nodes;
> @@ -298,6 +303,51 @@ static int print_summary(void)
>  	return (summary.bad_ports);
>  }
>  
> +static void insert_lid2sl_table(struct sa_query_result *r)
> +{
> +	unsigned int i;
> +	for (i = 0; i < r->result_cnt; i++) {
> +		ib_path_rec_t *p_pr = (ib_path_rec_t *)sa_get_query_rec(r->p_result_madw, i);
> +		lid2sl_table[cl_ntoh16(p_pr->dlid)] = ib_path_rec_sl(p_pr);
> +	}
> +}
> +
> +static int path_record_query(int src_lid,int dest_lid)
> +{
> +	ib_path_rec_t pr;
> +	ib_net64_t comp_mask = 0;
> +	uint8_t reversible = 0;
> +	struct sa_handle * h;
> +
> +	h = sa_get_handle();
> +	ibd_timeout = DEFAULT_HALF_WORLD_PR_TIMEOUT;
> +	memset(&pr, 0, sizeof(pr));
> +
> +	CHECK_AND_SET_VAL(src_lid, 16, 0, pr.slid, PR, SLID);
> +	CHECK_AND_SET_VAL(dest_lid, 16, 0, pr.dlid, PR, DLID);/*if dlid is 0 then we do half world query*/
> +	CHECK_AND_SET_VAL(1, 8, -1, pr.num_path, PR, NUMBPATH);/*to get only one PathRecord for each source and destination pair*/
> +	CHECK_AND_SET_VAL(1, 8, -1, reversible, PR, REVERSIBLE);/*for a reversible path*/
> +	pr.num_path |= reversible << 7;
> +	struct sa_query_result result;
> +	int ret = sa_query(h, IB_MAD_METHOD_GET_TABLE,
> +			   (uint16_t)IB_SA_ATTR_PATHRECORD,0,cl_ntoh64(comp_mask),ibd_sakey,
> +			   &pr, sizeof(pr), &result);
> +	if (ret) {
> +		fprintf(stderr, "Query SA failed: %s; sa call path_query failed\n", strerror(ret));
> +		return ret;
> +	}
> +	if (result.status != IB_SA_MAD_STATUS_SUCCESS) {
> +		sa_report_err(result.status);
> +		ret = EIO;
> +		goto Exit;
> +	}
> +
> +	insert_lid2sl_table(&result);
> +Exit:
> +	sa_free_result_mad(&result);
> +	return ret;
> +}
> +
>  static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
>  			  ibnd_node_t * node, char *node_name, int portnum,
>  			  const char *attr_name, uint16_t attr_id,
> @@ -447,6 +497,8 @@ static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
>  	uint8_t pc[1024] = { 0 };
>  	uint16_t rc_cap_mask;
>  
> +	portid->sl = lid2sl_table[portid->lid];
> +
>  	/* PerfMgt ClassPortInfo is a required attribute */
>  	if (!pma_query_via(pc, portid, portnum, ibd_timeout, CLASS_PORT_INFO,
>  			   ibmad_port)) {
> @@ -474,6 +526,8 @@ static int print_data_cnts(ib_portid_t * portid, uint16_t cap_mask,
>  
>  	memset(pc, 0, 1024);
>  
> +	portid->sl = lid2sl_table[portid->lid];
> +
>  	if (cap_mask & (IB_PM_EXT_WIDTH_SUPPORTED | IB_PM_EXT_WIDTH_NOIETF_SUP)) {
>  		if (!pma_query_via(pc, portid, portnum, ibd_timeout,
>  				   IB_GSI_PORT_COUNTERS_EXT, ibmad_port)) {
> @@ -543,6 +597,8 @@ static int print_errors(ib_portid_t * portid, uint16_t cap_mask,
>  	memset(pc, 0, 1024);
>  	memset(pce, 0, 1024);
>  
> +	portid->sl = lid2sl_table[portid->lid];
> +
>  	if (!pma_query_via(pc, portid, portnum, ibd_timeout,
>  			   IB_GSI_PORT_COUNTERS, ibmad_port)) {
>  		IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d",
> @@ -830,6 +886,9 @@ static int process_opt(void *context, int ch, char *optarg)
>  	case 'D':
>  		dr_path = strdup(optarg);
>  		break;
> +	case 'W':
> +		half_world_query = 1;
> +		break;
>  	case 'r':
>  		port_config++;
>  		break;
> @@ -858,6 +917,8 @@ int main(int argc, char **argv)
>  	ib_portid_t portid = { 0 };
>  	int rc = 0;
>  	ibnd_fabric_t *fabric = NULL;
> +	int self_lid = 0;
> +	int port = 0;
>  
>  	int mgmt_classes[4] = { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_CLASS,
>  		IB_PERFORMANCE_CLASS
> @@ -875,6 +936,8 @@ int main(int argc, char **argv)
>  		 "Same as \"-G\" for backward compatibility"},
>  		{"Direct", 'D', 1, "<dr_path>",
>  		 "report the node containing the port specified by <dr_path>"},
> +		{"obtain-sl", 'W', 0, NULL,
> +		"obtain SL to all destinations from local source port"},
>  		{"report-port", 'r', 0, NULL,
>  		 "report port link information"},
>  		{"threshold-file", 8, 1, NULL,
> @@ -933,6 +996,11 @@ int main(int argc, char **argv)
>  
>  	/* limit the scan the fabric around the target */
>  	if (dr_path) {
> +		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0) {
> +			IBERROR("can't resolve self port %s", argv[0]);
> +			goto close_port;
> +		}
> +		self_lid = portid.lid;
>  		if ((resolved =
>  		     resolve_portid_str(ibd_ca, ibd_ca_port, &portid, dr_path,
>  					IB_DEST_DRPATH, NULL, ibmad_port)) < 0) {
> @@ -947,6 +1015,13 @@ int main(int argc, char **argv)
>  			IBWARN("Failed to resolve %s;",port_guid_str);
>  			goto close_port;
>  		}
> +		lid2sl_table[portid.lid] = portid.sl;
> +	} else {
> +		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0) {
> +			IBERROR("can't resolve self port %s", argv[0]);
> +			goto close_port;
> +		}
> +		self_lid = portid.lid;
>  	}
>  
>  	if (load_cache_file) {
> @@ -996,12 +1071,17 @@ int main(int argc, char **argv)
>  
>  		port = ibnd_find_port_guid(fabric, port_guid);
>  		if (port) {
> +			if(path_record_query(self_lid,port->base_lid))
> +				goto close_port;
>  			print_node(port->node, NULL);
>  		} else
>  			fprintf(stderr, "Failed to find node: %s\n", dr_path);
> -	} else
> +	} else {
> +		if(half_world_query)
> +			if(path_record_query(self_lid,0))
> +				goto close_port;
>  		ibnd_iter_nodes(fabric, print_node, NULL);
> -
> +	}
>  	rc = print_summary();
>  	if (rc)
>  		rc = 1;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
