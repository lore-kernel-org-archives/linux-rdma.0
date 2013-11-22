From: "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>
Subject: PKey patch
Date: Fri, 22 Nov 2013 21:10:24 +0000
Message-ID: <79F41063-EC59-4515-B13B-C2104C8C490A@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <684CFC859697C84BAAFA9BDC1E65E845-r1tBtT6b1V2fRvmTrFJqzg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


=85 again =85 reworked as requested to use only the long option.

=46rom e3471983cf96c17e4353ff98a339f3ca2b767b13 Mon Sep 17 00:00:00 200=
1
=46rom: Susan K. Coulter <markus-iV/i8Rg4no+4oOebrmKTww@public.gmane.org>
Date: Fri, 22 Nov 2013 13:38:11 -0700
Subject: [PATCH] Allow specification of PKey index

Signed-off-by: Susan K. Coulter <markus-iV/i8Rg4no+4oOebrmKTww@public.gmane.org>
---
 src/perftest_communication.c |    9 +++------
 src/perftest_parameters.c    |   41 ++++++++++++++++++++++++++++++++++=
++++++-
 src/perftest_parameters.h    |    1 +
 src/perftest_resources.c     |    2 +-
 4 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/src/perftest_communication.c b/src/perftest_communication.=
c
index 44c0f32..1f0abcc 100755
--- a/src/perftest_communication.c
+++ b/src/perftest_communication.c
@@ -207,8 +207,7 @@ static int ethernet_read_keys(struct pingpong_dest =
*rem_dest,
 		char msg[KEY_MSG_SIZE];
=20
 		if (read(comm->rdma_params->sockfd, msg, sizeof msg) !=3D sizeof msg=
) {
-			perror("pp_read_keys");
-			fprintf(stderr, "Couldn't read remote address\n");
+			fprintf(stderr, "ethernet_read_keys: Couldn't read remote address\n=
");
 			return 1;
 		}
=20
@@ -229,8 +228,7 @@ static int ethernet_read_keys(struct pingpong_dest =
*rem_dest,
 		int i;
=20
 		if (read(comm->rdma_params->sockfd, msg, sizeof msg) !=3D sizeof msg=
) {
-			perror("pp_read_keys");
-			fprintf(stderr, "Couldn't read remote address\n");
+			fprintf(stderr, "ethernet_read_keys: Couldn't read remote address\n=
");
 			return 1;
 		}
=20
@@ -1130,8 +1128,7 @@ int ethernet_write_data(struct perftest_comm *com=
m, char* msg) {
 int ethernet_read_data(struct perftest_comm *comm, char* recv_msg) {
=20
 	if (read(comm->rdma_params->sockfd, recv_msg, sizeof recv_msg) !=3D s=
izeof recv_msg) {
-		perror("pp_read_keys");
-		fprintf(stderr, "Couldn't read reports\n");
+		fprintf(stderr, "ethernet_read_data: Couldn't read reports\n");
 		return 1;
 	}
=20
diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
index 084f16f..5899103 100755
--- a/src/perftest_parameters.c
+++ b/src/perftest_parameters.c
@@ -267,6 +267,8 @@ static void usage(const char *argv0,VerbType verb,T=
estType tst)	{
 	if (tst =3D=3D BW)
 		printf("  -q, --qp=3D<num of qp's>  Num of qp's(default %d)\n",DEF_N=
UM_QPS);
=20
+	printf("  --pkey_index=3D<pkey index> PKey index to use for QP\n");
+
 	putchar('\n');
 }
 /*********************************************************************=
*********
@@ -345,6 +347,7 @@ static void init_perftest_params(struct perftest_pa=
rameters *user_param) {
 	user_param->limit_bw =3D 0;
 	user_param->is_limit_msgrate =3D OFF;
 	user_param->limit_msgrate =3D 0;
+	user_param->pkey_index    =3D 0;
=20
 	if (user_param->tst =3D=3D LAT) {
 		user_param->r_flag->unsorted  =3D OFF;
@@ -841,6 +844,33 @@ static int ctx_set_out_reads(struct ibv_context *c=
ontext,int num_user_reads) {
 /*********************************************************************=
*********
  *
  *********************************************************************=
*********/
+static int ctx_chk_pkey_index(struct ibv_context *context,int pkey_idx=
) {
+
+
+        int idx =3D 0;
+        struct ibv_device_attr attr;
+
+	if (!ibv_query_device(context,&attr)) {
+
+ 	       	if (pkey_idx > attr.max_pkeys - 1) {
+        		printf(RESULT_LINE);
+                	fprintf(stderr," Specified PKey Index, %i, greater th=
an allowed max, %i\n",pkey_idx,attr.max_pkeys - 1);
+                	fprintf(stderr," Changing to 0\n");
+                	idx =3D 0;
+        	} else
+			idx =3D pkey_idx;
+	} else {
+		fprintf(stderr," Unable to validate PKey Index, changing to 0\n");
+		idx =3D 0;
+	}
+
+        return idx;
+
+}
+
+/*********************************************************************=
*********
+ *
+ *********************************************************************=
*********/
 static void ctx_set_max_inline(struct ibv_context *context,struct perf=
test_parameters *user_param) {
=20
=20
@@ -883,6 +913,7 @@ int parser(struct perftest_parameters *user_param,c=
har *argv[], int argc) {
 	static int run_inf_flag =3D 0;
 	static int report_fmt_flag =3D 0;
 	static int srq_flag =3D 0;
+	static int pkey_flag =3D 0;
=20
 	init_perftest_params(user_param);
=20
@@ -941,6 +972,7 @@ int parser(struct perftest_parameters *user_param,c=
har *argv[], int argc) {
 			{ .name =3D "run_infinitely", .has_arg =3D 0, .flag =3D &run_inf_fl=
ag, .val =3D 1 },
 			{ .name =3D "report_gbits",   .has_arg =3D 0, .flag =3D &report_fmt=
_flag, .val =3D 1},
 			{ .name =3D "use-srq",        .has_arg =3D 0, .flag =3D &srq_flag, =
=2Eval =3D 1},
+			{ .name =3D "pkey_index",     .has_arg =3D 1, .flag =3D &pkey_flag,=
 .val =3D 1},
             { 0 }
         };
         c =3D getopt_long(argc,argv,"w:y:p:d:i:m:s:n:t:u:S:x:c:q:I:o:M=
:r:Q:A:l:D:f:B:T:E:J:j:K:k:aFegzRvhbNVCHUOZP",long_options,NULL);
@@ -1143,7 +1175,11 @@ int parser(struct perftest_parameters *user_para=
m,char *argv[], int argc) {
 			case 'P': user_param->machine =3D CLIENT; break;
 			case 'Z': user_param->machine =3D SERVER; break;
 			case 'v': user_param->mac_fwd =3D ON; break;
-			case 0: break; // required for long options to work.
+			case 0:  // used for long options
+        			if (pkey_flag) {
+                			user_param->pkey_index =3D strtol(optarg,NULL,0);
+				}		=09
+				break;
 			default:
 				fprintf(stderr," Invalid Command or flag.\n");
 				fprintf(stderr," Please check command line and run again.\n\n");
@@ -1256,6 +1292,9 @@ int check_link_and_mtu(struct ibv_context *contex=
t,struct perftest_parameters *u
 	if (!user_param->ib_devname)
 		GET_STRING(user_param->ib_devname,ibv_get_device_name(context->devic=
e))
=20
+	if (user_param->pkey_index > 0)
+		user_param->pkey_index =3D ctx_chk_pkey_index(context, user_param->p=
key_index);
+
 	return SUCCESS;
 }
=20
diff --git a/src/perftest_parameters.h b/src/perftest_parameters.h
index 42f6966..3f0d59f 100755
--- a/src/perftest_parameters.h
+++ b/src/perftest_parameters.h
@@ -291,6 +291,7 @@ struct perftest_parameters {
 	int				work_rdma_cm;
 	char			*user_mgid;
 	int				buff_size;
+	int                     pkey_index;
 	// New test params format pilot. will be used in all flags soon,.
 	enum ctx_test_method 	test_method;
 	enum ibv_transport_type transport_type;
diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index 2ddddd1..9d869c1 100755
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -619,7 +619,7 @@ int ctx_modify_qp_to_init(struct ibv_qp *qp,struct =
perftest_parameters *user_par
=20
 	memset(&attr, 0, sizeof(struct ibv_qp_attr));
 	attr.qp_state        =3D IBV_QPS_INIT;
-	attr.pkey_index      =3D 0;
+	attr.pkey_index      =3D user_param->pkey_index;
=20
 	if ( user_param->use_xrc && (user_param->duplex || user_param->tst =3D=
=3D LAT)) {
 		num_of_qps /=3D 2;
--=20
1.7.1


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Susan Coulter
HPC-3 Network/Infrastructure
505-667-8425
Increase the Peace...
An eye for an eye leaves the whole world blind
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
