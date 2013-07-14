From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 11/13] IB/srp: Make HCA completion vector configurable
Date: Sun, 14 Jul 2013 12:43:00 +0300
Message-ID: <51E272A4.5030707@mellanox.com>
References: <51D41C03.4020607@acm.org> <51D41FFC.6070105@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51D41FFC.6070105-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/3/2013 3:58 PM, Bart Van Assche wrote:
> Several InfiniBand HCA's allow to configure the completion vector
> per queue pair. This allows to spread the workload created by IB
> completion interrupts over multiple MSI-X vectors and hence over
> multiple CPU cores. In other words, configuring the completion
> vector properly not only allows to reduce latency on an initiator
> connected to multiple SRP targets but also allows to improve
> throughput.

Hey Bart,
Just wrote a small patch to allow srp_daemon spread connection across 
HCA's completion vectors.
But re-thinking on this, is it really a good idea to give the user 
control over completion
vectors for CQs he doesn't really owns. This way the user must retrieve 
the maximum completion
vectors from the ib_device and consider this when adding a connection 
and In addition will need to set proper IRQ affinity.

Perhaps the driver can manage this on it's own without involving the 
user, take the mlx4_en driver for
example, it spreads it's CQs across HCAs completion vectors without 
involving the user. the user that
opens a socket has no influence of the underlying cq<->comp-vector 
assignment.

The only use-case I can think of is where the user will want to use only 
a subset of the completion-vectors
if the user will want to reserve some completion-vectors for native IB 
applications but I don't know
how common it is.

Other from that, I think it is always better to spread the CQs across 
HCA completion-vectors, so perhaps the driver
just assign connection CQs across comp-vecs without getting args from 
the user, but simply iterate over comp_vectors.

What do you think?

> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>   Documentation/ABI/stable/sysfs-driver-ib_srp |    7 +++++++
>   drivers/infiniband/ulp/srp/ib_srp.c          |   26 ++++++++++++++++++++++++--
>   drivers/infiniband/ulp/srp/ib_srp.h          |    1 +
>   3 files changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/ABI/stable/sysfs-driver-ib_srp b/Documentation/ABI/stable/sysfs-driver-ib_srp
> index 481aae9..5c53d28 100644
> --- a/Documentation/ABI/stable/sysfs-driver-ib_srp
> +++ b/Documentation/ABI/stable/sysfs-driver-ib_srp
> @@ -54,6 +54,13 @@ Description:	Interface for making ib_srp connect to a new target.
>   		  ib_srp. Specifying a value that exceeds cmd_sg_entries is
>   		  only safe with partial memory descriptor list support enabled
>   		  (allow_ext_sg=1).
> +		* comp_vector, a number in the range 0..n-1 specifying the
> +		  MSI-X completion vector. Some HCA's allocate multiple (n)
> +		  MSI-X vectors per HCA port. If the IRQ affinity masks of
> +		  these interrupts have been configured such that each MSI-X
> +		  interrupt is handled by a different CPU then the comp_vector
> +		  parameter can be used to spread the SRP completion workload
> +		  over multiple CPU's.
>   
>   What:		/sys/class/infiniband_srp/srp-<hca>-<port_number>/ibdev
>   Date:		January 2, 2006
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 2557b7a..6c164f6 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -294,14 +294,16 @@ static int srp_create_target_ib(struct srp_target_port *target)
>   		return -ENOMEM;
>   
>   	recv_cq = ib_create_cq(target->srp_host->srp_dev->dev,
> -			       srp_recv_completion, NULL, target, SRP_RQ_SIZE, 0);
> +			       srp_recv_completion, NULL, target, SRP_RQ_SIZE,
> +			       target->comp_vector);
>   	if (IS_ERR(recv_cq)) {
>   		ret = PTR_ERR(recv_cq);
>   		goto err;
>   	}
>   
>   	send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
> -			       srp_send_completion, NULL, target, SRP_SQ_SIZE, 0);
> +			       srp_send_completion, NULL, target, SRP_SQ_SIZE,
> +			       target->comp_vector);
>   	if (IS_ERR(send_cq)) {
>   		ret = PTR_ERR(send_cq);
>   		goto err_recv_cq;
> @@ -1976,6 +1978,14 @@ static ssize_t show_local_ib_device(struct device *dev,
>   	return sprintf(buf, "%s\n", target->srp_host->srp_dev->dev->name);
>   }
>   
> +static ssize_t show_comp_vector(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct srp_target_port *target = host_to_target(class_to_shost(dev));
> +
> +	return sprintf(buf, "%d\n", target->comp_vector);
> +}
> +
>   static ssize_t show_cmd_sg_entries(struct device *dev,
>   				   struct device_attribute *attr, char *buf)
>   {
> @@ -2002,6 +2012,7 @@ static DEVICE_ATTR(req_lim,         S_IRUGO, show_req_lim,         NULL);
>   static DEVICE_ATTR(zero_req_lim,    S_IRUGO, show_zero_req_lim,	   NULL);
>   static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
>   static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
> +static DEVICE_ATTR(comp_vector,     S_IRUGO, show_comp_vector,     NULL);
>   static DEVICE_ATTR(cmd_sg_entries,  S_IRUGO, show_cmd_sg_entries,  NULL);
>   static DEVICE_ATTR(allow_ext_sg,    S_IRUGO, show_allow_ext_sg,    NULL);
>   
> @@ -2016,6 +2027,7 @@ static struct device_attribute *srp_host_attrs[] = {
>   	&dev_attr_zero_req_lim,
>   	&dev_attr_local_ib_port,
>   	&dev_attr_local_ib_device,
> +	&dev_attr_comp_vector,
>   	&dev_attr_cmd_sg_entries,
>   	&dev_attr_allow_ext_sg,
>   	NULL
> @@ -2140,6 +2152,7 @@ enum {
>   	SRP_OPT_CMD_SG_ENTRIES	= 1 << 9,
>   	SRP_OPT_ALLOW_EXT_SG	= 1 << 10,
>   	SRP_OPT_SG_TABLESIZE	= 1 << 11,
> +	SRP_OPT_COMP_VECTOR	= 1 << 12,
>   	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
>   				   SRP_OPT_IOC_GUID	|
>   				   SRP_OPT_DGID		|
> @@ -2160,6 +2173,7 @@ static const match_table_t srp_opt_tokens = {
>   	{ SRP_OPT_CMD_SG_ENTRIES,	"cmd_sg_entries=%u"	},
>   	{ SRP_OPT_ALLOW_EXT_SG,		"allow_ext_sg=%u"	},
>   	{ SRP_OPT_SG_TABLESIZE,		"sg_tablesize=%u"	},
> +	{ SRP_OPT_COMP_VECTOR,		"comp_vector=%u"	},
>   	{ SRP_OPT_ERR,			NULL 			}
>   };
>   
> @@ -2315,6 +2329,14 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
>   			target->sg_tablesize = token;
>   			break;
>   
> +		case SRP_OPT_COMP_VECTOR:
> +			if (match_int(args, &token) || token < 0) {
> +				pr_warn("bad comp_vector parameter '%s'\n", p);
> +				goto out;
> +			}
> +			target->comp_vector = token;
> +			break;
> +
>   		default:
>   			pr_warn("unknown parameter or missing value '%s' in target creation request\n",
>   				p);
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
> index e45d9d0..cbc0b14 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -156,6 +156,7 @@ struct srp_target_port {
>   	char			target_name[32];
>   	unsigned int		scsi_id;
>   	unsigned int		sg_tablesize;
> +	int			comp_vector;
>   
>   	struct ib_sa_path_rec	path;
>   	__be16			orig_dgid[8];

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
