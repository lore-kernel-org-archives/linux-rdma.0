From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Add huge page support to
 ibv_madvise_range()
Date: Tue, 12 Jan 2010 16:25:45 +0200
Message-ID: <20100112142544.GA14861@mtls03>
References: <4B12AA78.7090401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B12AA78.7090401-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 29, 2009 at 07:08:08PM +0200, Alex Vainman wrote:
> +	p_hpage_val = strstr(buf, label);
> +	if (!p_hpage_val) {
> +		errno = EINVAL;
> +		return -1;
> +	}
> +	p_hpage_val += strlen(label);
> +
> +	errno = 0;
> +	ret_val = strtol(p_hpage_val, &end_pointer, 0);

If strtol() fails, you may return with an invalid, non zero value for
huge page size. Maybe use some temporary variable to hold the
intermediate result.
> +
> +	if (errno != 0)
> +		return -1;
> +
> +	return ret_val * 1024;
> +}
> +
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
