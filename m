From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH v2 3/6] RDMA/core: expose affinity mappings per completion vector
Date: Wed, 3 May 2017 12:34:16 +0200
Message-ID: <7E52FF12-AAB8-454E-9D47-C20701ADEADB@oracle.com>
References: <1491474998-16423-1-git-send-email-sagi@grimberg.me> <1491474998-16423-4-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1491474998-16423-4-git-send-email-sagi@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, OFED mailing list <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


> On 06 Apr 2017, at 12:36, Sagi Grimberg <sagi@grimberg.me> wrote:
> 
> This will allow ULPs to intelligently locate threads based
> on completion vector cpu affinity mappings. In case the
> driver does not expose a get_vector_affinity callout, return
> NULL so the caller can maintain a fallback logic.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---
> include/rdma/ib_verbs.h | 24 ++++++++++++++++++++++++
> 1 file changed, 24 insertions(+)
> 
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 0f1813c13687..d44b62791c64 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -2150,6 +2150,8 @@ struct ib_device {
> 	 */
> 	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
> 	void (*get_dev_fw_str)(struct ib_device *, char *str, size_t str_len);
> +	const struct cpumask *(*get_vector_affinity)(struct ib_device *ibdev,
> +						     int comp_vector);
> };
> 
> struct ib_client {
> @@ -3377,4 +3379,26 @@ void ib_drain_qp(struct ib_qp *qp);
> 
> int ib_resolve_eth_dmac(struct ib_device *device,
> 			struct ib_ah_attr *ah_attr);
> +
> +/**
> + * ib_get_vector_affinity - Get the affinity mappings of a given completion
> + *   vector
> + * @device:         the rdma device
> + * @comp_vector:    index of completion vector
> + *
> + * Returns NULL on failure, otherwise a corresponding cpu map of the
> + * completion vector (returns all-cpus map if the device driver doesn't
> + * implement get_vector_affinity).
> + */
> +static inline const struct cpumask *
> +ib_get_vector_affinity(struct ib_device *device, int comp_vector)
> +{
> +	if (comp_vector > device->num_comp_vectors ||

Should the valid comp_vector range be from 0 (zero) to (num_comp_vectors - 1) ?

Otherwise,

Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>


Thxs, Håkon


> +	    !device->get_vector_affinity)
> +		return NULL;
> +
> +	return device->get_vector_affinity(device, comp_vector);
> +
> +}
> +
> #endif /* IB_VERBS_H */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
