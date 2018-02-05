From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 09/24] ibtrs: server: main functionality
Date: Mon, 5 Feb 2018 13:29:16 +0200
Message-ID: <1a621ca3-c093-99d8-9ba4-c61ce854028e@grimberg.me>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-10-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180202140904.2017-10-roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roman,

Some comments below.

On 02/02/2018 04:08 PM, Roman Pen wrote:
> This is main functionality of ibtrs-server module, which accepts
> set of RDMA connections (so called IBTRS session), creates/destroys
> sysfs entries associated with IBTRS session and notifies upper layer
> (user of IBTRS API) about RDMA requests or link events.
> 
> Signed-off-by: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Signed-off-by: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/ibtrs/ibtrs-srv.c | 1811 ++++++++++++++++++++++++++++++
>   1 file changed, 1811 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/ibtrs/ibtrs-srv.c b/drivers/infiniband/ulp/ibtrs/ibtrs-srv.c
> new file mode 100644
> index 000000000000..0d1fc08bd821
> --- /dev/null
> +++ b/drivers/infiniband/ulp/ibtrs/ibtrs-srv.c
> @@ -0,0 +1,1811 @@
> +/*
> + * InfiniBand Transport Layer
> + *
> + * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
> + * Authors: Fabian Holler <mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>
> + *          Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> + *          Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> + *          Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> + *          Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> + *          Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> + *
> + * Copyright (c) 2017 - 2018 ProfitBricks GmbH. All rights reserved.
> + * Authors: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> + *          Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt) KBUILD_MODNAME " L" __stringify(__LINE__) ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/mempool.h>
> +
> +#include "ibtrs-srv.h"
> +#include "ibtrs-log.h"
> +
> +MODULE_AUTHOR("ibnbd-EIkl63zCoXaH+58JC4qpiA@public.gmane.org");
> +MODULE_DESCRIPTION("IBTRS Server");
> +MODULE_VERSION(IBTRS_VER_STRING);
> +MODULE_LICENSE("GPL");
> +
> +#define DEFAULT_MAX_IO_SIZE_KB 128
> +#define DEFAULT_MAX_IO_SIZE (DEFAULT_MAX_IO_SIZE_KB * 1024)
> +#define MAX_REQ_SIZE PAGE_SIZE
> +#define MAX_SG_COUNT ((MAX_REQ_SIZE - sizeof(struct ibtrs_msg_rdma_read)) \
> +		      / sizeof(struct ibtrs_sg_desc))
> +
> +static int max_io_size = DEFAULT_MAX_IO_SIZE;
> +static int rcv_buf_size = DEFAULT_MAX_IO_SIZE + MAX_REQ_SIZE;
> +
> +static int max_io_size_set(const char *val, const struct kernel_param *kp)
> +{
> +	int err, ival;
> +
> +	err = kstrtoint(val, 0, &ival);
> +	if (err)
> +		return err;
> +
> +	if (ival < 4096 || ival + MAX_REQ_SIZE > (4096 * 1024) ||
> +	    (ival + MAX_REQ_SIZE) % 512 != 0) {
> +		pr_err("Invalid max io size value %d, has to be"
> +		       " > %d, < %d\n", ival, 4096, 4194304);
> +		return -EINVAL;
> +	}
> +
> +	max_io_size = ival;
> +	rcv_buf_size = max_io_size + MAX_REQ_SIZE;
> +	pr_info("max io size changed to %d\n", ival);
> +
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops max_io_size_ops = {
> +	.set		= max_io_size_set,
> +	.get		= param_get_int,
> +};
> +module_param_cb(max_io_size, &max_io_size_ops, &max_io_size, 0444);
> +MODULE_PARM_DESC(max_io_size,
> +		 "Max size for each IO request, when change the unit is in byte"
> +		 " (default: " __stringify(DEFAULT_MAX_IO_SIZE_KB) "KB)");
> +
> +#define DEFAULT_SESS_QUEUE_DEPTH 512
> +static int sess_queue_depth = DEFAULT_SESS_QUEUE_DEPTH;
> +module_param_named(sess_queue_depth, sess_queue_depth, int, 0444);
> +MODULE_PARM_DESC(sess_queue_depth,
> +		 "Number of buffers for pending I/O requests to allocate"
> +		 " per session. Maximum: " __stringify(MAX_SESS_QUEUE_DEPTH)
> +		 " (default: " __stringify(DEFAULT_SESS_QUEUE_DEPTH) ")");
> +
> +/* We guarantee to serve 10 paths at least */
> +#define CHUNK_POOL_SIZE (DEFAULT_SESS_QUEUE_DEPTH * 10)
> +static mempool_t *chunk_pool;
> +
> +static int retry_count = 7;
> +
> +static int retry_count_set(const char *val, const struct kernel_param *kp)
> +{
> +	int err, ival;
> +
> +	err = kstrtoint(val, 0, &ival);
> +	if (err)
> +		return err;
> +
> +	if (ival < MIN_RTR_CNT || ival > MAX_RTR_CNT) {
> +		pr_err("Invalid retry count value %d, has to be"
> +		       " > %d, < %d\n", ival, MIN_RTR_CNT, MAX_RTR_CNT);
> +		return -EINVAL;
> +	}
> +
> +	retry_count = ival;
> +	pr_info("QP retry count changed to %d\n", ival);
> +
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops retry_count_ops = {
> +	.set		= retry_count_set,
> +	.get		= param_get_int,
> +};
> +module_param_cb(retry_count, &retry_count_ops, &retry_count, 0644);
> +
> +MODULE_PARM_DESC(retry_count, "Number of times to send the message if the"
> +		 " remote side didn't respond with Ack or Nack (default: 3,"
> +		 " min: " __stringify(MIN_RTR_CNT) ", max: "
> +		 __stringify(MAX_RTR_CNT) ")");
> +
> +static char cq_affinity_list[256] = "";
> +static cpumask_t cq_affinity_mask = { CPU_BITS_ALL };
> +
> +static void init_cq_affinity(void)
> +{
> +	sprintf(cq_affinity_list, "0-%d", nr_cpu_ids - 1);
> +}
> +
> +static int cq_affinity_list_set(const char *val, const struct kernel_param *kp)
> +{
> +	int ret = 0, len = strlen(val);
> +	cpumask_var_t new_value;
> +
> +	if (!strlen(cq_affinity_list))
> +		init_cq_affinity();
> +
> +	if (len >= sizeof(cq_affinity_list))
> +		return -EINVAL;
> +	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	ret = cpulist_parse(val, new_value);
> +	if (ret) {
> +		pr_err("Can't set cq_affinity_list \"%s\": %d\n", val,
> +		       ret);
> +		goto free_cpumask;
> +	}
> +
> +	strlcpy(cq_affinity_list, val, sizeof(cq_affinity_list));
> +	*strchrnul(cq_affinity_list, '\n') = '\0';
> +	cpumask_copy(&cq_affinity_mask, new_value);
> +
> +	pr_info("cq_affinity_list changed to %*pbl\n",
> +		cpumask_pr_args(&cq_affinity_mask));
> +free_cpumask:
> +	free_cpumask_var(new_value);
> +	return ret;
> +}
> +
> +static struct kparam_string cq_affinity_list_kparam_str = {
> +	.maxlen	= sizeof(cq_affinity_list),
> +	.string	= cq_affinity_list
> +};
> +
> +static const struct kernel_param_ops cq_affinity_list_ops = {
> +	.set	= cq_affinity_list_set,
> +	.get	= param_get_string,
> +};
> +
> +module_param_cb(cq_affinity_list, &cq_affinity_list_ops,
> +		&cq_affinity_list_kparam_str, 0644);
> +MODULE_PARM_DESC(cq_affinity_list, "Sets the list of cpus to use as cq vectors."
> +		 "(default: use all possible CPUs)");
> +

Can you explain why not using configfs?

> +static void ibtrs_srv_close_work(struct work_struct *work)
> +{
> +	struct ibtrs_srv_sess *sess;
> +	struct ibtrs_srv_ctx *ctx;
> +	struct ibtrs_srv_con *con;
> +	int i;
> +
> +	sess = container_of(work, typeof(*sess), close_work);
> +	ctx = sess->srv->ctx;
> +
> +	ibtrs_srv_destroy_sess_files(sess);
> +	ibtrs_srv_stop_hb(sess);
> +
> +	for (i = 0; i < sess->s.con_num; i++) {
> +		con = to_srv_con(sess->s.con[i]);
> +		if (!con)
> +			continue;
> +
> +		rdma_disconnect(con->c.cm_id);
> +		ib_drain_qp(con->c.qp);
> +	}
> +	/* Wait for all inflights */
> +	ibtrs_srv_wait_ops_ids(sess);
> +
> +	/* Notify upper layer if we are the last path */
> +	ibtrs_srv_sess_down(sess);
> +
> +	unmap_cont_bufs(sess);
> +	ibtrs_srv_free_ops_ids(sess);
> +
> +	for (i = 0; i < sess->s.con_num; i++) {
> +		con = to_srv_con(sess->s.con[i]);
> +		if (!con)
> +			continue;
> +
> +		ibtrs_cq_qp_destroy(&con->c);
> +		rdma_destroy_id(con->c.cm_id);
> +		kfree(con);
> +	}
> +	ibtrs_ib_dev_put(sess->s.ib_dev);
> +
> +	del_path_from_srv(sess);
> +	put_srv(sess->srv);
> +	sess->srv = NULL;
> +	ibtrs_srv_change_state(sess, IBTRS_SRV_CLOSED);
> +
> +	kfree(sess->rdma_addr);
> +	kfree(sess->s.con);
> +	kfree(sess);
> +}
> +
> +static int ibtrs_rdma_do_accept(struct ibtrs_srv_sess *sess,
> +				struct rdma_cm_id *cm_id)
> +{
> +	struct ibtrs_srv *srv = sess->srv;
> +	struct ibtrs_msg_conn_rsp msg;
> +	struct rdma_conn_param param;
> +	int err;
> +
> +	memset(&param, 0, sizeof(param));
> +	param.retry_count = retry_count;
> +	param.rnr_retry_count = 7;
> +	param.private_data = &msg;
> +	param.private_data_len = sizeof(msg);
> +
> +	memset(&msg, 0, sizeof(msg));
> +	msg.magic = cpu_to_le16(IBTRS_MAGIC);
> +	msg.version = cpu_to_le16(IBTRS_VERSION);
> +	msg.errno = 0;
> +	msg.queue_depth = cpu_to_le16(srv->queue_depth);
> +	msg.rkey = cpu_to_le32(sess->s.ib_dev->rkey);

As said, this cannot happen anymore...

> +static struct rdma_cm_id *ibtrs_srv_cm_init(struct ibtrs_srv_ctx *ctx,
> +					    struct sockaddr *addr,
> +					    enum rdma_port_space ps)
> +{
> +	struct rdma_cm_id *cm_id;
> +	int ret;
> +
> +	cm_id = rdma_create_id(&init_net, ibtrs_srv_rdma_cm_handler,
> +			       ctx, ps, IB_QPT_RC);
> +	if (IS_ERR(cm_id)) {
> +		ret = PTR_ERR(cm_id);
> +		pr_err("Creating id for RDMA connection failed, err: %d\n",
> +		       ret);
> +		goto err_out;
> +	}
> +	ret = rdma_bind_addr(cm_id, addr);
> +	if (ret) {
> +		pr_err("Binding RDMA address failed, err: %d\n", ret);
> +		goto err_cm;
> +	}
> +	ret = rdma_listen(cm_id, 64);
> +	if (ret) {
> +		pr_err("Listening on RDMA connection failed, err: %d\n",
> +		       ret);
> +		goto err_cm;
> +	}
> +
> +	switch (addr->sa_family) {
> +	case AF_INET:
> +		pr_debug("listening on port %u\n",
> +			 ntohs(((struct sockaddr_in *)addr)->sin_port));
> +		break;
> +	case AF_INET6:
> +		pr_debug("listening on port %u\n",
> +			 ntohs(((struct sockaddr_in6 *)addr)->sin6_port));
> +		break;
> +	case AF_IB:
> +		pr_debug("listening on service id 0x%016llx\n",
> +			 be64_to_cpu(rdma_get_service_id(cm_id, addr)));
> +		break;
> +	default:
> +		pr_debug("listening on address family %u\n", addr->sa_family);
> +	}

We already have printk that accepts address format...

> +
> +	return cm_id;
> +
> +err_cm:
> +	rdma_destroy_id(cm_id);
> +err_out:
> +
> +	return ERR_PTR(ret);
> +}
> +
> +static int ibtrs_srv_rdma_init(struct ibtrs_srv_ctx *ctx, unsigned int port)
> +{
> +	struct sockaddr_in6 sin = {
> +		.sin6_family	= AF_INET6,
> +		.sin6_addr	= IN6ADDR_ANY_INIT,
> +		.sin6_port	= htons(port),
> +	};
> +	struct sockaddr_ib sib = {
> +		.sib_family			= AF_IB,
> +		.sib_addr.sib_subnet_prefix	= 0ULL,
> +		.sib_addr.sib_interface_id	= 0ULL,
> +		.sib_sid	= cpu_to_be64(RDMA_IB_IP_PS_IB | port),
> +		.sib_sid_mask	= cpu_to_be64(0xffffffffffffffffULL),
> +		.sib_pkey	= cpu_to_be16(0xffff),
> +	};

ipv4?

> +	struct rdma_cm_id *cm_ip, *cm_ib;
> +	int ret;
> +
> +	/*
> +	 * We accept both IPoIB and IB connections, so we need to keep
> +	 * two cm id's, one for each socket type and port space.
> +	 * If the cm initialization of one of the id's fails, we abort
> +	 * everything.
> +	 */
> +	cm_ip = ibtrs_srv_cm_init(ctx, (struct sockaddr *)&sin, RDMA_PS_TCP);
> +	if (unlikely(IS_ERR(cm_ip)))
> +		return PTR_ERR(cm_ip);
> +
> +	cm_ib = ibtrs_srv_cm_init(ctx, (struct sockaddr *)&sib, RDMA_PS_IB);
> +	if (unlikely(IS_ERR(cm_ib))) {
> +		ret = PTR_ERR(cm_ib);
> +		goto free_cm_ip;
> +	}
> +
> +	ctx->cm_id_ip = cm_ip;
> +	ctx->cm_id_ib = cm_ib;
> +
> +	return 0;
> +
> +free_cm_ip:
> +	rdma_destroy_id(cm_ip);
> +
> +	return ret;
> +}
> +
> +static struct ibtrs_srv_ctx *alloc_srv_ctx(rdma_ev_fn *rdma_ev,
> +					   link_ev_fn *link_ev)
> +{
> +	struct ibtrs_srv_ctx *ctx;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return NULL;
> +
> +	ctx->rdma_ev = rdma_ev;
> +	ctx->link_ev = link_ev;
> +	mutex_init(&ctx->srv_mutex);
> +	INIT_LIST_HEAD(&ctx->srv_list);
> +
> +	return ctx;
> +}
> +
> +static void free_srv_ctx(struct ibtrs_srv_ctx *ctx)
> +{
> +	WARN_ON(!list_empty(&ctx->srv_list));
> +	kfree(ctx);
> +}
> +
> +struct ibtrs_srv_ctx *ibtrs_srv_open(rdma_ev_fn *rdma_ev, link_ev_fn *link_ev,
> +				     unsigned int port)
> +{
> +	struct ibtrs_srv_ctx *ctx;
> +	int err;
> +
> +	ctx = alloc_srv_ctx(rdma_ev, link_ev);
> +	if (unlikely(!ctx))
> +		return ERR_PTR(-ENOMEM);
> +
> +	err = ibtrs_srv_rdma_init(ctx, port);
> +	if (unlikely(err)) {
> +		free_srv_ctx(ctx);
> +		return ERR_PTR(err);
> +	}
> +	/* Do not let module be unloaded if server context is alive */
> +	__module_get(THIS_MODULE);
> +
> +	return ctx;
> +}
> +EXPORT_SYMBOL(ibtrs_srv_open);
> +
> +void ibtrs_srv_queue_close(struct ibtrs_srv_sess *sess)
> +{
> +	close_sess(sess);
> +}
> +
> +static void close_sess(struct ibtrs_srv_sess *sess)
> +{
> +	enum ibtrs_srv_state old_state;
> +
> +	if (ibtrs_srv_change_state_get_old(sess, IBTRS_SRV_CLOSING,
> +					   &old_state))
> +		queue_work(ibtrs_wq, &sess->close_work);
> +	WARN_ON(sess->state != IBTRS_SRV_CLOSING);
> +}
> +
> +static void close_sessions(struct ibtrs_srv *srv)
> +{
> +	struct ibtrs_srv_sess *sess;
> +
> +	mutex_lock(&srv->paths_mutex);
> +	list_for_each_entry(sess, &srv->paths_list, s.entry)
> +		close_sess(sess);
> +	mutex_unlock(&srv->paths_mutex);
> +}
> +
> +static void close_ctx(struct ibtrs_srv_ctx *ctx)
> +{
> +	struct ibtrs_srv *srv;
> +
> +	mutex_lock(&ctx->srv_mutex);
> +	list_for_each_entry(srv, &ctx->srv_list, ctx_list)
> +		close_sessions(srv);
> +	mutex_unlock(&ctx->srv_mutex);
> +	flush_workqueue(ibtrs_wq);
> +}
> +
> +void ibtrs_srv_close(struct ibtrs_srv_ctx *ctx)
> +{
> +	rdma_destroy_id(ctx->cm_id_ip);
> +	rdma_destroy_id(ctx->cm_id_ib);
> +	close_ctx(ctx);
> +	free_srv_ctx(ctx);
> +	module_put(THIS_MODULE);
> +}
> +EXPORT_SYMBOL(ibtrs_srv_close);
> +
> +static int check_module_params(void)
> +{
> +	if (sess_queue_depth < 1 || sess_queue_depth > MAX_SESS_QUEUE_DEPTH) {
> +		pr_err("Invalid sess_queue_depth parameter value\n");
> +		return -EINVAL;
> +	}
> +
> +	/* check if IB immediate data size is enough to hold the mem_id and the
> +	 * offset inside the memory chunk
> +	 */
> +	if (ilog2(sess_queue_depth - 1) + ilog2(rcv_buf_size - 1) >
> +	    MAX_IMM_PAYL_BITS) {
> +		pr_err("RDMA immediate size (%db) not enough to encode "
> +		       "%d buffers of size %dB. Reduce 'sess_queue_depth' "
> +		       "or 'max_io_size' parameters.\n", MAX_IMM_PAYL_BITS,
> +		       sess_queue_depth, rcv_buf_size);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __init ibtrs_server_init(void)
> +{
> +	int err;
> +
> +	if (!strlen(cq_affinity_list))
> +		init_cq_affinity();
> +
> +	pr_info("Loading module %s, version: %s "
> +		"(retry_count: %d, cq_affinity_list: %s, "
> +		"max_io_size: %d, sess_queue_depth: %d)\n",
> +		KBUILD_MODNAME, IBTRS_VER_STRING, retry_count,
> +		cq_affinity_list, max_io_size, sess_queue_depth);
> +
> +	err = check_module_params();
> +	if (err) {
> +		pr_err("Failed to load module, invalid module parameters,"
> +		       " err: %d\n", err);
> +		return err;
> +	}
> +	chunk_pool = mempool_create_page_pool(CHUNK_POOL_SIZE,
> +					      get_order(rcv_buf_size));
> +	if (unlikely(!chunk_pool)) {
> +		pr_err("Failed preallocate pool of chunks\n");
> +		return -ENOMEM;
> +	}
> +	ibtrs_wq = alloc_workqueue("ibtrs_server_wq", WQ_MEM_RECLAIM, 0);
> +	if (!ibtrs_wq) {
> +		pr_err("Failed to load module, alloc ibtrs_server_wq failed\n");
> +		goto out_chunk_pool;
> +	}
> +	err = ibtrs_srv_create_sysfs_module_files();
> +	if (err) {
> +		pr_err("Failed to load module, can't create sysfs files,"
> +		       " err: %d\n", err);
> +		goto out_ibtrs_wq;
> +	}
> +
> +	return 0;
> +
> +out_ibtrs_wq:
> +	destroy_workqueue(ibtrs_wq);
> +out_chunk_pool:
> +	mempool_destroy(chunk_pool);
> +
> +	return err;
> +}
> +
> +static void __exit ibtrs_server_exit(void)
> +{
> +	ibtrs_srv_destroy_sysfs_module_files();
> +	destroy_workqueue(ibtrs_wq);
> +	mempool_destroy(chunk_pool);
> +}
> +
> +module_init(ibtrs_server_init);
> +module_exit(ibtrs_server_exit);
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
