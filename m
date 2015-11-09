From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] IB/mlx5: Add support querying timestamp
 related fields in query_device
Date: Mon, 9 Nov 2015 21:26:10 +0200
Message-ID: <20151109192610.GF4023@leon.nu>
References: <1447086657-15358-1-git-send-email-matanb@mellanox.com>
 <1447086657-15358-4-git-send-email-matanb@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447086657-15358-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2015 at 06:30:56PM +0200, Matan Barak wrote:
> +
> +	if (uhw->outlen) {
> +		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
> +		if (err)
> +			return err;
> +	}
> +
>  	return 0;
What do you think about to rewrite this part of code to be something
like that?
+	int ret = 0;
.....
+	if (uhw->outlen)
+		ret = ib_copy_to_udata(uhw, &resp, resp.response_length);
+	return ret;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
