From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 13/37] add rxe_verbs.c
Date: Mon, 15 Aug 2011 18:31:48 +0200
Message-ID: <CAO+b5-pGZmfvNiaYn8UzYZz5odV6+rw9EEZJWakhwNEQLF-70w@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.761358826@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201228.761358826-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +static ssize_t rxe_show_skb_num(struct device *device,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct rxe_dev *rxe = container_of(device, struct rxe_dev,
> +					   ib_dev.dev);
> +
> +	return sprintf(buf, "req_in:%d resp_in:%d req_out:%d resp_out:%d\n",
> +		atomic_read(&rxe->req_skb_in),
> +		atomic_read(&rxe->resp_skb_in),
> +		atomic_read(&rxe->req_skb_out),
> +		atomic_read(&rxe->resp_skb_out));
> +}

The rule for sysfs attributes is one value per file. See also
Documentation/sysfs-rules.txt.

Also, all sysfs changes have to be documented [1]. See also
Documentation/ABI/README for more information.

[1] Greg Kroah-Hartman, http://lkml.org/lkml/2010/10/9/103.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
