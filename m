From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCHv2] infiniband-diags/ibqueryerrors.c: obtain destination
 sl before perf query
Date: Tue, 26 Feb 2013 17:07:44 -0800
Message-ID: <20130226170744.53adb74b6af9a54d9481dd4c@llnl.gov>
References: <20130220115807.GC20018@r-ufm5-17.lab.mtl.com>
	<20130224082140.GA11648@r-ufm5-17.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130224082140.GA11648-Kyg1NGsloJ/nXW+7WiO5SxL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 24 Feb 2013 10:21:40 +0200
Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> 1) if use -G or -D option : we obtain sl before doing perf query.
> 2) if no destination is given : we obtain sl for every pair source-de=
stination.
> 3) if no destination is given and use --skip-sl option : we don't obt=
ain
> sl to all nodes in the fabric,in this case sl=3D0 for all node pairs.

--skip-sl should apply to all modes.  Sorry if I was not clear about th=
at.

More comments below.

>=20
> Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes since v1:
>         Change 2 and 3: by default we obtain sl. When using skip-sl o=
ption
>         we don't obtain sl.
> 	Add option to documentation.
>=20
>  doc/man/ibqueryerrors.8.in |    3 ++
>  src/ibqueryerrors.c        |   83 ++++++++++++++++++++++++++++++++++=
++++++++-
>  2 files changed, 84 insertions(+), 2 deletions(-)
>=20
> diff --git a/doc/man/ibqueryerrors.8.in b/doc/man/ibqueryerrors.8.in
> index 00b0f61..65e5206 100644
> --- a/doc/man/ibqueryerrors.8.in
> +++ b/doc/man/ibqueryerrors.8.in
> @@ -56,6 +56,9 @@ Report the port information.  This includes LID, po=
rt, external port (if
>  applicable), link speed setting, remote GUID, remote port, remote ex=
ternal port
>  (if applicable), and remote node description information.
>  .sp
> +\fB\-\-skip-sl\fP
> +Use the default sl for queries.
> +.sp
>  \fB\-\-data\fP
>  Include the optional transmit and receive data counters.
>  .sp

This should be added to doc/rst/ibqueryerrors.8.in.rst and then the out=
put from that added to the git tree.

> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 6320972..c35cf6e 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -55,11 +55,14 @@
>  #include <infiniband/mad.h>
> =20
>  #include "ibdiag_common.h"
> +#include "ibdiag_sa.h"
> =20
>  struct ibmad_port *ibmad_port;
>  static char *node_name_map_file =3D NULL;
>  static nn_map_t *node_name_map =3D NULL;
>  static char *load_cache_file =3D NULL;
> +static uint16_t lid2sl_table[sizeof(uint8_t) * 1024 * 48] =3D { 0 };
> +static int half_world_query =3D 1;
> =20
>  int data_counters =3D 0;
>  int data_counters_only =3D 0;
> @@ -78,6 +81,8 @@ unsigned clear_errors =3D 0, clear_counts =3D 0, de=
tails =3D 0;
>  #define PRINT_ROUTER 0x4
>  #define PRINT_ALL 0xFF		/* all nodes default flag */
> =20
> +#define DEFAULT_HALF_WORLD_PR_TIMEOUT (3000)

This is fine for now but it might be nice to have an option for this as=
 well.

