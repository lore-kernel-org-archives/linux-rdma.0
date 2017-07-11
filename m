From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v7 for-4.13 6/7] block: Add rdma affinity based queue
 mapping helper
Date: Tue, 11 Jul 2017 22:13:40 +0000
Message-ID: <1499811219.2586.45.camel@wdc.com>
References: <1499671054-23899-1-git-send-email-sagi@grimberg.me>
         <1499671054-23899-7-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499671054-23899-7-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <28C17BD44562BB49984F300EB6536C7F-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-10 at 10:17 +0300, Sagi Grimberg wrote:
> +int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,
> +		struct ib_device *dev, int first_vec)
> +{
> +	const struct cpumask *mask;
> +	unsigned int queue, cpu;
> +
> +	if (set->nr_hw_queues > dev->num_comp_vectors)
> +		goto fallback;

Should this perhaps have been "if (first_vec + set->nr_hw_queues >
dev->num_comp_vectors)"? Additionally, since the return value of
ib_get_vector_affinity() is tested inside the loop, can this test be left o=
ut?

> +
> +	for (queue =3D 0; queue < set->nr_hw_queues; queue++) {
> +		mask =3D ib_get_vector_affinity(dev, first_vec + queue);
> +		if (!mask)
> +			goto fallback;
> +
> +		for_each_cpu(cpu, mask)
> +			set->mq_map[cpu] =3D queue;
> +	}
> +
> +	return 0;
> +fallback:
> +	return blk_mq_map_queues(set);

If you have to repost this patch, please insert a blank line above the
"fallback" label.

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
