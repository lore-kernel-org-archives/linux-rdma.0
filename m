From: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 03/16] IB/core: Introduce counter set describe
 verb
Date: Fri, 20 Oct 2017 05:44:23 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1710200541250.10736@nuc-kabylake>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com> <1508424118-27205-4-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-4-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 19 Oct 2017, Yishai Hadas wrote:

> +#define IB_COUNTER_NAME_LEN 64
> +struct ib_counter_set_describe_attr {
> +	/* Type that this set refers to, use enum ib_counter_set_type */
> +	u8 counted_type;

Gap here of 7 bytes. Maybe move the field to get a more compact
structure?

> +	/* Number of instances of this counter-set available in the hardware */
> +	u64 num_of_cs;

u16 or u32 should be enough right?

> +	/* Attributes of the set, use enum ib_counter_set_attributes */
> +	u32 attributes;
> +	/* Number of counters in this set */
> +	u8 entries_count;

A counter set is limited to 255? Could there be counter sets that have a
thousand or so?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
