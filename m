From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate
Date: Wed, 18 Jan 2012 12:04:48 +0200
Message-ID: <4F169940.5090007@mellanox.com>
References: <20120118084255.18560.40844.stgit@kop-dev-sles11-04.qlogic.org> <20120118084311.18560.22509.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120118084311.18560.22509.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/18/2012 10:43 AM, Swapna Thete wrote:
> @@ -1963,6 +1963,16 @@ local:
> +	} else {
> +		memcpy(response, recv, sizeof(*response));
> +		response->header.recv_wc.wc =&response->header.wc;
> +		response->header.recv_wc.recv_buf.mad =&response->mad.mad;
> +		response->header.recv_wc.recv_buf.grh =&response->grh;
> +		response->mad.mad.mad_hdr.method = IB_MGMT_METHOD_GET_RESP;
> +		response->mad.mad.mad_hdr.status =
> +				__be16_to_cpu(IB_MGMT_MAD_STATUS_BAD_VERSION);
Don't we want here IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB ?

Or.
> +		agent_send_response(&response->mad.mad,&recv->grh, wc,
> +			port_priv->device, port_num, qp_info->qp->qp_num);
>   	}
>
>   out:
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