> +
>  struct {
>  	int nodes_checked;
>  	int bad_nodes;
> @@ -298,6 +303,51 @@ static int print_summary(void)
>  	return (summary.bad_ports);
>  }
> =20
> +static void insert_lid2sl_table(struct sa_query_result *r)
> +{
> +	unsigned int i;
> +	for (i =3D 0; i < r->result_cnt; i++) {
> +		ib_path_rec_t *p_pr =3D (ib_path_rec_t *)sa_get_query_rec(r->p_res=
ult_madw, i);
> +		lid2sl_table[cl_ntoh16(p_pr->dlid)] =3D ib_path_rec_sl(p_pr);
> +	}
> +}
> +
> +static int path_record_query(int src_lid,int dest_lid)
> +{
> +	ib_path_rec_t pr;
> +	ib_net64_t comp_mask =3D 0;
> +	uint8_t reversible =3D 0;
> +	struct sa_handle * h;
> +
> +	h =3D sa_get_handle();
> +	ibd_timeout =3D DEFAULT_HALF_WORLD_PR_TIMEOUT;
> +	memset(&pr, 0, sizeof(pr));
> +
> +	CHECK_AND_SET_VAL(src_lid, 16, 0, pr.slid, PR, SLID);
> +	CHECK_AND_SET_VAL(dest_lid, 16, 0, pr.dlid, PR, DLID);/*if dlid is =
0 then we do half world query*/
> +	CHECK_AND_SET_VAL(1, 8, -1, pr.num_path, PR, NUMBPATH);/*to get onl=
y one PathRecord for each source and destination pair*/
> +	CHECK_AND_SET_VAL(1, 8, -1, reversible, PR, REVERSIBLE);/*for a rev=
ersible path*/
> +	pr.num_path |=3D reversible << 7;
> +	struct sa_query_result result;
> +	int ret =3D sa_query(h, IB_MAD_METHOD_GET_TABLE,
> +			   (uint16_t)IB_SA_ATTR_PATHRECORD,0,cl_ntoh64(comp_mask),ibd_sak=
ey,
> +			   &pr, sizeof(pr), &result);
> +	if (ret) {
> +		fprintf(stderr, "Query SA failed: %s; sa call path_query failed\n"=
, strerror(ret));
> +		return ret;
> +	}
> +	if (result.status !=3D IB_SA_MAD_STATUS_SUCCESS) {
> +		sa_report_err(result.status);
> +		ret =3D EIO;
> +		goto Exit;
> +	}
> +
> +	insert_lid2sl_table(&result);
> +Exit:
> +	sa_free_result_mad(&result);
> +	return ret;
> +}
> +
>  static int query_and_dump(char *buf, size_t size, ib_portid_t * port=
id,
>  			  ibnd_node_t * node, char *node_name, int portnum,
>  			  const char *attr_name, uint16_t attr_id,
> @@ -447,6 +497,8 @@ static int query_cap_mask(ib_portid_t * portid, c=
har *node_name, int portnum,
>  	uint8_t pc[1024] =3D { 0 };
>  	uint16_t rc_cap_mask;
> =20
> +	portid->sl =3D lid2sl_table[portid->lid];
> +
>  	/* PerfMgt ClassPortInfo is a required attribute */
>  	if (!pma_query_via(pc, portid, portnum, ibd_timeout, CLASS_PORT_INF=
O,
>  			   ibmad_port)) {
> @@ -474,6 +526,8 @@ static int print_data_cnts(ib_portid_t * portid, =
uint16_t cap_mask,
> =20
>  	memset(pc, 0, 1024);
> =20
> +	portid->sl =3D lid2sl_table[portid->lid];
> +
>  	if (cap_mask & (IB_PM_EXT_WIDTH_SUPPORTED | IB_PM_EXT_WIDTH_NOIETF_=
SUP)) {
>  		if (!pma_query_via(pc, portid, portnum, ibd_timeout,
>  				   IB_GSI_PORT_COUNTERS_EXT, ibmad_port)) {
> @@ -543,6 +597,8 @@ static int print_errors(ib_portid_t * portid, uin=
t16_t cap_mask,
>  	memset(pc, 0, 1024);
>  	memset(pce, 0, 1024);
> =20
> +	portid->sl =3D lid2sl_table[portid->lid];
> +
>  	if (!pma_query_via(pc, portid, portnum, ibd_timeout,
>  			   IB_GSI_PORT_COUNTERS, ibmad_port)) {
>  		IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d",
> @@ -822,6 +878,9 @@ static int process_opt(void *context, int ch, cha=
r *optarg)
>  	case 9:
>  		data_counters_only =3D 1;
>  		break;
> +	case 10:
> +		half_world_query =3D 0;
> +		break;
>  	case 'G':
>  	case 'S':
>  		port_guid_str =3D optarg;
> @@ -858,6 +917,8 @@ int main(int argc, char **argv)
>  	ib_portid_t portid =3D { 0 };
>  	int rc =3D 0;
>  	ibnd_fabric_t *fabric =3D NULL;
> +	int self_lid =3D 0;
> +	int port =3D 0;
> =20
>  	int mgmt_classes[4] =3D { IB_SMI_CLASS, IB_SMI_DIRECT_CLASS, IB_SA_=
CLASS,
>  		IB_PERFORMANCE_CLASS
> @@ -875,6 +936,7 @@ int main(int argc, char **argv)
>  		 "Same as \"-G\" for backward compatibility"},
>  		{"Direct", 'D', 1, "<dr_path>",
>  		 "report the node containing the port specified by <dr_path>"},
> +		{"skip-sl", 10, 0, NULL,"don't obtain SL to all destinations"},
>  		{"report-port", 'r', 0, NULL,
>  		 "report port link information"},
>  		{"threshold-file", 8, 1, NULL,
> @@ -933,6 +995,11 @@ int main(int argc, char **argv)
> =20
>  	/* limit the scan the fabric around the target */
>  	if (dr_path) {
> +		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0) {
> +			IBERROR("can't resolve self port %s", argv[0]);
> +			goto close_port;
> +		}
> +		self_lid =3D portid.lid;

I think you should call this before the check for dr_path and not below=
=2E  It is not too expensive to just resolve our local lid with resolve=
_self.

>  		if ((resolved =3D
>  		     resolve_portid_str(ibd_ca, ibd_ca_port, &portid, dr_path,
>  					IB_DEST_DRPATH, NULL, ibmad_port)) < 0) {
> @@ -947,6 +1014,13 @@ int main(int argc, char **argv)
>  			IBWARN("Failed to resolve %s;",port_guid_str);
>  			goto close_port;
>  		}
> +		lid2sl_table[portid.lid] =3D portid.sl;
> +	} else {

This else here is a compile error:

src/ibqueryerrors.c: In function =E2=80=98main=E2=80=99:
src/ibqueryerrors.c:1041: error: =E2=80=98else=E2=80=99 without a previ=
ous =E2=80=98if=E2=80=99


> +		if (resolve_self(ibd_ca, ibd_ca_port, &portid, &port, 0) < 0) {
> +			IBERROR("can't resolve self port %s", argv[0]);
> +			goto close_port;
> +		}
> +		self_lid =3D portid.lid;

I believe calling this here will break the DR mode since the NodeInfo q=
uery used in DR mode uses portid.

>  	}
> =20
>  	if (load_cache_file) {
> @@ -996,12 +1070,17 @@ int main(int argc, char **argv)
> =20
>  		port =3D ibnd_find_port_guid(fabric, port_guid);
>  		if (port) {
> +			if(path_record_query(self_lid,port->base_lid))
> +				goto close_port;

goto destroy_fabric since the fabric object is created at this point.

>  			print_node(port->node, NULL);
>  		} else
>  			fprintf(stderr, "Failed to find node: %s\n", dr_path);
> -	} else
> +	} else {
> +		if(half_world_query)
> +			if(path_record_query(self_lid,0))
> +				goto close_port;

goto destroy_fabric since the fabric object is created at this point.

>  		ibnd_iter_nodes(fabric, print_node, NULL);
> -
> +	}
>  	rc =3D print_summary();
>  	if (rc)
>  		rc =3D 1;
> --=20
> 1.7.1
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
