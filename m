From: Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH perftest] Allow specification of pkey index
Date: Tue, 20 Aug 2013 08:12:01 +0300
Message-ID: <5212FAA1.3070907@dev.mellanox.co.il>
References: <D9E00C9F-DED5-4799-8B04-414A64DF9E52@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D9E00C9F-DED5-4799-8B04-414A64DF9E52-YOWKrPYUwWM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>
Cc: "gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <gilr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Susan,

We (me and Gil) will apply it soon.

Ido

On 8/20/2013 12:54 AM, Coulter, Susan K wrote:
> Signed-off-by: Susan K. Coulter <markus-iV/i8Rg4no+4oOebrmKTww@public.gmane.org>
> ---
>   src/perftest_parameters.c |    7 ++++++-
>   src/perftest_parameters.h |    3 +++
>   src/perftest_resources.c  |    2 +-
>   3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
> index 084f16f..0350a54 100755
> --- a/src/perftest_parameters.c
> +++ b/src/perftest_parameters.c
> @@ -267,6 +267,8 @@ static void usage(const char *argv0,VerbType verb,TestType tst)	{
>   	if (tst == BW)
>   		printf("  -q, --qp=<num of qp's>  Num of qp's(default %d)\n",DEF_NUM_QPS);
>   
> +	printf("  -Y, --pkey=<pkey index> PKey index to use for QP\n");
> +
>   	putchar('\n');
>   }
>   /******************************************************************************
> @@ -345,6 +347,7 @@ static void init_perftest_params(struct perftest_parameters *user_param) {
>   	user_param->limit_bw = 0;
>   	user_param->is_limit_msgrate = OFF;
>   	user_param->limit_msgrate = 0;
> +	user_param->pkey        = 0;
>   
>   	if (user_param->tst == LAT) {
>   		user_param->r_flag->unsorted  = OFF;
> @@ -941,9 +944,10 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc) {
>   			{ .name = "run_infinitely", .has_arg = 0, .flag = &run_inf_flag, .val = 1 },
>   			{ .name = "report_gbits",   .has_arg = 0, .flag = &report_fmt_flag, .val = 1},
>   			{ .name = "use-srq",        .has_arg = 0, .flag = &srq_flag, .val = 1},
> +			{ .name = "pkey",           .has_arg = 1, .val = 'Y' },
>               { 0 }
>           };
> -        c = getopt_long(argc,argv,"w:y:p:d:i:m:s:n:t:u:S:x:c:q:I:o:M:r:Q:A:l:D:f:B:T:E:J:j:K:k:aFegzRvhbNVCHUOZP",long_options,NULL);
> +        c = getopt_long(argc,argv,"w:y:p:d:i:m:s:n:t:u:S:x:c:q:I:o:M:r:Q:A:l:D:f:B:T:E:J:j:K:k:Y:aFegzRvhbNVCHUOZP",long_options,NULL);
>   
>           if (c == -1)
>   			break;
> @@ -1143,6 +1147,7 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc) {
>   			case 'P': user_param->machine = CLIENT; break;
>   			case 'Z': user_param->machine = SERVER; break;
>   			case 'v': user_param->mac_fwd = ON; break;
> +			case 'Y': CHECK_VALUE(user_param->pkey,int,MIN_PKEY_IDX,MAX_PKEY_IDX," PKey Index"); break;
>   			case 0: break; // required for long options to work.
>   			default:
>   				fprintf(stderr," Invalid Command or flag.\n");
> diff --git a/src/perftest_parameters.h b/src/perftest_parameters.h
> index 42f6966..2110066 100755
> --- a/src/perftest_parameters.h
> +++ b/src/perftest_parameters.h
> @@ -135,6 +135,8 @@
>   #define MIN_CQ_MOD    (1)
>   #define MAX_CQ_MOD    (1024)
>   #define MAX_INLINE    (912)
> +#define MIN_PKEY_IDX  (0)
> +#define MAX_PKEY_IDX  (127)
>   
>   // Raw etherent defines
>   #define RAWETH_MIN_MSG_SIZE	(64)
> @@ -291,6 +293,7 @@ struct perftest_parameters {
>   	int				work_rdma_cm;
>   	char			*user_mgid;
>   	int				buff_size;
> +	int                     pkey;
>   	// New test params format pilot. will be used in all flags soon,.
>   	enum ctx_test_method 	test_method;
>   	enum ibv_transport_type transport_type;
> diff --git a/src/perftest_resources.c b/src/perftest_resources.c
> index 2ddddd1..4323734 100755
> --- a/src/perftest_resources.c
> +++ b/src/perftest_resources.c
> @@ -619,7 +619,7 @@ int ctx_modify_qp_to_init(struct ibv_qp *qp,struct perftest_parameters *user_par
>   
>   	memset(&attr, 0, sizeof(struct ibv_qp_attr));
>   	attr.qp_state        = IBV_QPS_INIT;
> -	attr.pkey_index      = 0;
> +	attr.pkey_index      = user_param->pkey;
>   
>   	if ( user_param->use_xrc && (user_param->duplex || user_param->tst == LAT)) {
>   		num_of_qps /= 2;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
