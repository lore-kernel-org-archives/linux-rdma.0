From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 34/37] add rxe_net_sysfs.c
Date: Sun, 7 Aug 2011 11:27:48 +0200
Message-ID: <CAO+b5-or9QcsjwPcs76WDR4mUrXig+8KSdb2TJbw1qBS60DzOQ@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.815123934@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.815123934-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +/* Copy argument and remove trailing CR. Return the new length. */

As far as I can see the function below removes a trailing newline
instead of a trailing carriage return ?

> +static int sanitize_arg(const char *val, char *intf, int intf_len)
> +{
> +	int len;
> +
> +	if (!val)
> +		return 0;
> +
> +	/* Remove newline. */
> +	for (len = 0; len < intf_len - 1 && val[len] && val[len] != '\n'; len++)
> +		intf[len] = val[len];
> +	intf[len] = 0;
> +
> +	if (len == 0 || (val[len] != 0 && val[len] != '\n'))
> +		return 0;
> +
> +	return len;
> +}

Has it been considered to use strchr() to find the first occurrence of
a newline character in "val" ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
